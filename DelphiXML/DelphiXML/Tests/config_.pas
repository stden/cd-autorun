// Модуль сгенерирован 03.05.2007 21:44:25 программой DelphiXML, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// По всем вопросам обращайтесь к Денису Степулёнку +79117117850 (super.denis@gmail.com)
{
  config(Config):None Структура
    mainFormCaption(MainFormCaption):String ПростойТип
    Button(Button):None Структура Повторяется
      image(Image):String
      open(Open):String
      x(X):UnsignedShort
      y(Y):UnsignedByte
      action(Action):String
    backGround(BackGround):None Структура
      filename(Filename):String
    AllPages(AllPages):None Структура
      pageWidth(PageWidth):UnsignedByte
      pageHeight(PageHeight):UnsignedByte
      pageImage(PageImage):String
      iconLeft(IconLeft):UnsignedByte
      iconTop(IconTop):UnsignedByte
      LabelBorderWidth(LabelBorderWidth):UnsignedByte
      font(Font):None Структура
        size(Size):UnsignedByte
        family(Family):String
        bold(Bold):String
        italic(Italic):String
        strikeout(Strikeout):String
        underline(Underline):String
        color(Color):String
    Page(Page):None Структура Повторяется
      exe(Exe):String
      icon(Icon):String
      X(X):UnsignedShort
      Y(Y):UnsignedShort
      Hint(Hint):String
      header(Header):String
      bottom(Bottom):String
      html(Html):String
      installerExe(InstallerExe):String
      exeAfterInstall(ExeAfterInstall):String
      regInstallPath(RegInstallPath):String
      Standart(Standart):Boolean
      pageImage(PageImage):String
      need(Need):None Структура
        msi(Msi):String
    msi(Msi):None Структура Повторяется
      id(Id):String
      exe(Exe):String
      cmd(Cmd):String
      check(Check):String
      Confirmation1(Confirmation1):String
      Confirmation2(Confirmation2):String
}

unit Config_;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Декларация интерфейсов }

  IXMLConfig = interface;
  IXMLButton = interface;
  IXMLButtonList = interface;
  IXMLBackGround = interface;
  IXMLAllPages = interface;
  IXMLFont = interface;
  IXMLPage = interface;
  IXMLPageList = interface;
  IXMLNeed = interface;
  IXMLMsi = interface;
  IXMLMsiList = interface;

{ IXMLConfig }

  IXMLConfig = interface(IXMLNode)
    ['{1838EEDC-094C-4E82-A83A-FBF5761E6834}']
    { Property Accessors }
    function Get_MainFormCaption: WideString;
    function Get_Button: IXMLButtonList;
    function Get_BackGround: IXMLBackGround;
    function Get_AllPages: IXMLAllPages;
    function Get_Page: IXMLPageList;
    function Get_Msi: IXMLMsiList;
    procedure Set_MainFormCaption(Value: WideString);
    { Methods & Properties }
    property MainFormCaption: WideString read Get_MainFormCaption write Set_MainFormCaption;
    property Button: IXMLButtonList read Get_Button;
    property BackGround: IXMLBackGround read Get_BackGround;
    property AllPages: IXMLAllPages read Get_AllPages;
    property Page: IXMLPageList read Get_Page;
    property Msi: IXMLMsiList read Get_Msi;
  end;

{ IXMLButton }

  IXMLButton = interface(IXMLNode)
    ['{7183CDC5-1838-4BFC-80E9-46F64E44EECB}']
    { Property Accessors }
    function Get_Image: WideString;
    function Get_Open: WideString;
    function Get_X: Integer;
    function Get_Y: Integer;
    function Get_Action: WideString;
    procedure Set_Image(Value: WideString);
    procedure Set_Open(Value: WideString);
    procedure Set_X(Value: Integer);
    procedure Set_Y(Value: Integer);
    procedure Set_Action(Value: WideString);
    { Methods & Properties }
    property Image: WideString read Get_Image write Set_Image;
    property Open: WideString read Get_Open write Set_Open;
    property X: Integer read Get_X write Set_X;
    property Y: Integer read Get_Y write Set_Y;
    property Action: WideString read Get_Action write Set_Action;
  end;

