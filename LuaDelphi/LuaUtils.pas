﻿unit LuaUtils;

interface

uses
  SysUtils, Classes, ComCtrls, lua, lauxlib, LuaBase;

type
  TOnLuaStdout = procedure (S: PAnsiChar; N: Integer);
  LuaException = class(Exception)
  end;
  ELuaException = class(Exception)
    Title: AnsiString;
    Line: Integer;
    Msg: AnsiString;
    constructor Create(Title: AnsiString; Line: Integer; Msg: AnsiString);
  end;

function lua_print(L: PLua_State): Integer; cdecl;
function lua_io_write(L: PLua_State): Integer; cdecl;

function LuaToBoolean(L: PLua_State; Index: Integer): Boolean;
procedure LuaPushBoolean(L: PLua_State; B: Boolean);
function LuaToInteger(L: PLua_State; Index: Integer): Integer;
procedure LuaPushInteger(L: PLua_State; N: Integer);
function LuaToString(L: PLua_State; Index: Integer): AnsiString;
procedure LuaPushString(L: PLua_State; const S: AnsiString);
function LuaIncIndex(L: PLua_State; Index: Integer): Integer;
function LuaAbsIndex(L: PLua_State; Index: Integer): Integer;
procedure LuaGetTable(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
function LuaGetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Boolean;
function LuaGetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Double;
function LuaGetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString): AnsiString;
function LuaGetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString): lua_CFunction;
function LuaGetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Pointer;
procedure LuaRawGetTable(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
function LuaRawGetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Boolean;
function LuaRawGetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Double;
function LuaRawGetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString): AnsiString;
function LuaRawGetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString): lua_CFunction;
function LuaRawGetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Pointer;
procedure LuaSetTableValue(L: PLua_State; TableIndex: Integer; const Key: AnsiString; ValueIndex: Integer);
procedure LuaSetTableNil(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
procedure LuaSetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString; B: Boolean);
procedure LuaSetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString; N: Double);
procedure LuaSetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString; S: AnsiString);
procedure LuaSetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString; F: lua_CFunction);
procedure LuaSetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString; P: Pointer);
procedure LuaSetTableClear(L: PLua_State; TableIndex: Integer);
procedure LuaRawSetTableValue(L: PLua_State; TableIndex: Integer; const Key: AnsiString; ValueIndex: Integer);
procedure LuaRawSetTableNil(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
procedure LuaRawSetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString; B: Boolean);
procedure LuaRawSetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString; N: Double);
procedure LuaRawSetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString; S: AnsiString);
procedure LuaRawSetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString; F: lua_CFunction);
procedure LuaRawSetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString; P: Pointer);
procedure LuaRawSetTableClear(L: PLua_State; TableIndex: Integer);
function LuaGetMetaFunction(L: PLua_State; Index: Integer; Key: AnsiString): lua_CFunction;
procedure LuaSetMetaFunction(L: PLua_State; Index: Integer; Key: AnsiString; F: lua_CFunction);

procedure LuaShowStack(L: PLua_State; Caption: AnsiString = '');
function LuaStackToStr(L: PLua_State; Index: Integer; MaxTable: Integer = -1): AnsiString;
procedure LuaRegisterCustom(L: PLua_State; TableIndex: Integer; const Name: PAnsiChar; F: lua_CFunction);
procedure LuaRegister(L: PLua_State; const Name: PAnsiChar; F: lua_CFunction);
procedure LuaRegisterMetatable(L: PLua_State; const Name: PAnsiChar; F: lua_CFunction);
procedure LuaRegisterProperty(L: PLua_State; const Name: PAnsiChar; ReadFunc, WriteFunc: lua_CFunction);
procedure LuaStackToStrings(L: PLua_State; Lines: TStrings; MaxTable: Integer = -1);
procedure LuaLocalToStrings(L: PLua_State; Lines: TStrings; MaxTable: Integer = -1);
procedure LuaTableToStrings(L: PLua_State; Index: Integer; Lines: TStrings; MaxTable: Integer = -1);
procedure LuaTableToTreeView(L: PLua_State; Index: Integer; TV: TTreeView; MaxTable: Integer = -1);
function LuaGetIdentValue(L: PLua_State; Ident: AnsiString; MaxTable: Integer = -1): AnsiString;
procedure LuaSetIdentValue(L: PLua_State; Ident, Value: AnsiString; MaxTable: Integer = -1);
procedure LuaLoadBuffer(L: PLua_State; const Code: AnsiString; const Name: AnsiString);
procedure LuaPCall(L: PLua_State; NArgs, NResults, ErrFunc: Integer);
procedure LuaError(L: PLua_State; const Msg: AnsiString);
procedure LuaErrorFmt(L: PLua_State; const Fmt: AnsiString; const Args: array of Const);
function LuaDataStrToStrings(const TableStr: AnsiString; Strings: TStrings): AnsiString;
function LuaDoFile(L: PLua_State): Integer; cdecl;
procedure LuaProcessErrorMessage(const ErrMsg: AnsiString; var Title: AnsiString; var Line: Integer; var Msg: AnsiString);
function Dequote(const QuotedStr: AnsiString): AnsiString;

