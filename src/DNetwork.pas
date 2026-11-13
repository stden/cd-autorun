unit DNetwork;

interface

function NetGetConnection( NetDrive:Char ):String;
function NetCancelConnection( NetDrive:Char ):String;
function NetAddConnection( NetDrive:Char; NetPath:String ):String;

implementation

uses Types, Windows;

function NetGetConnection( NetDrive:Char ):String;
var
  lpLocalName : PChar;
  lpRemoteName : PChar;
  Err : DWORD;
  MAX_SIZE : DWORD;
begin
  MAX_SIZE := 3000;
  GetMem( lpRemoteName, MAX_SIZE );
  lpLocalName := PChar(String(NetDrive+':'));
  Err := WNetGetConnection( lpLocalName, lpRemoteName, MAX_SIZE );
  case Err of
    NO_ERROR: Result := lpRemoteName;
    ERROR_BAD_DEVICE: Result := 'Значение "'+lpLocalName+'" неверно!';
    ERROR_NOT_CONNECTED: Result := 'Устройство указанное в "'+lpLocalName+'" не переназначенное устройство.';
    ERROR_MORE_DATA: Result := 'Буфер слишком маленький.';
    ERROR_CONNECTION_UNAVAIL: Result := 'Устройство на данный момент не соединено, но это захваченная связь.';
    ERROR_EXTENDED_ERROR: Result := 'Произошла сетевая спецефическая ошибка. Для того чтобы получить информацию об ошибке, вызовите функцию WNetGetLastError.';
    ERROR_NO_NET_OR_BAD_PATH: Result := 'Операция не выполнена потому что сетевой компонент не запущен или имя сетевого ресурса не может быть использовано.';
    ERROR_NO_NETWORK: Result := 'Сеть отсутствует.';
  end;
end;

function NetCancelConnection( NetDrive:Char ):String;
var
  lpLocalName : PChar;
  Err : DWORD;
begin
  lpLocalName := PChar(String(NetDrive+':'));
  Err := WNetCancelConnection( lpLocalName, true );
  case Err of
    NO_ERROR: Result := NetDrive+' успешно отключён!';
    ERROR_BAD_PROFILE: Result := 'Профиль пользователя неправильного формата.';
    ERROR_CANNOT_OPEN_PROFILE: Result := 'Система не может открыть профиль пользователя.';
    ERROR_DEVICE_IN_USE: Result := 'Устройсво используется активным процессом и не может быть разъеденено.';
    ERROR_EXTENDED_ERROR: Result := 'Произошла сетевая спецефическая ошибка. Для того чтобы получить информацию об ошибке, вызовите функцию WNetGetLastError.';
    ERROR_NOT_CONNECTED: Result := 'Имя определенное параметром lpName - не переназначенное устройство или система к настоящему времени не подключена к устройству.';
    ERROR_OPEN_FILES: Result := 'Если есть открытые файлы и параметр fForce равен False.';
  end;
end;

function NetAddConnection( NetDrive:Char; NetPath:String ):String;
var
  Err : DWORD;
begin
  { подключаем сетевой pесуpс, используя стpуктуpу TNetResource }
  Err := WNetAddConnection(
    PChar(NetPath),
    '', // lpPassword,
    PChar(String(NetDrive+':')) //lpLocalName
    );
  case Err of
    NO_ERROR: Result := NetDrive+' успешно подключён!';
    ERROR_ACCESS_DENIED: Result := 'Нет доступа к сетевому ресурсу.';
    ERROR_ALREADY_ASSIGNED: Result := 'Устройство указанное в параметре lpLocalName уже переопределено.';
    ERROR_BAD_DEV_TYPE: Result := 'Тип устройства и тип ресурса не сочетается.';
    ERROR_BAD_DEVICE: Result := 'Значение определенное в параметре lpLocalName неверно.';
    ERROR_BAD_NET_NAME: Result := 'Значение определенное в параметре lpRemoteName неверно.';
    ERROR_BAD_PROFILE: Result := 'Профиль пользователя неправильного формата.';
    ERROR_CANNOT_OPEN_PROFILE: Result := 'Система не может открыть профиль пользователя.';
    ERROR_DEVICE_ALREADY_REMEMBERED: Result := 'Прявязка для устройства указнного в параметре lpLocalName - уже в профиле пользователя.';
    ERROR_EXTENDED_ERROR: Result := 'Произошла сетевая спецефическая ошибка. Для того чтобы получить информацию об ошибке, вызовите функцию WNetGetLastError.';
    ERROR_INVALID_PASSWORD: Result := 'Пароль недействителен.';
    ERROR_NO_NET_OR_BAD_PATH: Result := 'Операция не выполнена потому что сетевой компонент не запущен или имя сетевого ресурса не может быть использовано.';
    ERROR_NO_NETWORK: Result := 'Сеть отсутствует.';
  else
    Result := 'Неизвестная ошибка!';
  end;
end;

end.
