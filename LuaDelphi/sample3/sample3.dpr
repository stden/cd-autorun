program sample3;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {frmMain},
  LuaUtils in '..\LuaUtils.pas',
  lauxlib in '..\lauxlib.pas',
  lua in '..\lua.pas',
  lualib in '..\lualib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
