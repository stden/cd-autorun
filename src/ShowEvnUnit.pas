unit ShowEvnUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids;

type
  TShowEnvForm = class(TForm)
    SG: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowEnvForm: TShowEnvForm;

implementation

{$R *.dfm}

function GetAllEnvVars(const Vars: TStrings): Integer;
var
  PEnvVars: PChar;    // pointer to start of environment block
  PEnvEntry: PChar;   // pointer to an env string in block
begin
  // Clear the list
  if Assigned(Vars) then
    Vars.Clear;
  // Get reference to environment block for this process
  PEnvVars := GetEnvironmentStrings;
  if PEnvVars <> nil then
  begin
    // We have a block: extract strings from it
    // Env strings are #0 separated and list ends with #0#0
    PEnvEntry := PEnvVars;
    try
      while PEnvEntry^ <> #0 do
      begin
        if Assigned(Vars) then
          Vars.Add(PEnvEntry);
        Inc(PEnvEntry, StrLen(PEnvEntry) + 1);
      end;
      // Calculate length of block
      Result := (PEnvEntry - PEnvVars) + 1;
    finally
      // Dispose of the memory block
      Windows.FreeEnvironmentStrings(PEnvEntry);
    end;
  end
  else
    // No block => zero length
    Result := 0;
end;

procedure TShowEnvForm.FormCreate(Sender: TObject);
var
  Vars: TStringList;
  i : integer;
  VarName: String;
begin
  Caption := GetCurrentDir;
  SG.Cells[0,0] := 'Переменная окружения';
  SG.Cells[1,0] := 'Значение';
  Vars := TStringList.Create;
  GetAllEnvVars(Vars);
  SG.RowCount := Vars.Count+1;
  for i := 0 to Vars.Count - 1 do begin
    VarName := Copy(Vars[i],1,pos('=',Vars[i])-1);
    SG.Cells[0,i+1] := VarName;
    SG.Cells[1,i+1] := GetEnvironmentVariable(VarName);
  end;
end;

end.
