// "Сырые" функции для работы с Lua, импортируемые из lua.dll
unit LuaBase;

interface

const
  Lua_DLL = 'lua.dll'; // Имя DLL-файла с интепретатором Lua

// option for multiple returns in `lua_pcall' and `lua_call'
  LUA_MULTRET = (-1);

const // pseudo-indices
  LUA_REGISTRYINDEX = (-10000);
  LUA_GLOBALSINDEX = (-10001);

const // error codes for `lua_load' and `lua_pcall'
  LUA_ERRRUN = 1;
  LUA_ERRFILE = 2;
  LUA_ERRSYNTAX = 3;
  LUA_ERRMEM = 4;
  LUA_ERRERR = 5;

const
  BUFSIZ = 1024;
  LUAL_BUFFERSIZE = BUFSIZ;
  // minimum Lua stack available to a C function
  LUA_MINSTACK = 20;

type // Типы данных в Lua
  LuaType = (
    LUA_TNONE = -1,
    LUA_TNIL = 0,
    LUA_TBOOLEAN = 1,
    LUA_TLIGHTUSERDATA = 2,
    LUA_TNUMBER = 3,
    LUA_TSTRING = 4,
    LUA_TTABLE = 5,
    LUA_TFUNCTION = 6,
    LUA_TUSERDATA = 7,
    LUA_TTHREAD = 8
  );

const
  LuaTypeToStr : array [LuaType] of AnsiString = (
    'LUA_TNONE',
    'LUA_TNIL',
    'LUA_TBOOLEAN',
    'LUA_TLIGHTUSERDATA',
    'LUA_TNUMBER',
    'LUA_TSTRING',
    'LUA_TTABLE',
    'LUA_TFUNCTION',
    'LUA_TUSERDATA',
    'LUA_TTHREAD'
  );

type
  lua_State = record end;
  PLua_State = ^lua_State;
  lua_CFunction = function (L: PLua_State): Integer; cdecl;
  size_t = Integer;
  Psize_t = ^size_t;
  // functions that read/write blocks when loading/dumping Lua chunks
  lua_Chunkreader = function (L: PLua_State; UD: Pointer; var SZ: size_t): PAnsiChar;
  lua_Chunkwriter = function (L: PLua_State; const P: Pointer; SZ: size_t; UD: Pointer): Integer;
  // type of numbers in Lua
  lua_Number = Double;
  luaL_Buffer = record
    P: PAnsiChar;    (* current position in buffer *)
    lvl: Integer; (* number of strings in the stack(level) *)
    L: PLua_State;
    buffer: array [0..LUAL_BUFFERSIZE - 1] of Char;
  end;
  PluaL_Buffer = ^luaL_Buffer;

// Перед вызовом любой функции API, вы должны создать состояние вызовом lua_open
function lua_open: PLua_State;
  cdecl external Lua_DLL;
procedure lua_close(L: PLua_State);
  cdecl external Lua_DLL;
function lua_newthread(L: PLua_State): PLua_State;
  cdecl external Lua_DLL;
function lua_atpanic(L: PLua_State; Panicf: lua_CFunction): lua_CFunction;
  cdecl external Lua_DLL;

// basic stack manipulation
function lua_gettop(L: PLua_State): Integer; cdecl external Lua_DLL;
procedure lua_settop(L: PLua_State; Idx: Integer); cdecl external Lua_DLL;
procedure lua_pushvalue(L: PLua_State; Idx: Integer); cdecl external Lua_DLL;
procedure lua_remove(L: PLua_State; Idx: Integer); cdecl external Lua_DLL;
procedure lua_insert(L: PLua_State; Idx: Integer); cdecl external Lua_DLL;
procedure lua_replace(L: PLua_State; Idx: Integer); cdecl external Lua_DLL;
function lua_checkstack(L: PLua_State; SZ: Integer): Integer; cdecl external Lua_DLL;
procedure lua_xmove (Src, Dst: PLua_State; N: Integer); cdecl external Lua_DLL;

