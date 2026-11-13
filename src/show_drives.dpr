{$APPTYPE CONSOLE}
uses Windows;
var
  i, mask : integer;
  s : string;
begin
  mask := GetLogicalDrives; 
  i := 0;
  while mask<>0 do begin
    s:= chr( ord('A') + i ) + ':\';
    if (mask and 1) <> 0 then
    case GetDriveType(PChar(s)) of
      0               : writeln(s + ' - UNKNOWN');
      1               : writeln(s + ' - NOT_EXIST');
      DRIVE_REMOVABLE : writeln(s + ' - REMOVABLE'); // floppy,zip
      DRIVE_FIXED     : writeln(s + ' - FIXED');
      DRIVE_REMOTE    : writeln(s + ' - NETWORK');
      DRIVE_CDROM     : writeln(s + ' - CDROM');
      DRIVE_RAMDISK   : writeln(s + ' - RAMDISK');
    end;
    inc(i); mask := mask shr 1;
  end;
end. 