const
  LuaGlobalVariableStr = '{111}';
var
  OnLuaStdout: TOnLuaStdout;
  DefaultMaxTable: Integer = 3;

implementation

uses
  Dialogs;

const
  QuoteStr = '"';
  CR = #$0D;
  LF = #$0A;
  CRLF = CR + LF;

function Quote(const Str: AnsiString): AnsiString;
begin
  Result := AnsiQuotedStr(Str, QuoteStr);
end;

function Dequote(const QuotedStr: AnsiString): AnsiString;
begin
  Result := AnsiDequotedStr(QuotedStr, QuoteStr);
end;

function fwrite(S: PAnsiChar; Un, Len: Integer; Dummy: Integer): Integer;
var
  Size: Integer;
begin
  Size := Un * Len;
  if (Assigned(OnLuaStdout)) then
    OnLuaStdout(S, Size);
  Result := Size;
end;

function fputs(const S: AnsiString; Dummy: Integer): Integer;
begin
  Result := fwrite(PAnsiChar(S), SizeOf(Char), Length(S), Dummy);
end;

function lua_print(L: PLua_State): Integer; cdecl;
const
  TAB = #$08;
  NL = #$0A;
  stdout = 0;
var
  N, I: Integer;
  S: PAnsiChar;
begin
  N := lua_gettop(L);  (* number of arguments *)
  lua_getglobal(L, 'tostring');
  for I := 1 to N do
  begin
    lua_pushvalue(L, -1);  (* function to be called *)
    lua_pushvalue(L, i);   (* value to print *)
    lua_call(L, 1, 1);
    S := lua_tostring(L, -1);  (* get result *)
    if (S = nil) then
    begin
      Result := luaL_error(L, '`tostring'' must return a AnsiString to `print''');
      Exit;
    end;
    if (I > 1) then fputs(TAB, stdout);
    fputs(S, stdout);
    lua_pop(L, 1);  (* pop result *)
  end;
  fputs(NL, stdout);
  Result := 0;
end;

function lua_io_write(L: PLua_State): Integer; cdecl;
// •WЏЂЏo—НЉЦђ”
  function pushresult(L: PLua_State; I: Boolean; FileName: PAnsiChar): Integer;
  begin
    lua_pushboolean(L, 1);
    Result := 1;
  end;
const
  F = 0;
var
  NArgs: Integer;
  Status: Boolean;
  Arg: Integer;
  Len: Integer;
  S: PAnsiChar;
begin
  Arg := 1;
  NArgs := lua_gettop(L);
  Status := True;
  while (NArgs > 0) do
  begin
    Dec(NArgs);
    if (lua_type(L, Arg) = LUA_TNUMBER) then
    begin
      (* optimization: could be done exactly as for strings *)
      Status := Status and
          (fputs(Format(LUA_NUMBER_FMT, [lua_tonumber(L, Arg)]), 0) > 0);
    end else
    begin
      S := luaL_checklstring(L, Arg, @Len);
      Status := Status and (fwrite(S, SizeOf(Char), Len, F) = Len);
    end;
    Inc(Arg);
  end;
  Result := pushresult(L, Status, nil);
end;

function LuaToBoolean(L: PLua_State; Index: Integer): Boolean;
begin
  Result := (lua_toboolean(L, Index) <> 0);
end;

procedure LuaPushBoolean(L: PLua_State; B: Boolean);
begin
  lua_pushboolean(L, Integer(B));
end;

function LuaToInteger(L: PLua_State; Index: Integer): Integer;
begin
  Result := Round(lua_tonumber(L, Index));
end;

procedure LuaPushInteger(L: PLua_State; N: Integer);
begin
  lua_pushnumber(L, N);
end;

function LuaToString(L: PLua_State; Index: Integer): AnsiString;
var
  Size: Integer;
begin
  Size := lua_strlen(L, Index);
  SetLength(Result, Size);
  if (Size > 0) then
    Move(lua_tostring(L, Index)^, Result[1], Size);
end;

procedure LuaPushString(L: PLua_State; const S: AnsiString);
begin
  lua_pushstring(L, PAnsiChar(S));
end;

function LuaIncIndex(L: PLua_State; Index: Integer): Integer;
begin
  if ((Index = LUA_GLOBALSINDEX) or (Index = LUA_REGISTRYINDEX)) then
  begin
    Result := Index;
    Exit;
  end;

  Result := LuaAbsIndex(L, Index) - lua_gettop(L) - 1;
end;

function LuaAbsIndex(L: PLua_State; Index: Integer): Integer;
begin
  if ((Index = LUA_GLOBALSINDEX) or (Index = LUA_REGISTRYINDEX)) then
  begin
    Result := Index;
    Exit;
  end;

  if (Index < 0) then
    Result := Index + lua_gettop(L) + 1
  else
    Result := Index;
end;

procedure LuaPushKeyString(L: PLua_State; var Index: Integer; const Key: AnsiString);
begin
  Index := LuaAbsIndex(L, Index);
  lua_pushstring(L, PAnsiChar(Key));
end;

