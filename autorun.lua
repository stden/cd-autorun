ChangeIconBorder(false);
Jissue="I";
Jyear=2010;
ProductName="���������� "..Jissue.." ������ ��� "..Jyear; -- ��� ������
MainCatalogName="InJournalP-"..Jyear.."-e"..Jissue; -- ������� � ������� ����������� ������� ������
--GenDoc("src\\MainUnit.pas","help.txt")
assert( GetDriveType("%ProgramFiles%") == "FIXED" );
assert( DirExists("%ProgramFiles%") );
assert( true );
assert( not DirExists("C:\\%ProgramFiles%\\not!") );
assert( RegKeyExists("HKEY_LOCAL_MACHINE") );

function NeedJava()
  if DirExists("%ProgramFiles%\\Java") and RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Internet Explorer\\AdvancedOptions\\JAVA_SUN")  then 
    return;
  end;
  if Ask("!��������: ��� ��������� ��������� ����������\n��� ���������� ���������� ����������� java-������ - JRE 1.5!\n\n����������?","���","��!")=="��!" then
    ExecMSI("msi\\J2SE_Runtime_Environmen_5-0.msi");
  end
end

function NeedPDF()
  if RegValueExists("HKEY_CLASSES_ROOT\\.pdf","") then 
    WhatInstalled = (RegGetValue("HKEY_CLASSES_ROOT\\.pdf",""));
  end;
  if (WhatInstalled=="AcroExch.Document") or (WhatInstalled=="FoxitReader.Document") or (WhatInstalled=="PDF Document Type") then 
    return;
  end
  if Ask("!��������: ��� ��������� ��������� ����������\n��� ���������� ���������� ��������� ��������� PDF-������!\n\n���������� Foxit Reader 3.0?\n\n��������� Foxit Reader ������� ��� ������������ ������\nAdobe Reader, �� ��������� � ������� ����� ������� �����,\n������� ���������������� � ��������, ����� �������\n��������������!","���","��!")=="��!" then 
    ExecMSI("msi\\FoxitReader30.msi");
  end;
end;
--[[
function NeeddotNet()
  if RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v2.*") or RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v3.*") then 
        return;
  end
  if Ask("!��������: ��� ��������� ��������� ����������\n��� ���������� ���������� .Net Framework v 2.0 ��� ����.\n\n����������?","���","��!")=="��!" then 
    ExecMSI("msi\\NETCFSetupv2.msi");
  end;
end;

function NeedFlash()
  if RegValueExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Macromedia\\FlashPlayer\\","CurrentVersion") and RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Macromedia\\FlashPlayerActiveX") and RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Macromedia\\FlashPlayerPlugin") then
    return;
  end
  if Ask("��� ��������� ����� ��������� ��������� ��������� Flash Player 9.0.\n������ �� �� ��� ����������?","���","��!")=="��!" then
    ExecMSI("msi\\flashplayer_ax.msi");
    ExecMSI("msi\\flash_player_Plugin.msi");
  end
end]]

--[[
function NeedExcel()
  if RegValueExists("HKEY_CLASSES_ROOT\\.xls","") then 
    WhatInstalled = (RegGetValue("HKEY_CLASSES_ROOT\\.xls",""));
  end;
  if (WhatInstalled=="OpenOffice.org.Xls") or (WhatInstalled=="Excel.Sheet.8") then
    return;
  end;
  if Ask("��� ��������� ����� ��������� ���������� ��������� ��������� ��������� ������ Excel.\n������ �� �� ���������� ������� ������ OpenOffice 3.0?","���","��")=="��" then
    Exec("msi\\OO_install.exe");
  end
end

function NeedPowerPoint()
  if RegValueExists("HKEY_CLASSES_ROOT\\.ppt","") then 
    WhatInstalled = (RegGetValue("HKEY_CLASSES_ROOT\\.ppt",""));
  end;
  if (WhatInstalled=="OpenOffice.org.Ppt") or (WhatInstalled=="PowerPoint.Show.8") then
    return;
  end;
  if Ask("��� ��������� ����� ��������� ���������� ��������� ��������� ��������� ������������� �����������.\n������ �� �� ���������� ������� ������ OpenOffice 3.0?","���","��")=="��" then
    Exec("msi\\OO_install.exe");
  end
end]]

