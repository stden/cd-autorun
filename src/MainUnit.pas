unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Dialogs,
  jpeg, DMessageDlg, Buttons, ComCtrls, StdCtrls, XPMan, Menus, DRegistry,
  LuaBase,
  Lua, lauxlib, LuaUtils, DLua, ExtCtrls, DShowText, DNetwork, WindowsFunc,
  Controls, ShellAPI, Mask, ComObj, ActiveX, ShlObj, sSkinManager,
  sStatusBar, sCheckBox, sLabel;

type
  TAutorunForm = class(TForm)
    Background: TImage;
    StatusBar: TsStatusBar;
    XPManifest: TXPManifest;
    SkinManager: TsSkinManager;
    procedure FormCreate(Sender: TObject);
    procedure BackgroundMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure ExecLuaScript;
  public
    CurShape: TShape;
    procedure CurShapeOff;
    procedure CurShapeOn(Shape: TShape);
    procedure RegisterLuaFunctions;
    procedure GetLuaGlobalVars;
    procedure WriteToStatusBar(s: string);
    destructor Destroy; override;
  end;

  TLuaButton = class(TBitBtn)
  public
    Action: TLuaAction;
    destructor Destroy; override;
  end;

  TLuaPage = class(TShape)
    Icon: TImage;
    CheckBox: TsCheckBox;
    Leaf: TImage;
    Header, Bottom: TsLabel;
    HeaderClick, BottomClick, IconClick: TLuaAction;
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    destructor Destroy; override;
  private
  end;

var
  AutorunForm: TAutorunForm;
  LuaObjects: TList;
  ChangeIconBorder : Boolean = true;

function ClassToLuaText(Obj: TObject): string;

implementation

uses StrUtils, Utils, SelectForInstallUnit, Prepare, GraphicEx,
  PNGimage, InstallAllWizardUnit, LogUnit, Math;

{$R *.dfm}

// *  Описание "встроенных" функций, доступных из Lua-сценария
// * ==========================================================

// * Exit - Выход из программы (закрывает главную форму)
function LuaExit(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 0, 'Exit() - не должно быть входных параметров');
    Res(Result, []);
    Free;
  end;
  AutorunForm.Close();
end;

// * GenDoc( SrcFileName, DocFile ) - Собирает текстовый файл из комментариев
// *                                      в файле с исходными текстами
// *  Пример: GenDoc("src\\MainUnit.pas","help.txt")
function LuaGenDoc(L: PLua_State): Integer; cdecl;
var
  SrcFileName, DocFile, s: string;
  Doc: TextFile;
  SL: TStringList;
  i, Spaces: Integer;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 2, 'GenDoc() - должно быть 2 параметра');
    // * SrcFileName (строка) - имя Pascal-файла
    SrcFileName := PreparePath(Get(1));
    if not FileExists(SrcFileName) then
    begin
      Assert(false, 'Отсутствует файл "' + SrcFileName +
          '" - игнорирую вызов GenDoc()');
      Res(Result, []);
      Exit;
    end;
    SL := TStringList.Create;
    SL.LoadFromFile(SrcFileName);
    // * DocFile (строка) - имя выходного файла для записи документации
    DocFile := PreparePath(Get(2));
    Rewrite(Doc, DocFile);
    for i := 0 to SL.Count - 1 do
    begin
      // * Комментарии для включения в выходной файл должны начинаться с //*
      s := TrimLeft(SL[i]);
      if Copy(s, 1, 3) = '//*' then
      begin
        // * Если перед строчкой с "//*" идёт пустая строка,
        // *   то в выходной файл также добавляется пустая строка
        if i > 0 then
          if Trim(SL[i - 1]) = '' then
            Writeln(Doc);
        // * Вначале строки с комментариями могут быть пробелы - они будут перенесены в выходной файл.
        Spaces := Length(SL[i]) - Length(s);
        if Spaces > 0 then
          Write(Doc, Copy(SL[i], 1, Spaces));
        Writeln(Doc, Copy(s, 4, Length(s)));
      end;
    end;
    CloseFile(Doc);
    SL.Free;
    Res(Result, []);
    Free;
  end;
end;

// * Message( Сообщение ) - выводит на экран окно с сообщением
// *   Сообщение - строка, например "Привет!"
function LuaMessage(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'Message() - должен быть 1 параметр - сообщение');
    _MessageDlg(Get(1), mtInformation);
    Res(Result, []);
    Free;
  end;
end;

// * ChangeIconBorder( Выводить? ) - true - если нужно обводить рамку красным,
//  false - в противном случае
function LuaChangeIconBorder(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'ChangeIconBorder() - должен быть 1 параметр');
    ChangeIconBorder := Get(1);
    Res(Result, []);
    Free;
  end;
end;

// * Button{ перечисление свойств через запятую } - создаёт кнопку
// *   Пример: Button{ image="img\\Выход.bmp", action=Exit, x=700, y=200 }
function LuaButton(L: PLua_State): Integer; cdecl;
var
  Button: TLuaButton;
begin
  Button := TLuaButton.Create(AutorunForm);
  with Button, TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1,
      'Button() - должен быть 1 параметр - таблица с параметрами кнопки');
    // * x,y - координаты кнопки, x - Left, y - Top
    Left := Table('x');
    Top := Table('y');
    // * image - загрузка картинки для кнопки
    Glyph.LoadFromFile(PreparePath(Table('image')));
    Glyph.Transparent := true;
    Width := Glyph.Width + 5;
    Height := Glyph.Height + 5;
    // * action - событие при нажатии на кнопку, может быть одного из 3-х типов:
    // *  1) "встроенная" функция - из Delphi
    // *  2) функция Lua - любая функция Lua без параметров и возвращаемых значений
    // *  3) строка - строка рассматривается как ссылка и открывается программой
    // *    назначенной в ОС для этого типа файлов
    Action := TLuaAction.Create(L, 'action');
    OnClick := Action.Execute;
    if Action.OpenLink <> '' then
    begin
      Hint := Action.OpenLink;
      ShowHint := true;
    end;
    // * При нажатии на кнопку курсор становится как "рука"
    Cursor := crHandPoint;
    Visible := true;
    // * Созданная кнопка помещается на форму
    AutorunForm.InsertControl(Button);
    // * Сама функция Button{} возвращает указатель на созданную кнопку
    Res(Result, [Button]);
    // Очищаем память
    Free;
  end;