{ IXMLButtonList }

  IXMLButtonList = interface(IXMLNodeCollection)
    ['{A12FAD72-DBDA-4908-8021-4E92C792E417}']
    { Methods & Properties }
    function Add: IXMLButton;
    function Insert(const Index: Integer): IXMLButton;
    function Get_Item(Index: Integer): IXMLButton;
    property Items[Index: Integer]: IXMLButton read Get_Item; default;
  end;

{ IXMLBackGround }

  IXMLBackGround = interface(IXMLNode)
    ['{947C07ED-B941-4A5C-B80B-EA51414C5037}']
    { Property Accessors }
    function Get_Filename: WideString;
    procedure Set_Filename(Value: WideString);
    { Methods & Properties }
    property Filename: WideString read Get_Filename write Set_Filename;
  end;

{ IXMLAllPages }

  IXMLAllPages = interface(IXMLNode)
    ['{AD6A214A-418C-41BA-A6AA-8AC4A750C919}']
    { Property Accessors }
    function Get_PageWidth: Integer;
    function Get_PageHeight: Integer;
    function Get_PageImage: WideString;
    function Get_IconLeft: Integer;
    function Get_IconTop: Integer;
    function Get_LabelBorderWidth: Integer;
    function Get_Font: IXMLFont;
    procedure Set_PageWidth(Value: Integer);
    procedure Set_PageHeight(Value: Integer);
    procedure Set_PageImage(Value: WideString);
    procedure Set_IconLeft(Value: Integer);
    procedure Set_IconTop(Value: Integer);
    procedure Set_LabelBorderWidth(Value: Integer);
    { Methods & Properties }
    property PageWidth: Integer read Get_PageWidth write Set_PageWidth;
    property PageHeight: Integer read Get_PageHeight write Set_PageHeight;
    property PageImage: WideString read Get_PageImage write Set_PageImage;
    property IconLeft: Integer read Get_IconLeft write Set_IconLeft;
    property IconTop: Integer read Get_IconTop write Set_IconTop;
    property LabelBorderWidth: Integer read Get_LabelBorderWidth write Set_LabelBorderWidth;
    property Font: IXMLFont read Get_Font;
  end;

{ IXMLFont }

  IXMLFont = interface(IXMLNode)
    ['{BC17A086-1E5C-4DB0-87A5-5D68C3E27890}']
    { Property Accessors }
    function Get_Size: Integer;
    function Get_Family: WideString;
    function Get_Bold: WideString;
    function Get_Italic: WideString;
    function Get_Strikeout: WideString;
    function Get_Underline: WideString;
    function Get_Color: WideString;
    procedure Set_Size(Value: Integer);
    procedure Set_Family(Value: WideString);
    procedure Set_Bold(Value: WideString);
    procedure Set_Italic(Value: WideString);
    procedure Set_Strikeout(Value: WideString);
    procedure Set_Underline(Value: WideString);
    procedure Set_Color(Value: WideString);
    { Methods & Properties }
    property Size: Integer read Get_Size write Set_Size;
    property Family: WideString read Get_Family write Set_Family;
    property Bold: WideString read Get_Bold write Set_Bold;
    property Italic: WideString read Get_Italic write Set_Italic;
    property Strikeout: WideString read Get_Strikeout write Set_Strikeout;
    property Underline: WideString read Get_Underline write Set_Underline;
    property Color: WideString read Get_Color write Set_Color;
  end;

