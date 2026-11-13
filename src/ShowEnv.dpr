program ShowEnv;

uses
  Forms,
  ShowEvnUnit in 'ShowEvnUnit.pas' {ShowEnvForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TShowEnvForm, ShowEnvForm);
  Application.Run;
end.