function Install()
  text="��������� ������� � ������� ������ �"..Jissue.." "..Jyear.." ���� ����� ����������� �� ��� ���������\n";
 text=text.."�� ������� ������������ ���������� ��� ������������� �����\n\n����� ��� ������� ��������� �� ������� �� ����� ������� �����\n\n";
 text=text.."������ ����������?";
 if Ask(text,"������","��!")=="��!" then 
    CopyDir(GetRunDir(), "%ProgramFiles%\\"..MainCatalogName);
    CreateIcon("%ProgramFiles%\\"..MainCatalogName.."\\autorun.exe", ShellFolder("Desktop"), ProductName, "" );
  end;
end

function unin()
text="��������� ������� � ������� ������ �"..Jissue.." "..Jyear.." ���� ����� ������� � ������ ����������\n\n";
text=text.."����������?";
if Ask(text,"������","����������")=="����������" then 
     DelDir("%ProgramFiles%\\"..MainCatalogName);
     DeleteFile( ShellFolder("Desktop").."\\"..ProductName..".lnk" )
   end;
end

function Uninstall()
 if (DirExists("%ProgramFiles%\\"..MainCatalogName)==false) then Message("��������� ������� � ������� ������ �"..Jissue.." "..Jyear.." ���� �� ����������� ��� ����������!")
 else 
    unin(); 
 end
end

function AboutProgram()
 text="� ���������\n\n\n";
 text=text.."������� � ������Ż\n������ �"..Jissue.." - "..Jyear.." ���\n\n\n";
 text=text.."����:              ��������� �.�.\n";
 text=text.."����������:   ����� �.�.\n";
 text=text.."                        ���������� �.�.      \n";
 text=text.."������:          ������� �.�.\n\n\n";
 text=text.."(c) http://ipo.spb.ru 1998-"..Jyear.."\n\n";
 Message(text);
end


-- K��������������� ����, ������� ��������� ������� ��������� CD Autorun
SetCaption("���������� "..Jissue.." ������ ��������-���� ��� "..Jyear.." ����")
LoadBackground("img\\back.jpg")

if (GetDriveType(GetRunDir())~="FIXED") then 
Menu{ 
  "����", { 
     "����������", function() Install(); end,
     "�������", function() Uninstall(); end, 
     "�����", Exit 
  }, 
  "� ���������", function() AboutProgram(); end 
} 
else 
Menu{ 
  "����", { 
     "�����", Exit 
  }, 
  "� ���������", function() AboutProgram(); end 
} 
end

-- ����� ��������� ��� ���� "��������": page - ������, icon - �������� ������ �������
--[[function CommonPage( r )
  -- ����� ��� ���� "��������"
  FHeader = Font{ size=10, family="Tahoma", bold=true, italic=false, strikeout=false, underline=false, color="clBlack" }
  F = Font{ size=10, family="Tahoma", bold=false, italic=false, strikeout=false, underline=false, color="clBlack" }
  T = { PageImage="img\\blank.png",
        IconLeft=19, IconTop=36,
        LabelBorderWidth=1, 
        HeaderFont = FHeader,
        Font = F,
        LabeltoIconLayout = "bottom"}  
  for k,v in pairs(r) do
    T[k] = v
  end
  return Page(T)
end]]

function CommonPage2( r )
  -- ����� ��� ���� "��������"
  --FHeader = Font{ size=10, family="Tahoma", bold=true, italic=false, strikeout=false, underline=false, color="clBlack" }
  F = Font{ size=9, family="Tahoma", bold=false, italic=false, strikeout=false, underline=false, color="clBlack" }
  T = { PageImage="img\\blank2.png",
        IconLeft=10, IconTop=5,
        LabelBorderWidth=0,
        --HeaderFont = FHeader,
        Font = F,
        LabeltoIconLayout = "right"}  
  for k,v in pairs(r) do
    T[k] = v
  end
  return Page(T)
end

commonTop1=236;
--[[A = CommonPage{ icon="img\\polygon.jpg", x=0, y=commonTop1,  
   Hint = "��������� ������ ��������������, �������� � ��������", 
   Header = "������������",
   HeaderClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   Bottom = "����������� ������ ��������������, �������� � ��������",
   IconClick = function() Exec("data\\polygon\\Polyhedrons.exe"); end, 
   BottomClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   }]]
B = CommonPage2{icon="img\\pdf.png", x=167, y=commonTop1,  
   Hint = "��������� ������", 
   --HeaderClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   Bottom = "����������� ������",
   --IconClick = function() Exec("data\\polygon\\Polyhedrons.exe"); end, 
   BottomClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   }

--[[Button{ image="img\\main.bmp", action="http://ipo.spb.ru/journal", x=28, y=100 }
Button{ image="img\\main.bmp", action="http://ipo.spb.ru/journal", x=28, y=500 }]]

