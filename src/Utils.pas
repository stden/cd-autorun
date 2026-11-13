// Вспомогательные процедуры и функции, независимые от выполняемых задач
unit Utils;

interface

// Открытие ссылки в Internet Explorer или другом броузере
procedure OpenLink( Link:string );

// Путь запуска программы
function GetRunDir : string;

procedure SaveStringToFile( Str, FileName : string );

// Запуск файла без ожидания завершения
procedure Execute( ExeFileName,Params: string );

// Запуск исполняемого файла и ожидание его завершения
procedure ExecuteAndWait( ExeFileName,Params : string );

// Тип исполняемого файла (типы отличаются методом запуска)
type TExecuteType = (MSI,EXE);
function GetExecuteType(FileName: string): TExecuteType;
procedure RunAndWait(FileName: string);

procedure Utf8File(FileName,S:string);

implementation

uses SysUtils, StrUtils, ShellAPI, Forms, Windows, Dialogs, DMessageDlg;

procedure OpenLink( Link:string );
begin
  ShellExecute(Application.Handle, 'open', PChar(Link), nil, nil, SW_SHOW);
end;

function GetRunDir : string;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

procedure SaveStringToFile( Str, FileName : string );
var T:TextFile;
begin
  Rewrite(T,FileName);
  Writeln(T,'<?xml version="1.0" encoding="windows-1251"?>');
  Writeln(T);
  Write(T, ReplaceStr(Str,#9,'  '));
  CloseFile(T);
end;

// Запуск исполняемого файла и ожидание его завершения
procedure ExecuteAndWait( ExeFileName,Params : string );
var SE : TShellExecuteInfo;
begin
  fillChar(SE,sizeof(SE),0);
  with SE do begin
    cbSize := sizeof(SE);
    Wnd := GetActiveWindow();
    lpFile := PChar(ExeFileName);
    lpDirectory := PChar(GetRunDir);
    lpVerb := 'open';
    lpParameters := PChar(Params);
    nShow := SW_SHOWNORMAL;
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
  end;
  if ShellExecuteEx(@SE) then begin
    while WaitForSingleObject(SE.hProcess, 100) <> WAIT_OBJECT_0 do
      Application.ProcessMessages;
  end else begin
    raise Exception.Create(SysErrorMessage(GetLastError));
  end;
end;

function GetExecuteType(FileName: string): TExecuteType;
const SeparateSymbols : set of char = [#0..#32];
var P : integer;
begin
  FileName := LowerCase(FileName)+' ';
  P := Pos('.msi',FileName);
  if (P <> 0) and (FileName[P+4] in SeparateSymbols)  then
    Result := MSI
  else
    Result := EXE;
end;

procedure RunAndWait(FileName: string);
begin
  case GetExecuteType(FileName) of
    EXE: ExecuteAndWait(FileName,'');
    MSI: ExecuteAndWait('msiexec.exe', '/i '+FileName);
  end;
end;

procedure Execute(ExeFileName,Params: string);
var
  FullFileName : string; // Полный путь к файлу
  RunDir : string; // Путь запуска
begin
  FullFileName := GetRunDir + PathDelim + ExeFileName;
  if(Not FileExists(FullFileName)) then
    _MessageDlg('Файл '+FullFileName+' не найден',mtError);
  RunDir := ExcludeTrailingPathDelimiter(ExtractFilePath(FullFileName));
  ExeFileName := ExtractFileName(FullFileName);
  ShellExecute(Application.Handle,'open',PChar(ExeFileName), PChar(Params),
    PChar(RunDir), SW_NORMAL);
end;

const         // surrogate bytes
  Clef = #$5B + #$D834 + #$DD1E + #$5D;

procedure Utf8File(FileName,S:string);
var
  F: TextFile;
  B: Byte;
begin
  Assign(F, FileName);
  Rewrite(f);
  for B in TEncoding.UTF8.GetPreamble do write(f, AnsiChar(B));
  writeln(f, UTF8String(S));
  Close(F);
end;

initialization

// Utf8File('a.txt','Привет, мир!');

end.