end;

// * Font{ свойства } - создание шрифта
function LuaFont(L: PLua_State): Integer; cdecl;
var
  Font: TFont;
begin
  Font := TFont.Create;
  LuaObjects.Add(Font);
  // Добавляем как компонент в форму чтобы память была корректно освобождена при закрытии формы
  with TLua.Create(L) do
  begin
    // * size - размер шрифта
    Font.size := Table('size');
    // * bold - true/false - жирный
    if Table('bold') = true then
      Font.Style := Font.Style + [fsBold];
    // * italic - true/false - наклонный
    if Table('italic') = true then
      Font.Style := Font.Style + [fsItalic];
    // * strikeout - true/false - зачёркнутый
    if Table('strikeout') = true then
      Font.Style := Font.Style + [fsStrikeout];
    // * underline - true/false - подчёркнутый
    if Table('underline') = true then
      Font.Style := Font.Style + [fsUnderline];
    // * color - (строка) цвет
    Font.Color := StringToColor(Table('color'));
    // * family - (строка) тип, например: "Times New Roman"
    Font.Name := Table('family');
    // * Возвращает Font - щрифт для Delphi
    Res(Result, [Font]);
    Free;
  end;
end;

// * Page{ параметры } - страница с описанием программы
function LuaPage(L: PLua_State): Integer; cdecl;
var
  Page: TLuaPage;
  Lua: TLua;
  PageImage, IconImage, HintStr, HeaderStr, BottomStr: string;
  IconLeft, IconTop, LabelBorderWidth: Integer;
  P: Pointer;
  LabeltoIconLayout: string;
