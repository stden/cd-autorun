unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TfrmMain = class(TForm)    
    memLog: TMemo;
    btnTest1: TButton;
    btnDebugger: TButton;
    btnAbout: TButton;
    btnStop: TButton;
    edtFile1: TEdit;
    edtArg2: TEdit;
    edtFile3: TEdit;
    edtArg3_1: TEdit;
    edtArg3_2: TEdit;
    edtFile4: TEdit;
    edtFunc4: TEdit;
    edtArg4: TEdit;
    edtFile5: TEdit;
    edtFunc5: TEdit;
    edtFunc3: TEdit;
    btnTest2: TButton;
    btnTest3: TButton;
    btnTest4: TButton;
    btnTest5: TButton;
    btnTest7: TButton;
    edtArg5: TEdit;
    edtFile7: TEdit;
    edtFunc7: TEdit;
    edtArg7: TEdit;
    edtFile2: TEdit;
    btnTest8: TButton;
    edtFile8: TEdit;
    Label1: TLabel;
    btnTest6: TButton;
    edtFile6: TEdit;
    edtFunc6: TEdit;
    btnTest9: TButton;
    edtFile9: TEdit;
    edtFunc9: TEdit;
    Label2: TLabel;
    btnClear: TButton;
    btnTest10: TButton;
    edtFile10: TEdit;
    Label3: TLabel;
    memRetValue: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    btnTest11: TButton;
    edtFile11: TEdit;
    edtArg11_1: TEdit;
    btnTest12: TButton;
    edtFile12: TEdit;
    edtArg11_2: TEdit;
    XPManifest: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStopClick(Sender: TObject);
    procedure btnDebuggerClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnTest1Click(Sender: TObject);
    procedure btnTest2Click(Sender: TObject);
    procedure btnTest3Click(Sender: TObject);
    procedure btnTest4Click(Sender: TObject);
    procedure btnTest5Click(Sender: TObject);
    procedure btnTest7Click(Sender: TObject);
    procedure btnTest8Click(Sender: TObject);
    procedure btnTest6Click(Sender: TObject);
    procedure btnTest9Click(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnTest10Click(Sender: TObject);
    procedure btnTest11Click(Sender: TObject);
    procedure btnTest12Click(Sender: TObject);
  private
    procedure RegisterMacros(Sender: TObject);
    procedure Puts(S: string);
    procedure Terminate(Sender: TObject);
    procedure Execute(FileName, FuncName: string; Args: array of string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
 // MacroFrm,
   LuaBase, lua, lualib, lauxlib, LuaUtils;

function LuaPrintf(L: PLua_State): Integer; cdecl;
var
  SL: TStrings;
  S: string;
  I: Integer;
begin
  Result := 0;
  SL := TStringList.Create;
  try
    for I := 1 to lua_gettop(L) do
    begin
      S := LuaStackToStr(L, I);
      if (S = '""') then
        S := '';
      S := AnsiDequotedStr(S, '"');
      OnLuaStdout(PChar(S), Length(S));
      frmMain.Puts(S);
    end;
  finally
    SL.Free;
  end;
end;

function LuaPrint(L: PLua_State): Integer; cdecl;
const
  CR = #$0D;
  LF = #$0A;
  CRLF = CR + LF;
begin
  Result := LuaPrintf(L);
  OnLuaStdout(CRLF, Length(CRLF));
  frmMain.Puts(CRLF);
end;

function LuaDirEntries(L: PLua_State): Integer; cdecl;
var
  Path: string;
  R: Integer;
  SR: TSearchRec;
  TI: Integer;
  Index: Integer;
begin
  Result := 1;
  Index := 0;
  Path := luaL_checkstring(L, 1);

  lua_newtable(L);
  TI := lua_gettop(L);

  R := FindFirst(Path, faAnyFile, SR);
  while (R = 0) do
  begin
  {$WARN SYMBOL_PLATFORM OFF}
    lua_pushstring(L, SR.FindData.cFileName);
  {$WARN SYMBOL_PLATFORM ON}
    Inc(Index);
    lua_rawseti(L, TI, Index);
    R := FindNext(SR);
  end;
  FindClose(SR);
end;

procedure TfrmMain.RegisterMacros(Sender: TObject);
var
  L: Plua_State;
begin
//  L := frmMacro.LuaState;
  LuaRegister(L, 'print', LuaPrint);
  LuaRegister(L, 'printf', LuaPrintf);
  LuaRegister(L, 'Dir.entries', LuaDirEntries);
  LuaRegister(L, 'DoFile', LuaDoFile);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
const
  DefaultFile = 'default.lua';
begin
(*  frmMacro := TfrmMacro.Create(Application);
  frmMacro.OnRegister := RegisterMacros;
  frmMacro.LuaPath := Format('?.lua;%s?.lua', [ExtractFilePath(Application.ExeName)]);
  frmMacro.chkDisp.Checked := True;
  frmMacro.AboutMenuItem.OnClick := btnAboutClick;
  if (FileExists(DefaultFile)) then
    frmMacro.LoadFromFile(DefaultFile); *)
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
(*  if (frmMacro.Running) then
  begin
    ShowMessage('É}ÉNÉçé¿çsíÜÇÕèIóπÇ≈Ç´Ç‹ÇπÇÒ');
    CanClose := False;
    Exit;
  end;
  CanClose := CanClose and frmMacro.CanCloseAll; *)
end;

procedure TfrmMain.Puts(S: string);
begin
  with (memLog) do
  begin
    SelStart := Length(Text);
    SelLength := 0;
    SelText := S;
  end;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
(*  frmMacro.Stop; *)
end;

procedure TfrmMain.btnDebuggerClick(Sender: TObject);
begin
(*  frmMacro.Show; *)
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  ShowMessage('ÉfÉoÉbÉKëgÇ›çûÇ›ÉTÉìÉvÉã');
end;

procedure TfrmMain.Execute(FileName, FuncName: string; Args: array of string);
  procedure SetEnabled(B: Boolean);
    function Find(var Button: TButton; Index: Integer): Boolean;
    begin
      Button := FindComponent('btnTest' + IntToStr(Index)) as TButton;
      Result := Assigned(Button);
    end;
  var
    Index: Integer;
    Button: TButton;
  begin
    Index := 1;
    while (Find(Button, Index)) do
    begin
      Inc(Index);
      Button.Enabled := B;
    end;
  end;
begin
  Caption := '«‡ÔÛÒÍ...';
  SetEnabled(False);
  try
(*    frmMacro.Execute(FileName, FuncName, Args, memRetValue.Lines); *)
  finally
    Caption := '!!!!';
    SetEnabled(True);
  end;
end;

procedure TfrmMain.Terminate(Sender: TObject);
var
  L: Plua_State;
begin
//  L := frmMacro.LuaState;
  lua_getglobal(L, PChar(edtFunc9.Text));
  LuaStackToStrings(L, memRetValue.Lines);
  LuaDataStrToStrings(memRetValue.Lines.Text, memLog.Lines);
  memLog.Lines.CommaText := memLog.Lines.Text;
  ShowMessage(memLog.Lines.Text);
  lua_pop(L, 1);
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  memLog.Clear;
  memRetValue.Clear;
end;

procedure TfrmMain.btnTest1Click(Sender: TObject);
begin
  Execute(edtFile1.Text, '', []);
end;

procedure TfrmMain.btnTest2Click(Sender: TObject);
begin
  Execute(edtFile2.Text, '', [edtArg2.Text]);
end;

procedure TfrmMain.btnTest3Click(Sender: TObject);
begin
  Execute(edtFile3.Text, edtFunc3.Text, [edtArg3_1.Text, edtArg3_2.Text]);
end;

procedure TfrmMain.btnTest4Click(Sender: TObject);
begin
  Execute(edtFile4.Text, edtFunc4.Text, [edtArg4.Text]);
end;

procedure TfrmMain.btnTest5Click(Sender: TObject);
var
  Args: array of string;
  I: Integer;
begin
  with (TStringList.Create) do
  try
    CommaText := edtArg5.Text;
    SetLength(Args, Count);
    for I := 0 to Count - 1 do
    begin
      Args[I] := Strings[I];
    end;
  finally
    Free;
  end;

  Execute(edtFile5.Text, edtFunc5.Text, Args);
end;

procedure TfrmMain.btnTest6Click(Sender: TObject);
begin
  Execute(edtFile6.Text, edtFunc6.Text, []);
  LuaDataStrToStrings(memRetValue.Text, memLog.Lines);
end;

procedure TfrmMain.btnTest7Click(Sender: TObject);
var
  I: Integer;
begin
  Execute(edtFile7.Text, edtFunc7.Text, [edtArg7.Text]);
  with (TStringList.Create) do
  try
    LuaDataStrToStrings(memRetValue.Text, memLog.Lines);
    memLog.Lines.CommaText := memLog.Text;
    for I := 0 to memLog.Lines.Count - 1 do
      Add(AnsiDequotedStr(memLog.Lines.Values[memLog.Lines.Names[I]], '"'));
    ShowMessage(Text);
  finally
    Free;
  end;
end;

procedure TfrmMain.btnTest8Click(Sender: TObject);
begin
  Execute(edtFile8.Text, '', []);
end;

procedure TfrmMain.btnTest9Click(Sender: TObject);
begin
//  frmMacro.OnTerminate := Terminate;
  try
    Execute(edtFile9.Text, '', []);
  finally
//    frmMacro.OnTerminate := nil;
  end;
end;

procedure TfrmMain.btnTest10Click(Sender: TObject);
begin
  Execute(edtFile10.Text, '', []);
end;

procedure TfrmMain.btnTest11Click(Sender: TObject);
begin
  Execute(edtFile11.Text, '', [edtArg11_1.Text, edtArg11_2.Text]);
end;

procedure TfrmMain.btnTest12Click(Sender: TObject);
begin
  Execute(edtFile12.Text, '', []);
end;

end.
