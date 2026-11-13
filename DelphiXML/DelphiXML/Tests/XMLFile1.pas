
{***********************************************************************}
{                                                                       }
{                           XML Data Binding                            }
{                                                                       }
{         Generated on: 03.05.2007 16:54:01                             }
{       Generated from: C:\FTP\DelphiXML\DelphiXML\Tests\XMLFile1.xml   }
{   Settings stored in: C:\FTP\DelphiXML\DelphiXML\Tests\XMLFile1.xdb   }
{                                                                       }
{***********************************************************************}

unit XMLFile1;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLTest = interface;

{ IXMLTest }

  IXMLTest = interface(IXMLNodeCollection)
    ['{596F0327-F055-4A83-A777-6D874DAFE6A0}']
    { Property Accessors }
    function Get_HelloWorld(Index: Integer): Integer;
    { Methods & Properties }
    function Add(const HelloWorld: Integer): IXMLNode;
    function Insert(const Index: Integer; const HelloWorld: Integer): IXMLNode;
    property HelloWorld[Index: Integer]: Integer read Get_HelloWorld; default;
  end;

{ Forward Decls }

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