{ IXMLPage }

  IXMLPage = interface(IXMLNodeCollection)
    ['{46850CE5-DF9F-4719-98EA-F98A4F863090}']
    { Property Accessors }
    function Get_Exe: WideString;
    function Get_Icon: WideString;
    function Get_X: Integer;
    function Get_Y: Integer;
    function Get_Hint: WideString;
    function Get_Header: WideString;
    function Get_Bottom: WideString;
    function Get_Html: WideString;
    function Get_InstallerExe: WideString;
    function Get_ExeAfterInstall: WideString;
    function Get_RegInstallPath: WideString;
    function Get_Standart: Boolean;
    function Get_PageImage: WideString;
    function Get_Need(Index: Integer): IXMLNeed;
    procedure Set_Exe(Value: WideString);
    procedure Set_Icon(Value: WideString);
    procedure Set_X(Value: Integer);
    procedure Set_Y(Value: Integer);
    procedure Set_Hint(Value: WideString);
    procedure Set_Header(Value: WideString);
    procedure Set_Bottom(Value: WideString);
    procedure Set_Html(Value: WideString);
    procedure Set_InstallerExe(Value: WideString);
    procedure Set_ExeAfterInstall(Value: WideString);
    procedure Set_RegInstallPath(Value: WideString);
    procedure Set_Standart(Value: Boolean);
    procedure Set_PageImage(Value: WideString);
    { Methods & Properties }
    function Add: IXMLNeed;
    function Insert(const Index: Integer): IXMLNeed;
    property Exe: WideString read Get_Exe write Set_Exe;
    property Icon: WideString read Get_Icon write Set_Icon;
    property X: Integer read Get_X write Set_X;
    property Y: Integer read Get_Y write Set_Y;
    property Hint: WideString read Get_Hint write Set_Hint;
    property Header: WideString read Get_Header write Set_Header;
    property Bottom: WideString read Get_Bottom write Set_Bottom;
    property Html: WideString read Get_Html write Set_Html;
    property InstallerExe: WideString read Get_InstallerExe write Set_InstallerExe;
    property ExeAfterInstall: WideString read Get_ExeAfterInstall write Set_ExeAfterInstall;
    property RegInstallPath: WideString read Get_RegInstallPath write Set_RegInstallPath;
    property Standart: Boolean read Get_Standart write Set_Standart;
    property PageImage: WideString read Get_PageImage write Set_PageImage;
    property Need[Index: Integer]: IXMLNeed read Get_Need; default;
  end;

{ IXMLPageList }

  IXMLPageList = interface(IXMLNodeCollection)
    ['{D542D631-7E0C-493B-BE9F-75042B5214D9}']
    { Methods & Properties }
    function Add: IXMLPage;
    function Insert(const Index: Integer): IXMLPage;
    function Get_Item(Index: Integer): IXMLPage;
    property Items[Index: Integer]: IXMLPage read Get_Item; default;
  end;

{ IXMLNeed }

  IXMLNeed = interface(IXMLNode)
    ['{D500B507-1045-4375-A454-42D51F66CB73}']
    { Property Accessors }
    function Get_Msi: WideString;
    procedure Set_Msi(Value: WideString);
    { Methods & Properties }
    property Msi: WideString read Get_Msi write Set_Msi;
  end;

{ IXMLMsi }

  IXMLMsi = interface(IXMLNode)
    ['{471A0451-CEDD-4BA6-B173-B19D0CCCF70E}']
    { Property Accessors }
    function Get_Id: WideString;
    function Get_Exe: WideString;
    function Get_Cmd: WideString;
    function Get_Check: WideString;
    function Get_Confirmation1: WideString;
    function Get_Confirmation2: WideString;
    procedure Set_Id(Value: WideString);
    procedure Set_Exe(Value: WideString);
    procedure Set_Cmd(Value: WideString);
    procedure Set_Check(Value: WideString);
    procedure Set_Confirmation1(Value: WideString);
    procedure Set_Confirmation2(Value: WideString);
    { Methods & Properties }
    property Id: WideString read Get_Id write Set_Id;
    property Exe: WideString read Get_Exe write Set_Exe;
    property Cmd: WideString read Get_Cmd write Set_Cmd;
    property Check: WideString read Get_Check write Set_Check;
    property Confirmation1: WideString read Get_Confirmation1 write Set_Confirmation1;
    property Confirmation2: WideString read Get_Confirmation2 write Set_Confirmation2;
  end;

{ IXMLMsiList }

  IXMLMsiList = interface(IXMLNodeCollection)
    ['{DE39EC91-9A7D-43F4-B943-A623C2923529}']
    { Methods & Properties }
    function Add: IXMLMsi;
    function Insert(const Index: Integer): IXMLMsi;
    function Get_Item(Index: Integer): IXMLMsi;
    property Items[Index: Integer]: IXMLMsi read Get_Item; default;
  end;

