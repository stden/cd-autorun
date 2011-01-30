unit DLua;

interface

uses LuaBase, Lua, LauxLib, DMessageDlg, Dialogs, Forms;

type
  TLua = class
    L : PLua_State;
    constructor Create( _L : PLua_State );
    procedure Res( var Result:integer; Res:array of const );
    procedure DoFile( FileName: String );
    procedure RegFunction( const Name: String; F: lua_CFunction);
    function Table( const Key: String ): variant;
    procedure Push( Value : variant ); overload;
    procedure Push( Value : TObject ); overload;
    function Pop : variant; overload;
    function PopClass : TObject; overload;
    function Get( index : integer ):variant;
    function GetGlobal( const VarName: String ):variant; overload;
    function RunFunction( const FunctionCall: String ):variant; overload;
    procedure Assert( cond:boolean; const mes:string );
    procedure Exec( const Code:string );
  private
    procedure ClearStack;
  end;
  TLuaActionType = (laLuaAction,laDelphiAction,laOpenLink,laNothing);
  TLuaAction = class
    LuaActionType : TLuaActionType;
    DelphiAction : Lua_CFunction;
    LuaAction : Integer;
    OpenLink, ActionName : String;
    constructor Create( L : PLua_State; ActionKey : String ); overload;
    constructor Create( L : PLua_State ); overload;
    procedure Execute(Sender: TObject);
  private
    procedure SetAction( L: PLua_State; StackIndex : Integer );
  end;

var GLua : TLua;

implementation

uses Utils, Variants, LuaUtils, SysUtils;

function LuaPrint(L: PLua_State): Integer; cdecl;
var I, N: Integer;
begin
  LuaShowStack(L, 'LuaPrint');
  N := lua_gettop(L);
  for I := 1 to N do
    Write('~'+lua_toString(L, I));
  Writeln;
  Result := 0;
end;

{ TLua }

procedure TLua.Assert(cond: boolean; const mes: string);
begin
  if not cond then
    luaL_error(L, PAnsiChar(AnsiString(mes)));
end;

procedure TLua.ClearStack;
begin
  lua_pop( L, lua_gettop(L) );
  Assert( lua_gettop(L) = 0, 'Стек должен быть чист' );
end;

constructor TLua.Create( _L: PLua_State );
begin
  L := _L;
end;

function TLua.Table(const Key: String):variant;
begin
  LuaGetTable(L, 1, Key);
  Result := Get(-1);
  lua_pop(L, 1);
//  Write(' ',Key,'=',Result);
end;

procedure TLua.DoFile( FileName: String );
begin
  try
    luaL_loadfile(L,PAnsiChar(AnsiString(FileName)));
  except
    _MessageDlg('Не удалось выполнить файл '+FileName,mtError);
  end;
  LuaPCall(L,0,0,0);
  ClearStack;
end;

procedure TLua.Exec(const Code: string);
begin
  LuaLoadBuffer(L,Code,'Exec');
  LuaPCall(L,0,0,0);
end;

const VTypeToStr : array [vtInteger..vtUnicodeString] of string = (
  'vtInteger','vtBoolean','vtChar','vtExtended','vtString',
  'vtPointer', 'vtPChar', 'vtObject', 'vtClass', 'vtWideChar',
  'vtPWideChar', 'vtAnsiString', 'vtCurrency', 'vtVariant', 'vtInterface',
  'vtWideString', 'vtInt64', 'vtUnicodeString');

procedure TLua.Res(var Result: integer; Res: array of const );
var i:integer; V : TVarData;
begin
  ClearStack;
  for i := 0 to Length(Res) - 1 do begin
    case Res[i].VType of
      vtInteger: lua_pushnumber(L,Res[i].VInteger);
      vtExtended: lua_pushnumber(L,Res[i].VExtended^);
      vtString,vtUnicodeString:
        lua_pushstring(L, PAnsiChar(AnsiString(string(Res[i].VString))));
      vtAnsiString:
        lua_pushstring(L, PAnsiChar(AnsiString(Res[i].VString)));
      vtBoolean: lua_pushboolean(L,ord(Res[i].VBoolean));
      vtObject: lua_pushlightuserdata(L,Res[i].VObject);
      vtVariant: begin
        V := TVarData(Res[i].VVariant^);
        case V.VType of
          varInteger: lua_pushnumber(L,V.VInteger);
          varDouble: lua_pushnumber(L,V.VDouble);
          varString: lua_pushstring(L, PAnsiChar(V.VString));
          varBoolean: lua_pushboolean(L,ord(V.VBoolean));
          varUString: lua_pushstring(L, PAnsiChar(AnsiString(string(V.VString))));
        else
          raise Exception.Create('Неизвестный тип: '+VarTypeAsText(V.VType));
        end;
      end
    else
      raise Exception.Create('Неизвестный тип: '+VTypeToStr[Res[i].VType]);
    end;
  end;
  Result := Length(Res);
  System.Assert( Result = lua_gettop(L) );