procedure LuaGetTable(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_gettable(L, TableIndex);
end;

function LuaGetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Boolean;
begin
  LuaGetTable(L, TableIndex, Key);
  Result := (lua_toboolean(L, -1) <> 0);
  lua_pop(L, 1);
end;

function LuaGetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Double;
begin
  LuaGetTable(L, TableIndex, Key);
  Result := lua_tonumber(L, -1);
  lua_pop(L, 1);
end;

function LuaGetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString): AnsiString;
begin
  LuaGetTable(L, TableIndex, Key);
  Result := lua_tostring(L, -1);
  lua_pop(L, 1);
end;

function LuaGetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString): lua_CFunction;
begin
  LuaGetTable(L, TableIndex, Key);
  Result := lua_tocfunction(L, -1);
  lua_pop(L, 1);
end;

function LuaGetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Pointer;
begin
  LuaGetTable(L, TableIndex, Key);
  Result := lua_touserdata(L, -1);
  lua_pop(L, 1);
end;

procedure LuaRawGetTable(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_rawget(L, TableIndex);
end;

function LuaRawGetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Boolean;
begin
  LuaRawGetTable(L, TableIndex, Key);
  Result := (lua_toboolean(L, -1) <> 0);
  lua_pop(L, 1);
end;

function LuaRawGetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Double;
begin
  LuaRawGetTable(L, TableIndex, Key);
  Result := lua_tonumber(L, -1);
  lua_pop(L, 1);
end;

function LuaRawGetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString): AnsiString;
begin
  LuaRawGetTable(L, TableIndex, Key);
  Result := lua_tostring(L, -1);
  lua_pop(L, 1);
end;

function LuaRawGetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString): lua_CFunction;
begin
  LuaRawGetTable(L, TableIndex, Key);
  Result := lua_tocfunction(L, -1);
  lua_pop(L, 1);
end;

function LuaRawGetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString): Pointer;
begin
  LuaRawGetTable(L, TableIndex, Key);
  Result := lua_touserdata(L, -1);
  lua_pop(L, 1);
end;

procedure LuaSetTableValue(L: PLua_State; TableIndex: Integer; const Key: AnsiString; ValueIndex: Integer);
begin
  TableIndex := LuaAbsIndex(L, TableIndex);
  ValueIndex := LuaAbsIndex(L, ValueIndex);
  lua_pushstring(L, PAnsiChar(Key));
  lua_pushvalue(L, ValueIndex);
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableNil(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushnil(L);
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString; B: Boolean);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushboolean(L, Integer(B));
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString; N: Double);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushnumber(L, N);
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString; S: AnsiString);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushstring(L, PAnsiChar(S));
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString; F: lua_CFunction);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushcfunction(L, F);
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString; P: Pointer);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushlightuserdata(L, P);
  lua_settable(L, TableIndex);
end;

procedure LuaSetTableClear(L: PLua_State; TableIndex: Integer);
begin
  TableIndex := LuaAbsIndex(L, TableIndex);

  lua_pushnil(L);
  while (lua_next(L, TableIndex) <> 0) do
  begin
    lua_pushnil(L);
    lua_replace(L, -1 - 1);
    lua_settable(L, TableIndex);
    lua_pushnil(L);
  end;
end;

procedure LuaRawSetTableValue(L: PLua_State; TableIndex: Integer; const Key: AnsiString; ValueIndex: Integer);
begin
  TableIndex := LuaAbsIndex(L, TableIndex);
  ValueIndex := LuaAbsIndex(L, ValueIndex);
  lua_pushstring(L, PAnsiChar(Key));
  lua_pushvalue(L, ValueIndex);
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableNil(L: PLua_State; TableIndex: Integer; const Key: AnsiString);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushnil(L);
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableBoolean(L: PLua_State; TableIndex: Integer; const Key: AnsiString; B: Boolean);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushboolean(L, Integer(B));
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableNumber(L: PLua_State; TableIndex: Integer; const Key: AnsiString; N: Double);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushnumber(L, N);
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableString(L: PLua_State; TableIndex: Integer; const Key: AnsiString; S: AnsiString);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushstring(L, PAnsiChar(S));
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableFunction(L: PLua_State; TableIndex: Integer; const Key: AnsiString; F: lua_CFunction);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushcfunction(L, F);
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableLightUserData(L: PLua_State; TableIndex: Integer; const Key: AnsiString; P: Pointer);
begin
  LuaPushKeyString(L, TableIndex, Key);
  lua_pushlightuserdata(L, P);
  lua_rawset(L, TableIndex);
end;

procedure LuaRawSetTableClear(L: PLua_State; TableIndex: Integer);
begin
  TableIndex := LuaAbsIndex(L, TableIndex);

  lua_pushnil(L);
  while (lua_next(L, TableIndex) <> 0) do
  begin
    lua_pushnil(L);
    lua_replace(L, -1 - 1);
    lua_rawset(L, TableIndex);
    lua_pushnil(L);
  end;
end;

