unit lauxlib;

interface

uses
  LuaBase;


type
  luaL_reg = record
    name: PAnsiChar;
    func: lua_CFunction;
  end;
  PluaL_reg = ^luaL_reg;

procedure luaL_openlib(L: PLua_State; libname: PAnsiChar;
                               R: PluaL_reg; Nup: Integer);
  cdecl external Lua_DLL;
function luaL_getmetafield(L: PLua_State; Obj: Integer; const E: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function luaL_callmeta(L: PLua_State; Obj: Integer; const E: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function luaL_typerror(L: PLua_State; NArg: Integer; const TName: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function luaL_argerror(L: PLua_State; NumArg: Integer; const ExtraMsg: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function luaL_checklstring(L: PLua_State; NumArg: Integer; S: Psize_t): PAnsiChar;
  cdecl external Lua_DLL;
function luaL_optlstring(L: PLua_State; NumArg: Integer;
                                           const Def: PAnsiChar; S: Psize_t): PAnsiChar;
  cdecl external Lua_DLL;
function luaL_checknumber(L: PLua_State; NumArg: Integer): lua_Number;
  cdecl external Lua_DLL;
function luaL_optnumber(L: PLua_State; NArg: Integer; Def: Lua_Number): lua_Number;
  cdecl external Lua_DLL;

procedure luaL_checkstack(L: PLua_State; SZ: Integer; const Msg: PAnsiChar);
  cdecl external Lua_DLL;
procedure luaL_checktype(L: PLua_State; NArg: Integer; T: Integer);
  cdecl external Lua_DLL;
procedure luaL_checkany(L: PLua_State; NArg: Integer);
  cdecl external Lua_DLL;

function   luaL_newmetatable(L: PLua_State; const TName: PAnsiChar): Integer;
  cdecl external Lua_DLL;
procedure  luaL_getmetatable(L: PLua_State; const TName: PAnsiChar);
  cdecl external Lua_DLL;
function luaL_checkudata(L: PLua_State; UD: Integer; const TName: PAnsiChar): Pointer;
  cdecl external Lua_DLL;

procedure luaL_where(L: PLua_State; LVL: Integer);
  cdecl external Lua_DLL;
function luaL_error(L: PLua_State; const Fmt: PAnsiChar): Integer; varargs;
  cdecl external Lua_DLL;

//function luaL_findstring(const ST: PAnsiChar; const char *const lst[]): Integer;

function luaL_ref(L: PLua_State; T: Integer): Integer;
  cdecl external Lua_DLL;
procedure luaL_unref(L: PLua_State; T: Integer; Ref: Integer);
  cdecl external Lua_DLL;

function luaL_getn(L: PLua_State; T: Integer): Integer;
  cdecl external Lua_DLL;
procedure luaL_setn(L: PLua_State; T: Integer; N: Integer);
  cdecl external Lua_DLL;

function luaL_loadfile(L: PLua_State; const FileName: PAnsiChar): Integer;
  cdecl external Lua_DLL;
function luaL_loadbuffer(L: PLua_State; const Buff: PAnsiChar; SZ: size_t;
                                const Name: PAnsiChar): Integer;
  cdecl external Lua_DLL;



(*
** ===============================================================
** some useful macros
** ===============================================================
*)

procedure luaL_argcheck(L: PLua_State; Cond: Boolean; NumArg: Integer; const ExtraMsg: PAnsiChar);
function luaL_checkstring(L: PLua_State; N: Integer): PAnsiChar;
function luaL_optstring(L: PLua_State; N: Integer; const D: PAnsiChar): PAnsiChar;
function luaL_checkint(L: PLua_State; N: Integer): Integer;
function luaL_checklong(L: PLua_State; N: Integer): Integer;
function luaL_optint(L: PLua_State; N: Integer; D: Lua_Number): Integer;
function luaL_optlong(L: PLua_State; N: Integer; D: Lua_Number): Integer;

(*
** {======================================================
** Generic Buffer manipulation
** =======================================================
*)



procedure luaL_putchar(B: PluaL_Buffer; C: AnsiChar);

function luaL_addsize(B: PLuaL_Buffer; N: Integer): PAnsiChar;


implementation

procedure luaL_argcheck(L: PLua_State; Cond: Boolean; NumArg: Integer; const ExtraMsg: PAnsiChar);
begin
 if(not Cond) then
   luaL_argerror(L, NumArg, ExtraMsg)
end;

function luaL_checkstring(L: PLua_State; N: Integer): PAnsiChar;
begin
  Result := luaL_checklstring(L, N, nil);
end;

function luaL_optstring(L: PLua_State; N: Integer; const D: PAnsiChar): PAnsiChar;
begin
  Result := luaL_optlstring(L, N, D, nil);
end;

function luaL_checkint(L: PLua_State; N: Integer): Integer;
begin
  Result := Trunc(luaL_checknumber(L, N));
end;

function luaL_checklong(L: PLua_State; N: Integer): Integer;
begin
  Result := Trunc(luaL_checknumber(L, N));
end;

function luaL_optint(L: PLua_State; N: Integer; D: Lua_Number): Integer;
begin
  Result := Trunc(luaL_optnumber(L, N, D));
end;

function luaL_optlong(L: PLua_State; N: Integer; D: Lua_Number): Integer;
begin
  Result := Trunc(luaL_optnumber(L, N, D));
end;

procedure luaL_putchar(B: PluaL_Buffer; C: AnsiChar);
begin
  if ((B.P <= @B.Buffer[High(B.Buffer)]) or (luaL_prepbuffer(B) <> #0)) then
  begin
    B.P^ := C;
    Inc(B.P);
  end;
end;

function luaL_addsize(B: PLuaL_Buffer; N: Integer): PAnsiChar;
begin
  Inc(B.P, N);
  Result := B.P;
end;

end.
