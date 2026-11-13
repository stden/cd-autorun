// Модуль с русифицированной и упрощённой функцией MessageDlg
// и диалогом AskMessageDlg
unit DMessageDlg;

interface

uses Dialogs;

// Эта функция ведет себя как настоящий MessageDlg.
// Она не создает нового окна. И вызывается модально, т.е. нельзя
// переключиться на другое окно не отреагировав на сообщение.
function _MessageDlg( const Msg: string; DlgType: TMsgDlgType ): boolean;

// Диалог: подтверждение с пользовательскими кнопками
function AskMessageDlg( const Msg: string; DlgType: TMsgDlgType;
  Buttons: array of string; DefaultButton: string ): string;

implementation

uses Windows, Controls, Forms, StdCtrls, Graphics, Classes, Messages, SysUtils, CommDlg,
  Printers, ExtCtrls, Consts, Dlgs, Math;

function _MessageDlg( const Msg: string; DlgType: TMsgDlgType ): boolean;
var
  Caption : String;
  DType,Buttons : Word;
  Res : Word;
begin
  DType := 0;
  Case DlgType of
    mtCustom: Caption := Application.Title; // A message box with a caption you supply (or, if you do not supply a caption, with the application title for a caption.)
    mtInformation: Caption := 'Информация'; // A message box with the caption 'Information'.
    mtWarning: Caption := 'Предупреждение'; // A message box with the caption 'Warning'.
    mtError: Caption := 'Ошибка'; // A message box with the caption 'Error'.
    mtConfirmation: Caption := 'Подтверждение'; // A message box with the caption 'Confirm' that asks for confirmation before performing some action. If you do not supply an image to appear in the message box, it displays the confirmation icon.
  end;
  Case DlgType of
    mtCustom: DType := MB_ICONHAND;
    mtInformation: DType := MB_ICONINFORMATION;
    mtWarning: DType := MB_ICONWARNING;
    mtError: DType := MB_ICONERROR;
    mtConfirmation: DType := MB_ICONQUESTION;
  end;
  Buttons := MB_OK;
  Case DlgType of
    mtInformation: Buttons := MB_OK;
    mtWarning: Buttons := MB_OK;
    mtError: Buttons := MB_OK;
    mtConfirmation: Buttons := MB_YESNO;
  end;
  Res := mrOK;
  case MessageBox(Application.Handle,PChar(Msg),PChar(Caption), DType or Buttons
    or MB_SYSTEMMODAL{!!!!} ) of
    IDABORT: Res := mrAbort; // Abort button was selected.
    IDCANCEL: Res := mrCancel; // Cancel button was selected.
    IDIGNORE: Res := mrIgnore; // Ignore button was selected.
    IDNO: Res := mrNo; // No button was selected.
    IDOK: Res := mrOK; // OK button was selected.
    IDRETRY: Res := mrRetry; // Retry button was selected.
    IDYES: Res := mrYes; // Yes button was selected.
  end;
  Result := true;
  if Res = mrYes then Result := true;
  if Res = mrNo then Result := false;
end;

{ Message dialog }

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

type
  TMessageForm = class(TForm)
  private
    Message: TLabel;
  protected
    procedure CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WriteToClipBoard(Text: String);
    function GetFormText: String;
  public
    ResultButton : String;
    procedure ButtonClick(Sender: TObject);
    constructor CreateNew(AOwner: TComponent); reintroduce;
  end;

procedure TMessageForm.ButtonClick(Sender: TObject);
begin
  ResultButton := TButton(Sender).Caption;
  Close;
end;

constructor TMessageForm.CreateNew(AOwner: TComponent);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited CreateNew(AOwner);
  NonClientMetrics.cbSize := sizeof(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

procedure TMessageForm.CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = Word('C')) then
  begin
    Beep;
    WriteToClipBoard(GetFormText);
  end;
end;

procedure TMessageForm.WriteToClipBoard(Text: String);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  if OpenClipBoard(0) then
  begin
    try
      Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Length(Text) + 1);
      try
        DataPtr := GlobalLock(Data);
        try
          Move(PChar(Text)^, DataPtr^, Length(Text) + 1);
          EmptyClipBoard;
          SetClipboardData(CF_TEXT, Data);
        finally
          GlobalUnlock(Data);
        end;
      except
        GlobalFree(Data);
        raise;
      end;
    finally
      CloseClipBoard;
    end;
  end
  else
    raise Exception.CreateRes(@SCannotOpenClipboard);
end;

function TMessageForm.GetFormText: String;
var
  DividerLine, ButtonCaptions: string;
  I: integer;
begin
  DividerLine := StringOfChar('-', 27) + sLineBreak;
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TButton then
      ButtonCaptions := ButtonCaptions + TButton(Components[I]).Caption +
        StringOfChar(' ', 3);
  ButtonCaptions := StringReplace(ButtonCaptions,'&','', [rfReplaceAll]);
  Result := Format('%s%s%s%s%s%s%s%s%s%s', [DividerLine, Caption, sLineBreak,
    DividerLine, Message.Caption, sLineBreak, DividerLine, ButtonCaptions,
    sLineBreak, DividerLine]);
end;

const
  SMsgDlgWarning = 'Предупреждение';
  SMsgDlgError = 'Ошибка';
  SMsgDlgInformation = 'Информация';
  SMsgDlgConfirm = 'Подтверждение';

var
  Captions: array[TMsgDlgType] of String = (SMsgDlgWarning, SMsgDlgError,
    SMsgDlgInformation, SMsgDlgConfirm, '');
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);