begin
  Lua := TLua.Create(L);
  Page := TLuaPage.Create(AutorunForm);
  LuaObjects.Add(Page);

  Page.Leaf := TImage.Create(Page);
  With Page.Leaf do
  begin
    // * PageImage - картинка для "Листика" (подложки)
    PageImage := PreparePath(Lua.Table('PageImage'));
    if PageImage <> '' then
      Picture.LoadFromFile(PageImage);
    // * Размер подстраивается под размер картинки
    AutoSize := true;
    // * x - смещение листика (Left)
    Left := Lua.Table('x');
    // * y - смещение листика (Top)
    Top := Lua.Table('y');
    // * Картинка прозрачная по краям
    Transparent := true;
  end;
  AutorunForm.InsertControl(Page.Leaf);

  // * Hint - строка подсказки к Page
  HintStr := Lua.Table('Hint');

  Page.Icon := TImage.Create(Page);
  // * icon - имя файла с "иконкой"
  with Page.Icon do
  begin
    IconImage := PreparePath(Lua.Table('icon'));
    if IconImage <> '' then
      try
        Picture.LoadFromFile(IconImage);
      except
        on e: Exception do
          _MessageDlg('Не удалось загрузить файл c иконкой "' + IconImage +
              '"', mtError);
      end;
    // * Координаты иконки задаются явно
    // * IconLeft - смещение по x относительно угла "листика"
    IconLeft := Lua.Table('IconLeft');
    Left := Page.Leaf.Left + IconLeft + 2;
    // * IconTop - смещение по y относительно угла "листика"
    IconTop := Lua.Table('IconTop');
    Top := Page.Leaf.Top + IconTop + 2;
    // * IconClick - событие - нажатие по иконке/странице
    Page.IconClick := TLuaAction.Create(L, 'IconClick');
    OnClick := Page.IconClick.Execute;

    Page.Icon.Hint := HintStr;
    ShowHint := true;
    Cursor := crHandPoint; // --!!!-- указатель мыши не становится рукой
    AutoSize := true;
  end;
  AutorunForm.InsertControl(Page.Icon);

  with Page do
  begin
    if ChangeIconBorder then begin
      Pen.Width := 2;
      Pen.Color := clBlue;
    end else begin
      Page.Pen.Width := 0;
      Page.Pen.Style := psClear;
    end;
    Left := Icon.Left - Pen.Width;
    Top := Icon.Top - Pen.Width;
    Width := Icon.Width + Pen.Width * 2;
    Height := Icon.Height + Pen.Width * 2;
    Visible := true;
    OnMouseMove := ShapeMouseMove;
    Page.Hint := HintStr;
    ShowHint := true;
    OnClick := Page.IconClick.Execute;
    Brush.Style := bsClear;
  end;
  AutorunForm.InsertControl(Page);

  // * LabeltoIconLayout - положением надписи относительно иконки
  // *   bottom - описание размещается под иконкой (то, как это реализовано сейчас
  // *   top - описание находится над иконкой (то, что нужно для этого дизайна)
  // *   left - описание слева от иконки (пока не нужно, но может пригодиться в будущем)
  // *   right - описание справа от иконки (пока не нужно, но может пригодиться в будущем)
  LabeltoIconLayout := LowerCase(Lua.Table('LabeltoIconLayout'));

  // * Header - заголовок (выше картинки)
  HeaderStr := Lua.Table('Header');
  // * LabelBorderWidth - "каёмочка вокруг Label'ов"
  LabelBorderWidth := Lua.Table('LabelBorderWidth');
  if HeaderStr <> '' then
  begin
    Page.Header := TsLabel.Create(Page);

    with Page.Header do
    begin
      AutoSize := false;
      Caption := HeaderStr;

      // * HeaderClick - событие при нажатии на нижнюю надпись
      Page.HeaderClick := TLuaAction.Create(L, 'HeaderClick');
      OnClick := Page.HeaderClick.Execute;

      // * HeaderFont - шрифт заголовка
      P := TVarData(Lua.Table('HeaderFont')).VPointer;
      if P <> nil then
        Font := P;

      if Width > Page.Width then
        Width := Page.Width;

      Transparent := true;

      Alignment := taCenter;
      Layout := tlCenter;

      Left := Page.Leaf.Left + LabelBorderWidth;
      // Правило изменено по желанию Алексея Пухова 4.07.2008
      // Top := Page.Leaf.Top + LabelBorderWidth;
      Top := Page.Icon.Top - 10 - Page.Header.Height - 7;

      Width := Page.Leaf.Width - 2 * LabelBorderWidth;
      Height := Page.Icon.Top - Page.Leaf.Top;

      WordWrap := true;
      BringToFront;
    end;

    AutorunForm.InsertControl(Page.Header);
  end;

  // * Bottom - подпись внизу страницы
  BottomStr := Lua.Table('Bottom');
  if BottomStr <> '' then
  begin
    Page.Bottom := TsLabel.Create(Page);
    with Page.Bottom do
    begin
      Caption := BottomStr;
      AutoSize := false;
      Height := Page.Leaf.Height - (Page.Icon.Height) -
        (Page.Icon.Top - Page.Leaf.Top);

      P := TVarData(Lua.Table('Font')).VPointer;
      if P <> nil then
        Font := P;

      Left := Page.Leaf.Left + 7;
      Width := Page.Leaf.Width - 15;
      // Правило изменено по желанию Алексея Пухова 4.07.2008
      if (LabeltoIconLayout = 'bottom') or (LabeltoIconLayout = '')
      (* Значение не указано *) then begin
        Top := Page.Icon.Top + Page.Icon.Height + 7;
        Layout := tlTop;
        Height := Page.Leaf.Height - (Page.Icon.Height) -
          (Page.Icon.Top - Page.Leaf.Top);
      end else if LabeltoIconLayout = 'top' then begin
        Top := Page.Icon.Top + 5;
        Layout := tlTop;
        Height := Page.Leaf.Height - (Page.Icon.Height) -
          (Page.Icon.Top - Page.Leaf.Top);
      end else if LabeltoIconLayout = 'right' then begin
        // При LabeltoIconLayout = right подпись к листику
        // - находилась строго справа от черного квадратика (на небольшом расстоянии от него),
        // - находилась по середине высоты черного квадратика (т.е. vlign = center относительно черного квадратика)
        // - если ширины желтого квадрата не хватает чтобы вместить всю подпись - то тескт бы сносился на следующую строку
        // - если высоты желтого квадрата не хватает чтобы вместить весь снесенный текст, то то, что не поместилось, не будет показываться (типа значит нужно было желтый квадрат лучше рисовать)
        Layout := tlCenter;
        Alignment := taCenter;
        AutoSize := true;
        WordWrap := true;
        Width := Min(Width, Page.Leaf.Width - 50 + Page.Icon.Left - Page.Icon.Width - Page.Leaf.Left);
        Left := Page.Icon.Left + Page.Icon.Width + 10;
        Top := Page.Icon.Top + Page.Icon.Height div 2 - Height div 2;
        // Color := clRed;  Transparent := false; // Отладка
      end else if LabeltoIconLayout = 'left' then begin

      end;


      Cursor := crHandPoint;
      WordWrap := true;

      Alignment := taCenter;

      // * BottomClick - событие при нажатии на нижнюю надпись
      Page.BottomClick := TLuaAction.Create(L, 'BottomClick');
      OnClick := Page.BottomClick.Execute;
    end;
    AutorunForm.InsertControl(Page.Bottom);
  end;
  Lua.Res(Result, [Page]);
  Lua.Free;
end;

// * SetCaption( Заголовок )
function LuaSetCaption(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'SetCaption() - должен быть 1 параметр');
      // * Меняет заголовок главного окна
      AutorunForm.Caption := Get(1);
      // * Ничего не возвращает
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * Ask( Вопрос, Варианты_ответа } - окно подтверждения
// *   Пример: Message(Ask("Установить?","Да","Нет"))
function LuaAsk(L: PLua_State): Integer; cdecl;
var
  Msg, Answer: string;
  Buttons: array of string;
  N: Integer;
  i: Integer;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) >= 2, 'Ask() - должно быть >= 2 параметров');
      // * Вопрос - (строка) первый параметр функции
      Msg := Get(1);
      // * Остальные параметры (строки) - варианты ответов
      N := lua_gettop(L);
      SetLength(Buttons, N - 1);
      for i := 2 to N do
        Buttons[N - i] := Get(i);
      Answer := AskMessageDlg(Msg, mtConfirmation, Buttons, Buttons[0]);
      // * Возвращает один результат - строку - ответ пользователя
      Res(Result, [Answer]);
    finally
      Free;
    end;
  end;
end;