{ Декларация типов }

  TXMLConfig = class;
  TXMLButton = class;
  TXMLButtonList = class;
  TXMLBackGround = class;
  TXMLAllPages = class;
  TXMLFont = class;
  TXMLPage = class;
  TXMLPageList = class;
  TXMLNeed = class;
  TXMLMsi = class;
  TXMLMsiList = class;

{ TXMLConfig }

  TXMLConfig = class(TXMLNode, IXMLConfig)
  private
    FButton: IXMLButtonList;
    FPage: IXMLPageList;
    FMsi: IXMLMsiList;
  protected
    { IXMLConfig }
    function Get_MainFormCaption: WideString;
    function Get_Button: IXMLButtonList;
    function Get_BackGround: IXMLBackGround;
    function Get_AllPages: IXMLAllPages;
    function Get_Page: IXMLPageList;
    function Get_Msi: IXMLMsiList;
    procedure Set_MainFormCaption(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLButton }

  TXMLButton = class(TXMLNode, IXMLButton)
  protected
    { IXMLButton }
    function Get_Image: WideString;
    function Get_Open: WideString;
    function Get_X: Integer;
    function Get_Y: Integer;
    function Get_Action: WideString;
    procedure Set_Image(Value: WideString);
    procedure Set_Open(Value: WideString);
    procedure Set_X(Value: Integer);
    procedure Set_Y(Value: Integer);
    procedure Set_Action(Value: WideString);
  end;

{ TXMLButtonList }

  TXMLButtonList = class(TXMLNodeCollection, IXMLButtonList)
  protected
    { IXMLButtonList }
    function Add: IXMLButton;
    function Insert(const Index: Integer): IXMLButton;
    function Get_Item(Index: Integer): IXMLButton;
  end;

{ TXMLBackGround }

  TXMLBackGround = class(TXMLNode, IXMLBackGround)
  protected
    { IXMLBackGround }
    function Get_Filename: WideString;
    procedure Set_Filename(Value: WideString);
  end;

{ TXMLAllPages }

  TXMLAllPages = class(TXMLNode, IXMLAllPages)
  protected
    { IXMLAllPages }
    function Get_PageWidth: Integer;
    function Get_PageHeight: Integer;
    function Get_PageImage: WideString;
    function Get_IconLeft: Integer;
    function Get_IconTop: Integer;
    function Get_LabelBorderWidth: Integer;
    function Get_Font: IXMLFont;
    procedure Set_PageWidth(Value: Integer);
    procedure Set_PageHeight(Value: Integer);
    procedure Set_PageImage(Value: WideString);
    procedure Set_IconLeft(Value: Integer);
    procedure Set_IconTop(Value: Integer);
    procedure Set_LabelBorderWidth(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFont }

  TXMLFont = class(TXMLNode, IXMLFont)
  protected
    { IXMLFont }
    function Get_Size: Integer;
    function Get_Family: WideString;
    function Get_Bold: WideString;
    function Get_Italic: WideString;
    function Get_Strikeout: WideString;
    function Get_Underline: WideString;
    function Get_Color: WideString;
    procedure Set_Size(Value: Integer);
    procedure Set_Family(Value: WideString);
    procedure Set_Bold(Value: WideString);
    procedure Set_Italic(Value: WideString);
    procedure Set_Strikeout(Value: WideString);
    procedure Set_Underline(Value: WideString);
    procedure Set_Color(Value: WideString);
  end;

