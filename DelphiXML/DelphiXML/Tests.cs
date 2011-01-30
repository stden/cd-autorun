using System.Collections;
using System.Xml.Schema;
using csUnit;

namespace DelphiXML {
  [TestFixture]
  internal class Tests {
    [Test]
    public void ТестированиеОбъектаТекст() {
      Text t = new Text();
      t.Tab = 2;
      t.Add("Test1!");
      Assert.Equals("  Test1!" + Utils.NewLine, t.Res);
      t.Add("Test2!");
      Assert.Equals("  Test1!" + Utils.NewLine + "  Test2!" + Utils.NewLine, t.Res);
      t.Tab = 4;
      t.Add("Test3!");
      Assert.Equals("  Test1!" + Utils.NewLine + "  Test2!" + Utils.NewLine + "    Test3!" + Utils.NewLine, t.Res);
    }

    [Test]
    public void ТестированиеПовторяющегосяПростогоТэга() {
      DelphiGenerator dg = GetDelphiGenerator(@"..\..\Tests\XMLFile1.xml");
      Assert.NotNull(dg);
      Assert.Equals(1, dg.TypeList.Count);
      TypeInterface XMLTest = dg.TypeList[0];
      Assert.Equals("IXMLTest", XMLTest.InterfaceName);
      Assert.Equals(1, XMLTest.PropertyAccessors.Count);
      Assert.Equals("function Get_HelloWorld(Index: Integer): Integer;", XMLTest.PropertyAccessors[0].Декларация);
      Assert.Equals(2, XMLTest.Methods.Count);
      Assert.Equals("function Add(const HelloWorld: Integer): IXMLNode;", XMLTest.Methods[0].Декларация);
      Assert.Equals("function Insert(const Index: Integer; const HelloWorld: Integer): IXMLNode;",
                    XMLTest.Methods[1].Декларация);
      Assert.Equals(1, XMLTest.Properties.Count);
      Assert.Equals("property HelloWorld[Index: Integer]: Integer read Get_HelloWorld; default;", XMLTest.Properties[0]);
      Assert.Equals("  ItemTag := 'HelloWorld';" + Utils.NewLine + "  ItemInterface := IXMLNode;",
                    XMLTest.AfterConstruction);

      Assert.Equals(3, dg.GlobalFunctions.Count);
      Assert.Equals("function GetTest(Doc: IXMLDocument): IXMLTest;", dg.GlobalFunctions[0].Заголовок);
      Assert.Equals("  Result := Doc.GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;",
                    dg.GlobalFunctions[0].Тело);
      Assert.Equals("function LoadTest(const FileName: WideString): IXMLTest;", dg.GlobalFunctions[1].Заголовок);
      Assert.Equals(
        "  Result := LoadXMLDocument(FileName).GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;",
        dg.GlobalFunctions[1].Тело);
      Assert.Equals("function NewTest: IXMLTest;", dg.GlobalFunctions[2].Заголовок);
      Assert.Equals("  Result := NewXMLDocument.GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;",
                    dg.GlobalFunctions[2].Тело);

      dg.Сгенерировать(@"..\..\Tests\XMLFile1_.pas");
    }

    private static DelphiGenerator GetDelphiGenerator(string имяXMLФайла) {
      DelphiGenerator dg = null;
      XmlSchema Схема = Program.ПолучитьСхемуXMLФайла(имяXMLФайла);
      foreach (DictionaryEntry de in Схема.Elements) {
        Тэг корень = Program.Build((XmlSchemaElement) de.Value);
        dg = new DelphiGenerator(корень);
        break; // обрабатываем только первый элемент
      }
      return dg;
    }

