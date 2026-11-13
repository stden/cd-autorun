unit TestLua;

interface

implementation

Uses SysUtils, DLua, MainUnit, LuaBase, LuaUtils, Variants, Utils, Graphics,
  DRegistry;

type
  MyClass = class
    Mess : string;
    constructor Create( _Mess : string );
  end;

{ MyClass }

constructor MyClass.Create(_Mess: string);
begin
  Mess := _Mess;
end;

procedure PushPopTest;
var
  i : integer;
  d : double;
  e : extended;
  M,M1 : MyClass;
begin
  i := Random(10000);
  GLua.Push(i);
  assert( GLua.Pop = i );
  d := Random(10000)/12;
  GLua.Push(d);
  assert( GLua.Pop = d );
  e := Random(10000)/12;
  GLua.Push(e);
  assert( GLua.Pop = e );
  GLua.Push('Привет!');
  assert( GLua.Pop = 'Привет!' );
  GLua.Push(true);
  assert( GLua.Pop = true );
  GLua.Push(false);
  assert( GLua.Pop = false );
  // Тестирование добавления пользовательских данных
  M := MyClass.Create('Test message');
  GLua.Push( M );
  M1 := MyClass(GLua.PopClass);
  assert( M1.Mess = 'Test message');
end;

procedure TestXX;
var F : TFont;
begin
  F := TFont.Create;
  with F do begin
    Size := 12;
    Name := 'Times New Roman';
    Style := [fsBold];
    Color := clWhite;
  end;
  Writeln( ClassToLuaText(F) );
  assert( ClassToLuaText(F) = 'Font{ size=12, family="Times New Roman", bold=true, italic=false, strikeout=false, underline=false, color="clWhite" }' );
end;

procedure TestShellFolder;
begin
  assert( GLua.RunFunction('ShellFolder("Desktop")') =
    RegGetValue(
      'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',
      'Desktop') );
     // C:\Documents and Settings\Admin\Рабочий стол
  assert( GLua.RunFunction('ShellFolder("Personal")') =
    RegGetValue(
      'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',
      'Personal') );
     // C:\Documents and Settings\Admin\Мои документы
end;

procedure TestDeleteFile;
begin
  GLua.RunFunction('DeleteFile("Несуществующий файл")');
end;

var
  R,k,i : integer;
  M : MyClass;
  P : Variant;
begin
  PushPopTest;
  // Тестирование добавления результатов с помощью array of const
  GLua.Res( R, [3,2,'aa',true,false,MyClass.Create('Test!')] );
  // В стеке оказалось 6 чисел
  assert( R = 6 );
  // Проверяем их значения
  assert( GLua.Get(1) = 3 );
  k := GLua.Get(2);
  assert( k = 2 );
  assert( GLua.Get(3) = 'aa' );
  assert( GLua.Get(4) = true );
  assert( GLua.Get(5) = false );
  M := MyClass(TVarData(GLua.Get(6)).VPointer);
  assert( M.Mess = 'Test!' );
  // Тестрование работы функций для работы с реестром
  MainUnit.AutorunForm.RegisterLuaFunctions;
  GLua.Exec( 'temp = GetRunDir()' );
  for i := 0 to 10 do
    assert( GLua.GetGlobal('temp') = GetRunDir() );
  assert( GLua.RunFunction('GetRunDir()') = GetRunDir() );
  // поразмялись? а теперь за дело..
  // Корневые каталоги реестра
  assert( GLua.RunFunction('RegKeyExists("HKEY_CLASSES_ROOT")') = true );
  assert( GLua.RunFunction('not RegKeyExists("HKEY_CLASSES_ROOT!")') = true );
  assert( GLua.RunFunction('RegKeyExists("HKEY_CURRENT_USER")') = true );
  assert( GLua.RunFunction('RegKeyExists("HKEY_LOCAL_MACHINE")') = true );
  assert( GLua.RunFunction('RegKeyExists("HKEY_USERS")') = true );
  assert( GLua.RunFunction('RegKeyExists("HKEY_CURRENT_CONFIG")') = true );
  // Получение значений
  assert( GLua.RunFunction('RegGetValue("HKEY_CURRENT_USER\\Environment","TEMP")') =
    '%USERPROFILE%\Local Settings\Temp' );
  assert( GLua.RunFunction('RegGetValue("HKEY_CURRENT_USER\\Console","ColorTable01")') =
    8388608 );
  GLua.RunFunction( 'RegSetValue("HKEY_CURRENT_USER\\Denis","String","Test string")' );;
  assert( GLua.RunFunction( 'RegGetValue("HKEY_CURRENT_USER\\Denis","String")' ) = 'Test string' );

  TestXX;
  TestShellFolder;
  TestDeleteFile;

  LuaShowStack(Glua.L,'11');
end.
