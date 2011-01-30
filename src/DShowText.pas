unit DShowText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, sMemo;

type
  TShowTextForm = class(TForm)
    Config: TsMemo;
  end;

var
  ShowTextForm: TShowTextForm;

implementation

{$R *.dfm}

end.
