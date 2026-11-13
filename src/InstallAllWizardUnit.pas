unit InstallAllWizardUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, sLabel, sPageControl, sButton, sPanel;

type
  TInstallAllWizardForm = class(TForm)
    BottomPanel: TsPanel;
    CancelButton: TsButton;
    BackButton: TsButton;
    NextButton: TsButton;
    WizardImage: TImage;
    WelcomeText: TsLabel;
    InstallButton: TsButton;
    PageControl1: TsPageControl;
    WelcomeStep: TsTabSheet;
    Step1: TsTabSheet;
    TabSheet1: TsTabSheet;
    TabSheet2: TsTabSheet;
    procedure CancelButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Step : Integer;
    procedure UpdatePage;
  end;

var
  InstallAllWizardForm: TInstallAllWizardForm;

implementation

{$R *.dfm}

procedure TInstallAllWizardForm.BackButtonClick(Sender: TObject);
begin
  Dec(Step);
  // Шаг назад в мастере
  PageControl1.SelectNextPage( false, false );
  UpdatePage;
end;

procedure TInstallAllWizardForm.NextButtonClick(Sender: TObject);
begin
  Inc(Step);
  // Врерёд на шаг в мастере
  PageControl1.SelectNextPage( true, false);
  UpdatePage;
end;

procedure TInstallAllWizardForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TInstallAllWizardForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Step := 0;
end;

procedure TInstallAllWizardForm.FormCreate(Sender: TObject);
var i: integer;
begin
  // Прячем закладки. В принципе эту операцию можно выполнить
  // и в Инспекторе объектов, но так будет более универсально
  for i := 0 to PageControl1.PageCount-1 do
    PageControl1.Pages[i].TabVisible := false;
  // Делаем активной (видимой) первую страницу
  PageControl1.ActivePageIndex := 0;
  // Обновляем элементы управления
//     CheckChange(0);
  Step := 0;
end;

procedure TInstallAllWizardForm.UpdatePage;
begin
  WelcomeText.Visible := Step = 0;
  BackButton.Enabled := Step > 0;
  case Step of
    0: begin
      NextButton.Caption := 'Далее >';
      NextButton.Enabled := true;
    end;
    1: begin
      NextButton.Caption := 'Пропустить';
      InstallButton.Visible := true;
      InstallButton.Enabled := true;
    end;
    2: begin
      NextButton.Enabled := false;
      InstallButton.Enabled := false;
    end;
  end;
end;

end.