function LuaGetMetaFunction(L: PLua_State; Index: Integer; Key: AnsiString): lua_CFunction;
begin
  Result := nil;
  Index := LuaAbsIndex(L, Index);
  if (lua_getmetatable(L, Index) = 0) then
    Exit;

  LuaGetTable(L, -1, Key);
  if (lua_iscfunction(L, -1) <> 0) then
    Result := lua_tocfunction(L, -1);
  lua_pop(L, 2);
end;

procedure LuaSetMetaFunction(L: PLua_State; Index: Integer; Key: AnsiString; F: lua_CFunction);
// ѓЃѓ^ЉЦђ”‚МђЭ’и
// Key = __add, __sub, __mul, __div, __pow, __unm, __concat,
//       __eq, __lt, __le, __index, __newindex, __call
// [ѓЃѓ‚]
// __newindex ‚Н ђV‹K‘г“ьЋћ‚µ‚©ЊД‚О‚к‚И‚ў‚М‚Е’Ќ€У
// table ‚рѓOѓЌЃ[ѓoѓ‹•Пђ”‚Ж‚·‚й‚Ж‚±‚¤‚И‚йЃB
//
// a=1  -- (a=nil‚И‚М‚Е)ѓЃѓ^ЉЦђ”ЊД‚СЏo‚і‚к‚й
// a=2  -- ѓЃѓ^ЉЦђ”‚НЊД‚СЏo‚і‚к‚И‚ў
// a=3  -- ѓЃѓ^ЉЦђ”‚НЊД‚СЏo‚і‚к‚И‚ў
// a=nil
// a=4  -- (a=nil‚И‚М‚Е)ѓЃѓ^ЉЦђ”ЊД‚СЏo‚і‚к‚й
//
// lua •t‘®‚М trace-globals ‚Е‚Н__newindex ‚Ж __index ‚рѓZѓbѓg‚ЕЏгЏ‘‚«‚µ‚Д
// ѓOѓЌЃ[ѓoѓ‹•Пђ”‚Ц‚МѓAѓNѓZѓX‚рѓЌЃ[ѓJѓ‹•Пђ”‚Ц‚МѓAѓNѓZѓX‚ЙђШ‚и‘Ц‚¦‚ДѓOѓЌЃ[
// ѓoѓ‹•Пђ”‚МЋА‘М‚НЏн‚Й table[key] = nil ‚р•Ы‚Ѕ‚№‚Д __newindex ѓCѓxѓ“ѓg‚р
// ”­ђ¶‚і‚№‚Д‚ў‚йЃB
begin
  Index := LuaAbsIndex(L, Index);
  if (lua_getmetatable(L, Index) = 0) then
    lua_newtable(L);

  LuaRawSetTableFunction(L, -1, Key, F);
  lua_setmetatable(L, Index);
end;

function LuaStackToStr(L: PLua_State; Index: Integer; MaxTable: Integer): AnsiString;
//ѓXѓ^ѓbѓN‚М“а—e‚р•¶Ћљ—с‚Й•ПЉ·
// nil    : nil
// Number : FloatToStr
// Boolean: True/False
// stirng : "..."
// Table  : { Key1=Value Key2=Value }
  function TableToStr(Index: Integer): AnsiString;
  var
    Key, Value: AnsiString;
    Count: Integer;
  begin
    Result := '{ ';
    Count := 0;
    lua_pushnil(L);
    while (lua_next(L, Index) <> 0) do
    begin
      Inc(Count);
      if (Count > MaxTable) then
      begin
        Result := Result + '... ';
        lua_pop(L, 2);
        Break;
      end;
      Key := Dequote(LuaStackToStr(L, -2, MaxTable));
      if (Key = '_G') then
        Value := LuaGlobalVariableStr
      else
        Value := LuaStackToStr(L, -1, MaxTable);
      if (lua_type(L, -1) = LUA_TFUNCTION) then
        Result := Result + Format('%s() ', [Key])
      else
        Result := Result + Format('%s=%s ', [Key, Value]);
      // Key ‚НЋџ‚М‚Ѕ‚Я‚ЙЋc‚·
      lua_pop(L, 1);
    end;
    Result := Result + '}';
  end;
var
  Size: Integer;
begin
  if (MaxTable < 0) then
    MaxTable := DefaultMaxTable;

  Index := LuaAbsIndex(L, Index);

  case (lua_type(L, Index)) of
  LUA_TNIL:
    Result := 'nil';
  LUA_TNUMBER:
    Result := Format('%g', [lua_tonumber(L, Index)]);
  LUA_TBOOLEAN:
    Result := BoolToStr(lua_toboolean(L, Index) <> 0, True);
  LUA_TSTRING:
  begin
    Size := lua_strlen(L, Index);
    SetLength(Result, Size);
    if (Size > 0) then
      Move(lua_tostring(L, Index)^, Result[1], Size);
    Result := Quote(Result);
  end;
  LUA_TTABLE:
    Result := TableToStr(Index);
  LUA_TFUNCTION:
    if (lua_iscfunction(L, Index) <> 0) then
      Result := Format('CFUNC:%p', [Pointer(lua_tocfunction(L, Index))])
    else
      Result := Format('FUNC:%p', [lua_topointer(L, Index)]);
  LUA_TUSERDATA:
    Result := Format('USERDATA:%p', [lua_touserdata(L, Index)]);
  LUA_TTHREAD:
    Result := Format('THREAD:%p', [lua_tothread(L, Index)]);
  LUA_TLIGHTUSERDATA:
    Result := Format('LIGHTUSERDATA:%p', [lua_touserdata(L, Index)]);
  else
    Assert(False);
  end;
