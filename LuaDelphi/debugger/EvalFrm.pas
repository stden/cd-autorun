unit EvalFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmEval = class(TForm)
    Label1: TLabel;
    edtIdent: TEdit;
    memValue: TMemo;
    Label2: TLabel;
    edtNewValue: TEdit;
    btnEval: TButton;
    btnChange: TButton;
    Label3: TLabel;
    procedure btnEvalClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
  end;

var
  frmEval: TfrmEval;

implementation

uses MacroFrm;

{$R *.dfm}

procedure TfrmEval.btnEvalClick(Sender: TObject);
begin
  memValue.Text := frmMacro.GetValue(edtIdent.Text);
end;

procedure TfrmEval.btnChangeClick(Sender: TObject);
begin
  frmMacro.SetValue(edtIdent.Text, edtNewValue.Text);
  btnEvalClick(Self);
end;

end.