{ TXMLPage }

  TXMLPage = class(TXMLNodeCollection, IXMLPage)
  protected
    { IXMLPage }
    function Get_Exe: WideString;
    function Get_Icon: WideString;
    function Get_X: Integer;
    function Get_Y: Integer;
    function Get_Hint: WideString;
    function Get_Header: WideString;
    function Get_Bottom: WideString;
    function Get_Html: WideString;
    function Get_InstallerExe: WideString;
    function Get_ExeAfterInstall: WideString;
    function Get_RegInstallPath: WideString;
    function Get_Standart: Boolean;
    function Get_PageImage: WideString;
    function Get_Need(Index: Integer): IXMLNeed;
    procedure Set_Exe(Value: WideString);
    procedure Set_Icon(Value: WideString);
    procedure Set_X(Value: Integer);
    procedure Set_Y(Value: Integer);
    procedure Set_Hint(Value: WideString);
    procedure Set_Header(Value: WideString);
    procedure Set_Bottom(Value: WideString);
    procedure Set_Html(Value: WideString);
    procedure Set_InstallerExe(Value: WideString);
    procedure Set_ExeAfterInstall(Value: WideString);
    procedure Set_RegInstallPath(Value: WideString);
    procedure Set_Standart(Value: Boolean);
    procedure Set_PageImage(Value: WideString);
    function Add: IXMLNeed;
    function Insert(const Index: Integer): IXMLNeed;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPageList }

  TXMLPageList = class(TXMLNodeCollection, IXMLPageList)
  protected
    { IXMLPageList }
    function Add: IXMLPage;
    function Insert(const Index: Integer): IXMLPage;
    function Get_Item(Index: Integer): IXMLPage;
  end;

{ TXMLNeed }

  TXMLNeed = class(TXMLNode, IXMLNeed)
  protected
    { IXMLNeed }
    function Get_Msi: WideString;
    procedure Set_Msi(Value: WideString);
  end;

{ TXMLMsi }

  TXMLMsi = class(TXMLNode, IXMLMsi)
  protected
    { IXMLMsi }
    function Get_Id: WideString;
    function Get_Exe: WideString;
    function Get_Cmd: WideString;
    function Get_Check: WideString;
    function Get_Confirmation1: WideString;
    function Get_Confirmation2: WideString;
    procedure Set_Id(Value: WideString);
    procedure Set_Exe(Value: WideString);
    procedure Set_Cmd(Value: WideString);
    procedure Set_Check(Value: WideString);
    procedure Set_Confirmation1(Value: WideString);
    procedure Set_Confirmation2(Value: WideString);
  end;

{ TXMLMsiList }

  TXMLMsiList = class(TXMLNodeCollection, IXMLMsiList)
  protected
    { IXMLMsiList }
    function Add: IXMLMsi;
    function Insert(const Index: Integer): IXMLMsi;
    function Get_Item(Index: Integer): IXMLMsi;
  end;

{ Global Functions }

function GetConfig(Doc: IXMLDocument): IXMLConfig;
function LoadConfig(const FileName: WideString): IXMLConfig;
function NewConfig: IXMLConfig;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetConfig(Doc: IXMLDocument): IXMLConfig;
begin
  Result := Doc.GetDocBinding('config', TXMLConfig, TargetNamespace) as IXMLConfig;
end;

function LoadConfig(const FileName: WideString): IXMLConfig;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('config', TXMLConfig, TargetNamespace) as IXMLConfig;
end;

function NewConfig: IXMLConfig;
begin
  Result := NewXMLDocument.GetDocBinding('config', TXMLConfig, TargetNamespace) as IXMLConfig;
end;

{ TXMLConfig }

procedure TXMLConfig.AfterConstruction;
begin
  RegisterChildNode('Button', TXMLButton);
  RegisterChildNode('backGround', TXMLBackGround);
  RegisterChildNode('AllPages', TXMLAllPages);
  RegisterChildNode('Page', TXMLPage);
  RegisterChildNode('msi', TXMLMsi);
  FButton := CreateCollection(TXMLButtonList, IXMLButton, 'Button') as IXMLButtonList;
  FPage := CreateCollection(TXMLPageList, IXMLPage, 'Page') as IXMLPageList;
  FMsi := CreateCollection(TXMLMsiList, IXMLMsi, 'msi') as IXMLMsiList;
  inherited;
end;

function TXMLConfig.Get_MainFormCaption: WideString;
begin
  Result := ChildNodes['mainFormCaption'].Text;
end;

function TXMLConfig.Get_Button: IXMLButtonList;
begin
  Result := FButton;
end;

function TXMLConfig.Get_BackGround: IXMLBackGround;
begin
  Result := ChildNodes['backGround'] as IXMLBackGround;