end;

procedure LuaShowStack(L: PLua_State; Caption: AnsiString);
var
  I, N: Integer;
  S: AnsiString;
begin
  N := lua_gettop(L);
  S := '[' + Caption + ']';
  for I := N downto 1 do
    S := S + CRLF + Format('%3d,%3d:%s', [LuaAbsIndex(L, I), LuaIncIndex(L, I),
      LuaStackToStr(L, I, -1)]);
  ShowMessage(S);
end;

procedure LuaProcessTableName(L: PLua_State; const Name: PAnsiChar;
  var LastName: AnsiString; var TableIndex, Count: Integer);
// Name ‚МѓeЃ[ѓuѓ‹—v‘f‚рѓXѓ^ѓbѓN‚ЙђП‚с‚ЕЃA
// ѓXѓ^ѓbѓN‚ЙђП‚с‚ѕђ”‚Ж Name ‚МЌЕЏI—v‘f‚М–ј‘O‚Ж‚»‚МђeѓeЃ[ѓuѓ‹‚МѓCѓ“ѓfѓbѓNѓX‚р•Ф‚·
// ѓeЃ[ѓuѓ‹‚Є–і‚ўЏкЌ‡‚НЌмђ¬‚·‚й
// LuaProcessTableName(L, 'print', S, TI, Count) ЃЁ S = print, TI = LUA_GLOBALSINDEX, Count = 0
// LuaProcessTableName(L, 'io.write', S, TI, Count) ЃЁ S = write, TI -> io, Count = 1
// LuaProcessTableName(L, 'a.b.c.func', S, TI, Count) ЃЁ S = func, TI -> a.b.c, Count = 3
  function GetToken(var S: AnsiString): AnsiString;
  var
    Index: Integer;
  begin
    Index := Pos('.', S);
    if (Index = 0) then
    begin
      Result := S;
      S := '';
      Exit;
    end;
    Result := Copy(S, 1, Index - 1);
    S := Copy(S, Index + 1, Length(S));
  end;
var
  S: AnsiString;
begin
  S := Name;
  Count := 0;

  LastName := GetToken(S);
  while (S <> '') do
  begin
    Inc(Count);
    TableIndex := LuaAbsIndex(L, TableIndex);
    LuaGetTable(L, TableIndex, LastName);
    if (lua_type(L, -1) <> LUA_TTABLE) then
    begin
      lua_pop(L, 1);
      lua_pushstring(L, PAnsiChar(LastName));
      lua_newtable(L);
      lua_rawset(L, TableIndex);
      LuaGetTable(L, TableIndex, LastName);
    end;
    TableIndex := -1;
    LastName := GetToken(S);
  end;
end;

procedure LuaRegisterCustom(L: PLua_State; TableIndex: Integer; const Name: PAnsiChar; F: lua_CFunction);
var
  Count: Integer;
  S: AnsiString;
begin
  LuaProcessTableName(L, Name, S, TableIndex, Count);
  LuaRawSetTableFunction(L, TableIndex, S, F);
  lua_pop(L, Count);
end;

procedure LuaRegister(L: PLua_State; const Name: PAnsiChar; F: lua_CFunction);
// ЉЦђ”‚М“o^
// LuaRegister(L, 'print', lua_print);
// LuaRegister(L, 'io.write', lua_io_write);  // ѓeЃ[ѓuѓ‹ io ‚Є–і‚ўЏкЌ‡‚НЌмђ¬
// LuaRegister(L, 'a.b.c.func', a_b_c_func);  // ѓeЃ[ѓuѓ‹ a.b.c ‚Є–і‚ўЏкЌ‡‚НЌмђ¬
begin
  LuaRegisterCustom(L, LUA_GLOBALSINDEX, Name, F);
end;

procedure LuaRegisterMetatable(L: PLua_State; const Name: PAnsiChar; F: lua_CFunction);
begin
  LuaRegisterCustom(L, LUA_REGISTRYINDEX, Name, F);
end;

procedure LuaRegisterProperty(L: PLua_State; const Name: PAnsiChar; ReadFunc, WriteFunc: lua_CFunction);
var
  Count: Integer;
  TI: Integer;
  S: AnsiString;
begin
  TI := LUA_GLOBALSINDEX;
  LuaProcessTableName(L, Name, S, TI, Count);
  TI := LuaAbsIndex(L, TI);

  LuaGetTable(L, TI, S);
  if (lua_type(L, -1) <> LUA_TTABLE) then
  begin
    lua_pop(L, 1);
    lua_pushstring(L, PAnsiChar(S));
    lua_newtable(L);
    lua_settable(L, TI);
    LuaGetTable(L, TI, S);
  end;
  if (Assigned(ReadFunc)) then
    LuaSetMetaFunction(L, -1, '__index', ReadFunc);
  if (Assigned(WriteFunc)) then
    LuaSetMetaFunction(L, -1, '__newindex', WriteFunc);
  lua_pop(L, Count + 1);