function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons : array of string; DefaultButton : string ): TMessageForm;
const
  mcHorzMargin = 8;
  mcVertMargin = 8;
  mcHorzSpacing = 10;
  mcVertSpacing = 10;
  mcButtonWidth = 50;
  mcButtonHeight = 14;
  mcButtonSpacing = 4;
var
  DialogUnits: TPoint;
  HorzMargin, VertMargin, HorzSpacing, VertSpacing, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonGroupWidth,
  IconTextWidth, IconTextHeight, X, ALeft: Integer;
  B : integer;
  CancelButton: string;
  IconID: PChar;
  TextRect: TRect;
  LButton: TButton;
  ButtonWidths : array of integer;  // initialized to zero
begin
  SetLength(ButtonWidths,Length(Buttons));
  Result := TMessageForm.CreateNew(Application);
  with Result do
  begin
    BiDiMode := Application.BiDiMode;
    BorderStyle := bsDialog;
    Canvas.Font := Font;
    KeyPreview := True;
    Position := poDesigned;
    OnKeyDown := TMessageForm(Result).CustomKeyDown;
    DialogUnits := GetAveCharSize(Canvas);
    HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
    VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
    HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
    VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(mcButtonWidth, DialogUnits.X, 4);
    for B := Low(Buttons) to High(Buttons) do
    begin
        if ButtonWidths[B] = 0 then
        begin
          TextRect := Rect(0,0,0,0);
          Windows.DrawText( canvas.handle,
            PChar(Buttons[B]), -1,
            TextRect, DT_CALCRECT or DT_LEFT or DT_SINGLELINE or
            DrawTextBiDiModeFlagsReadingOnly);
          with TextRect do ButtonWidths[B] := Right - Left + 8;
        end;
        if ButtonWidths[B] > ButtonWidth then
          ButtonWidth := ButtonWidths[B];
    end;
    ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
    ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
    SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
    DrawText(Canvas.Handle, PChar(Msg), Length(Msg)+1, TextRect,
      DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK or
      DrawTextBiDiModeFlagsReadingOnly);
    IconID := IconIDs[DlgType];
    IconTextWidth := TextRect.Right;
    IconTextHeight := TextRect.Bottom;
    if IconID <> nil then
    begin
      Inc(IconTextWidth, 32 + HorzSpacing);
      if IconTextHeight < 32 then IconTextHeight := 32;
    end;
    ButtonGroupWidth := 0;
    if Length(Buttons) <> 0 then
      ButtonGroupWidth := ButtonWidth * Length(Buttons) +
        ButtonSpacing * (Length(Buttons) - 1);
    ClientWidth := Max(IconTextWidth, ButtonGroupWidth) + HorzMargin * 2;
    ClientHeight := IconTextHeight + ButtonHeight + VertSpacing +
      VertMargin * 2;
    Left := (Screen.Width div 2) - (Width div 2);
    Top := (Screen.Height div 2) - (Height div 2);
    if DlgType <> mtCustom then
      Caption := Captions[DlgType] else
      Caption := Application.Title;
    if IconID <> nil then
      with TImage.Create(Result) do begin
        Name := 'Image';
        Parent := Result;
        Picture.Icon.Handle := LoadIcon(0, IconID);
        SetBounds(HorzMargin, VertMargin, 32, 32);
      end;
    Result.Message := TLabel.Create(Result);
    with Result.Message do
    begin
      Name := 'Message';
      Parent := Result;
      WordWrap := True;
      Caption := Msg;
      BoundsRect := TextRect;
      BiDiMode := Result.BiDiMode;
      ALeft := IconTextWidth - TextRect.Right + HorzMargin;
      if UseRightToLeftAlignment then
        ALeft := Result.ClientWidth - ALeft - Width;
      SetBounds(ALeft, VertMargin,
        TextRect.Right, TextRect.Bottom);
    end;
    X := (ClientWidth - ButtonGroupWidth) div 2;
    for B := Low(Buttons) to High(Buttons) do
      begin
        LButton := TButton.Create(Result);
        with LButton do
        begin
          Name := 'Button'+IntToStr(B);
          Parent := Result;
          Caption := Buttons[B];
          // Устанавливаем, какая кнопка будет какой результат возвращать
          ModalResult := mrOk; //ModalResults[B];
          if Buttons[B] = DefaultButton then
          begin
            Default := True;
            ActiveControl := LButton;
          end;
          if Buttons[B] = CancelButton then
            Cancel := True;
          SetBounds(X, IconTextHeight + VertMargin + VertSpacing,
            ButtonWidth, ButtonHeight);
          Inc(X, ButtonWidth + ButtonSpacing);
          OnClick := Result.ButtonClick;
//          if B = mbHelp then
//            OnClick := TMessageForm(Result).HelpButtonClick;
        end;
      end;
  end;
end;

function xDoMessageDlgPosHelp(MessageDialog: TMessageForm; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string): string;
begin
  with MessageDialog do
    try
      HelpContext := HelpCtx;
      HelpFile := HelpFileName;
      if X >= 0 then Left := X;
      if Y >= 0 then Top := Y;
      if (Y < 0) and (X < 0) then Position := poScreenCenter;
      ShowModal;
      Result := ResultButton;
    finally
      Free;
    end;
end;

function AskMessageDlg( const Msg: string; DlgType: TMsgDlgType;
  Buttons: array of string; DefaultButton: string ): string;
begin
  Result := xDoMessageDlgPosHelp(CreateMessageDialog(Msg, DlgType, Buttons, DefaultButton),
    0, -1, -1, '' );
end;

end.
