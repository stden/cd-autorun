unit lua;

interface

uses LuaBase;

function lua_upvalueindex(I: Integer): Integer;
function lua_boxpointer(L: PLua_State; U: Pointer): Pointer;
function lua_unboxpointer(L: PLua_State; I: Integer): Pointer;
procedure lua_pop(L: PLua_State; N: Integer);
procedure lua_register(L: PLua_State; const N: PAnsiChar; F: lua_CFunction);
procedure lua_pushcfunction(L: PLua_State; F: lua_CFunction);
function lua_isfunction(L: PLua_State; N: Integer): Boolean;
function lua_istable(L: PLua_State; N: Integer): Boolean;
function lua_islightuserdata(L: PLua_State; N: Integer): Boolean;
function lua_isnil(L: PLua_State; N: Integer): Boolean;
function lua_isboolean(L: PLua_State; N: Integer): Boolean;
function lua_isnone(L: PLua_State; N: Integer): Boolean;
function lua_isnoneornil(L: PLua_State; N: Integer): Boolean;
procedure lua_pushliteral(L: PLua_State; const S: PAnsiChar);

(*
** compatibility macros and functions
*)

function lua_pushupvalues(L: PLua_State): Integer;
  cdecl; external Lua_DLL;

procedure lua_getregistry(L: PLua_State);
procedure lua_setglobal(L: PLua_State; const S: PAnsiChar);
procedure lua_getglobal(L: PLua_State; const S: PAnsiChar);

(* compatibility with ref system *)

(* pre-defined references *)
const
  LUA_NOREF = (-2);
  LUA_REFNIL = (-1);

//procedure lua_ref(L: PLua_State; Lock: Integer);
function lua_ref(L: PLua_State; Lock: Integer):integer;
procedure lua_unref(L: PLua_State; Ref: Integer);
procedure lua_getref(L: PLua_State; Ref: Integer);

(*
** {======================================================================
** useful definitions for Lua kernel and libraries
** =======================================================================
*)

(* formats for Lua numbers *)
const
  LUA_NUMBER_SCAN = '%lf';
  LUA_NUMBER_FMT = '%.14g';

(* }====================================================================== *)


