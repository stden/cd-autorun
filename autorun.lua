ChangeIconBorder(false);
Jissue="I";
Jyear=2010;
ProductName="Победителю "..Jissue.." уровня КИО "..Jyear; -- для ярлыка
MainCatalogName="InJournalP-"..Jyear.."-e"..Jissue; -- каталог в который складируетя текущий выпуск
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
  if Ask("!ВНИМАНИЕ: для успешного просмотра материалов\nВам необходимо установить виртуальную java-машину - JRE 1.5!\n\nУстановить?","Нет","Да!")=="Да!" then
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
  if Ask("!ВНИМАНИЕ: для успешного просмотра материалов\nВам необходимо установить программу просмотра PDF-файлов!\n\nУстановить Foxit Reader 3.0?\n\nПрограмма Foxit Reader создана как альтернатива пакету\nAdobe Reader, по сравнению с которым имеет меньший объём,\nменьшую требовательность к ресурсам, более высокое\nбыстродействие!","Нет","Да!")=="Да!" then 
    ExecMSI("msi\\FoxitReader30.msi");
  end;
end;
--[[
function NeeddotNet()
  if RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v2.*") or RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v3.*") then 
        return;
  end
  if Ask("!ВНИМАНИЕ: для успешного просмотра материалов\nВам необходимо установить .Net Framework v 2.0 или выше.\n\nУстановить?","Нет","Да!")=="Да!" then 
    ExecMSI("msi\\NETCFSetupv2.msi");
  end;
end;

function NeedFlash()
  if RegValueExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Macromedia\\FlashPlayer\\","CurrentVersion") and RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Macromedia\\FlashPlayerActiveX") and RegKeyExists("HKEY_LOCAL_MACHINE\\SOFTWARE\\Macromedia\\FlashPlayerPlugin") then
    return;
  end
  if Ask("Для просмотра этого документа требуется установка Flash Player 9.0.\nХотите ли Вы его установить?","Нет","Да!")=="Да!" then
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
  if Ask("Для просмотра этого документа необходима установка программы просмотра таблиц Excel.\nХотите ли Вы установить русскую версию OpenOffice 3.0?","Нет","Да")=="Да" then
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
  if Ask("Для просмотра этого документа необходима установка программы просмотра интерактивных презентаций.\nХотите ли Вы установить русскую версию OpenOffice 3.0?","Нет","Да")=="Да" then
    Exec("msi\\OO_install.exe");
  end
end]]

function Install()
  text="Программа «Журнал в журнале» выпуск №"..Jissue.." "..Jyear.." года будет установлена на Ваш компьютер\n";
 text=text.."Вы сможете пользоваться программой без установочного диска\n\nЯрлык для запуска программы Вы найдете на своем Рабочем Столе\n\n";
 text=text.."Хотите продолжить?";
 if Ask(text,"Отмена","Да!")=="Да!" then 
    CopyDir(GetRunDir(), "%ProgramFiles%\\"..MainCatalogName);
    CreateIcon("%ProgramFiles%\\"..MainCatalogName.."\\autorun.exe", ShellFolder("Desktop"), ProductName, "" );
  end;
end

function unin()
text="Программа «Журнал в журнале» выпуск №"..Jissue.." "..Jyear.." года будет удалена с Вашего компьютера\n\n";
text=text.."Продолжить?";
if Ask(text,"Отмена","Продолжить")=="Продолжить" then 
     DelDir("%ProgramFiles%\\"..MainCatalogName);
     DeleteFile( ShellFolder("Desktop").."\\"..ProductName..".lnk" )
   end;
end

function Uninstall()
 if (DirExists("%ProgramFiles%\\"..MainCatalogName)==false) then Message("Программа «Журнал в журнале» выпуск №"..Jissue.." "..Jyear.." года не установлена или перемещена!")
 else 
    unin(); 
 end
end

function AboutProgram()
 text="О программе\n\n\n";
 text=text.."«ЖУРНАЛ В ЖУРНАЛЕ»\nВыпуск №"..Jissue.." - "..Jyear.." год\n\n\n";
 text=text.."Идея:              Поздняков С.Н.\n";
 text=text.."Реализация:   Пухов А.Ф.\n";
 text=text.."                        Степуленок Д.О.      \n";
 text=text.."Дизайн:          Баранов А.И.\n\n\n";
 text=text.."(c) http://ipo.spb.ru 1998-"..Jyear.."\n\n";
 Message(text);
end


-- Kонфигурационный файл, который управляет работой программы CD Autorun
SetCaption("Победителю "..Jissue.." уровня конкурса-игры КИО "..Jyear.." года")
LoadBackground("img\\back.jpg")

if (GetDriveType(GetRunDir())~="FIXED") then 
Menu{ 
  "Меню", { 
     "Установить", function() Install(); end,
     "Удалить", function() Uninstall(); end, 
     "Выход", Exit 
  }, 
  "О программе", function() AboutProgram(); end 
} 
else 
Menu{ 
  "Меню", { 
     "Выход", Exit 
  }, 
  "О программе", function() AboutProgram(); end 
} 
end

-- Общие настройки для всех "листиков": page - листик, icon - картинка внутри листика
--[[function CommonPage( r )
  -- Шрифт для всех "листиков"
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
  -- Шрифт для всех "листиков"
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
   Hint = "Запустить модуль «Многогранники, развёртки и сечения»", 
   Header = "СТЕРЕОМЕТРИЯ",
   HeaderClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   Bottom = "Программный модуль «Многогранники, развёртки и сечения»",
   IconClick = function() Exec("data\\polygon\\Polyhedrons.exe"); end, 
   BottomClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   }]]
B = CommonPage2{icon="img\\pdf.png", x=167, y=commonTop1,  
   Hint = "Запустить модуль", 
   --HeaderClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   Bottom = "Программный модуль",
   --IconClick = function() Exec("data\\polygon\\Polyhedrons.exe"); end, 
   BottomClick = function() NeedPDF(); Exec("PDF\\polygon.pdf"); end,
   }

--[[Button{ image="img\\main.bmp", action="http://ipo.spb.ru/journal", x=28, y=100 }
Button{ image="img\\main.bmp", action="http://ipo.spb.ru/journal", x=28, y=500 }]]

