program Coder;

uses
  ExceptionLog,
  Forms,
  CoderUnit in 'CoderUnit.pas' {CoderForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCoderForm, CoderForm);
  Application.Run;
end.