// * Menu( таблица меню } - создание главного меню программы
// * На вход подаётся таблица:
// *   ключи - строки-названия пунктов меню
// *   значения - выполняемые действия
function LuaMenu(L: PLua_State): Integer; cdecl;
var
  Lua: TLua;

  function CreateMenuItem(AOwner: TComponent): TMenuItem;
  var
    Index: Integer;
    Action: TLuaAction;
  begin
    Result := TMenuItem.Create(AOwner);
    // LuaShowStack(L,'До получения пункта меню');
    // * Каждый нечётный элемент таблицы - имя пункта меню
    Result.Caption := Lua.Pop;
    // LuaShowStack(L,'После получения имени пункта меню');
    // * Дальше обязательно должна быть функция или подтаблица = подменю
    Lua.Assert(lua_next(L, Index) <> 0,
      'После названия пункта меню должна идти функция или подменю (в виде таблицы)');
    // LuaShowStack(L,'До получения функции');
    Index := LuaAbsIndex(L, -1);
    // При нажатии:
    if lua_istable(L, -1) then
    begin // Подменю
      lua_pushnil(L);
      while (lua_next(L, Index) <> 0) do
        Result.Add(CreateMenuItem(Result));
      lua_pop(L, 1);
    end
    else
    begin // Действие
      Action := TLuaAction.Create(L);
      LuaObjects.Add(Action);
      Result.OnClick := Action.Execute;
    end;
    // LuaShowStack(L,'После получения функции');
  end;

var
  M: TMainMenu;
  Index: Integer;
begin
  Lua := TLua.Create(L);
  M := TMainMenu.Create(AutorunForm);
  Index := LuaAbsIndex(L, 1);
  // * Функция оббегает всю переданную ей таблицу.
  lua_pushnil(L);
  while lua_next(L, Index) <> 0 do
    M.Items.Add(CreateMenuItem(M));
  AutorunForm.Menu := M;
  // * Ничего не возвращает, заменяет главное меню
  Lua.Res(Result, []);
  Lua.Free;
end;

// * LoadBackground( имя_файла_с_картинкой ) - заменяет фон
function LuaLoadBackground(L: PLua_State): Integer; cdecl;
var
  FileName: string;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1,
      'У функции LoadBackground должен быть один параметр - имя файла с картинкой');
    try
      FileName := PreparePath(Get(1));
      with AutorunForm.Background do
      begin
        Picture.LoadFromFile(FileName);
        AutorunForm.Background.Left := 0;
        Top := 0;
      end;
      with AutorunForm do
      begin
        ClientHeight := Background.Height + StatusBar.Height;
        ClientWidth := Background.Width;
      end;
    except
      on e: EFOpenError do
        Assert(false, 'Невозможно открыть файл "' + FileName +
            '" проверьте правильность указания имени файла и наличие самого файла');
      on e: Exception do
        Assert(false, e.ClassType.ClassName + ': ' + e.Message);
    end;
    // * Ничего не возвращает
    Res(Result, []);
    // Очищаем память
    Free;
  end;
end;

// * GetRunDir() - возвращает строку - путь запуска программы cd-autorun
function LuaGetRunDir(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 0, 'Функция GetRunDir() без параметров');
    Res(Result, [GetRunDir]);
    Free;
  end;
end;

// * ShellFolder( имя_каталога ) - возвращает путь к специальной папке
// *  Возможные имена каталогов:
// *   "Desktop" - рабочий стол текущего пользователя
// *   "Personal" - "Мои документы" текущего пользователя
// *   "Start Menu" - "Главное меню"
// *   "Programs" - "Главное меню\Программы"
// *   "Startup" - "Главное меню\Программы\Автозагрузка"
// *   "Fonts" - Системные шрифты
function LuaShellFolder(L: PLua_State): Integer; cdecl;
var
  FolderName: string;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'ShellFolder() - ожидается 1 параметр');
    FolderName := Get(1);
    Res(Result, [RegGetValue(
        'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', FolderName)]);
    Free;
  end;
end;

// * CreateIcon(    - создать ярлык
// *   “%ProgramFiles%\cd-autorun\autorun.exe” - Имя файла/каталога на который будет указывать ярлык
// *   LinkDir,     - Имя каталога, где создать ярлык
// *   LinkName,    - Имя ярлыка
// *   Arguments )  - Параметры запуска программы
// * В путях можно применять переменные окружения:
// *   %ProgramFiles% -> C:\Program Files
// *   %AllUsersProfile% -> C:\Documents and Settings\All Users
// *   %APPDATA%
// *   %CommonProgramFiles%
// *   %HOMEDRIVE%
// *   %HOMEPATH%
// *   %ProgramFiles%
// *   %SystemDrive%
// *   %SystemRoot%
// *   %USERNAME%
// *   %USERPROFILE%
// * Пример:
// *   CreateIcon( GetRunDir(), ShellFolder("Desktop"), "Каталог с Autorun", "" )
// *     создание ярлыка на рабочем столе текущего пользователя для каталога запуска Autorun

// Перевод из стандартной строки Delphi в Unicode-строку для WinAPI
function Str2Wide(lpStr: String): PWideChar;
var
  dwStrlen: Cardinal;
begin
  dwStrlen := lstrlen(PChar(lpStr));
  GetMem(Result, (dwStrlen + 1) * 2);
  StringToWideChar(lpStr, Result, dwStrlen + 1);
end;

// * Создание ярлыка на рабочем столе
procedure CreateLink(FileOrDirName: String; // Имя файла на который будет указывать ярлык
  LinkDir: String; // Имя каталога, где создать ярлык
  LinkName: String; // Имя ярлыка
  Arguments: String = '' // Аргументы запуска программы
  );