// access functions (stack -> C)
function lua_isnumber(L: PLua_State; Idx: Integer): Integer; cdecl external Lua_DLL;
function lua_isstring(L: PLua_State; Idx: Integer): Integer; cdecl external Lua_DLL;
function lua_iscfunction(L: PLua_State; Idx: Integer): Integer; cdecl external Lua_DLL;
function lua_isuserdata(L: PLua_State; Idx: Integer): Integer; cdecl external Lua_DLL;
function lua_type(L: PLua_State; Idx: Integer): LuaType; cdecl external Lua_DLL;
function lua_typename(L: PLua_State; TP: Integer): PAnsiChar; cdecl external Lua_DLL;

function lua_equal(L: PLua_State; Idx1: Integer; Idx2: Integer): Integer;
  cdecl external Lua_DLL;
function lua_rawequal(L: PLua_State; Idx1: Integer; Idx2: Integer): Integer;
  cdecl external Lua_DLL;
function lua_lessthan(L: PLua_State; Idx1: Integer; Idx2: Integer): Integer;
  cdecl external Lua_DLL;

// Функции преобразования  
function lua_tonumber( L:PLua_State; index:Integer ): lua_Number;
  cdecl external Lua_DLL;
function lua_toboolean( L:PLua_State; index:Integer ): Integer;
  cdecl external Lua_DLL;
function lua_tostring( L:PLua_State; index:Integer ): PAnsiChar;
  cdecl external Lua_DLL;
function lua_strlen( L:PLua_State; index:Integer ): size_t;
  cdecl external Lua_DLL;
function lua_tocfunction( L:PLua_State; index:Integer ): lua_CFunction;
  cdecl external Lua_DLL;
function lua_touserdata( L:PLua_State; index:Integer ): Pointer;
  cdecl external Lua_DLL;
function lua_tothread( L:PLua_State; index:Integer ): PLua_State;
  cdecl external Lua_DLL;
function lua_topointer( L:PLua_State; index:Integer ): Pointer;
  cdecl external Lua_DLL;

(*
** push functions (C -> stack)
*)
procedure lua_pushnil(L: PLua_State);
  cdecl external Lua_DLL;
procedure lua_pushnumber(L: PLua_State; N: lua_Number);
  cdecl external Lua_DLL;
procedure lua_pushlstring(L: PLua_State; const S: PAnsiChar; N: size_t);
  cdecl external Lua_DLL;
procedure lua_pushstring(L: PLua_State; const S: PAnsiChar);
  cdecl external Lua_DLL;
function lua_pushvfstring(L: PLua_State; const Fmt: PAnsiChar; Argp: Pointer): PAnsiChar;
  cdecl external Lua_DLL;
function lua_pushfstring(L: PLua_State; const Fmt: PAnsiChar): PAnsiChar; varargs;
  cdecl external Lua_DLL;
procedure lua_pushcclosure(L: PLua_State; Fn: lua_CFunction; N: Integer);
  cdecl external Lua_DLL;
procedure lua_pushboolean(L: PLua_State; B: Integer);
  cdecl external Lua_DLL;
procedure lua_pushlightuserdata(L: PLua_State; P: Pointer);
  cdecl external Lua_DLL;


(*
** get functions (Lua -> stack)
*)
procedure lua_gettable(L: PLua_State; Idx: Integer);
  cdecl external Lua_DLL;
procedure lua_rawget(L: PLua_State; Idx: Integer);
  cdecl external Lua_DLL;
procedure lua_rawgeti(L: PLua_State; Idx: Integer; N: Integer);
  cdecl external Lua_DLL;
procedure lua_newtable(L: PLua_State);
  cdecl external Lua_DLL;
function lua_newuserdata(L: PLua_State; SZ: size_t): Pointer;
  cdecl external Lua_DLL;
function lua_getmetatable(L: PLua_State; ObjIndex: Integer): Integer;
  cdecl external Lua_DLL;
procedure lua_getfenv(L: PLua_State; Idx: Integer);
  cdecl external Lua_DLL;


(*
** set functions (stack -> Lua)
*)
procedure lua_settable(L: PLua_State; Idx: Integer);
  cdecl external Lua_DLL;
procedure lua_rawset(L: PLua_State; Idx: Integer);
  cdecl external Lua_DLL;
procedure lua_rawseti(L: PLua_State; Idx: Integer; N: Integer);
  cdecl external Lua_DLL;
