unit TestRegistryU;

interface

implementation

uses DRegistry;

var i : integer;
begin
  // �������� �������� �������
  assert( RegKeyExists('HKEY_CLASSES_ROOT') );
  assert( not RegKeyExists('HKEY_CLASSES_ROOT!') );
  assert( RegKeyExists('HKEY_CURRENT_USER') );
  assert( RegKeyExists('HKEY_LOCAL_MACHINE') );
  assert( RegKeyExists('HKEY_USERS') );
  assert( RegKeyExists('HKEY_CURRENT_CONFIG') );
  // �����������
  assert( RegKeyExists('HKEY_CURRENT_USER\Software') );
  assert( not RegKeyExists('HKEY_CURRENT_USER\Software!') );
  assert( RegKeyExists('HKEY_CURRENT_USER\Software\Microsoft') );
  assert( RegKeyExists('HKEY_CURRENT_USER\Software\Microsoft\Windows') );
  assert( RegKeyExists('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion') );
  // ���������� �����
  assert( RegValueExists('HKEY_CURRENT_USER\Console','ColorTable00') );
  assert( not RegValueExists('HKEY_CURRENT_USER\Console','!ColorTable00') );
  assert( not RegValueExists('HKEY_CURRENT_USER\Console!','ColorTable00') );
  // ��������� ��������
  assert( RegGetValue('HKEY_CURRENT_USER\Environment','TEMP') =
    '%USERPROFILE%\Local Settings\Temp' );
  assert( RegGetValue('HKEY_CURRENT_USER\Console','ColorTable01') =
    8388608 );
  // ������ ��������
  RegSetValue('HKEY_CURRENT_USER\Denis','String','Test string');
  assert( RegGetValue('HKEY_CURRENT_USER\Denis','String') = 'Test string' );
  i := Random(100);
  RegSetValue('HKEY_CURRENT_USER\Denis','Integer',i);
  writeln(RegGetValue('HKEY_CURRENT_USER\Denis','Integer'));
  assert( RegGetValue('HKEY_CURRENT_USER\Denis','Integer') = i );
end.
