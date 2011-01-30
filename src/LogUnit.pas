unit LogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sListBox, Buttons, sBitBtn;

type
  TLogForm = class(TForm)
    Events: TsListBox;
    CloseButton: TsBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.dfm}

end.