var
  MyObject: IUnknown;
  MyIcon: IShellLink;
  MyPFile: IPersistFile;
  LinkFileName: String;
  TempLinkFileName: String;
  PP: PWideChar;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MyIcon := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MyIcon do
  begin
    SetPath(PChar(FileOrDirName)); // Путь к запускаемому файлу
    SetArguments(PChar(Arguments)); // Аргументы запуска программы
    SetWorkingDirectory(PChar(ExtractFilePath(FileOrDirName)));
    // Рабочий каталог
  end;
  LinkFileName := LinkDir + '\' + LinkName + '.lnk';
  // Даже если ярлык есть - лучше его пересоздать - вдруг он ссылается не туда
  if FileExists(LinkFileName) then
  begin
    // Log('Ярлык "'+LinkFileName+'" уже есть! Пропускаю создание!');
    // exit;
    DeleteFile(LinkFileName);
  end;
  // Следующая строка почему-то не работает под WindowsXP English + MUI (русификация)
  // Такое ощущение, что иконка создаётся в неправильной кодировке.
  // MyPFile.Save( Str2Wide(LinkFileName), False); !!!
  // В результате пользуюсь пока таким "извратом" ("грязный хак"):
  // 1. Создаём временную иконку
  TempLinkFileName := LinkDir + '\!TempLink!.lnk';
  PP := Str2Wide(TempLinkFileName);
  MyPFile.Save(PP, false);
  FreeMem(PP);
  // 2. Переименовываем её правильно
  RenameFile(TempLinkFileName, LinkFileName);
  if FileExists(TempLinkFileName) then
    DeleteFile(TempLinkFileName);
  // Проверяем, что ярлык действительно есть
  // Writeln('Создан ярлык "'+LinkFileName+'"');
end;

// * Создание иконки на рабочем столе
function LuaCreateIcon(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 4, 'CreateIcon() - ожидается 4 параметра');
    CreateLink(PreparePath(Get(1)), PreparePath(Get(2)), Get(3), Get(4));
    Res(Result, []);
    Free;
  end;
end;

// * ChangeWallpaper( имя_файла ) - смена обоев на рабочем столе
function LuaChangeWallpaper(L: PLua_State): Integer; cdecl;
const
  CLSID_ActiveDesktop: TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';
var
  ActiveDesktop: IActiveDesktop;
  FileName: string;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'ChangeWallpaper() - ожидается 1 параметр');
    FileName := PreparePath(Get(1));
    Res(Result, []);
    Free;
  end;
  ActiveDesktop := CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;
  ActiveDesktop.SetWallpaper(PWideChar(FileName), 0);
  ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
end;

// * DirExists( имя_каталога )
function LuaDirExists(L: PLua_State): Integer; cdecl;
var
  DirName: string;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'Один параметр - имя каталога');
    DirName := PreparePath(Get(1));
    // * Возвращает одно значение - есть ли каталог
    Res(Result, [SysUtils.DirectoryExists(DirName)]);
    Free;
  end;
end;

// * FontDialog( [шрифт_для_модификации] )
// * Показывает диалог выбора шрифта
function LuaFontDialog(L: PLua_State): Integer; cdecl;
var
  FontDialog: TFontDialog;
  Font: TFont;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) in [0, 1],
      'Функцию FontDialog можно вызывать с одним параметром или без параметров.'
      );
    // * Можно передать необязательный параметр - шрифт для модификации
    // * Создать его можно с помощью процедуры Font
    FontDialog := TFontDialog.Create(AutorunForm);
    // * Если передан 1 параметр - шрифт, то он устанавливается начальным для диалога
    if lua_gettop(L) = 1 then
    begin
      Font := TFont(lua_touserdata(L, 1));
      FontDialog.Font.Assign(Font);
    end
    else
      Font := TFont.Create;
    if FontDialog.Execute then
    begin
      Font.Assign(FontDialog.Font);
    end;
    FontDialog.Free;
    // * Возвращает выбранный в диалоге шрифт
    Res(Result, [Font]);
    Free;
  end;
end;

// * Env( имя_переменной_окружения ) - получить значение переменной окружения
function LuaEnv(L: PLua_State): Integer; cdecl;
var
  EnvVarName: string;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'Env() - ожидается один параметр');
    EnvVarName := Pop;
    Res(Result, [GetEnvironmentVariable(EnvVarName)]);
    Free;
  end;
end;

// * RegKeyExists( имя_ключа ) - присутствует ли ключ в реестре
function LuaRegKeyExists(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) = 1, 'RegKeyExists() - ожидается один параметр');
    Res(Result, [RegKeyExists(Get(1))]);
    Free;
  end;
end;

// * RegValueExists( имя_ключа, имя_значения ) - присутствует ли значение в реестре
function LuaRegValueExists(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 2, 'RegValueExists() - ожидается 2 параметра');
      Res(Result, [RegValueExists(Get(1), Get(2))]);
    finally
      Free;
    end;
  end;
end;

// * RegGetValue( имя_ключа, имя_значения ) - получение значения из реестра
// *   Пример:
// *     Message("HKEY_CLASSES_ROOT\\.pdf - Content Type = "..RegGetValue("HKEY_CLASSES_ROOT\\.pdf","Content Type"))
function LuaRegGetValue(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 2, 'RegGetValue() - ожидается 2 параметра');
      Res(Result, [RegGetValue(Get(1), Get(2))]);
    finally
      Free;
    end;
  end;
end;

// * RegGetValue( имя_ключа, имя_значения, значение ) - получение значения из реестра
function LuaRegSetValue(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 3, 'RegSetValue() - ожидается 3 параметра');
      RegSetValue(Get(1), Get(2), Get(3));
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

const
  BoolToStr: array [false .. true] of string = ('false', 'true');

function ClassToLuaText(Obj: TObject): string;
var
  F: TFont;
