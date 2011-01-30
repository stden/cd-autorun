unit TestX;

interface

implementation

uses SysUtils, LuaBase;

procedure TestLua;
var L : PLua_State;
begin
  L := lua_open;
  // Открываем библиотеки
  luaopen_math(L);
  luaopen_io(L);
  luaopen_base(L);

  lua_close(L);
end;

initialization

TestLua;

end.
