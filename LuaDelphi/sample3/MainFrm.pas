unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Contnrs, XPMan;

type
  TTortoise = class
  public
    X, Y: Double;
    Angle: Double;
    Image: TImage;
    Color: TColor;
    procedure Go(L: Double);
    procedure Rotate(Rad: Double);
    procedure Draw;
    procedure Affine(var AX, AY: Double; X, Y: Double);
    procedure LPtoDP(var DPX, DPY: Integer; LPX, LPY: Double);
  end;
  TfrmMain = class(TForm)
    memCode: TMemo;
    Image1: TImage;
    GroupBox1: TGroupBox;
    btnRun: TButton;
    btnForward: TButton;
    btnBack: TButton;
    btnRight: TButton;
    chkRegist: TCheckBox;
    edtLength: TEdit;
    edtAngle: TEdit;
    udAngle: TUpDown;
    udLength: TUpDown;
    btnLeft: TButton;
    btnGraphClear: TButton;
    btnCreate: TButton;
    lblName: TLabel;
    btnDestroy: TButton;
    btnLoad: TButton;
    btnSave: TButton;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    chkHide: TCheckBox;
    btnColor: TButton;
    pnlColor: TPanel;
    dlgColor: TColorDialog;
    XPManifest: TXPManifest;
    procedure btnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnGraphClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnDestroyClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnColorClick(Sender: TObject);
  private
    Tortoise: TTortoise;
    TortoiseList: TObjectList;
    Running: Boolean;
    function SafeTortoise: TTortoise;
    procedure AddOpCodeFmt(Fmt: string; const Args: array of Const);
    procedure AddCode(Code: string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  LuaBase, Math, lua, lualib, lauxlib, LuaUtils;

const
  HandleStr = 'Handle';

procedure LuaIdle(L: Plua_State);
begin
  if (frmMain.chkHide.Checked) then
    Exit;
  Application.ProcessMessages;
  if (not frmMain.Running) then
    luaL_error(L, 'íÜífÇµÇ‹ÇµÇΩ');
end;

function LuaPrint(L: Plua_State): Integer; cdecl;
begin
  LuaShowStack(L);
  Result := 0;
end;

function LuaClear(L: Plua_State): Integer; cdecl;
begin
  frmMain.btnGraphClearClick(nil);
  LuaIdle(L);
  Result := 0;
end;

procedure CheckArg(L: Plua_State; N: Integer);
begin
  if (lua_gettop(L) <> N) then
    luaL_error(L, 'à¯êîÇ™à·Ç¢Ç‹Ç∑');
end;

function GetTortoise(L: Plua_State; Index: Integer): TTortoise;
begin
  Result := TTortoise(LuaGetTableLightUserData(L, Index, HandleStr));
end;

function TortoiseForward(L: Plua_State): Integer; cdecl;
begin
  CheckArg(L, 2);
  GetTortoise(L, 1).Go(lua_tonumber(L, 2));
  LuaIdle(L);
  Result := 0;
end;

function TortoiseBack(L: Plua_State): Integer; cdecl;
begin
  CheckArg(L, 2);
  GetTortoise(L, 1).Go(-lua_tonumber(L, 2));
  LuaIdle(L);
  Result := 0;
end;

function TortoiseRight(L: Plua_State): Integer; cdecl;
begin
  CheckArg(L, 2);
  GetTortoise(L, 1).Rotate(-DegToRad(lua_tonumber(L, 2)));
  LuaIdle(L);
  Result := 0;
end;

function TortoiseLeft(L: Plua_State): Integer; cdecl;
begin
  CheckArg(L, 2);
  GetTortoise(L, 1).Rotate(DegToRad(lua_tonumber(L, 2)));
  LuaIdle(L);
  Result := 0;
end;

function FreeTortoise(L: Plua_State): Integer; cdecl;
var
  Tortoise: TTortoise;
begin
  CheckArg(L, 1);
  Tortoise := GetTortoise(L, 1);
  Tortoise.Draw;
  with (frmMain.TortoiseList) do
    Delete(IndexOf(Tortoise));
  LuaSetTableClear(L, 1);
  Result := 0;
end;

function TortoiseIndex(L: Plua_State): Integer; cdecl;
begin
  Result := 1;
  if (lua_tostring(L, 2) = 'X') then
    lua_pushnumber(L, GetTortoise(L, 1).X)
  else if (lua_tostring(L, 2) = 'Y') then
    lua_pushnumber(L, GetTortoise(L, 1).Y)
  else if (lua_tostring(L, 2) = 'Color') then
    lua_pushnumber(L, GetTortoise(L, 1).Color)
  else if (lua_tostring(L, 2) = 'Angle') then
    lua_pushnumber(L, GetTortoise(L, 1).Angle)
  else
    Result := 0;
end;

function TortoiseNewIndex(L: Plua_State): Integer; cdecl;
begin
  if (lua_tostring(L, 2) = 'Color') then
    GetTortoise(L, 1).Color := TColor(Round(lua_tonumber(L, 3)))
  else
    luaL_error(L, PChar(lua_tostring(L, 2) + 'Ç÷ÇÃë„ì¸ÇÕèoóàÇ‹ÇπÇÒ'));
  Result := 0;
end;

function CreateTortoise(L: Plua_State): Integer; cdecl;
var
  Tortoise: TTortoise;
begin
  Tortoise := TTortoise.Create;
  frmMain.TortoiseList.Add(Tortoise);

  Tortoise.Image := frmMain.Image1;
  Tortoise.X := LuaGetTableNumber(L, 1, 'X');
  Tortoise.Y := LuaGetTableNumber(L, 1, 'Y');
  Tortoise.Color := Round(LuaGetTableNumber(L, 1, 'Color'));
  Tortoise.Angle := LuaGetTableNumber(L, 1, 'Angle');
  Tortoise.Draw;

  LuaSetTableNil(L, 1, 'X');
  LuaSetTableNil(L, 1, 'Y');
  LuaSetTableNil(L, 1, 'Color');
  LuaSetTableNil(L, 1, 'Angle');
  LuaSetTableLightUserData(L, 1, HandleStr, Tortoise);
  LuaSetTableFunction(L, 1, 'F', TortoiseForward);
  LuaSetTableFunction(L, 1, 'B', TortoiseBack);
  LuaSetTableFunction(L, 1, 'R', TortoiseRight);
  LuaSetTableFunction(L, 1, 'L', TortoiseLeft);
  LuaSetTableFunction(L, 1, 'Free', FreeTortoise);
  LuaSetMetaFunction(L, 1, '__index', TortoiseIndex);
  LuaSetMetaFunction(L, 1, '__newindex', TortoiseNewIndex);

  Result := 1;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
  L: Plua_State;
begin
  if (Running) then begin
    Running := False;
    btnRun.Enabled := False;
    Exit;
  end;

  L := lua_open;
  Running := True;
  try
    btnLoad.Enabled := False;
    btnSave.Enabled := False;
    btnRun.Caption := 'íÜíf';
    luaopen_math(L);
    lua_settop(L, 0);
    LuaRegister(L, 'Print', LuaPrint);
    LuaRegister(L, 'Clear', LuaClear);
    LuaRegister(L, 'TTortoise', CreateTortoise);
    LuaLoadBuffer(L, memCode.Text, 'code');
    LuaPCall(L, 0, 0, 0);
  finally
    TortoiseList.Clear;
    Running := False;
    lua_close(L);
    btnRun.Caption := 'é¿çs';
    btnLoad.Enabled := True;
    btnSave.Enabled := True;
    btnRun.Enabled := True;
  end;
end;

{ TTortoise }

procedure TTortoise.Affine(var AX, AY: Double; X, Y: Double);
begin
  AX := X * Cos(Angle) - Y * Sin(Angle);
  AY := X * Sin(Angle) + Y * Cos(Angle);
end;

procedure TTortoise.Draw;
  function AffinePoint(DX, DY: Double): TPoint;
  var
    AX, AY: Double;
  begin
    Affine(AX, AY, DX, DY);
    LPtoDP(Result.X, Result.Y, X + AX, Y + AY);
  end;
const
  L = 20;
var
  P: array [0..2] of TPoint;
begin
  P[0] := AffinePoint(0, L);
  P[1] := AffinePoint(L div 3, 0);
  P[2] := AffinePoint(-L div 3, 0);
  Image.Canvas.Pen.Mode := pmXor;
  Image.Canvas.Pen.Color := clBlue;
  Image.Canvas.Polygon(P);
  Image.Canvas.Pen.Mode := pmCopy;
end;

procedure TTortoise.Go(L: Double);
var
  DX, DY: Double;
  DPX, DPY: Integer;
begin
  Draw;
  LPtoDP(DPX, DPY, X, Y);
  Image.Canvas.MoveTo(DPX, DPY);
  Affine(DX, DY, 0, L);
  X := X + DX;
  Y := Y + DY;
  Image.Canvas.Pen.Color := Color;
  LPtoDP(DPX, DPY, X, Y);
  Image.Canvas.LineTo(DPX, DPY);
  Draw;
end;

procedure TTortoise.LPtoDP(var DPX, DPY: Integer; LPX, LPY: Double);
begin
  DPX := Image.Width div 2 + Round(LPX);
  DPY := Image.Height div 2 - Round(LPY);
end;

procedure TTortoise.Rotate(Rad: Double);
begin
  Draw;
  Angle := Angle + Rad;
  Draw;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TortoiseList := TObjectList.Create;
  btnGraphClearClick(Self);
end;

procedure TfrmMain.btnForwardClick(Sender: TObject);
begin
  SafeTortoise.Go(udLength.Position);
  AddOpCodeFmt(':F(%d)', [udLength.Position]);
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  SafeTortoise.Go(-udLength.Position);
  AddOpCodeFmt(':B(%d)', [udLength.Position]);
end;

procedure TfrmMain.btnRightClick(Sender: TObject);
begin
  SafeTortoise.Rotate(-DegToRad(udAngle.Position));
  AddOpCodeFmt(':R(%d)', [udAngle.Position]);
end;

procedure TfrmMain.btnLeftClick(Sender: TObject);
begin
  SafeTortoise.Rotate(DegToRad(udAngle.Position));
  AddOpCodeFmt(':L(%d)', [udAngle.Position]);
end;

procedure TfrmMain.btnGraphClearClick(Sender: TObject);
var
  I: Integer;
begin
  AddCode('Clear()');
  Image1.Canvas.Pen.Color := clWhite;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Rectangle(0, 0, Image1.Width, Image1.Height);
  if (Assigned(Tortoise)) then
    Tortoise.Draw;
  for I := 0 to TortoiseList.Count - 1 do
    (TortoiseList[I] as TTortoise).Draw;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  TortoiseList.Free;
end;

procedure TfrmMain.btnCreateClick(Sender: TObject);
var
  S: string;
begin
  if (Assigned(Tortoise)) then
    raise Exception.Create('Ç‹ÇæãTÇ™ãèÇ‹Ç∑');

  S := 'T';
  if (not InputQuery('ãTÇÃñºëO', 'ãTÇÃñºëOÇì¸óÕÇµÇƒÇ≠ÇæÇ≥Ç¢', S)) then
    Exit;
  lblName.Caption := S;
  AddOpCodeFmt(' = TTortoise{X=0, Y=0, Angle=0}', []);
  Tortoise := TTortoise.Create;
  Tortoise.Image := Image1;
  Tortoise.X := 0;
  Tortoise.Y := 0;
  Tortoise.Angle := 0;
  Tortoise.Draw;
end;

procedure TfrmMain.btnDestroyClick(Sender: TObject);
begin
  if (not Assigned(Tortoise)) then
    Exit;
  AddOpCodeFmt(':Free()', []);
  Tortoise.Draw;
  FreeAndNil(Tortoise);
  lblName.Caption := '';
end;

procedure TfrmMain.AddOpCodeFmt(Fmt: string; const Args: array of Const);
begin
  AddCode(lblName.Caption + Format(Fmt, Args));
end;

procedure TfrmMain.AddCode(Code: string);
begin
  if (not chkRegist.Checked) or (Running)then
    Exit;
  memCode.Lines.Add(Code);
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
  dlgOpen.FileName := Caption;
  if (not dlgOpen.Execute) then
    Exit;

  memCode.Lines.LoadFromFile(dlgOpen.FileName);
  Caption := dlgOpen.FileName;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  dlgSave.FileName := Caption;
  if (not dlgSave.Execute) then
    Exit;

  memCode.Lines.SaveToFile(dlgSave.FileName);
  Caption := dlgSave.FileName;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (Running) then
    ShowMessage('œÓ„‡ÏÏ‡ ‚˚ÔÓÎÌˇÂÚÒˇ');
  CanClose := not Running;
end;

procedure TfrmMain.btnColorClick(Sender: TObject);
begin
  if (not dlgColor.Execute) then
    Exit;
  SafeTortoise.Color := dlgColor.Color;
  AddOpCodeFmt('.Color = %d', [dlgColor.Color]);
end;

function TfrmMain.SafeTortoise: TTortoise;
begin
  if (not Assigned(Tortoise)) then
    raise Exception.Create('ãTÇ™Ç¢Ç‹ÇπÇÒ');
  Result := Tortoise;
end;

end.