begin
  if Obj is TFont then
  begin
    F := TFont(Obj);
    Result := 'Font{ size=' + IntToStr(F.size)
      + ',' + ' family="' + F.Name + '",' + ' bold=' + BoolToStr
      [fsBold in F.Style] + ',' + ' italic=' + BoolToStr[fsItalic in F.Style]
      + ',' + ' strikeout=' + BoolToStr[fsStrikeout in F.Style]
      + ',' + ' underline=' + BoolToStr[fsUnderline in F.Style]
      + ',' + ' color="' + ColorToString(F.Color) + '" }';
  end;
end;

// * ShowText( текст или объект ) - показывает текст в
// *   отдельном окне с возможностью копирования
// *   Функция нужна для автоматизации разработки Lua-скрипта
function LuaShowText(L: PLua_State): Integer; cdecl;
var
  F: TShowTextForm;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'LuaGenText() - ожидается 1 параметр');
      F := TShowTextForm.Create(AutorunForm);
      if lua_type(L, 1) = LUA_TUSERDATA then
        F.Config.Text := ClassToLuaText(PopClass)
      else
        F.Config.Text := VarToStr(Pop);
      F.ShowModal;
      F.Free;
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * NetUse( имя_диска, сетевой_путь ) - подключение сетевого диска
function LuaNetUse(L: PLua_State): Integer; cdecl;
var
  NetDrive, NetPath, Cur: String;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 2, 'NetUse() - ожидается 2 параметра');
      NetDrive := Get(1);
      NetPath := Get(2);
      Assert(Length(NetDrive) = 1,
        'NetUse - первый параметр - имя диска - одна буква');
      // * Получает путь сейчас ассоциированный с данной буквой
      Cur := NetGetConnection(NetDrive[1]);
      Writeln('Диск "' + NetDrive + '" подключен к: "' + Cur + '"');
      // * Если он не соответствует тому, что должно быть, то
      if Trim(Cur) <> Trim(NetPath) then
      begin
        Writeln('А должен быть подключен к: "' + NetPath + '"');
        // * - отключаем текущий сетевой путь
        Writeln('Отключаю: ' + NetCancelConnection(NetDrive[1]));
        // * - подключаем новый сетевой путь
        Writeln('Подключаю: ' + NetAddConnection(NetDrive[1], NetPath));
      end;
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * CopyDir( fromDir, toDir ) - скопировать дерево каталогов
// *   fromDir - откуда копировать
// *   toDir - в какой каталог копировать
// *   Пример - программа копирует сама себя на жёсткий диск:
// *     CopyDir( GetRunDir(), “%ProgramFiles%\cd-autorun” )
function LuaCopyDir(L: PLua_State): Integer; cdecl;
var
  fromDir, toDir: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 2, 'CopyDir() - ожидается 2 параметра');
      fromDir := PreparePath(Get(1));
      toDir := PreparePath(Get(2));
      Res(Result, [false]);
      Assert(DirectoryExists(fromDir),
        'Каталог не существует "' + fromDir + '"');
      Assert(CopyDir(fromDir, toDir),
        'Не удалось скопировать каталог. CopyDir("' + fromDir + '","' + toDir +
          '"');
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * MoveDir( fromDir, toDir ) - перемещение каталога
// *   fromDir - откуда копировать
// *   toDir - в какой каталог копировать
function LuaMoveDir(L: PLua_State): Integer; cdecl;
var
  fromDir, toDir: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 2, 'MoveDir() - ожидается 2 параметра');
      fromDir := PreparePath(Get(1));
      toDir := PreparePath(Get(2));
      Res(Result, []);
      Assert(DirectoryExists(fromDir),
        'Каталог не существует "' + fromDir + '"');
      Assert(MoveDir(fromDir, toDir),
        'MoveDir("' + fromDir + '","' + toDir + '"');
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * DelDir( DirName ) - удаление каталога (дерева каталогов)
// *   DirName - какой каталог удалять
function LuaDelDir(L: PLua_State): Integer; cdecl;
var
  DirName: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'DelDir() - ожидается 1 параметр');
      DirName := PreparePath(Get(1));
      Res(Result, []);
      Assert(DirectoryExists(DirName),
        'Каталог не существует "' + DirName + '"');
      Res(Result, [DelDir(DirName)]);
    finally
      Free;
    end;
  end;
end;

// * Exec( FileName [, Params] ) - запуск файла без ожидания завершения
// *   FileName - имя исполняемого файла
// *   Params (необязательный 2-ой параметр) - параметры вызова
function LuaExec(L: PLua_State): Integer; cdecl;
var
  FileName, Params: string;
begin
  with TLua.Create(L) do
  begin
    Assert(lua_gettop(L) in [1 .. 2], 'Exec() - ожидается 1-2 параметра');
    FileName := PreparePath(Get(1));
    if lua_gettop(L) = 2 then
      Params := Get(2)
    else
      Params := '';
    Res(Result, []);
    try
      LogForm.Events.Items.Add('Запуск программы "' + FileName + '"');
      Execute(FileName, Params);
    except
      // on E : Exception do Assert( false, E.Message + ' "'+FileName+'"' );
    end;
    Free;
  end;
end;

// * ExecWait( FileName [, Params] ) - запуск файла и ожидание его завершения
// *   FileName - имя исполняемого файла
// *   Params (необязательный 2-ой параметр) - параметры вызова
function LuaExecWait(L: PLua_State): Integer; cdecl;
var
  FileName, Params: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) in [1 .. 2], 'Exec() - ожидается 1-2 параметра');
      FileName := PreparePath(Get(1));
      if lua_gettop(L) = 2 then
        Params := Get(2)
      else
        Params := '';
      Res(Result, []);
      try
        ExecuteAndWait(FileName, Params);
      except
        on e: Exception do
          _MessageDlg(e.Message + ' "' + FileName + '"', mtError);
      end;
    finally
      Free;
    end;
  end;
end;

