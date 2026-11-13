unit Prepare;

interface

// Поиск символа в строке начиная с позиции startIndex
function myPos( const C: char; Str: string; startIndex: integer ):integer; overload;

// Если startIndex не указывать, то поиск начинается с начала строки
function myPos( const C: char; Str: string ):integer; overload;

// Замена в имени каталога переменных окружения на их реальные значения
function PreparePath( const Dir: string ):string;

implementation

uses SysUtils;

// Поиск символа в строке начиная с позиции startIndex
function myPos( const C: char; Str: string; startIndex: integer ):integer; overload;
var i:integer;
begin
  myPos := 0;
  for i:=startIndex to Length(Str) do
    if Str[i] = C then begin
      myPos := i;
      exit;
    end;
end;

// Если startIndex не указывать, то поиск начинается с начала строки
function myPos( const C: char; Str: string ):integer; overload;
begin
  myPos := myPos(C,Str,1);
end;

// Замена в имени каталога переменных окружения на их реальные значения
function PreparePath( const Dir: string ):string;
var
  p1,p2 : integer;
begin
  Result := Dir;
  while true do begin
    p1 := myPos('%',Result);
    if p1 = 0 then exit;
    p2 := myPos('%',Result,p1+1);
    if p2 = 0 then exit;
    Result := copy(Result,1,p1-1) + GetEnvironmentVariable(copy(Result,p1+1,p2-p1-1)) + copy(Result,p2+1,MaxLongInt);
  end;
end;

initialization

assert(PreparePath('xxx%ProgramFiles%\TestDir') =
  'xxx'+GetEnvironmentVariable('ProgramFiles')+'\TestDir');

end.