end;

procedure LuaStackToStrings(L: PLua_State; Lines: TStrings; MaxTable: Integer);
var
  I: Integer;
begin
  Lines.Clear;
  for I := lua_gettop(L) downto 1 do
    Lines.Add(LuaStackToStr(L, I, MaxTable));
end;

procedure LuaLocalToStrings(L: PLua_State; Lines: TStrings; MaxTable: Integer);
var
  Name: PAnsiChar;
  Index: Integer;
  Debug: lua_Debug;
  AR: Plua_Debug;
begin
  AR := @Debug;
  Lines.Clear;
  Index := 1;
  if (lua_getstack(L, 0, AR) = 0) then
    Exit;

  Name := lua_getlocal(L, AR, Index);
  while (Name <> nil) do
  begin
    Lines.Values[Name] := LuaStackToStr(L, -1, MaxTable);
    lua_pop(L, 1);
    Inc(Index);
    Name := lua_getlocal(L, AR, Index);
  end;
end;

procedure LuaTableToStrings(L: PLua_State; Index: Integer; Lines: TStrings; MaxTable: Integer);
var
  Key, Value: AnsiString;
begin
  Index := LuaAbsIndex(L, Index);
  Lines.Clear;
  lua_pushnil(L);
  while (lua_next(L, Index) <> 0) do begin
    Key := Dequote(LuaStackToStr(L, -2, MaxTable));
    Value := LuaStackToStr(L, -1, MaxTable);
    Lines.Values[Key] := Value;
    lua_pop(L, 1);
  end;
end;

procedure LuaTableToTreeView(L: PLua_State; Index: Integer; TV: TTreeView; MaxTable: Integer);
// Index ‚М Table ‚©‚з TreeView Ќмђ¬
  procedure ParseTreeNode(TreeNode: TTreeNode; Index: Integer);
  var
    Key: AnsiString;
  begin
    Index := LuaAbsIndex(L, Index);

    lua_pushnil(L);
    while (lua_next(L, Index) <> 0) do
    begin
      Key := Dequote(LuaStackToStr(L, -2, MaxTable));
      if (lua_type(L, -1) <> LUA_TTABLE) then
        TV.Items.AddChild(TreeNode, Key + '=' + LuaStackToStr(L, -1, MaxTable))
      else
      begin
        if (Key = '_G') then
          TV.Items.AddChild(TreeNode, Key + '={ѓOѓЌЃ[ѓoѓ‹•Пђ”}')
        else
          ParseTreeNode(TV.Items.AddChild(TreeNode, Key), -1);
      end;
      lua_pop(L, 1);
    end;
  end;
begin
  Assert(lua_type(L, Index) = LUA_TTABLE);
  TV.Items.BeginUpdate;
  TV.Items.Clear;
  try
    ParseTreeNode(nil, Index);
  finally
    TV.Items.EndUpdate;
  end;
end;

function LuaGetIdentValue(L: PLua_State; Ident: AnsiString; MaxTable: Integer): AnsiString;
const
  DebugValue = '___DEBUG_VALUE___';
var
  Local: TStrings;
  Code: AnsiString;
  Hook: lua_Hook;
  Mask: Integer;
  Count: Integer;
begin
  if (Ident = '') then
  begin
    Result := '';
    Exit;
  end;

  Local := TStringList.Create;
  try
    LuaLocalToStrings(L, Local, MaxTable);
    Result := Local.Values[Ident];
    if (Result <> '') then
      Exit;
  finally
    Local.Free;
  end;

  Code := DebugValue + '=' + Ident;
  luaL_loadbuffer(L, PAnsiChar(Code), Length(Code), 'debug');
  Hook := lua_gethook(L);
  Mask := lua_gethookmask(L);
  Count := lua_gethookcount(L);
  lua_sethook(L, Hook, 0, Count);
  if (lua_pcall(L, 0, 0, 0) = 0) then
    LuaRawGetTable(L, LUA_GLOBALSINDEX, DebugValue);
  Result := LuaStackToStr(L, -1, MaxTable);
  lua_remove(L, -1);
  lua_dostring(L, DebugValue + '=nil');
  lua_sethook(L, Hook, Mask, Count);
end;

procedure LuaSetIdentValue(L: PLua_State; Ident, Value: AnsiString; MaxTable: Integer);
var
  Local: TStrings;
  Code: AnsiString;
  Index: Integer;
  Debug: lua_Debug;
  AR: Plua_Debug;
begin
  Local := TStringList.Create;
  try
    AR := @Debug;
    LuaLocalToStrings(L, Local, MaxTable);
    Index := Local.IndexOf(Ident);
    if (Index >= 0) then
    begin
      try
        lua_pushnumber(L, StrToFloat(Value));
      except
        lua_pushstring(L, PAnsiChar(Dequote(Value)));
      end;
      lua_getstack(L, 0, AR);
      lua_getinfo(L, 'Snlu', AR);
      lua_setlocal(L, AR, Index + 1);
    end else
    begin
      Code := Ident + '=' + Value;
      luaL_loadbuffer(L, PAnsiChar(Code), Length(Code), 'debug');
      if (lua_pcall(L, 0, 0, 0) <> 0) then
        lua_remove(L, -1);
    end;
  finally
    Local.Free;
  end;
