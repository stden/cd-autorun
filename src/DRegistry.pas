// Модуль работы с реестром
unit DRegistry;

interface

uses Registry, Windows;

function RegKeyExists( KeyFullName : string ):boolean;
function RegValueExists( KeyFullName,ValueName : string ):boolean;
function RegGetValue( const KeyFullPath,ValueName: string ):variant;
procedure RegSetValue( KeyFullPath,ValueName: string; Value: variant );

implementation

uses Variants, Classes;

function SplitRegKey( const KeyFullPath: string; out KeyName: string;
  CheckRootKey : boolean = true ):HKEY;
var
  RootName : string;
  P : Integer;
begin
  // Получаем текстовое имя корня
  P := Pos('\',KeyFullPath);
  if P=0 then begin
    RootName := KeyFullPath;
    KeyName := '';
  end else begin
    RootName := Copy(KeyFullPath,1,P-1);
    KeyName := Copy(KeyFullPath,P+1);
  end;
  Result := 0;
  if RootName = 'HKEY_CLASSES_ROOT' then Result := HKEY_CLASSES_ROOT;
  if RootName = 'HKEY_CURRENT_USER' then Result := HKEY_CURRENT_USER;
  if RootName = 'HKEY_LOCAL_MACHINE' then Result := HKEY_LOCAL_MACHINE;
  if RootName = 'HKEY_USERS' then Result := HKEY_USERS;
  if RootName = 'HKEY_PERFORMANCE_DATA' then Result := HKEY_PERFORMANCE_DATA;
  if RootName = 'HKEY_CURRENT_CONFIG' then Result := HKEY_CURRENT_CONFIG;
  if RootName = 'HKEY_DYN_DATA' then Result := HKEY_DYN_DATA;
  if CheckRootKey and (Result=0) then
    raise ERegistryException.Create('Недопустимый корневой раздел реестра: "'+RootName+'" не существует! '+
    'Должен быть: HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE, '+
    'HKEY_USERS, HKEY_PERFORMANCE_DATA, HKEY_CURRENT_CONFIG, HKEY_DYN_DATA' );
end;

// Сравнение строки с шаблоном
//  S - строка для сравнения
//  Template - шаблон
function Match( S,Template : string ):boolean;
// Массив, можно ли сопоставить шаблону до буквы i строку до буквы j
var A : array of array of Boolean;
  I,J : Integer;
begin
  // Решение динамикой.. а как это сделать ещё?
  SetLength(A,Length(Template)+1);
  for I := 0 to Length(Template) do begin
    SetLength(A[I],Length(S)+1);
    for J := 0 to Length(S) do
      A[I,J] := (I=0) and (J=0);
    if I<>0 then
      for J := 1 to Length(S) do
        A[I,J] := A[I-1,J-1] and
          ((S[J] = Template[I]) or (Template[I] = '?'))
            or ((A[I-1,J-1] or A[I,J-1]) and (Template[I] = '*'));
  end;
  // Вывод результата
  Result := A[Length(Template),Length(S)];
end;

function RegKeyExists( KeyFullName : string ):boolean;
var KeyName,Before,After : String;
  i,j,ii : integer;
  Keys : TStrings;
  Key : String;
  Template : String;
  KeyFind : boolean;
begin
  with TRegistry.Create(KEY_READ) do
    try
      RootKey := SplitRegKey(KeyFullName,KeyName,false);
      if KeyName='' then
        Result := RootKey<>0
      else begin
        Keys := TStringList.Create;
        // Если содержит звёздочку - значит это шаблон
        while (Pos('*',KeyName) <> 0) or (Pos('?',KeyName) <> 0) do begin
          // Выделяем кусочек до звёздочки
          i := Pos('*',KeyName);
          ii := Pos('?',KeyName);
          if (ii > 0) and ((i = 0) or (ii<i)) then
            i := ii;
          j := i;
          while (i>1) and (KeyName[i-1]<>'\') do dec(i);
          while (j < Length(KeyName)) and (KeyName[j+1]<>'\') do inc(j);
          Before := copy(KeyName,1,i-2);
          After := copy(KeyName,j+2);
          Template := copy(KeyName,i,j-i+1);
          OpenKey(Before, False);
          GetKeyNames(Keys);
          KeyFind := false;
          for Key in Keys do
            if Match(Key,Template) then begin
              KeyFind := true;
              if After = '' then begin
                Result := true;
                Keys.Free;
                exit;
              end else begin
                assert( OpenKey(Key, False) );
                KeyName := After;
                break;
              end;
            end;
          if not KeyFind then begin
            Result := false;
            Keys.Free;
            exit;
          end;
        end;
        Keys.Free;
        Result := OpenKey(KeyName, False); // Открытие без создания - false
      end;
    finally
      Free;
    end;
end;

function RegValueExists( KeyFullName,ValueName : string ):boolean;
var KeyName : String;
begin
  Result := false;
  with TRegistry.Create(KEY_READ) do
    try
      RootKey := SplitRegKey( KeyFullName, KeyName );
      if KeyName='' then
        raise ERegistryException.Create('Ключ не должен быть пустым');
      if not OpenKey(KeyName, False) then // Открытие без создания - false
        exit
      else
        Result := ValueExists(ValueName);
    finally
      Free;
    end;
end;

function RegGetValue( const KeyFullPath,ValueName: string ):variant;
var
  KeyName : string;
  S : String;
begin
  with TRegistry.Create(KEY_READ) do
    try
      RootKey := SplitRegKey(KeyFullPath,KeyName);
      if not OpenKey(KeyName, False) then // Открытие без создания - false
        raise ERegistryException.Create('Нет такого ключа в реестре');
      case GetDataType(ValueName) of
        rdUnknown: raise ERegistryException.Create('Нет такого значения');
        rdString, rdExpandString: begin
          Result := ReadString(ValueName);
          S := ReadString(ValueName);
        end;
        rdInteger: Result := ReadInteger(ValueName);
        rdBinary: raise ERegistryException.Create('Программа не умеет обрабатывать двоичные данные');
      end;
    finally
      Free;
    end;
end;

procedure RegSetValue( KeyFullPath,ValueName: string; Value: variant );
var
  KeyName : string;
begin
  with TRegistry.Create do
    try
      RootKey := SplitRegKey(KeyFullPath,KeyName);
      if OpenKey(KeyName, True) then begin
        case VarType(Value) of
          varInteger: WriteInteger(ValueName,Value);
          varString: WriteString(ValueName,Value);
        else
          raise ERegistryException.Create('Неправильный тип '+VarTypeAsText(VarType(Value)));
        end;
        CloseKey;
      end else
        raise ERegistryException.Create('Ключ не открылся на запись');
    finally
      Free;
    end;
end;

begin
  assert( Match('','') );
  assert( Match('1','1') );
  assert( not Match('1','2') );
  assert( not Match('1','11') );
  assert( not Match('11','1') );
  assert( Match('11','11') );
  assert( not Match('11','12') );
  assert( Match('11','1?') );
  assert( not Match('112','1?3') );
  assert( Match('12','1*') );
  assert( Match('1111','1*') );
  assert( not Match('111','1?') );
  assert( Match('1234','1*') );
  assert( Match('1234','1*4') );
  assert( Match('12345','1?3?5') );
  assert( not Match('12345','1?p?5') );
  assert( not Match('1234','1*****5') );
  assert( not Match('A','E*') );
  assert( not Match('AppEvents','En*') );
  assert( Match('Environment','En*') );

  assert( RegKeyExists('HKEY_CURRENT_USER\AppEvents\Event*s\ActivatingDocument') );
  assert( RegKeyExists('HKEY_CURRENT_USER\AppEvents\Ev*') );
  assert( RegKeyExists('HKEY_CURRENT_USER\*Events\Event*s\ActivatingDocument') );
  assert( RegKeyExists('HKEY_CURRENT_USER\Environment') );
  assert( not RegKeyExists('HKEY_CURRENT_USER\Environment!!!!!') );
  assert( RegKeyExists('HKEY_CURRENT_USER\En*') );
  assert( not RegKeyExists('HKEY_CURRENT_USER\EnXX*') );
  assert( not RegKeyExists('HKEY_CURRENT_USER\*Events\!!!!!') );
  assert( RegKeyExists('HKEY_CURRENT_USER\E?vironment') );
  assert( not RegKeyExists('HKEY_CURRENT_USER\E?vironmen!') );
  assert( RegKeyExists('HKEY_CURRENT_USER\*Even?s\Eve?t*s\Activati??Document') );

end.