// * ExecMSI( MSI_FileName ) - запуск MSI-файла (файла инсталлятора в формате Microsoft)
function LuaExecMSI(L: PLua_State): Integer; cdecl;
var
  MSI_FileName: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'ExecMSI() - ожидается 1 параметр');
      MSI_FileName := PreparePath(Get(1));
      Res(Result, []);
      // * Ожидается завершение файла
      ExecuteAndWait('msiexec.exe', '/i ' + MSI_FileName);
    finally
      Free;
    end;
  end;
end;

// * DeleteFile( FileName ) - удалить файл
// *  Возвращает true - если файл удалён успешно и false в противном случае.
function LuaDeleteFile(L: PLua_State): Integer; cdecl;
var
  FileName: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'DeleteFile() - ожидается 1 параметр');
      FileName := Get(1);
      LogUnit.LogForm.Events.Items.Add('Удаление файла "' + FileName + '" - ');
      Res(Result, [DeleteFile(FileName)]);
    finally
      Free;
    end;
  end;
end;

// * GetDriveType( Путь ) - возвращает тип диска (строку)
// * Возможные возвращаемые значения
// *   UNKNOWN - неизвестно
// *   NOT_EXIST - не существует
// *   REMOVABLE - дисковод, флешка
// *   FIXED - жёсткий диск
// *   NETWORK - сетевой диск
// *   CDROM - CD/DVD ROM
// *   RAMDISK - RAMDISK
function LuaGetDriveType(L: PLua_State): Integer; cdecl;
var
  Path, T: string;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'GetDriveType() - ожидается 1 параметр');
      Path := Copy(PreparePath(Get(1)), 1, 3);
      Case GetDriveType(PChar(Path)) of
        0:
          T := 'UNKNOWN';
        1:
          T := 'NOTEXIST';
        DRIVE_REMOVABLE:
          T := 'REMOVABLE';
        DRIVE_FIXED:
          T := 'FIXED';
        DRIVE_REMOTE:
          T := 'NETWORK';
        DRIVE_CDROM:
          T := 'CDROM';
        DRIVE_RAMDISK:
          T := 'RAMDISK';
      end;
      Res(Result, [T]);
    finally
      Free;
    end;
  end;
end;