end;

function TLua.RunFunction(const FunctionCall: String): variant;
begin
  try
    Exec( 'temp = '+FunctionCall );
    Result := GLua.GetGlobal('temp');
  except
    on e:ELuaException do
      _MessageDlg(e.Message,mtError);
  end;
end;

function TLua.Get(index: integer): variant;
begin
  case lua_type(L,index) of
    LUA_TNIL: TVarData(Result).VPointer := nil;
    LUA_TBOOLEAN: Result := lua_toboolean(L,index) = 1;
    LUA_TNUMBER: Result := lua_tonumber(L,index);
    LUA_TSTRING: Result := AnsiString(lua_tostring(L,index));
    LUA_TLIGHTUSERDATA: TVarData(Result).VPointer := lua_touserdata(L,index);
    LUA_TTABLE: raise Exception.Create('Не могу получить таблицу');
  else
    raise Exception.Create('Неизвестный тип: '+LuaTypeToStr[lua_type(L,index)]);
  end;
end;

function TLua.GetGlobal(const VarName: String): variant;
begin
  lua_getglobal(L, PAnsiChar(VarName) );
  Result := Get(-1);
  lua_pop(L,1);
end;

function TLua.Pop : variant;
begin
  Result := Get(-1);
  lua_pop(L,1);
end;

function TLua.PopClass : TObject;
begin
  Result := lua_touserdata(L,-1);
  lua_pop(L,1);
end;

procedure TLua.Push( Value: TObject );
begin
  lua_pushlightuserdata(L,Value);
end;

procedure TLua.Push( Value: variant );
begin
  case VarType(Value) of
    varBoolean: lua_pushboolean(L,ord(TVarData(Value).VBoolean));
    varSmallint,varInteger,varDouble,varSingle: lua_pushnumber(L,Value);
    varString: lua_pushstring(L,PAnsiChar(TVarData(Value).VString));
  end;
end;

procedure TLua.RegFunction(const Name: String; F: lua_CFunction);
begin
  LuaRegister(L,PAnsiChar(AnsiString(Name)),F);
end;

{ TLuaAction }

constructor TLuaAction.Create(L: PLua_State; ActionKey: String);
var Top : integer;
begin
  Top := lua_gettop(L);
  ActionName := ActionKey;
  LuaGetTable(L, 1, ActionKey);
  SetAction( L, -1 );
  assert( Top = lua_gettop(L) );
end;

constructor TLuaAction.Create( L: PLua_State );
var Top : integer;
begin
  Top := lua_gettop(L);
  SetAction( L, -1 );
  assert( Top = lua_gettop(L)+1 );
end;

procedure TLuaAction.Execute(Sender: TObject);
begin
  try
    case LuaActionType of
      laLuaAction: begin
          lua_getref(GLua.L,LuaAction);
          LuaPCall(GLua.L,0,0,0);
        end;
      laDelphiAction: DelphiAction(GLua.L);
      laOpenLink: Utils.OpenLink(OpenLink);
      laNothing: _MessageDlg('Не назначено никакого события "'+ActionName+'"',mtError);
    else
      _MessageDlg('Не назначено никакого события "'+ActionName+'"',mtError);
    end;
  except
    on e: ELuaException do begin
      _MessageDlg(e.Message, mtError);
      Application.Terminate;
    end;
  end;
end;

procedure TLuaAction.SetAction;
begin
  case lua_type(L, StackIndex) of
    LUA_TFUNCTION:
      // Если обработчик - функция
      if (lua_iscfunction(L, StackIndex) <> 0) then begin
        // Функция Delphi
        DelphiAction := lua_tocfunction(L, StackIndex);
        LuaActionType := laDelphiAction;
      end else begin
        // Функция Lua
        LuaAction := lua_ref(L, StackIndex);
        LuaActionType := laLuaAction;
      end;
    LUA_TSTRING:
      begin
        // Если обработчик - строка
        OpenLink := lua_tostring(L, StackIndex);
        LuaActionType := laOpenLink;
      end;
    LUA_TNIL:
      LuaActionType := laNothing;
  else
    TLua.Create(L).Assert(false, 'Ожидается обработчик события - '+LuaTypeToStr[lua_type(L, StackIndex)]);
    LuaActionType := laNothing;
  end;
  if LuaActionType <> laLuaAction then
    lua_pop(L,1);
end;

initialization
  GLua := TLua.Create(lua_open);
  luaopen_base(GLua.L);
  GLua.RegFunction('print',LuaPrint);
  lua_atpanic(Glua.L,LuaPrint);
  // Процедура для помещения array of const в стек Lua
  // Процедура для извлечения из стека Lua в array of const

finalization
  lua_close(GLua.L);
  GLua.Free;

end.