end;

procedure LuaProcessErrorMessage(const ErrMsg: AnsiString; var Title: AnsiString; var Line: Integer; var Msg: AnsiString);
const
  Term = #$00;
  function S(Index: Integer): AnsiChar;
  begin
    if (Index <= Length(ErrMsg)) then
      Result := ErrMsg[Index]
    else
      Result := Term;
  end;
  function IsDigit(C: AnsiChar): Boolean;
  begin
    Result := ('0' <= C) and (C <= '9');
  end;
  function PP(var Index: Integer): Integer;
  begin
    Inc(Index);
    Result := Index;
  end;
var
  I, Start, Stop: Integer;
  LS: AnsiString;
  Find: Boolean;
begin
  // ErrMsg = Title:Line:Message
  Title := '';
  Line := 0;
  Msg := ErrMsg;
  Find := False;
  I := 1 - 1;
  Stop := 0;
  // :ђ”’l: ‚р’T‚·
  repeat
    while (S(PP(I)) <> ':') do
      if (S(I) = Term) then
        Exit;
    Start := I;
    if (not IsDigit(S(PP(I)))) then
      Continue;
    while (IsDigit(S(PP(I)))) do
      if (S(I - 1) = Term) then
        Exit;
    Stop := I;
    if (S(I) = ':') then
      Find := True;
  until (Find);
  Title := Copy(ErrMsg, 1, Start - 1);
  LS := Copy(ErrMsg, Start + 1, Stop - Start - 1);
  Line := StrToIntDef(LS, 0);
  Msg := Copy(ErrMsg, Stop + 1, Length(ErrMsg));
end;

procedure LuaLoadBuffer(L: PLua_State; const Code: AnsiString; const Name: AnsiString);
var
  Title, Msg: AnsiString;
  Line: Integer;
begin
  if (luaL_loadbuffer(L, PAnsiChar(Code), Length(Code), PAnsiChar(Name)) = 0) then
    Exit;

  LuaProcessErrorMessage(Dequote(LuaStackToStr(L, -1, -1)),
    Title, Line, Msg);
  raise ELuaException.Create(Title, Line, Msg);
end;

procedure XXX(L: Plua_State; Level: Integer);
var
  Name: PAnsiChar;
  Index: Integer;
  Debug: lua_Debug;
  AR: Plua_Debug;
begin
  AR := @Debug;
//  Lines.Clear;
  Index := 1;
  if (lua_getstack(L, Level, AR) = 0) then
    Exit;
  LuaShowStack(L);

(*  Name := lua_getlocal(L, AR, Index);
  while (Name <> nil) do
  begin
    Lines.Values[Name] := LuaStackToStr(L, -1, MaxTable);
    lua_pop(L, 1);
    Inc(Index);
    Name := lua_getlocal(L, AR, Index);
  end; *)
end;

procedure LuaPCall(L: PLua_State; NArgs, NResults, ErrFunc: Integer);
var
  Title, Msg, StackTrace: AnsiString;
  Line: Integer;
begin
  if (lua_pcall(L, NArgs, NResults, ErrFunc) = 0) then
    Exit;

  StackTrace := LuaStackToStr(L, -1, -1);
  LuaProcessErrorMessage(Dequote(StackTrace), Title, Line, Msg);
  raise ELuaException.Create(Title, Line, Msg);
end;

procedure LuaError(L: PLua_State; const Msg: AnsiString);
begin
  luaL_error(L, PAnsiChar(Msg));
end;

procedure LuaErrorFmt(L: PLua_State; const Fmt: AnsiString; const Args: array of Const);
begin
  LuaError(L, Format(Fmt, Args));
end;

{ ELuaException }

constructor ELuaException.Create(Title: AnsiString; Line: Integer;
  Msg: AnsiString);
var
  LS: AnsiString;
begin
  if (Line > 0) then
    LS := Format('(%d)', [Line])
  else
    LS := '';
  inherited Create(Title + LS + Msg);
  Self.Title := Title;
  Self.Line := Line;
  Self.Msg := Msg;
end;

