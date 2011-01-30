// ������ ������������ 03.05.2007 21:44:25 ���������� DelphiXML, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// �� ���� �������� ����������� � ������ ��������� +79117117850 (super.denis@gmail.com)
{
  Test(Test):None ���������
    HelloWorld(HelloWorld):UnsignedInt ����������
}

unit Xmlfile2_;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ ���������� ����������� }

  IXMLTest = interface;

{ IXMLTest }

  IXMLTest = interface(IXMLNode)
    ['{7D06F36B-D10E-47AE-B498-34AE2F1B11D6}']
    { Property Accessors }
    function Get_HelloWorld: Integer;
    procedure Set_HelloWorld(Value: Integer);
    { Methods & Properties }
    property HelloWorld: Integer read Get_HelloWorld write Set_HelloWorld;
  end;

{ ���������� ����� }

  TXMLTest = class;

{ TXMLTest }

  TXMLTest = class(TXMLNode, IXMLTest)
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

function TXMLTest.Get_HelloWorld: Integer;
begin
  Result := ChildNodes['HelloWorld'].NodeValue;
end;

procedure TXMLTest.Set_HelloWorld(Value: Integer);
begin
  ChildNodes['HelloWorld'].NodeValue := Value;
end;

end.
