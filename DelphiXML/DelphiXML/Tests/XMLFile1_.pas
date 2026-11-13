// Модуль сгенерирован 03.05.2007 21:44:25 программой DelphiXML, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// По всем вопросам обращайтесь к Денису Степулёнку +79117117850 (super.denis@gmail.com)
{
  Test(Test):None Структура
    HelloWorld(HelloWorld):UnsignedInt ПростойТип
}

unit Xmlfile1_;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Декларация интерфейсов }

  IXMLTest = interface;

{ IXMLTest }

  IXMLTest = interface(IXMLNodeCollection)
    ['{FCFEBFAD-E8FD-49E5-A486-8C02573A1DC6}']
    { Property Accessors }
    function Get_HelloWorld(Index: Integer): Integer;
    { Methods & Properties }
    function Add(const HelloWorld: Integer): IXMLNode;
    function Insert(const Index: Integer; const HelloWorld: Integer): IXMLNode;
    property HelloWorld[Index: Integer]: Integer read Get_HelloWorld; default;
  end;

{ Декларация типов }

  TXMLTest = class;

{ TXMLTest }

  TXMLTest = class(TXMLNodeCollection, IXMLTest)
  protected
    { IXMLTest }
    function Get_HelloWorld(Index: Integer): Integer;
    function Add(const HelloWorld: Integer): IXMLNode;
    function Insert(const Index: Integer; const HelloWorld: Integer): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ Global Functions }

function GetTest(Doc: IXMLDocument): IXMLTest;
function LoadTest(const FileName: WideString): IXMLTest;
function NewTest: IXMLTest;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetTest(Doc: IXMLDocument): IXMLTest;
begin
  Result := Doc.GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;
end;

function LoadTest(const FileName: WideString): IXMLTest;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;
end;

function NewTest: IXMLTest;
begin
  Result := NewXMLDocument.GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;
end;

{ TXMLTest }

procedure TXMLTest.AfterConstruction;
begin
  ItemTag := 'HelloWorld';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLTest.Get_HelloWorld(Index: Integer): Integer;
begin
  Result := List[Index].NodeValue;
end;

function TXMLTest.Add(const HelloWorld: Integer): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := HelloWorld;
end;

function TXMLTest.Insert(const Index: Integer; const HelloWorld: Integer): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := HelloWorld;
end;

end.
