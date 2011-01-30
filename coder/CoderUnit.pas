unit CoderUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, sMaskEdit, sCustomComboEdit, sTooledit, sSkinManager,
  sButton, sAlphaListBox, sMemo, sEdit, sCheckBox;

type
  TCoderForm = class(TForm)
    SiteDir: TsDirectoryEdit;
    sSkinManager1: TsSkinManager;
    Convert: TsButton;
    Log: TsListBox;
    sMemo1: TsMemo;
    What: TsEdit;
    Replace: TsEdit;
    ChangeText: TsCheckBox;
    procedure ConvertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Search( Dir : string );
    procedure ConvFile( FileName : string );
  end;

var
  CoderForm: TCoderForm;

implementation

{$R *.dfm}

// Добавление слеша к концу пути, если он нужен
function P( S:string ):string;
begin
  if (S='') or (S[Length(S)] = '\')  then
    P := S
  else
    P := S + '\';
end;

// Оканчивается ли строка S на подстроку EndS
function EndsWith( S,EndS:string ):boolean;
begin
  EndsWith := Copy(S,Length(S)-Length(EndS)+1,Length(EndS)) = EndS;
end;

procedure TCoderForm.ConvertClick(Sender: TObject);
begin
  Search('');
end;

procedure TCoderForm.ConvFile(FileName: string);
var
  S : TStringList;
  FullName: string;
  I: Integer;
begin
  Log.Items.Add('>> "'+FileName+'"');
  S := TStringList.Create;
  FullName := P(SiteDir.Text) + FileName;
  S.LoadFromFile(FullName);
  if ChangeText.Checked then
    for I := 0 to S.Count - 1 do
      S[I] := StringReplace(S[I],What.Text,Replace.Text,[rfReplaceAll]);
  S.SaveToFile(FullName,TEncoding.UTF8);
  S.Free;
end;

procedure TCoderForm.Search(Dir: string);
var
  SR : TSearchRec;
  Ext: string;
begin
  Log.Items.Add('Каталог "'+Dir+'"');
  // Ищем и разбегаемся по подкаталогам
  if FindFirst( P(P(SiteDir.Text) + Dir) + '*.*', faDirectory, SR) = 0 then begin
    repeat
      // Разбегаемся рекурсивно по подкаталогам
      if (SR.attr and faDirectory) = faDirectory then begin
        if (SR.Name <> '.') and (SR.Name <> '..') then
          Search( P(Dir) + SR.Name );
      end else begin
        for Ext in sMemo1.Lines do
          if EndsWith(LowerCase(SR.Name),LowerCase(Ext)) then
            ConvFile(P(Dir)+SR.Name);
      end;
    until FindNext(SR) <> 0;
    // Освобождаем ресурсы
    FindClose(SR);
  end;
end;

end.
