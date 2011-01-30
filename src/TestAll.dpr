program TestAll;

{$APPTYPE CONSOLE}

uses ExceptionLog, Utils, SysUtils;

begin
  // Проверка работы GetExecuteType
  assert( GetExecuteType('a.exe') = EXE );
  assert( GetExecuteType('test.Msi') = MSI );
  assert( GetExecuteType('a.msi.exe') = EXE );
  assert( GetExecuteType('a.exe.msi') = MSI );
  assert( GetExecuteType('a.exe.msi -tt') = MSI );
  try
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
