
{***********************************************************************}
{                                                                       }
{                           XML Data Binding                            }
{                                                                       }
{         Generated on: 03.05.2007 17:51:11                             }
{       Generated from: C:\FTP\DelphiXML\DelphiXML\Tests\XMLFile2.xml   }
{   Settings stored in: C:\FTP\DelphiXML\DelphiXML\Tests\XMLFile2.xdb   }
{                                                                       }
{***********************************************************************}

unit XMLFile2;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLTest = interface;

{ IXMLTest }

  IXMLTest = interface(IXMLNode)
    ['{32148D41-A3C9-4715-9028-F37129520BEC}']
    { Property Accessors }
    function Get_HelloWorld: Integer;
    procedure Set_HelloWorld(Value: Integer);
    { Methods & Properties }
    property HelloWorld: Integer read Get_HelloWorld write Set_HelloWorld;
  end;

{ Forward Decls }

  TXMLTestType = class;

{ TXMLTestType }

  TXMLTestType = class(TXMLNode, IXMLTest)
  protected
    { IXMLTest }
    function Get_HelloWorld: Integer;
    procedure Set_HelloWorld(Value: Integer);
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
  Result := Doc.GetDocBinding('Test', TXMLTestType, TargetNamespace) as IXMLTest;
end;

function LoadTest(const FileName: WideString): IXMLTest;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Test', TXMLTestType, TargetNamespace) as IXMLTest;
end;

function NewTest: IXMLTest;
begin
  Result := NewXMLDocument.GetDocBinding('Test', TXMLTestType, TargetNamespace) as IXMLTest;
end;

{ TXMLTestType }

function TXMLTestType.Get_HelloWorld: Integer;
begin
  Result := ChildNodes['HelloWorld'].NodeValue;
end;

procedure TXMLTestType.Set_HelloWorld(Value: Integer);
begin
  ChildNodes['HelloWorld'].NodeValue := Value;
end;

end.