unit SelectForInstallUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, CheckLst, sCheckBox, sButton, sPanel,
  sCheckListBox, sListBox;

type
  TSelectForInstall = class(TForm)
    SelectedList: TsCheckListBox;
    Panel1: TsPanel;
    InstallButton: TsButton;
    CancelButton: TsButton;
    sCheckBox1: TsCheckBox;
    sCheckListBox1: TsCheckListBox;
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectForInstall: TSelectForInstall;

implementation

{$R *.dfm}

procedure TSelectForInstall.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