end;

function TXMLConfig.Get_AllPages: IXMLAllPages;
begin
  Result := ChildNodes['AllPages'] as IXMLAllPages;
end;

function TXMLConfig.Get_Page: IXMLPageList;
begin
  Result := FPage;
end;

function TXMLConfig.Get_Msi: IXMLMsiList;
begin
  Result := FMsi;
end;

procedure TXMLConfig.Set_MainFormCaption(Value: WideString);
begin
  ChildNodes['mainFormCaption'].NodeValue := Value;
end;

{ TXMLButton }

function TXMLButton.Get_Image: WideString;
begin
  Result := AttributeNodes['image'].Text;
end;

function TXMLButton.Get_Open: WideString;
begin
  Result := AttributeNodes['open'].Text;
end;

function TXMLButton.Get_X: Integer;
begin
  Result := AttributeNodes['x'].NodeValue;
end;

function TXMLButton.Get_Y: Integer;
begin
  Result := AttributeNodes['y'].NodeValue;
end;

function TXMLButton.Get_Action: WideString;
begin
  Result := AttributeNodes['action'].Text;
end;

procedure TXMLButton.Set_Image(Value: WideString);
begin
  SetAttribute('image', Value);
end;

procedure TXMLButton.Set_Open(Value: WideString);
begin
  SetAttribute('open', Value);
end;

procedure TXMLButton.Set_X(Value: Integer);
begin
  SetAttribute('x', Value);
end;

procedure TXMLButton.Set_Y(Value: Integer);
begin
  SetAttribute('y', Value);
end;

procedure TXMLButton.Set_Action(Value: WideString);
begin
  SetAttribute('action', Value);
end;

{ TXMLButtonList }

function TXMLButtonList.Add: IXMLButton;
begin
  Result := AddItem(-1) as IXMLButton;
end;

function TXMLButtonList.Insert(const Index: Integer): IXMLButton;
begin
  Result := AddItem(Index) as IXMLButton;
end;

function TXMLButtonList.Get_Item(Index: Integer): IXMLButton;
begin
  Result := List[Index] as IXMLButton;
end;

{ TXMLBackGround }

function TXMLBackGround.Get_Filename: WideString;
begin
  Result := AttributeNodes['filename'].Text;
end;

procedure TXMLBackGround.Set_Filename(Value: WideString);
begin
  SetAttribute('filename', Value);
end;

{ TXMLAllPages }

procedure TXMLAllPages.AfterConstruction;
begin
  RegisterChildNode('font', TXMLFont);
  inherited;
end;

function TXMLAllPages.Get_PageWidth: Integer;
begin
  Result := AttributeNodes['pageWidth'].NodeValue;
end;

function TXMLAllPages.Get_PageHeight: Integer;
begin
  Result := AttributeNodes['pageHeight'].NodeValue;
end;

function TXMLAllPages.Get_PageImage: WideString;
begin
  Result := AttributeNodes['pageImage'].Text;
end;

function TXMLAllPages.Get_IconLeft: Integer;
begin
  Result := AttributeNodes['iconLeft'].NodeValue;
end;

function TXMLAllPages.Get_IconTop: Integer;
begin
  Result := AttributeNodes['iconTop'].NodeValue;
end;

function TXMLAllPages.Get_LabelBorderWidth: Integer;
begin
  Result := AttributeNodes['LabelBorderWidth'].NodeValue;
end;

function TXMLAllPages.Get_Font: IXMLFont;
begin
  Result := ChildNodes['font'] as IXMLFont;
end;

procedure TXMLAllPages.Set_PageWidth(Value: Integer);
begin
  SetAttribute('pageWidth', Value);
end;

procedure TXMLAllPages.Set_PageHeight(Value: Integer);
begin
  SetAttribute('pageHeight', Value);
end;

procedure TXMLAllPages.Set_PageImage(Value: WideString);
begin
  SetAttribute('pageImage', Value);
end;

procedure TXMLAllPages.Set_IconLeft(Value: Integer);
begin
  SetAttribute('iconLeft', Value);
end;