(*
** {======================================================================
** Debug API
** =======================================================================
*)

const
(*
** Event codes
*)
  LUA_HOOKCALL = 0;
  LUA_HOOKRET = 1;
  LUA_HOOKLINE = 2;
  LUA_HOOKCOUNT = 3;
  LUA_HOOKTAILRET = 4;


(*
** Event masks
*)
  LUA_MASKCALL = (1 shl LUA_HOOKCALL);
  LUA_MASKRET = (1 shl LUA_HOOKRET);
  LUA_MASKLINE = (1 shl LUA_HOOKLINE);
  LUA_MASKCOUNT = (1 shl LUA_HOOKCOUNT);

const
  LUA_IDSIZE = 60;

type
  lua_Debug = record
    event: Integer;
    name: PAnsiChar; (* (n) *)
    namewhat: PAnsiChar; (* (n) `global', `local', `field', `method' *)
    what: PAnsiChar; (* (S) `Lua', `C', `main', `tail' *)
    source: PAnsiChar; (* (S) *)
    currentline: Integer;  (* (l) *)
    nups: Integer;   (* (u) number of upvalues *)
    linedefined: Integer;  (* (S) *)
    short_src: array [0..LUA_IDSIZE - 1] of Char; (* (S) *)
    (* private part *)
    i_ci: Integer;  (* active function *)
  end;
  Plua_Debug = ^lua_Debug;

  lua_Hook = procedure (L: PLua_State; AR: Plua_Debug); cdecl;


function lua_getstack(L: PLua_State; Level: Integer; AR: Plua_Debug): Integer;
  cdecl external Lua_DLL;
function lua_getinfo(L: PLua_State; const What: PAnsiChar; AR: Plua_Debug): Integer;
  cdecl external Lua_DLL;
function lua_getlocal(L: PLua_State; const AR: Plua_Debug; N: Integer): PAnsiChar;
  cdecl external Lua_DLL;
function lua_setlocal(L: PLua_State; const AR: Plua_Debug; N: Integer): PAnsiChar;
  cdecl external Lua_DLL;
function lua_getupvalue(L: PLua_State; FuncIndex: Integer; N: Integer): PAnsiChar;
  cdecl external Lua_DLL;
function lua_setupvalue(L: PLua_State; FuncIndex: Integer; N: Integer): PAnsiChar;
  cdecl external Lua_DLL;

function lua_sethook(L: PLua_State; Func: lua_Hook; Mask: Integer; Count: Integer): Integer;
  cdecl external Lua_DLL;
function lua_gethook(L: PLua_State): lua_Hook;
  cdecl external Lua_DLL;
function lua_gethookmask(L: PLua_State): Integer;
  cdecl external Lua_DLL;
function lua_gethookcount(L: PLua_State): Integer;
  cdecl external Lua_DLL;

implementation

uses
  SysUtils, lauxlib;

const
  MAX_SIZE = High(Integer);
  MAX_POINTER_ARRAY = MAX_SIZE div SizeOf(Pointer);

function lua_upvalueindex(I: Integer): Integer;
begin
  Result := LUA_GLOBALSINDEX - I;
end;

function lua_boxpointer(L: PLua_State; U: Pointer): Pointer;
begin
  PPointerArray(lua_newuserdata(L, sizeof(U)))^[0] := U;
  Result := U;
end;

function lua_unboxpointer(L: PLua_State; I: Integer): Pointer;
begin
  Result := PPointerArray(lua_touserdata(L, I))^[0];
end;

procedure lua_pop(L: PLua_State; N: Integer);
begin
  lua_settop(L, -(N)-1);
end;

procedure lua_register(L: PLua_State; const N: PAnsiChar; F: lua_CFunction);
begin
  lua_pushstring(L, N);
  lua_pushcfunction(L, F);
  lua_settable(L, LUA_GLOBALSINDEX);
end;

procedure lua_pushcfunction(L: PLua_State; F: lua_CFunction);
begin
  lua_pushcclosure(L, F, 0);
end;

function lua_isfunction(L: PLua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TFUNCTION;
end;

function lua_istable(L: PLua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TTABLE;
end;

function lua_islightuserdata(L: PLua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TLIGHTUSERDATA;
end;

function lua_isnil(L: PLua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TNIL;
end;

function lua_isboolean(L: PLua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TBOOLEAN;
end;

function lua_isnone(L: PLua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TNONE;
end;

function lua_isnoneornil(L: PLua_State; N: Integer): Boolean;
begin
  Result := ord(lua_type(L, n)) <= 0;
end;

procedure lua_pushliteral(L: PLua_State; const S: PAnsiChar);
begin
  lua_pushlstring(L, S, StrLen(S));
end;

procedure lua_getregistry(L: PLua_State);
begin
  lua_pushvalue(L, LUA_REGISTRYINDEX);
end;

procedure lua_setglobal(L: PLua_State; const S: PAnsiChar);
begin
  lua_pushstring(L, S);
  lua_insert(L, -2);
  lua_settable(L, LUA_GLOBALSINDEX);
end;

procedure lua_getglobal(L: PLua_State; const S: PAnsiChar);
begin
  lua_pushstring(L, S);
  lua_gettable(L, LUA_GLOBALSINDEX);
end;

function lua_ref(L: PLua_State; Lock: Integer):integer;
begin
  if (Lock <> 0) then begin
    Result := luaL_ref(L, LUA_REGISTRYINDEX);
  end else begin
    lua_pushstring(L, 'unlocked references are obsolete');
    lua_error(L);
  end;
end;

procedure lua_unref(L: PLua_State; Ref: Integer);
begin
  luaL_unref(L, LUA_REGISTRYINDEX, Ref);
end;

procedure lua_getref(L: PLua_State; Ref: Integer);
begin
  lua_rawgeti(L, LUA_REGISTRYINDEX, Ref);
end;

end.
