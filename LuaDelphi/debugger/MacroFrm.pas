unit MacroFrm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls,
  lua, lualib, lauxlib, LuaUtils,
  Grids, Menus, ActnList, Buttons, XPMan, JvExControls, JvEditorCommon,
  JvEditor, JvHLEditor, JvHLEditorPropertyForm;

type
  TBreakInfo = record
    FileName: string;
    Line: Integer;
  end;
  PBreakInfo = ^TBreakInfo;
  TBreakPoints = class
  private
    FBreakPoints: array of TBreakInfo;
    function GetBreakPoints(Index: Integer): PBreakInfo;
    function BreakPointIndex(const FileName: string; Line: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property BreakPoints[Index: Integer]: PBreakInfo read GetBreakPoints; default;
    procedure Clear;
    function Cmp(const FileName: string; Line: Integer): Boolean;
    procedure Add(const FileName: string; Line: Integer; Uniq: Boolean = True);
    procedure Delete(Index: Integer);
    procedure Remove(const FileName: string; Line: Integer);
    procedure Inverse(const FileName: string; Line: Integer);
    function Count: Integer;
  end;
  TEditInfo = class
  private
    FBackupEdited: Boolean;
    BreakPoints: TBreakPoints;
    procedure SetFileName(FileName: string);
  public
    Sheet: TTabSheet;
    FileName: string;
    Editor: TEdit;
    OnChangeFileName: TNotifyEvent;
    constructor Create(Page: TPageControl; BP: TBreakPoints; OnChangeFileName: TNotifyEvent);
    destructor Destroy; override;
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    procedure MoveCursor(Line: Integer);
    procedure DispLine(Line: Integer);
    procedure SetLineColor(Line: Integer; BrushColor, Color: TColor);
    procedure UpdateLine(Line: Integer);
    procedure UpdateLines;
    procedure Invalidate;
    procedure BackupEdited;
    procedure RestoreEdited;
    procedure ClearEdited;
    procedure OrEdited;
  end;
  TfrmMacro = class(TForm)
    pnlTop: TPanel;
    btnExecute: TButton;
    btnTrace: TButton;
    btnPause: TButton;
    btnStop: TButton;
    pnlBottom: TPanel;
    Splitter1: TSplitter;
    pnlRight: TPanel;
    btnStep: TButton;
    pnlBottom1: TPanel;
    lstLocal: TListBox;
    pgcWatch: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    sgWatch: TStringGrid;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    pgcMessage: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    memMessage: TMemo;
    memConsole: TMemo;
    mnuMain: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    AboutMenuItem: TMenuItem;
    chkDisp: TCheckBox;
    btnEval: TButton;
    btnUp: TButton;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    lstStackTrace: TListBox;
    Splitter4: TSplitter;
    pgcStack: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    lstStack: TListBox;
    tvGlobal: TTreeView;
    R1: TMenuItem;
    N2: TMenuItem;
    S1: TMenuItem;
    T1: TMenuItem;
    C1: TMenuItem;
    U1: TMenuItem;
    G1: TMenuItem;
    E1: TMenuItem;
    N3: TMenuItem;
    V1: TMenuItem;
    W1: TMenuItem;
    N4: TMenuItem;
    pgcEdit: TPageControl;
    sgBreak: TStringGrid;
    alMain: TActionList;
    acStop: TAction;
    acExecuteToCursor: TAction;
    acAddWatch: TAction;
    acSetBreak: TAction;
    acTrace: TAction;
    acStep: TAction;
    acUp: TAction;
    acRun: TAction;
    acPause: TAction;
    acEval: TAction;
    cbTarget: TComboBox;
    V2: TMenuItem;
    Close1: TMenuItem;
    L1: TMenuItem;
    chkInterlock: TCheckBox;
    XPManifest1: TXPManifest;
    JvHLEditor1: TJvHLEditor;
    JvHLEdPropDlg1: TJvHLEdPropDlg;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sgWatchSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgWatchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pgcWatchResize(Sender: TObject);
    procedure sgWatchSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure lstStackTraceClick(Sender: TObject);
    procedure AboutMenuItemClick(Sender: TObject);
    procedure pgcStackChange(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure acExecuteToCursorExecute(Sender: TObject);
    procedure acAddWatchExecute(Sender: TObject);
    procedure acSetBreakExecute(Sender: TObject);
    procedure acTraceExecute(Sender: TObject);
    procedure acStepExecute(Sender: TObject);
    procedure acUpExecute(Sender: TObject);
    procedure acRunExecute(Sender: TObject);
    procedure acPauseExecute(Sender: TObject);
    procedure acEvalExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcEditChange(Sender: TObject);
    procedure sgBreakSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure V2Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure chkInterlockClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    PreviousEditorValue: string;
    StackTrace: TBreakPoints;
    BreakPoints: TBreakPoints;
    Page: TPageControl;
    Target: TComboBox;
    FEditors: TList;
    PrevFile: string;
    PrevLine: Integer;
    CurrentICI: Integer;
    PauseICI: Integer;
    FRunning: Boolean;
    ReStart, FPause: Boolean;
    PauseLine: Integer;
    PauseFile: string;
    FLuaState: Plua_State;
    function GetEditors(Index: Integer): TEditInfo;
    procedure PrintStack(L: Plua_State);
    procedure PrintLocal(L: Plua_State);
    procedure PrintGlobal(L: Plua_State; Foce: Boolean = False);
    procedure PrintWatch(L: Plua_State);
    procedure DispBreakPoints;
    procedure DispPC(EI: TEditInfo; Line: Integer);
    procedure HidePC(EI: TEditInfo; Line: Integer; Invalidate: Boolean = True);
    function Save(EI: TEditInfo): Boolean;
    function SaveAs(EI: TEditInfo): Boolean;
    procedure BackupEdited;
    procedure RestoreEdited;
    procedure ClearEdited;
    procedure OrEdited;
    function IsEdited(IgnoreIndex: Integer = -1): Boolean;
    procedure LMHook(L: Plua_State; AR: Plua_Debug);
    procedure UpdateButtons;
    procedure Put(const S: string);
    function IsBreak(Line: Integer): Boolean;
    function IsICI(ICI: Integer): Boolean;
    procedure SetCurrentIndex(const Value: Integer);
    function GetCurrentIndex: Integer;
  public
    LuaPath: string;
    OnRegister, OnTerminate: TNotifyEvent;
    property LuaState: PLua_State read FLuaState;
    property Running: Boolean read FRunning;
    function GetValue(Name: string): string;
    procedure SetValue(Name, Value: string);
    property Editors[Index: Integer]: TEditInfo read GetEditors;
    function Count: Integer;
    function Current: TEditInfo;
    property CurrentIndex: Integer read GetCurrentIndex write SetCurrentIndex;
    function TargetEditor: TEditInfo;
    function IndexOf(FileName: string): Integer;
    function Add(FileName: string): TEditInfo;
    procedure Delete(Index: Integer);
    procedure MoveCursor(FileName: string; Line: Integer);
    function Find(FileName: string): TEditInfo;
    function Disp(FileName: string): TEditInfo;
    procedure UpdateTarget(Sender: TObject);
    procedure CustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
    procedure ExecuteCurrent(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer);
    procedure Execute(FileName, FuncName: string; const Args: array of string; Results: TStrings = nil);
    procedure LoadFromFile(FileName: string);
    function SaveAll: Boolean;
    function CloseAll: Boolean;
    function CanClose(Index: Integer): Boolean;
    function CanCloseAll: Boolean;
    procedure Pause;
    procedure Run;
    procedure Step;
    procedure Stop;
    procedure Trace;
    procedure UpTrace;
  end;

var
  frmMacro: TfrmMacro;

implementation

{$R *.dfm}

uses
  Math, EvalFrm,
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl
  {$WARN UNIT_PLATFORM ON}
  ;

const
  HOOK_MASK = LUA_MASKCALL or LUA_MASKRET or LUA_MASKLINE;
  PRINT_SIZE = 32;
  ArgIdent = 'arg';

procedure LMLuaHook(L: Plua_State; AR: Plua_Debug); cdecl;
begin
  frmMacro.LMHook(L, AR);
end;

{ TBreakPoints }

procedure TBreakPoints.Clear;
begin
  SetLength(FBreakPoints, 0);
end;

constructor TBreakPoints.Create;
begin
  inherited;
  Clear;
end;

destructor TBreakPoints.Destroy;
begin
  Clear;
  inherited;
end;

function TBreakPoints.Cmp(const FileName: string; Line: Integer): Boolean;
begin
  Result := (BreakPointIndex(FileName, Line) <> -1);
end;

function TBreakPoints.BreakPointIndex(const FileName: string;
  Line: Integer): Integer;
  function Equal(const BP: PBreakInfo): Boolean;
  begin
    Result := (BP.FileName = FileName) and (BP.Line = Line);
  end;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if (Equal(BreakPoints[I])) then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TBreakPoints.Add(const FileName: string; Line: Integer; Uniq: Boolean);
begin
  if (Uniq and Cmp(FileName, Line)) then
    Exit;

  SetLength(FBreakPoints, Count + 1);
  BreakPoints[Count - 1].FileName := FileName;
  BreakPoints[Count - 1].Line := Line;
end;

procedure TBreakPoints.Delete(Index: Integer);
var
  I: Integer;
begin
  for I := Index to Count - 1 - 1 do
  begin
    BreakPoints[I].FileName := BreakPoints[I + 1].FileName;
    BreakPoints[I].Line := BreakPoints[I + 1].Line;
  end;
  SetLength(FBreakPoints, Max(0, Count - 1));
end;

procedure TBreakPoints.Remove(const FileName: string; Line: Integer);
var
  Index: Integer;
begin
  Index := BreakPointIndex(FileName, Line);
  if (Index < 0) then
    Exit;

  Delete(Index);
end;

procedure TBreakPoints.Inverse(const FileName: string; Line: Integer);
begin
  if (Cmp(FileName, Line)) then
    Remove(FileName, Line)
  else
    Add(FileName, Line);
end;

function TBreakPoints.Count: Integer;
begin
  Result := Length(FBreakPoints);
end;

function TBreakPoints.GetBreakPoints(Index: Integer): PBreakInfo;
begin
  Assert((0 <= Index) and (Index < Count));
  Result := @FBreakPoints[Index];
end;

{ TEditInfo }

constructor TEditInfo.Create(Page: TPageControl; BP: TBreakPoints; OnChangeFileName: TNotifyEvent);
begin
  inherited Create;

  Self.BreakPoints := BP;
  Self.OnChangeFileName := OnChangeFileName;
  Sheet := TTabSheet.Create(Page);
  Sheet.PageControl := Page;
  Page.ActivePage := Sheet;
  Editor := TEdit.Create(Sheet);
  Editor.Align := alClient;
(*  Editor.CharPich := 1;
  Editor.Options := [aoAutoIndent];
  Editor.ViewOpt := [
    voDependence, voHankana, voCr, voAnsiSpace, voTab, voIndent,
    voKeyWord, voRowNum, voWrapLine, voFoldMark
    ];
  Editor.Keywords.CommaText :=
    'and,break,do,else,elseif,end,false,' +
    'for,function,if,in,local,nil,not,or,' +
    'repeat,return,then,true,until,while,require';
  Editor.KeywordStyle := [];
  Editor.ColKeyWord := clBlue;
  Editor.Edited := False;      *)
end;

destructor TEditInfo.Destroy;
begin
  Sheet.Free;
  inherited;
end;

procedure TEditInfo.DispLine(Line: Integer);
begin
(*  Editor.CaretPos := Point(0, Line);
  if (Line >= Editor.TopLine + Editor.DspRowCount) then
    Editor.TopLine := Line - Editor.DspRowCount + 1
  else if (Line < Editor.TopLine) then
    Editor.TopLine := Line; *)
end;

procedure TEditInfo.LoadFromFile(FileName: string);
begin
//  Editor.LoadFromFile(FileName, []);
  SetFileName(FileName);
  UpdateLines;
end;

procedure TEditInfo.MoveCursor(Line: Integer);
var
  AControl: TWinControl;
begin
  AControl := Editor;
  while (Assigned(AControl.Parent)) do
    AControl := AControl.Parent;
  AControl.Visible := True;

//  Editor.CaretPos := Point(0, Line);
//  Editor.TopLine := Line - Editor.DspRowCount div 2;
  Editor.SetFocus;
end;

procedure TEditInfo.SaveToFile(FileName: string);
begin
//  Editor.SaveToFile(FileName, []);
  SetFileName(FileName);
end;

procedure TEditInfo.SetFileName(FileName: string);
begin
  Self.FileName := FileName;
  Sheet.Caption := ChangeFileExt(ExtractFileName(FileName), '');
  if (Assigned(OnChangeFileName)) then
    OnChangeFileName(Self);
end;

procedure TEditInfo.SetLineColor(Line: Integer; BrushColor, Color: TColor);
begin
//  Editor.LineAttrs[Line].BrushColor := BrushColor;
//  Editor.LineAttrs[Line].Color := Color;
end;

procedure TEditInfo.UpdateLines;
var
  I: Integer;
begin
//  for I := 0 to Editor.Count - 1 do
//    UpdateLine(I);
end;

procedure TEditInfo.UpdateLine(Line: Integer);
var
  Color: TColor;
begin
  if (BreakPoints.Cmp(FileName, Line)) then
    Color := clRed
  else
    Color := Editor.Color;
  SetLineColor(Line, Color, Editor.Font.Color);
end;

procedure TEditInfo.Invalidate;
begin
  Editor.Invalidate;
end;

procedure TEditInfo.BackupEdited;
begin
//  FBackupEdited := Editor.Edited;
end;

procedure TEditInfo.ClearEdited;
begin
//  Editor.Edited := False;
end;

procedure TEditInfo.OrEdited;
begin
//  FBackupEdited := FBackupEdited or Editor.Edited;
end;

procedure TEditInfo.RestoreEdited;
begin
//  Editor.Edited := FBackupEdited;
end;

{ TfrmMacro }

function TfrmMacro.Add(FileName: string): TEditInfo;
begin
  Result := Find(FileName);
  if (Assigned(Result)) then
    Exit;

  Result := TEditInfo.Create(pgcEdit, BreakPoints, UpdateTarget);
  FEditors.Add(Result);
  if (FileExists(FileName)) then
    Result.LoadFromFile(FileName)
  else
    Result.SetFileName(FileName);
end;

function TfrmMacro.Count: Integer;
begin
  Result := FEditors.Count;
end;

function TfrmMacro.Current: TEditInfo;
begin
  Result := Editors[CurrentIndex];
end;

function TfrmMacro.GetCurrentIndex: Integer;
begin
  Result := Page.ActivePageIndex;
end;

procedure TfrmMacro.Delete(Index: Integer);
begin
  Editors[Index].Free;
  FEditors.Delete(Index);
  UpdateTarget(Self);
end;

function TfrmMacro.Disp(FileName: string): TEditInfo;
begin
  if (IndexOf(FileName) = -1) then
    Add(FileName);
  Page.ActivePageIndex := IndexOf(FileName);
  Result := Current;
end;

function TfrmMacro.Find(FileName: string): TEditInfo;
var
  Index: Integer;
begin
  Index := IndexOf(FileName);
  if (Index = -1) then
    Result := nil
  else
    Result := Editors[Index]
end;

function TfrmMacro.GetEditors(Index: Integer): TEditInfo;
begin
  Result := FEditors[Index];
end;

function TfrmMacro.IndexOf(FileName: string): Integer;
var
  I: Integer;
begin
  FileName := ExpandUNCFileName(FileName);
  for I := 0 to Count - 1 do
    if (ExpandUNCFileName(Editors[I].FileName) = FileName) then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TfrmMacro.MoveCursor(FileName: string; Line: Integer);
begin
  Disp(FileName).MoveCursor(Line);
end;

function TfrmMacro.TargetEditor: TEditInfo;
begin
  Result := Editors[Target.ItemIndex];
end;

procedure TfrmMacro.UpdateTarget(Sender: TObject);
var
  Index, I: Integer;
begin
  Index := Target.ItemIndex;
  Target.Clear;
  for I := 0 to Count - 1 do
    Target.Items.Add(Format('%s', [Editors[I].Sheet.Caption]));

  Target.ItemIndex := Max(0, Min(Index, Count - 1));
end;

procedure TfrmMacro.FormCreate(Sender: TObject);
begin
  LuaPath := '?;?.lua';
  StackTrace := TBreakPoints.Create;
  BreakPoints := TBreakPoints.Create;
  FEditors := TList.Create;
  Page := pgcEdit;
  Target := cbTarget;
  Add('');

  UpdateButtons;
  pgcWatchResize(Self);
  CurrentICI := 1;
end;

procedure TfrmMacro.FormDestroy(Sender: TObject);
begin
  while (Count > 0) do
    Delete(0);
  FEditors.Free;
  BreakPoints.Free;
  StackTrace.Free;
end;

procedure DoLuaStdout(S: PChar; N: Integer);
const
  CR = #$0D;
  LF = #$0A;
  CRLF = CR + LF;
begin
  frmMacro.Put(StringReplace(S, LF, CRLF, [rfReplaceAll]));
end;

procedure TfrmMacro.CustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
  procedure OpenLibs(L: PLua_State);
  begin
    luaopen_base(L);
    luaopen_table(L);
    luaopen_io(L);
    luaopen_string(L);
    luaopen_math(L);
    luaopen_debug(L);
    luaopen_loadlib(L);
    lua_settop(L, 0);
  end;
  procedure UpdateEditors;
  var
    I: Integer;
  begin
    for I := 0 to Count - 1 do
      Editors[I].UpdateLines;
    Current.Invalidate;
  end;
  function TitleToFileName(Title: string): string;
  var
    Index: Integer;
    S: string;
  begin
    Result := Title;
    Index := Pos('"', Title);
    if (Index = 0) then
      Exit;
    S := Copy(Title, Index + 1, Length(Title));
    Index := Pos('"', S);
    if (Index = 0) then
      Exit;
    Result := Copy(S, 1, Index - 1);
  end;
  procedure SetPause;
  begin
    if (not Pause) then
      HidePC(Find(PrevFile), PrevLine);
    Self.FPause := Pause;
    Self.PauseICI := PauseICI;
    Self.PauseLine := PauseLine;
    Self.PauseFile := PauseFile;
  end;
var
  L: Plua_State;
  StartTime: DWORD;
  FileName: string;
  I, NArgs: Integer;
begin
  if (Running) then
  begin
    if (IsEdited) then
    begin
      case (MessageDlg('ソースが変更されました。中断しますか？', mtInformation, [mbOK, mbCancel], 0)) of
      mrOK:
        begin
          FRunning := False;
          Exit;
        end;
      mrCancel:
        begin
          OrEdited;
          ClearEdited;
        end;
      end;
    end;
    SetPause;
    ReStart := True;
    Exit;
  end else
  begin
    if (IsEdited(CurrentIndex)) then
    begin
      if (MessageDlg('ソースを保存しますか？', mtInformation, [mbOK, mbCancel], 0) <> mrOK) then
        Exit;
      if (not SaveAll) then
        Exit;
    end;
    SetPause;
  end;
  FLuaState := lua_open;
  L := LuaState;
  OnLuaStdout := DoLuaStdOut;

  OpenLibs(L);
  if (LuaPath <> '') then
    LuaSetTableString(L, LUA_GLOBALSINDEX, 'LUA_PATH', LuaPath);
  LuaRegister(L, 'print', lua_print);
  LuaRegister(L, 'io.write', lua_io_write);
  if (Assigned(OnRegister)) then
    OnRegister(Self);

  lua_sethook(L, LMLuaHook, HOOK_MASK, 0);
  FRunning := True;
  CurrentICI := 1;
  UpdateButtons;
  UpdateEditors;
  pgcMessage.ActivePageIndex := 1;
  Caption := TargetEditor.FileName + ' [実行中]';
  if (Assigned(Results)) then
    Results.Clear;
  try
    BackupEdited;
    ClearEdited;
    PrevFile := TargetEditor.FileName;
    PrevLine := 0;
    if (Pause) then
      DispPC(Disp(PrevFile), PrevLine);
    try
      memConsole.Clear;
      memMessage.Clear;
      lstStackTrace.Clear;
      StackTrace.Clear;
      StartTime := GetTickCount;
      if (TargetEditor.Editor.Text = '') then
        Exit;
      LuaLoadBuffer(L, TargetEditor.Editor.Text, TargetEditor.FileName);
      if (FuncName <> '') then
      begin
        LuaPCall(L, 0, 0, 0);
        lua_getglobal(L, PChar(FuncName));
        if (lua_type(L, -1) <> LUA_TFUNCTION) then
          raise Exception.CreateFmt('関数 %s が見つかりません', [FuncName]);
        NArgs := Length(Args);
        for I := 0 to NArgs - 1 do
          LuaPushString(L, Args[I]);
      end else
      begin
        NArgs := 0;
        lua_newtable(L);
        for I := 0 to Length(Args) - 1 do
        begin
          LuaPushString(L, Args[I]);
          lua_rawseti(L, -2, I + 1);
        end;
        lua_setglobal(L, ArgIdent);
      end;
      LuaPCall(L, NArgs, LUA_MULTRET, 0);
      StartTime := GetTickCount - StartTime;
      memMessage.Lines.Add(Format('実行時間=%dms', [StartTime]));
      if (Assigned(Results)) then
      begin
        Results.Clear;
        for I := 1 to lua_gettop(L) do
          Results.Add(LuaStackToStr(L, I));
      end;
      PrintStack(L);
      PrintGlobal(L, True);
      PrintWatch(L);
    finally
      if (Assigned(OnTerminate)) then
        OnTerminate(Self);
      RestoreEdited;
      HidePC(Find(PrevFile), PrevLine);
      Disp(TargetEditor.FileName);
      pgcEditChange(Self);
      lua_close(L);
      FLuaState := nil;
      FRunning := False;
      Self.FPause := False;
      Self.PauseICI := 0;
      Self.PauseLine := -1;
      Self.PauseFile := '';
      CurrentICI := 1;
      UpdateButtons;
    end;
  except
    on E: ELuaException do
    begin
      FileName := TitleToFileName(E.Title);
      if (not FileExists(FileName)) then
        FileName := PrevFile;
      if (FileExists(FileName) and (E.Line > 0)) then
      begin
        Disp(FileName).SetLineColor(E.Line - 1, clMaroon, clWhite);
        MoveCursor(FileName, E.Line - 1);
      end;
      pgcMessage.ActivePageIndex := 0;
      memMessage.Lines.Add(E.Msg);
      if (E.Msg <> 'STOP') then
        raise;
    end;
  end;
end;

procedure TfrmMacro.ExecuteCurrent(Pause: Boolean; PauseICI: Integer;
  PauseFile: string; PauseLine: Integer);
begin
  CustomExecute(Pause, PauseICI, PauseFile, PauseLine, '', [], nil);
end;

procedure TfrmMacro.Execute(FileName, FuncName: string; const Args: array of string; Results: TStrings);
begin
  LoadFromFile(FileName);
  cbTarget.ItemIndex := pgcEdit.ActivePageIndex;
  CustomExecute(False, 0, '', -1, FuncName, Args, Results);
end;

procedure TfrmMacro.PrintWatch(L: Plua_State);
var
  I: Integer;
begin
  if (not Assigned(L)) then
    Exit;

  for I := 0 to sgWatch.RowCount - 1 do
    sgWatch.Cells[1, I] := GetValue(sgWatch.Cells[0, I]);
end;

procedure TfrmMacro.LMHook(L: Plua_State; AR: Plua_Debug);
  procedure Update;
  var
    NextFile: string;
    NextLine: Integer;
    NextEdit, PrevEdit: TEditInfo;
  begin
    NextFile := ExpandUNCFileName(StringReplace(AR.source, '@', '',[]));
    NextLine := AR.currentline - 1;
    NextEdit := Disp(NextFile);
    if (PrevFile = NextFile) then
      PrevEdit := NextEdit
    else
      PrevEdit := Find(PrevFile);

    HidePC(PrevEdit, PrevLine, PrevEdit <> NextEdit);
    DispPC(NextEdit, NextLine);
    PrevFile := NextFile;
    PrevLine := NextLine;
    PrintStack(L);
    PrintLocal(L);
    PrintGlobal(L);
    PrintWatch(L);
  end;
  procedure WaitReStart;
  begin
    CurrentICI := AR.i_ci;
    FPause := FPause or IsBreak(AR.currentline - 1) or IsICI(CurrentICI);
    ReStart := not FPause;
    if (FPause) then
    begin
      FPause := False;
      PauseICI := 0;
      PauseLine := -1;
      PauseFile := '';
    end;
    UpdateButtons;

    if ((not ReStart) or chkDisp.Checked) then
      Update;

    repeat
      Application.ProcessMessages;
      if (not Running) then
      begin
        lua_pushstring(L, 'STOP');
        lua_error(L);
      end;
    until (ReStart);
  end;
begin
  lua_getinfo(L, 'Snlu', AR);
  case (AR.event) of
  LUA_HOOKCALL:
    if (chkDisp.Checked and (PrevLine <> 0)) then
    begin
//      lstStackTrace.Items.Insert(0, Trim(Disp(PrevFile).Editor.Lines[PrevLine]));
      StackTrace.Add(PrevFile, PrevLine, False);
    end;
  LUA_HOOKRET:
  begin
    if (chkDisp.Checked) then
    begin
      lstStackTrace.Items.Delete(0);
      StackTrace.Delete(StackTrace.Count - 1);
    end;
  end;
  LUA_HOOKLINE:
    WaitReStart;
  LUA_HOOKCOUNT, LUA_HOOKTAILRET:;
  end;
end;

procedure TfrmMacro.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (Self <> Application.MainForm) then
    Exit;

  if (Running) then
  begin
    case (MessageDlg('デバッグ中です。終了してよろしいですか？', mtInformation, [mbOK, mbCancel], 0)) of
    mrOK:
      FRunning := False;
    mrCancel:
      CanClose := not Running;
    end;
  end;
end;

procedure TfrmMacro.UpdateButtons;
begin
  acRun.Enabled := True;
  acTrace.Enabled := (not Running) or (not ReStart);
  acStep.Enabled := (not Running) or (not ReStart);
  acUp.Enabled := (not Running) or (not ReStart);
  acEval.Enabled := (not Running) or (not ReStart);
  acPause.Enabled := Running and ReStart;
  acStop.Enabled := Running;
end;

procedure TfrmMacro.Put(const S: string);
begin
  memConsole.SelStart := Length(memConsole.Text);
  memConsole.SelLength := 0;
  memConsole.SelText := S;
end;

procedure TfrmMacro.PrintStack(L: Plua_State);
begin
  LuaStackToStrings(L, lstStack.Items, PRINT_SIZE);
end;

procedure TfrmMacro.PrintLocal(L: Plua_State);
begin
  LuaLocalToStrings(L, lstLocal.Items, PRINT_SIZE);
end;

function TfrmMacro.IsBreak(Line: Integer): Boolean;
var
  FileName: string;
begin
  FileName := Current.FileName;
  Result := BreakPoints.Cmp(FileName, Line)
    or (FileName = PauseFile) and (Line = PauseLine);
end;

function TfrmMacro.IsICI(ICI: Integer): Boolean;
begin
  Result := (ICI <= PauseICI);
end;

procedure TfrmMacro.sgWatchSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := (ACol = 0);
end;

procedure TfrmMacro.sgWatchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    PrintWatch(LuaState);
end;

procedure TfrmMacro.pgcWatchResize(Sender: TObject);
  procedure Resize(SG: TStringGrid; ResizeCol: Integer);
  begin
    SG.ColWidths[ResizeCol] := 0;
    SG.ColWidths[ResizeCol] := SG.ColWidths[ResizeCol] + SG.ClientWidth - SG.GridWidth;
  end;
begin
  Resize(sgWatch, 1);
  Resize(sgBreak, 0);
  DispBreakPoints;
end;

procedure TfrmMacro.sgWatchSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
const
  MagicValue = 'd0308|ybh<_lfds$t083q()'#1#5; // 入力値としてありえない値
begin
  if (Value <> PreviousEditorValue) then
  begin
    PreviousEditorValue := Value;
    Exit;
  end;
  // 次回のために絶対にありえない文字列を代入
  PreviousEditorValue := MagicValue;

  PrintWatch(LuaState);
end;

procedure TfrmMacro.LoadFromFile(FileName: string);
var
  EI: TEditInfo;
begin
  EI := Find(FileName);
  if (Assigned(EI)) then
    EI.LoadFromFile(FileName);

  if ((Count > 0) and (Editors[0].FileName = '')) then
    Editors[0].LoadFromFile(FileName)
  else
    Disp(FileName);
  pgcEditChange(Self);
  acStopExecute(Self);
end;

procedure TfrmMacro.Open1Click(Sender: TObject);
begin
  if Running then begin
    case MessageDlg('実行中です。中断して読み込みますか？', mtInformation, [mbOK, mbCancel], 0) of
    mrOK:
      acStopExecute(Self);
    else
      Exit;
    end;
  end;
  dlgOpen.FileName := Current.FileName;
  if not dlgOpen.Execute then Exit;
  LoadFromFile(dlgOpen.FileName);
end;

function TfrmMacro.Save(EI: TEditInfo): Boolean;
begin
  if (EI.FileName = '') then
  begin
    Result := SaveAs(EI);
    Exit;
  end;
  EI.SaveToFile(EI.FileName);
  Result := True;
end;

function TfrmMacro.SaveAs(EI: TEditInfo): Boolean;
begin
  dlgSave.FileName := EI.FileName;
  Result := dlgSave.Execute;
  if (not Result) then
    Exit;

  EI.SaveToFile(dlgSave.FileName);
  pgcEditChange(Self);
end;

function TfrmMacro.SaveAll: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if (not Save(Editors[I])) then
      Exit;
  Result := True;
end;

function TfrmMacro.CloseAll: Boolean;
begin
  Result := CanCloseAll;
  if (not Result) then
    Exit;
  while (Count > 0) do
    Delete(0);
  Add('');
  pgcEditChange(Self);
end;

function TfrmMacro.CanClose(Index: Integer): Boolean;
const
  CAN_CLOSE_MSG = 'ファイルが変更されています。セーブしますか？';
begin
  Result := False;
(*  if (Editors[Index].Editor.Edited) then
    case (MessageDlg(CAN_CLOSE_MSG, mtWarning, mbYesNoCancel, 0)) of
      mrYes: if (not Save(Editors[Index])) then Exit;
      mrCancel, mrNone: Exit;
    end; *)
  Result := True;
end;

function TfrmMacro.CanCloseAll: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if (not CanClose(I)) then
      Exit;
  Result := True;
end;

procedure TfrmMacro.Save1Click(Sender: TObject);
begin
  Save(Current);
end;

procedure TfrmMacro.SaveAs1Click(Sender: TObject);
begin
  SaveAs(Current);
end;

procedure TfrmMacro.Exit1Click(Sender: TObject);
begin
  Close;
end;

function TfrmMacro.GetValue(Name: string): string;
begin
  if (not Assigned(LuaState)) then
    Exit;
  Result :=  LuaGetIdentValue(LuaState, Name, PRINT_SIZE);
end;

procedure TfrmMacro.SetValue(Name, Value: string);
begin
  if (not Assigned(LuaState)) then
    Exit;

  LuaSetIdentValue(LuaState, Name, Value, PRINT_SIZE);
  PrintLocal(LuaState);
  PrintWatch(LuaState);
end;

procedure TfrmMacro.lstStackTraceClick(Sender: TObject);
var
  ST: PBreakInfo;
begin
  ST := StackTrace[lstStackTrace.Count -  lstStackTrace.ItemIndex - 1];
  MoveCursor(ST.FileName, ST.Line);
end;

procedure TfrmMacro.AboutMenuItemClick(Sender: TObject);
begin
  ShowMessage('Lua Debugger サンプル');
end;

procedure TfrmMacro.PrintGlobal(L: Plua_State; Foce: Boolean);
begin
  if (not Assigned(L)) then
    Exit;
  if ((not Foce) and (pgcStack.ActivePageIndex <> 1)) then
    Exit;
  LuaTableToTreeView(L, LUA_GLOBALSINDEX, tvGlobal, PRINT_SIZE);
end;

procedure TfrmMacro.pgcStackChange(Sender: TObject);
begin
  if (pgcStack.ActivePageIndex <> 0) then
    PrintGlobal(LuaState);
end;

procedure TfrmMacro.acStopExecute(Sender: TObject);
begin
  Stop;
end;

procedure TfrmMacro.acExecuteToCursorExecute(Sender: TObject);
begin
  if (FPause) then
    Exit;
//  ExecuteCurrent(False, 0, Current.FileName, Current.Editor.CaretPos.Y);
end;

procedure TfrmMacro.acAddWatchExecute(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  S := Current.Editor.SelText;
  if (not InputQuery('監視式', '監視式の追加', S)) then
    Exit;

  with (sgWatch) do
  begin
    I := 0;
    while (Cells[0, I] <> '') do
    begin
      Inc(I);
      if (I = RowCount) then
        RowCount := RowCount + 1;
    end;
    Cells[0, I] := S;
    PrintWatch(LuaState);
  end;
end;

procedure TfrmMacro.acSetBreakExecute(Sender: TObject);
var
  I: Integer;
begin
//  I := Current.Editor.CaretPos.Y;

  BreakPoints.Inverse(Current.FileName, I);

  DispBreakPoints;
  Current.UpdateLine(I);
  Current.Invalidate;
end;

procedure TfrmMacro.acTraceExecute(Sender: TObject);
begin
  Trace;
end;

procedure TfrmMacro.acStepExecute(Sender: TObject);
begin
  Step;
end;

procedure TfrmMacro.acUpExecute(Sender: TObject);
begin
  UpTrace;
end;

procedure TfrmMacro.Run;
begin
  ExecuteCurrent(False, 0, '', -1);
end;

procedure TfrmMacro.Pause;
begin
  if (ReStart) then
    FPause := True;
end;

procedure TfrmMacro.Stop;
begin
  FRunning := False;
end;

procedure TfrmMacro.Trace;
begin
  if (FPause) then
    Exit;
  ExecuteCurrent(True, 0, '', -1);
end;

procedure TfrmMacro.Step;
begin
  if (FPause) then
    Exit;
  ExecuteCurrent(False, CurrentICI, '', -1);
end;

procedure TfrmMacro.UpTrace;
begin
  if (FPause) then
    Exit;
  ExecuteCurrent(False, CurrentICI - 1, '', -1);
end;

procedure TfrmMacro.acRunExecute(Sender: TObject);
begin
  Run;
end;

procedure TfrmMacro.acPauseExecute(Sender: TObject);
begin
  Pause;
end;

procedure TfrmMacro.acEvalExecute(Sender: TObject);
begin
  frmEval.Show;
end;

procedure TfrmMacro.pgcEditChange(Sender: TObject);
begin
  Caption := Current.FileName;
  chkInterlockClick(Self);
end;

procedure TfrmMacro.DispBreakPoints;
var
  I: Integer;
begin
  sgBreak.Cols[0].Clear;
  sgBreak.Cols[1].Clear;
  for I := 0 to BreakPoints.Count - 1 do
  begin
    sgBreak.Cells[0, I] :=
      MinimizeName(BreakPoints[I].FileName, sgBreak.Canvas, sgBreak.ColWidths[0]);

    sgBreak.Cells[1, I] := IntToStr(BreakPoints[I].Line + 1);
  end;
end;

procedure TfrmMacro.sgBreakSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  BI: PBreakInfo;
begin
  BI := BreakPoints[sgBreak.Row];
  MoveCursor(BI.FileName, BI.Line);
end;

procedure TfrmMacro.V2Click(Sender: TObject);
begin
  SaveAll;
end;

procedure TfrmMacro.Close1Click(Sender: TObject);
begin
  if (not CanClose(CurrentIndex)) then
    Exit;
  Delete(CurrentIndex);
  if (Count = 0) then
    Add('');
  pgcEditChange(Self);
end;

procedure TfrmMacro.L1Click(Sender: TObject);
begin
  CloseAll;
end;

procedure TfrmMacro.chkInterlockClick(Sender: TObject);
begin
  if (not chkInterlock.Checked) then
    Exit;
  cbTarget.ItemIndex := pgcEdit.ActivePageIndex;
end;

procedure TfrmMacro.DispPC(EI: TEditInfo; Line: Integer);
begin
  Assert(Assigned(EI));
  EI.SetLineColor(Line, clYellow, clBlack);
  EI.DispLine(Line);
  EI.Invalidate;
end;

procedure TfrmMacro.HidePC(EI: TEditInfo; Line: Integer; Invalidate: Boolean);
begin
  if (not Assigned(EI)) then
    Exit;

  EI.UpdateLine(PrevLine);
  if (Invalidate) then
    EI.Invalidate;
end;

procedure TfrmMacro.BackupEdited;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Editors[I].BackupEdited;
end;

procedure TfrmMacro.Button1Click(Sender: TObject);
begin
  JvHLEditor1.Highlighter := hlSyntaxHighlighter;
  JvHLEdPropDlg1.Execute;
end;

procedure TfrmMacro.ClearEdited;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Editors[I].ClearEdited;
end;

procedure TfrmMacro.OrEdited;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Editors[I].OrEdited;
end;

procedure TfrmMacro.RestoreEdited;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Editors[I].RestoreEdited;
end;

function TfrmMacro.IsEdited(IgnoreIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
(*  for I := 0 to Count - 1 do
    if (I <> IgnoreIndex) then
      Result := Result or Editors[I].Editor.Edited; *)
end;

procedure TfrmMacro.FormShow(Sender: TObject);
const
  DefaultFileName = 'default.lua';
begin
  if (Self <> Application.MainForm) then
    Exit;
  LoadFromFile(DefaultFileName);
end;

procedure TfrmMacro.SetCurrentIndex(const Value: Integer);
begin
  Page.ActivePageIndex := Value;
end;

end.