// * LoadIcon( файл_с_иконкой ) - загрузка иконки
// *   Используется: Application.Icon.LoadFromFile('icon.ico');
function LuaLoadIcon(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 1, 'LoadIcon() - ожидается 1 параметр');
      Application.Icon.LoadFromFile(Get(1));
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * LoadSkin( путь_к_каталогу, файл_с_темой_оформления ) - загрузка иконки
function LuaLoadSkin(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    try
      Assert(lua_gettop(L) = 2, 'LoadSkin() - ожидается 2 параметра');
      AutorunForm.SkinManager.SkinDirectory := Get(1);
      AutorunForm.SkinManager.SkinName := Get(2);
      AutorunForm.SkinManager.Active := true;
      Res(Result, []);
    finally
      Free;
    end;
  end;
end;

// * InstallWizard( необходимые_для_установки_компоненты ) - вызов мастера установки
// *   Пример: InstallWizard(Flash, Java, PDF)
// *
function LuaInstallWizard(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    (* Assert( lua_gettop(L) = 1, 'GetDriveType() - ожидается 1 параметр' );
      Path := Copy( PreparePath(Get(1)), 1, 3 );
      Case GetDriveType(PChar(Path)) of
      0               : T := 'UNKNOWN';
      1               : T := 'NOTEXIST';
      DRIVE_REMOVABLE : T := 'REMOVABLE';
      DRIVE_FIXED     : T := 'FIXED';
      DRIVE_REMOTE    : T := 'NETWORK';
      DRIVE_CDROM     : T := 'CDROM';
      DRIVE_RAMDISK   : T := 'RAMDISK';
      end;
      Res( Result, [T] ); *)
    Free;
  end;
end;

// * InstallAllWizard() - вызов мастера установки Журнала в Журнале
// *   Пример: InstallAllWizard()
// *   При выводе окон мастера используются глобальные переменные
// *
function LuaInstallAllWizard(L: PLua_State): Integer; cdecl;
begin
  with TLua.Create(L) do
  begin
    InstallAllWizardForm.Caption := GLua.GetGlobal('WizardCaption');
    InstallAllWizardForm.WelcomeText.Caption := GLua.GetGlobal('WelcomeText');
    InstallAllWizardForm.ShowModal;
    (* Assert( lua_gettop(L) = 1, 'GetDriveType() - ожидается 1 параметр' );
      Path := Copy( PreparePath(Get(1)), 1, 3 );
      Case GetDriveType(PChar(Path)) of
      0               : T := 'UNKNOWN';
      1               : T := 'NOTEXIST';
      DRIVE_REMOVABLE : T := 'REMOVABLE';
      DRIVE_FIXED     : T := 'FIXED';
      DRIVE_REMOTE    : T := 'NETWORK';
      DRIVE_CDROM     : T := 'CDROM';
      DRIVE_RAMDISK   : T := 'RAMDISK';
      end; *)
    Res(Result, []);
    Free;
  end;
end;

// * Порядок выполнения конфигурационного файла написанного на Lua:
procedure TAutorunForm.ExecLuaScript;
begin
  // * 1. Регистрация Lua-функций в хост-программе
  RegisterLuaFunctions;
  // * 2. Выполнение скрипта "autorun.lua"
  try
    GLua.DoFile('autorun.lua');
  except
    on e: ELuaException do
    begin
      _MessageDlg(e.Message, mtError);
      Application.Terminate;
    end;
  end;
  // * 3. Получение значений глобальных переменных (для "мастеров" установки)
  GetLuaGlobalVars;
  // * 4. Реакция на события (запуск программ, выбор в меню и т.д.)
end;

// Процедура, которая вызывается при создании главной формы
// Обработчик события "открытие формы"
// она выполняется автоматически при создании формы AutorunForm
procedure TAutorunForm.FormCreate(Sender: TObject);
begin
  LuaObjects := TList.Create;
  StatusBar.SimplePanel := true;
  CurShape := nil;
  // Запуск основной Lua-программы
  ExecLuaScript;
end;

procedure TAutorunForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = Ord('L')) then
    LogForm.Show;
end;

var
  WelcomeText: string;
  WizardLog: string;

  // *  Глобальные переменные autorun.lua
  // * ===================================
procedure TAutorunForm.GetLuaGlobalVars;
begin
  // * WelcomeText="Вас приветствует ..."
  WelcomeText := GLua.GetGlobal('WelcomeText');
  // * CheckSystemTitle="Проверка системы"
  // * CheckSystemText="Обнаружилось..."
  // * CheckSystemFinish="Система Готова"
  // * ChooseCatalogTitle=""
  // * ChooseCatalogText=""
  // * GoodByeText=""
  // * WizardLog - файл с картинкой в левом углу первого и последнего окна Wizard'а
  WizardLog := GLua.GetGlobal('WizardLog');
end;

procedure TAutorunForm.CurShapeOff;
begin
  if CurShape <> nil then
  begin
    if ChangeIconBorder then
      CurShape.Pen.Color := clBlue
    else
      CurShape.Pen.Width := 0;
    CurShape := nil;
  end;
end;

procedure TAutorunForm.CurShapeOn(Shape: TShape);
begin
  if CurShape <> nil then
    CurShapeOff;
  Assert(CurShape = nil,
    'Выбранным одновременно может быть только один обьект TShape');
  CurShape := Shape;
  if ChangeIconBorder then
    CurShape.Pen.Color := clRed
  else
    CurShape.Pen.Width := 0;
end;

destructor TAutorunForm.Destroy;
var
  Obj: Pointer;
begin
  for Obj in LuaObjects do
    TObject(Obj).Free;
  LuaObjects.Free;
  inherited;
end;

procedure TAutorunForm.RegisterLuaFunctions;
begin
  GLua.RegFunction('GenDoc', LuaGenDoc);
  GLua.RegFunction('Button', LuaButton);
  GLua.RegFunction('Font', LuaFont);
  GLua.RegFunction('Page', LuaPage);
  GLua.RegFunction('LoadBackground', LuaLoadBackground);
  GLua.RegFunction('SetCaption', LuaSetCaption);
  GLua.RegFunction('ChangeIconBorder', LuaChangeIconBorder);
  GLua.RegFunction('Exit', LuaExit);
  GLua.RegFunction('Message', LuaMessage);
  GLua.RegFunction('ShowMessage', LuaMessage);
  GLua.RegFunction('Show', LuaMessage);
  GLua.RegFunction('Ask', LuaAsk);
  GLua.RegFunction('Menu', LuaMenu);
  GLua.RegFunction('Env', LuaEnv);
  GLua.RegFunction('FontDialog', LuaFontDialog);
  GLua.RegFunction('DirExists', LuaDirExists);
  GLua.RegFunction('GetRunDir', LuaGetRunDir);
  GLua.RegFunction('RegKeyExists', LuaRegKeyExists);
  GLua.RegFunction('RegValueExists', LuaRegValueExists);
  GLua.RegFunction('RegGetValue', LuaRegGetValue);
  GLua.RegFunction('RegSetValue', LuaRegSetValue);
  GLua.RegFunction('ShowText', LuaShowText);
  GLua.RegFunction('NetUse', LuaNetUse);
  GLua.RegFunction('CopyDir', LuaCopyDir);
  GLua.RegFunction('MoveDir', LuaMoveDir);
  GLua.RegFunction('DelDir', LuaDelDir);
  GLua.RegFunction('Exec', LuaExec);
  GLua.RegFunction('ExecWait', LuaExecWait);
  GLua.RegFunction('ExecMSI', LuaExecMSI);
  GLua.RegFunction('ShellFolder', LuaShellFolder);
  GLua.RegFunction('CreateIcon', LuaCreateIcon);
  GLua.RegFunction('DeleteFile', LuaDeleteFile);
  GLua.RegFunction('ChangeWallpaper', LuaChangeWallpaper);
  GLua.RegFunction('GetDriveType', LuaGetDriveType);
  GLua.RegFunction('InstallWizard', LuaInstallWizard);
  GLua.RegFunction('InstallAllWizard', LuaInstallAllWizard);
  GLua.RegFunction('LoadIcon', LuaLoadIcon);
  GLua.RegFunction('LoadSkin', LuaLoadSkin);
end;

destructor TLuaPage.Destroy;
begin
  if HeaderClick <> nil then
    HeaderClick.Free;
  if BottomClick <> nil then
    BottomClick.Free;
  if IconClick <> nil then
    IconClick.Free;
  inherited;
end;

procedure TLuaPage.ShapeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Shape: TShape;
begin
  Shape := nil;
  if Sender is TShape then
    Shape := Sender As TShape;
  if Sender is TImage then
    Shape := ((Sender As TImage).Owner) As TShape;
  if AutorunForm.CurShape <> Shape then
    AutorunForm.CurShapeOn(Shape);
end;

procedure TAutorunForm.BackgroundMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  CurShapeOff;
end;

procedure TAutorunForm.WriteToStatusBar(s: string);
begin
  StatusBar.SimpleText := s;
end;

{ TLuaButton }

destructor TLuaButton.Destroy;
begin
  Action.Free;
  inherited;
end;

end.
