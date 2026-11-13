unit InstallWizardUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, sLabel, sPageControl, sButton, sPanel;

type
  TInstallWizardForm = class(TForm)
    TopPanel: TsPanel;
    Label1: TsLabel;
    BottomPanel: TsPanel;
    SkipButton: TsButton;
    InstallButton: TsButton;
    Label2: TsLabel;
    Label3: TsLabel;
    Label4: TsLabel;
    Image1: TImage;
    PageControl1: TsPageControl;
    TabSheet1: TsTabSheet;
    TabSheet2: TsTabSheet;
    procedure InstallButtonClick(Sender: TObject);
    procedure SkipButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InstallWizardForm: TInstallWizardForm;

implementation

{$R *.dfm}

procedure TInstallWizardForm.InstallButtonClick(Sender: TObject);
begin
  // Установить
end;

procedure TInstallWizardForm.SkipButtonClick(Sender: TObject);
begin
  // Переход сразу к выбору папки
end;

end.