procedure TXMLAllPages.Set_IconTop(Value: Integer);
begin
  SetAttribute('iconTop', Value);
end;

procedure TXMLAllPages.Set_LabelBorderWidth(Value: Integer);
begin
  SetAttribute('LabelBorderWidth', Value);
end;

{ TXMLFont }

function TXMLFont.Get_Size: Integer;
begin
  Result := AttributeNodes['size'].NodeValue;
end;

function TXMLFont.Get_Family: WideString;
begin
  Result := AttributeNodes['family'].Text;
end;

function TXMLFont.Get_Bold: WideString;
begin
  Result := AttributeNodes['bold'].Text;
end;

function TXMLFont.Get_Italic: WideString;
begin
  Result := AttributeNodes['italic'].Text;
end;

function TXMLFont.Get_Strikeout: WideString;
begin
  Result := AttributeNodes['strikeout'].Text;
end;

function TXMLFont.Get_Underline: WideString;
begin
  Result := AttributeNodes['underline'].Text;
end;

function TXMLFont.Get_Color: WideString;
begin
  Result := AttributeNodes['color'].Text;
end;

procedure TXMLFont.Set_Size(Value: Integer);
begin
  SetAttribute('size', Value);
end;

procedure TXMLFont.Set_Family(Value: WideString);
begin
  SetAttribute('family', Value);
end;

procedure TXMLFont.Set_Bold(Value: WideString);
begin
  SetAttribute('bold', Value);
end;

procedure TXMLFont.Set_Italic(Value: WideString);
begin
  SetAttribute('italic', Value);
end;

procedure TXMLFont.Set_Strikeout(Value: WideString);
begin
  SetAttribute('strikeout', Value);
end;

procedure TXMLFont.Set_Underline(Value: WideString);
begin
  SetAttribute('underline', Value);
end;

procedure TXMLFont.Set_Color(Value: WideString);
begin
  SetAttribute('color', Value);
end;

{ TXMLPage }

procedure TXMLPage.AfterConstruction;
begin
  RegisterChildNode('need', TXMLNeed);
  ItemTag := 'need';
  ItemInterface := IXMLNeed;
  inherited;
end;

function TXMLPage.Get_Exe: WideString;
begin
  Result := AttributeNodes['exe'].Text;
end;

function TXMLPage.Get_Icon: WideString;
begin
  Result := AttributeNodes['icon'].Text;
end;

function TXMLPage.Get_X: Integer;
begin
  Result := AttributeNodes['X'].NodeValue;
end;

function TXMLPage.Get_Y: Integer;
begin
  Result := AttributeNodes['Y'].NodeValue;
end;

function TXMLPage.Get_Hint: WideString;
begin
  Result := AttributeNodes['Hint'].Text;
end;

function TXMLPage.Get_Header: WideString;
begin
  Result := AttributeNodes['header'].Text;
end;

function TXMLPage.Get_Bottom: WideString;
begin
  Result := AttributeNodes['bottom'].Text;
end;

function TXMLPage.Get_Html: WideString;
begin
  Result := AttributeNodes['html'].Text;
end;

function TXMLPage.Get_InstallerExe: WideString;
begin
  Result := AttributeNodes['installerExe'].Text;
end;

function TXMLPage.Get_ExeAfterInstall: WideString;
begin
  Result := AttributeNodes['exeAfterInstall'].Text;
end;

function TXMLPage.Get_RegInstallPath: WideString;
begin
  Result := AttributeNodes['regInstallPath'].Text;
end;

function TXMLPage.Get_Standart: Boolean;
begin
  Result := AttributeNodes['Standart'].NodeValue;
end;

function TXMLPage.Get_PageImage: WideString;
begin
  Result := AttributeNodes['pageImage'].Text;
end;

function TXMLPage.Get_Need(Index: Integer): IXMLNeed;
begin
  Result := List[Index].NodeValue;
end;

procedure TXMLPage.Set_Exe(Value: WideString);
begin
  SetAttribute('exe', Value);
end;

procedure TXMLPage.Set_Icon(Value: WideString);
begin
  SetAttribute('icon', Value);
end;