function lua_setmetatable(L: PLua_State; ObjIndex: Integer): Integer;
  cdecl external Lua_DLL;
function lua_setfenv(L: PLua_State; Idx: Integer): Integer;
  cdecl external Lua_DLL;


(*
** `load' and `call' functions (load and run Lua code)
*)
procedure lua_call(L: PLua_State; NArgs: Integer; NResults: Integer);
  cdecl external Lua_DLL;
function lua_pcall(L: PLua_State; NArgs: Integer; NResults: Integer; ErrFunc: Integer): Integer;
  cdecl external Lua_DLL;
function lua_cpcall(L: PLua_State; Func: lua_CFunction; UD: Pointer): Integer;
  cdecl external Lua_DLL;
function lua_load(L: PLua_State; Reader: lua_Chunkreader; DT: Pointer;
                        const ChunkName: PAnsiChar): Integer;
  cdecl external Lua_DLL;

function lua_dump(L: PLua_State; Writer: lua_Chunkwriter; Data: Pointer): Integer;
  cdecl external Lua_DLL;

// coroutine functions
function lua_yield(L: PLua_State; NResults: Integer): Integer;
  cdecl external Lua_DLL;
function lua_resume(L: PLua_State; NArg: Integer): Integer;
  cdecl external Lua_DLL;

// garbage-collection functions
function lua_getgcthreshold(L: PLua_State): Integer;
  cdecl external Lua_DLL;
function lua_getgccount(L: PLua_State): Integer;
  cdecl external Lua_DLL;
procedure lua_setgcthreshold(L: PLua_State; NewThreshold: Integer);
  cdecl external Lua_DLL;

// miscellaneous functions
function lua_version: PAnsiChar;
  cdecl external Lua_DLL;
function lua_error(L: PLua_State): Integer;
  cdecl external Lua_DLL;
function lua_next(L: PLua_State; Idx: Integer): Integer;
  cdecl external Lua_DLL;
procedure lua_concat(L: PLua_State; N: Integer);
  cdecl external Lua_DLL;

// = Библиотеки Lua =
const
  LUA_COLIBNAME = 'coroutine';
  LUA_TABLIBNAME = 'table';
  LUA_IOLIBNAME = 'io';
  LUA_OSLIBNAME = 'os';
  LUA_STRLIBNAME = 'string';
  LUA_MATHLIBNAME = 'math';
  LUA_DBLIBNAME = 'debug';

// "Базовая" библиотека
function luaopen_base(L: PLua_State): Integer; cdecl external Lua_DLL;
// Библиотека пакетов
function luaopen_package(L: PLua_State): Integer; cdecl external Lua_DLL;
// Библиотека работы с таблицами
function luaopen_table(L: PLua_State): Integer; cdecl external Lua_DLL;
// Для ввода/вывода и библиотек работы с операционной системой
function luaopen_io(L: PLua_State): Integer; cdecl external Lua_DLL;
function luaopen_string(L: PLua_State): Integer; cdecl external Lua_DLL;
function luaopen_math(L: PLua_State): Integer; cdecl external Lua_DLL;
function luaopen_debug(L: PLua_State): Integer; cdecl external Lua_DLL;
function luaopen_loadlib(L: PLua_State): Integer; cdecl external Lua_DLL;


procedure luaL_buffinit(L: PLua_State; B: PluaL_Buffer);
  cdecl external Lua_DLL;
function luaL_prepbuffer(B: PluaL_Buffer): PAnsiChar;
  cdecl external Lua_DLL;
procedure luaL_addlstring(B: PluaL_Buffer; const S: PAnsiChar; L: size_t);
  cdecl external Lua_DLL;
procedure luaL_addstring(B: PluaL_Buffer; const S: PAnsiChar);
  cdecl external Lua_DLL;
procedure luaL_addvalue(B: PluaL_Buffer);
  cdecl external Lua_DLL;
procedure luaL_pushresult(B: PluaL_Buffer);
  cdecl external Lua_DLL;
function lua_dofile(L: PLua_State; const FileName: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function lua_dostring(L: PLua_State; const Str: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function lua_dobuffer(L: PLua_State; const Buff: PAnsiChar; SZ: size_t;
                               const N: PAnsiChar): Integer;
  cdecl external Lua_DLL;


implementation

end.