function LuaDataStrToStrings(const TableStr: AnsiString; Strings: TStrings): AnsiString;
(*
  LuaStackToStr Њ`Ћ®‚©‚з Strings.Values[Name] Ќ\‘ў‚Ц•ПЉ·
  TableStr
  { Name = "Lua" Version = 5.0 }
  Ѓ«
  Strings
  Name="Lua"
  Version=5.0

  DataList  : Data DataList
            |

  Data      : Table
            | {ѓOѓЌЃ[ѓoѓ‹•Пђ”}
            | Ident ( )
            | Ident = Value
            | Ident
            |

  Table     : { DataList }
            |

  Value     : "..."
            | Data

*)
const
  EOF = #$00;
var
  Index: Integer;
  Text: AnsiString;
  Token: AnsiChar;
  function S(Index: Integer): AnsiChar;
  begin
    if (Index <= Length(TableStr)) then
      Result := TableStr[Index]
    else
      Result := EOF;
  end;
  function GetString: AnsiString;
  var
    SI: Integer;
  begin
    Dec(Index);
    Result := '';
    repeat
      Assert(S(Index) = '"');
      SI := Index;
      Inc(Index);
      while (S(Index) <> '"') do
        Inc(Index);
      Result := Result + Copy(TableStr, SI, Index - SI + 1);
      Inc(Index);
    until (S(Index) <> '"');
  end;
  function GetValue: AnsiString;
    function IsIdent(C: AnsiChar): Boolean;
    const
      S = ' =(){}' + CR + LF;
    begin
      Result := (Pos(C, S) = 0);
    end;
  var
    SI: Integer;
  begin
    Dec(Index);
    SI := Index;
    while (IsIdent(S(Index))) do
      Inc(Index);
    Result := Copy(TableStr, SI, Index - SI);
  end;
  function GetToken: AnsiChar;
    function SkipSpace(var Index: Integer): Integer;
    const
      TAB = #$09;
      CR = #$0D;
      LF = #$0A;
    begin
      while (S(Index) in [' ', TAB, CR, LF]) do
        Inc(Index);
      Result := Index;
    end;
  begin
    SkipSpace(Index);
    Token := S(Index);
    Inc(Index);
    Text := Token;
    case (Token) of
    EOF: ;
    '"': Text := GetString;
    '{':
      if (Copy(TableStr, Index - 1, Length(LuaGlobalVariableStr)) = LuaGlobalVariableStr) then
      begin
        Token := 'G';
        Text := LuaGlobalVariableStr;
        Inc(Index, Length(LuaGlobalVariableStr) - 1);
      end;
    '}': ;
    '(': ;
    ')': ;
    '=': ;
    else Text := GetValue
    end;
    Result := Token;
  end;
  procedure Check(S: AnsiString);
  begin
    if (Pos(Token, S) = -1) then
      raise Exception.CreateFmt('Error %s is required :%s', [Copy(TableStr, Index - 1, Length(TableStr))]);
  end;
  function CheckGetToken(S: AnsiString): AnsiChar;
  begin
    Result := GetToken;
    Check(S);
  end;
  function ParseData: AnsiString; forward;
  function ParseTable: AnsiString; forward;
  function ParseValue: AnsiString; forward;
  function ParseDataList: AnsiString;
  begin
    with (TStringList.Create) do
    try
      while not (Token in [EOF, '}']) do
        Add(ParseData);
      Result := Text;
    finally
      Free;
    end;
  end;
  function ParseData: AnsiString;
  begin
    if (Token = EOF) then
    begin
      Result := '';
      Exit;
    end;

    case (Token) of
    '{': Result := ParseTable;
    'G':
      begin
        Result := Text;
        GetToken;
      end;
    else
      begin
        Result := Text;
        case (GetToken) of
        '(':
          begin
            CheckGetToken(')');
            Result := Format('%s=()', [Result]);
            GetToken;
          end;
        '=':
          begin
            GetToken;
            Result := Format('%s=%s', [Result, ParseValue]);
          end;
        end;
      end;
    end;
  end;
  function ParseTable: AnsiString;
  begin
    if (Token in [EOF]) then
    begin
      Result := '';
      Exit;
    end;
    Check('{');
    GetToken;
    with (TStringList.Create) do
    try
      Text := ParseDataList;
      Result := CommaText;
    finally
      Free;
    end;
    Check('}');
    GetToken;
  end;
  function ParseValue: AnsiString;
  begin
    if (Token = EOF) then
    begin
      Result := '';
      Exit;
    end;

    case (Token) of
    '"':
      begin
        Result := Text;
        GetToken;
      end;
    else
      Result := ParseData;
    end;
  end;
begin
  Index := 1;
  GetToken;
  Strings.Text := ParseDataList;
end;

function LuaDoFile(L: PLua_State): Integer; cdecl;
const
  ArgIdent = 'arg';
var
  FileName: PAnsiChar;
  I, N, R: Integer;
  ArgTable, ArgBackup: Integer;
begin
  N := lua_gettop(L);

  lua_getglobal(L, ArgIdent);
  ArgBackup := lua_gettop(L);

  FileName := luaL_checkstring(L, 1);
  lua_newtable(L);
  ArgTable := lua_gettop(L);
  for I := 2 to N do begin
    lua_pushvalue(L, I);
    lua_rawseti(L, ArgTable, I - 1);
  end;
  lua_setglobal(L, ArgIdent);

  Result := lua_gettop(L);
  luaL_loadfile(L, PAnsiChar(FileName));
  R := lua_pcall(L, 0, LUA_MULTRET, 0);
  Result := lua_gettop(L) - Result;

  LuaRawSetTableValue(L, LUA_GLOBALSINDEX, ArgIdent, ArgBackup);
  lua_remove(L, ArgBackup);

  if (R <> 0) then
    lua_error(L);
end;

initialization
  DefaultMaxTable := 256;

end.