procedure TXMLPage.Set_X(Value: Integer);
begin
  SetAttribute('X', Value);
end;

procedure TXMLPage.Set_Y(Value: Integer);
begin
  SetAttribute('Y', Value);
end;

procedure TXMLPage.Set_Hint(Value: WideString);
begin
  SetAttribute('Hint', Value);
end;

procedure TXMLPage.Set_Header(Value: WideString);
begin
  SetAttribute('header', Value);
end;

procedure TXMLPage.Set_Bottom(Value: WideString);
begin
  SetAttribute('bottom', Value);
end;

procedure TXMLPage.Set_Html(Value: WideString);
begin
  SetAttribute('html', Value);
end;

procedure TXMLPage.Set_InstallerExe(Value: WideString);
begin
  SetAttribute('installerExe', Value);
end;

procedure TXMLPage.Set_ExeAfterInstall(Value: WideString);
begin
  SetAttribute('exeAfterInstall', Value);
end;

procedure TXMLPage.Set_RegInstallPath(Value: WideString);
begin
  SetAttribute('regInstallPath', Value);
end;

procedure TXMLPage.Set_Standart(Value: Boolean);
begin
  SetAttribute('Standart', Value);
end;

procedure TXMLPage.Set_PageImage(Value: WideString);
begin
  SetAttribute('pageImage', Value);
end;

function TXMLPage.Add: IXMLNeed;
begin
  Result := AddItem(-1);
end;

function TXMLPage.Insert(const Index: Integer): IXMLNeed;
begin
  Result := AddItem(Index);
end;

{ TXMLPageList }

function TXMLPageList.Add: IXMLPage;
begin
  Result := AddItem(-1) as IXMLPage;
end;

function TXMLPageList.Insert(const Index: Integer): IXMLPage;
begin
  Result := AddItem(Index) as IXMLPage;
end;

function TXMLPageList.Get_Item(Index: Integer): IXMLPage;
begin
  Result := List[Index] as IXMLPage;
end;

{ TXMLNeed }

function TXMLNeed.Get_Msi: WideString;
begin
  Result := AttributeNodes['msi'].Text;
end;

procedure TXMLNeed.Set_Msi(Value: WideString);
begin
  SetAttribute('msi', Value);
end;

{ TXMLMsi }

function TXMLMsi.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].Text;
end;

function TXMLMsi.Get_Exe: WideString;
begin
  Result := AttributeNodes['exe'].Text;
end;

function TXMLMsi.Get_Cmd: WideString;
begin
  Result := AttributeNodes['cmd'].Text;
end;

function TXMLMsi.Get_Check: WideString;
begin
  Result := AttributeNodes['check'].Text;
end;

function TXMLMsi.Get_Confirmation1: WideString;
begin
  Result := AttributeNodes['Confirmation1'].Text;
end;

function TXMLMsi.Get_Confirmation2: WideString;
begin
  Result := AttributeNodes['Confirmation2'].Text;
end;

procedure TXMLMsi.Set_Id(Value: WideString);
begin
  SetAttribute('id', Value);
end;

procedure TXMLMsi.Set_Exe(Value: WideString);
begin
  SetAttribute('exe', Value);
end;

procedure TXMLMsi.Set_Cmd(Value: WideString);
begin
  SetAttribute('cmd', Value);
end;

procedure TXMLMsi.Set_Check(Value: WideString);
begin
  SetAttribute('check', Value);
end;

procedure TXMLMsi.Set_Confirmation1(Value: WideString);
begin
  SetAttribute('Confirmation1', Value);
end;

procedure TXMLMsi.Set_Confirmation2(Value: WideString);
begin
  SetAttribute('Confirmation2', Value);
end;

{ TXMLMsiList }

function TXMLMsiList.Add: IXMLMsi;
begin
  Result := AddItem(-1) as IXMLMsi;
end;

function TXMLMsiList.Insert(const Index: Integer): IXMLMsi;
begin
  Result := AddItem(Index) as IXMLMsi;
end;

function TXMLMsiList.Get_Item(Index: Integer): IXMLMsi;
begin
  Result := List[Index] as IXMLMsi;
end;

end.