    [Test]
    public void ТестированиеПростогоТэга() {
      DelphiGenerator dg = GetDelphiGenerator(@"..\..\Tests\XMLFile2.xml");
      Assert.NotNull(dg);
      Assert.Equals(1, dg.TypeList.Count);
      TypeInterface XMLTest = dg.TypeList[0];
      Assert.Equals("IXMLTest", XMLTest.InterfaceName);
      Assert.Equals(2, XMLTest.PropertyAccessors.Count);
      Assert.Equals("function Get_HelloWorld: Integer;", XMLTest.PropertyAccessors[0].Декларация);
      Assert.Equals("  Result := ChildNodes['HelloWorld'].NodeValue;", XMLTest.PropertyAccessors[0].Тело);
      Assert.Equals("procedure Set_HelloWorld(Value: Integer);", XMLTest.PropertyAccessors[1].Декларация);
      Assert.Equals("  ChildNodes['HelloWorld'].NodeValue := Value;", XMLTest.PropertyAccessors[1].Тело);
      Assert.Equals(0, XMLTest.Methods.Count);
      Assert.Equals(1, XMLTest.Properties.Count);
      Assert.Equals("property HelloWorld: Integer read Get_HelloWorld write Set_HelloWorld;", XMLTest.Properties[0]);
      Assert.Equals("", XMLTest.AfterConstruction);

      Assert.Equals(3, dg.GlobalFunctions.Count);
      Assert.Equals("function GetTest(Doc: IXMLDocument): IXMLTest;", dg.GlobalFunctions[0].Заголовок);
      Assert.Equals("  Result := Doc.GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;",
                    dg.GlobalFunctions[0].Тело);
      Assert.Equals("function LoadTest(const FileName: WideString): IXMLTest;", dg.GlobalFunctions[1].Заголовок);
      Assert.Equals(
        "  Result := LoadXMLDocument(FileName).GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;",
        dg.GlobalFunctions[1].Тело);
      Assert.Equals("function NewTest: IXMLTest;", dg.GlobalFunctions[2].Заголовок);
      Assert.Equals("  Result := NewXMLDocument.GetDocBinding('Test', TXMLTest, TargetNamespace) as IXMLTest;",
                    dg.GlobalFunctions[2].Тело);

      dg.Сгенерировать(@"..\..\Tests\XMLFile2_.pas");
    }

