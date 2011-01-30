program Autorun;

uses
  Windows,
  Forms,
  SysUtils,
  MainUnit in 'MainUnit.pas' {AutorunForm},
  DMessageDlg in 'DMessageDlg.pas',
  DShowText in 'DShowText.pas' {ShowTextForm},
  SelectForInstallUnit in 'SelectForInstallUnit.pas' {SelectForInstall},
  DRegistry in 'DRegistry.pas',
  Prepare in 'Prepare.pas',
  GIFImage in 'GIFImage.pas',
  Utils in 'Utils.pas',
  LuaUtils in '..\LuaDelphi\LuaUtils.pas',
  lauxlib in '..\LuaDelphi\lauxlib.pas',
  lua in '..\LuaDelphi\lua.pas',
  DLua in 'DLua.pas',
  LuaBase in '..\LuaDelphi\LuaBase.pas',
  DNetwork in 'DNetwork.pas',
  SelectDirU in 'SelectDirU.pas',
  WindowsFunc in 'WindowsFunc.pas',
  GraphicCompression in 'GraphicEx\GraphicCompression.pas',
  GraphicEx in 'GraphicEx\GraphicEx.pas',
  pngimage in 'PNG\pngimage.pas',
  InstallWizardUnit in 'InstallWizardUnit.pas' {InstallWizardForm},
  InstallAllWizardUnit in 'InstallAllWizardUnit.pas' {InstallAllWizardForm},
  LogUnit in 'LogUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'КИО "Журнал в журнале"';
  Application.MainFormOnTaskBar := false;
  Application.CreateForm(TAutorunForm, AutorunForm);
  Application.CreateForm(TInstallWizardForm, InstallWizardForm);
  Application.CreateForm(TInstallAllWizardForm, InstallAllWizardForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.Run;
end.
