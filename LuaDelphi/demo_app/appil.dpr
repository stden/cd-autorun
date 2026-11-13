program appil;

uses
  Forms,
  Windows,
  SysUtils,
  MainFrm in 'MainFrm.pas' {frmMain},
  LuaUtils in '..\LuaUtils.pas',
  lauxlib in '..\lauxlib.pas',
  lua in '..\lua.pas',
  lualib in '..\lualib.pas',
  LuaBase in '..\LuaBase.pas';

{$R *.res}

{$IFDEF MemCheckStackTrace}
procedure GetExceptInfoFunc(Obj: TObject; var Message: string; var ExceptionRecord: Windows.PExceptionRecord);
begin
  if Obj is Exception then
  begin
    Message := Exception(Obj).Message;
{$WARNINGS OFF}
    if Obj is EExternal then
      ExceptionRecord := Pointer(EExternal(Obj).ExceptionRecord);
{$WARNINGS ON}
  end;
end;

procedure SetExceptMessageFunc(Obj: TObject; const NewMessage: string);
begin
  if Obj is Exception then
    Exception(Obj).Message := NewMessage;
end;
{$ENDIF}

begin
{$IFDEF MemCheckStackTrace}
  MemCheckInstallExceptionHandler(GetExceptInfoFunc, SetExceptMessageFunc);
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
