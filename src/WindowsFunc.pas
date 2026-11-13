unit WindowsFunc;

interface

function CopyDir(const fromDir, toDir: string): Boolean;
function MoveDir(const fromDir, toDir: string): Boolean;
function DelDir(const dir: string): Boolean;

implementation

uses Windows, ShellAPI, SysUtils;

// Если в конце имени каталога идёт '\', то надо добавить '*'
function FixFromDir( const fromDir: string):string;
begin
  Result := fromDir;
  if Copy(Result,Length(Result),1) = PathDelim then
    Result := Result + '*';
end;

function CopyDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do begin
    wFunc  := FO_COPY;
    fFlags := FOF_NOCONFIRMMKDIR + FOF_NOCONFIRMATION;
    pFrom  := PChar(FixFromDir(fromDir) + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function MoveDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do begin
    wFunc  := FO_MOVE;
    fFlags := FOF_NOCONFIRMMKDIR + FOF_NOCONFIRMATION;
    pFrom  := PChar(FixFromDir(fromDir) + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function DelDir(const dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do begin
    wFunc  := FO_DELETE;
    fFlags := FOF_NOCONFIRMATION;
    pFrom  := PChar(FixFromDir(dir) + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;

end.