    [Test]
    public void TestConfig() {
      DelphiGenerator dg = GetDelphiGenerator(@"..\..\Tests\config.xml");
      Assert.NotNull(dg);
      Assert.Equals(11, dg.TypeList.Count);
      Assert.Equals("IXMLConfig", dg.TypeList[0].InterfaceName);
      Assert.Equals("IXMLButton", dg.TypeList[1].InterfaceName);
      Assert.Equals("IXMLButtonList", dg.TypeList[2].InterfaceName);
      Assert.Equals("IXMLBackGround", dg.TypeList[3].InterfaceName);
      Assert.Equals("IXMLAllPages", dg.TypeList[4].InterfaceName);
      Assert.Equals("IXMLFont", dg.TypeList[5].InterfaceName);
      Assert.Equals("IXMLPage", dg.TypeList[6].InterfaceName);
      Assert.Equals("IXMLPageList", dg.TypeList[7].InterfaceName);
      Assert.Equals("IXMLNeed", dg.TypeList[8].InterfaceName);
      Assert.Equals("IXMLMsi", dg.TypeList[9].InterfaceName);
      Assert.Equals("IXMLMsiList", dg.TypeList[10].InterfaceName);

      TypeInterface XMLConfig = dg.TypeList[0];
      Assert.Equals("TXMLConfig", XMLConfig.TypeName);
      Assert.Equals("class(TXMLNode, IXMLConfig)", XMLConfig.TypeType);
      TypeInterface XMLButton = dg.TypeList[1];
      Assert.Equals("TXMLButton", XMLButton.TypeName);
      Assert.Equals("class(TXMLNode, IXMLButton)", XMLButton.TypeType);
      TypeInterface XMLButtonList = dg.TypeList[2];
      Assert.Equals("TXMLButtonList", XMLButtonList.TypeName);
      Assert.Equals("class(TXMLNodeCollection, IXMLButtonList)", XMLButtonList.TypeType);
      TypeInterface XMLBackGround = dg.TypeList[3];
      Assert.Equals("TXMLBackGround", XMLBackGround.TypeName);
      Assert.Equals("class(TXMLNode, IXMLBackGround)", XMLBackGround.TypeType);
      TypeInterface XMLAllPages = dg.TypeList[4];
      Assert.Equals("TXMLAllPages", XMLAllPages.TypeName);
      Assert.Equals("class(TXMLNode, IXMLAllPages)", XMLAllPages.TypeType);
      TypeInterface XMLFont = dg.TypeList[5];
      Assert.Equals("TXMLFont", XMLFont.TypeName);
      Assert.Equals("class(TXMLNode, IXMLFont)", XMLFont.TypeType);
      TypeInterface XMLPage = dg.TypeList[6];
      Assert.Equals("TXMLPage", XMLPage.TypeName);
      Assert.Equals("class(TXMLNodeCollection, IXMLPage)", XMLPage.TypeType);
      TypeInterface XMLPageList = dg.TypeList[7];
      Assert.Equals("TXMLPageList", XMLPageList.TypeName);
      Assert.Equals("class(TXMLNodeCollection, IXMLPageList)", XMLPageList.TypeType);
      TypeInterface XMLNeed = dg.TypeList[8];
      Assert.Equals("TXMLNeed", XMLNeed.TypeName);
      Assert.Equals("class(TXMLNode, IXMLNeed)", XMLNeed.TypeType);
      TypeInterface XMLMsi = dg.TypeList[9];
      Assert.Equals("TXMLMsi", XMLMsi.TypeName);
      Assert.Equals("class(TXMLNode, IXMLMsi)", XMLMsi.TypeType);
      TypeInterface XMLMsiList = dg.TypeList[10];
      Assert.Equals("TXMLMsiList", XMLMsiList.TypeName);
      Assert.Equals("class(TXMLNodeCollection, IXMLMsiList)", XMLMsiList.TypeType);

      Assert.Equals(
        @"  RegisterChildNode('Button', TXMLButton);
  RegisterChildNode('backGround', TXMLBackGround);
  RegisterChildNode('AllPages', TXMLAllPages);
  RegisterChildNode('Page', TXMLPage);
  RegisterChildNode('msi', TXMLMsi);
  FButton := CreateCollection(TXMLButtonList, IXMLButton, 'Button') as IXMLButtonList;
  FPage := CreateCollection(TXMLPageList, IXMLPage, 'Page') as IXMLPageList;
  FMsi := CreateCollection(TXMLMsiList, IXMLMsi, 'msi') as IXMLMsiList;",
        XMLConfig.AfterConstruction);

      Метод метод;
      метод = XMLPage.PropertyAccessors[0];
      Assert.Equals("Get_Exe: WideString;", метод.Заголовок);
      Assert.Equals(@"  Result := AttributeNodes['exe'].Text;", метод.Тело);
      метод = XMLPage.PropertyAccessors[2];
      Assert.Equals("Get_X: Integer;", метод.Заголовок);
      Assert.Equals(@"  Result := AttributeNodes['X'].NodeValue;", метод.Тело);
      метод = XMLPage.PropertyAccessors[3];
      Assert.Equals("Get_Y: Integer;", метод.Заголовок);
      Assert.Equals(@"  Result := AttributeNodes['Y'].NodeValue;", метод.Тело);
      метод = XMLPage.PropertyAccessors[11];
      Assert.Equals("Get_Standart: Boolean;", метод.Заголовок);
      Assert.Equals(@"  Result := AttributeNodes['Standart'].NodeValue;", метод.Тело);
      метод = XMLPage.PropertyAccessors[13];
      Assert.Equals("Get_Need(Index: Integer): IXMLNeed;", метод.Заголовок);
      Assert.Equals(@"  Result := List[Index].NodeValue;", метод.Тело);
      метод = XMLPage.PropertyAccessors[16];
      Assert.Equals("Set_X(Value: Integer);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('X', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[17];
      Assert.Equals("Set_Y(Value: Integer);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('Y', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[18];
      Assert.Equals("Set_Hint(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('Hint', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[19];
      Assert.Equals("Set_Header(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('header', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[20];
      Assert.Equals("Set_Bottom(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('bottom', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[21];
      Assert.Equals("Set_Html(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('html', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[22];
      Assert.Equals("Set_InstallerExe(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('installerExe', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[23];
      Assert.Equals("Set_ExeAfterInstall(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('exeAfterInstall', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[24];
      Assert.Equals("Set_RegInstallPath(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('regInstallPath', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[25];
      Assert.Equals("Set_Standart(Value: Boolean);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('Standart', Value);", метод.Тело);
      метод = XMLPage.PropertyAccessors[26];
      Assert.Equals("Set_PageImage(Value: WideString);", метод.Заголовок);
      Assert.Equals(@"  SetAttribute('pageImage', Value);", метод.Тело);

      //int cnt = 0;
      //foreach (TypeInterface ti in dg.TypeList) {
      //  string s = ti.TypeName.Substring(1);
      //  Console.WriteLine("TypeInterface " + s + " = dg.TypeList[" + cnt + "];");
      //  Console.WriteLine("Assert.Equals(\"" + ti.TypeName + "\"," + s + ".TypeName);");
      //  Console.WriteLine("Assert.Equals(\"" + ti.TypeType + "\"," + s + ".TypeType);");
      //  cnt++;
      //}

      //int cnt = 0;
      //Console.WriteLine("Метод метод;");
      //foreach (Метод m in XMLPage.PropertyAccessors) {
      //  Console.WriteLine("метод = XMLPage.PropertyAccessors[" + cnt + "];");
      //  Console.WriteLine("Assert.Equals(\"" + m.Заголовок + "\",метод.Заголовок);");
      //  Console.WriteLine("Assert.Equals(@" + "\"" + m.Тело + "\",метод.Тело);");
      //  cnt++;
      //}


      dg.Сгенерировать(@"..\..\Tests\config_.pas");
    }
  }
}