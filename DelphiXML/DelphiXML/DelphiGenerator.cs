using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Xml.Schema;

namespace DelphiXML {
  public class DelphiGenerator {
    private static StreamWriter wr;

    public List<TypeInterface> TypeList = new List<TypeInterface>();
    public List<Function> GlobalFunctions = new List<Function>();

    private Тэг корень;

    public DelphiGenerator(Тэг корень) {
      this.корень = корень;

      Подготовка(корень);

      GlobalFunctions.Add(new Function("function Get" + корень.Id + "(Doc: IXMLDocument): IXML" + корень.Id + ";",
                                       "  Result := Doc.GetDocBinding('" + корень.имяXML + "', TXML" + корень.Id +
                                       ", TargetNamespace) as IXML" + корень.Id + ";"));
      GlobalFunctions.Add(
        new Function("function Load" + корень.Id + "(const FileName: WideString): IXML" + корень.Id + ";",
                     "  Result := LoadXMLDocument(FileName).GetDocBinding('" + корень.имяXML + "', TXML" + корень.Id +
                     ", TargetNamespace) as IXML" + корень.Id + ";"));
      GlobalFunctions.Add(new Function("function New" + корень.Id + ": IXML" + корень.Id + ";",
                                       "  Result := NewXMLDocument.GetDocBinding('" + корень.имяXML + "', TXML" +
                                       корень.Id + ", TargetNamespace) as IXML" + корень.Id + ";"));
    }

    private void Подготовка(Тэг t) {
      if (t.типТэга == ТипТэга.ПростойТип) return;
      bool ОдиночныйВложенныйПовторяющийсяТэг = t.ВложенныеТэги.Count == 1 && t.ВложенныеТэги[0].Повторяется;
      TypeInterface ti = new TypeInterface();
      ti.InterfaceName = "IXML" + t.Id;
      ti.TypeName = "TXML" + t.Id;
      ti.InterfaceType = "interface(IXMLNode)";
      ti.TypeType = "class(TXMLNode, " + ti.InterfaceName + ")";
      TypeList.Add(ti);

      GetAttributes(t, ti);

      foreach (Тэг tt in t.ВложенныеТэги) if (tt.типТэга == ТипТэга.Структура) ti.AfterConstruction += "  RegisterChildNode('" + tt.имяXML + "', TXML" + tt.Id + ");" + Utils.NewLine;
      ti.AfterConstruction = ti.AfterConstruction.TrimEnd();

      if (ОдиночныйВложенныйПовторяющийсяТэг) {
        string idТэга = t.ВложенныеТэги[0].Id;
        ti.InterfaceType = "interface(IXMLNodeCollection)";
        ti.TypeType = "class(TXMLNodeCollection, " + ti.InterfaceName + ")";
        string тип = t.ВложенныеТэги[0].PascalType;
        string типItemInterface = "IXMLNode";
        if (t.ВложенныеТэги[0].типТэга == ТипТэга.Структура) {
          типItemInterface = "IXML" + t.ВложенныеТэги[0].Id;
          тип = типItemInterface;
          ti.Methods.Add(new Метод("function", "Add: " + типItemInterface + ";",
                                   "  Result := AddItem(-1);"));
          ti.Methods.Add(
            new Метод("function", "Insert(const Index: Integer): " + типItemInterface + ";",
                      "  Result := AddItem(Index);"));
        } else {
          ti.Methods.Add(new Метод("function", "Add(const " + idТэга + ": " + тип + "): " + типItemInterface + ";",
                                   "  Result := AddItem(-1);" + Utils.NewLine +
                                   "  Result.NodeValue := " + idТэга + ";"));
          ti.Methods.Add(
            new Метод("function",
                      "Insert(const Index: Integer; const " + idТэга + ": " + тип + "): " + типItemInterface + ";",
                      "  Result := AddItem(Index);" + Utils.NewLine +
                      "  Result.NodeValue := " + idТэга + ";"));
        }
        ti.PropertyAccessors.Add(new Метод("function", "Get_" + idТэга + "(Index: Integer): " + тип + ";",
                                           "  Result := List[Index].NodeValue;"));
        if (ti.AfterConstruction != "") ti.AfterConstruction += Utils.NewLine;
        ti.AfterConstruction += "  ItemTag := '" + t.ВложенныеТэги[0].имяXML + "';" + Utils.NewLine +
                                "  ItemInterface := " + типItemInterface + ";";
      } else {
        if (ti.AfterConstruction != "") ti.AfterConstruction += Utils.NewLine;
        foreach (Тэг tt in t.ВложенныеТэги) {
          if (tt.типТэга == ТипТэга.Структура && tt.Повторяется) {
            ti.Fields.Add("F" + tt.Id + ": IXML" + tt.Id + "List;");
            ti.AfterConstruction += "  F" + tt.Id + " := CreateCollection(TXML" + tt.Id + "List, IXML" + tt.Id + ", '" +
                                    tt.имяXML + "') as IXML" + tt.Id + "List;" + Utils.NewLine;
          }
        }
        ti.AfterConstruction = ti.AfterConstruction.TrimEnd();
        foreach (Тэг tt in t.ВложенныеТэги) {
          string body = "  Result := ChildNodes['" + tt.имяXML + "'].NodeValue;";
          if (tt.TypeCode == XmlTypeCode.String) body = "  Result := ChildNodes['" + tt.имяXML + "'].Text;";
          if (tt.типТэга == ТипТэга.Структура) {
            if (tt.Повторяется) body = "  Result := F" + tt.Id + ";";
            else body = "  Result := ChildNodes['" + tt.имяXML + "'] as IXML" + tt.Id + ";";
          }
          ti.PropertyAccessors.Add(new Метод("function", "Get_" + tt.Id + ": " + tt.PascalType + ";",
                                             body));
        }
      }
      foreach (Атрибут a in t.Атрибуты) {
        ti.PropertyAccessors.Add(new Метод("procedure", "Set_" + a.Id + "(Value: " + a.PascalType + ");",
                                           "  SetAttribute('" + a.имяXML + "', Value);"));
        ti.Properties.Add("property " + a.Id + ": " + a.PascalType + " read Get_" + a.Id + " write Set_" + a.Id + ";");
      }
      if (!ОдиночныйВложенныйПовторяющийсяТэг) {
        foreach (Тэг tt in t.ВложенныеТэги) {
          switch (tt.типТэга) {
            case ТипТэга.Структура:
              ti.Properties.Add("property " + tt.Id + ": " + tt.PascalType + " read Get_" + tt.Id + ";");
              break;
            case ТипТэга.ПростойТип:
              ti.PropertyAccessors.Add(new Метод("procedure", "Set_" + tt.Id + "(Value: " + tt.PascalType + ");",
                                                 "  ChildNodes['" + tt.имяXML + "'].NodeValue := Value;"));
              ti.Properties.Add("property " + tt.Id + ": " + tt.PascalType + " read Get_" + tt.Id + " write Set_" +
                                tt.Id + ";");
              break;
          }
        }
        foreach (Тэг tt in t.ВложенныеТэги) Подготовка(tt);
      }

      if (t.Повторяется) {
        TypeInterface tiList = new TypeInterface();
        tiList.InterfaceName = "IXML" + t.Id + "List";
        tiList.TypeName = "TXML" + t.Id + "List";
        tiList.InterfaceType = "interface(IXMLNodeCollection)";
        tiList.TypeType = "class(TXMLNodeCollection, " + tiList.InterfaceName + ")";
        tiList.Methods.Add(new Метод("function", "Add: " + ti.InterfaceName + ";",
                                     "  Result := AddItem(-1) as " + ti.InterfaceName + ";"));
        tiList.Methods.Add(new Метод("function", "Insert(const Index: Integer): " + ti.InterfaceName + ";",
                                     "  Result := AddItem(Index) as " + ti.InterfaceName + ";"));
        tiList.Methods.Add(new Метод("function", "Get_Item(Index: Integer): " + ti.InterfaceName + ";",
                                     "  Result := List[Index] as " + ti.InterfaceName + ";"));
        tiList.Properties.Add("property Items[Index: Integer]: IXML" + t.Id + " read Get_Item; default;");
        TypeList.Add(tiList);
      }
      if (ОдиночныйВложенныйПовторяющийсяТэг) {
        if (t.ВложенныеТэги[0].типТэга == ТипТэга.Структура) {
          ti.Properties.Add("property " + t.ВложенныеТэги[0].Id + "[Index: Integer]: IXML" + t.ВложенныеТэги[0].Id +
                            " read Get_" +
                            t.ВложенныеТэги[0].Id + "; default;");
        } else {
          ti.Properties.Add("property " + t.ВложенныеТэги[0].Id + "[Index: Integer]: " + t.ВложенныеТэги[0].PascalType +
                            " read Get_" +
                            t.ВложенныеТэги[0].Id + "; default;");
        }
        t.ВложенныеТэги[0].Повторяется = false;
        Подготовка(t.ВложенныеТэги[0]);
      }
    }

    private static void GetAttributes(Тэг t, TypeInterface ti) {
      foreach (Атрибут a in t.Атрибуты) {
        string body = "  Result := AttributeNodes['" + a.имяXML + "'].NodeValue;";
        if (a.TypeCode == XmlTypeCode.String) body = "  Result := AttributeNodes['" + a.имяXML + "'].Text;";
        ti.PropertyAccessors.Add(new Метод("function", "Get_" + a.Id + ": " + a.PascalType + ";",
                                           body));
      }
    }


    public void Сгенерировать(string имяВыходногоPascalФайла) {
      using (wr = new StreamWriter(имяВыходногоPascalФайла, false, Program.Кодировка)) {
        wr.WriteLine("// Модуль сгенерирован " + DateTime.Now + " программой " +
                     Assembly.GetExecutingAssembly().GetName());
        wr.WriteLine("// По всем вопросам обращайтесь к Денису Степулёнку +79117117850 (super.denis@gmail.com)");
        wr.WriteLine("{");
        wr.WriteLine(корень.ToString(2));
        wr.WriteLine("}");
        wr.WriteLine();
        // Получаем имя модуля по названию pascal файла
        string имяМодуля = new FileInfo(имяВыходногоPascalФайла).Name.ToLower().Replace(".pas", "");
        // Делаем первую букву названия модуля заглавной
        имяМодуля = имяМодуля.Substring(0, 1).ToUpper() + имяМодуля.Substring(1);
        wr.WriteLine("unit " + имяМодуля + ";");
        wr.WriteLine();
        wr.WriteLine("interface");
        wr.WriteLine();
        wr.WriteLine("uses xmldom, XMLDoc, XMLIntf;");
        wr.WriteLine();
        wr.WriteLine("type");
        wr.WriteLine();
        wr.WriteLine("{ Декларация интерфейсов }");
        wr.WriteLine();
        foreach (TypeInterface ti in TypeList) wr.WriteLine("  " + ti.InterfaceName + " = interface;");
        wr.WriteLine();
        foreach (TypeInterface ti in TypeList) ОписаниеИнтерфейса(ti);
        wr.WriteLine("{ Декларация типов }");
        wr.WriteLine();
        foreach (TypeInterface ti in TypeList) wr.WriteLine("  " + ti.TypeName + " = class;");
        wr.WriteLine();
        foreach (TypeInterface ti in TypeList) ОписаниеТипа(ti); 
        ЗаголовкиГлобальныхФункций();
        wr.WriteLine("const");
        wr.WriteLine("  TargetNamespace = '';");
        wr.WriteLine();
        wr.WriteLine("implementation");
        wr.WriteLine();
        ИмплементацияГлобальныхФункций();
        // Описание методов класса
        foreach (TypeInterface ti in TypeList) {
          wr.WriteLine("{ " + ti.TypeName + " }");
          wr.WriteLine();
          if (ti.AfterConstruction != "") {
            wr.WriteLine("procedure " + ti.TypeName + ".AfterConstruction;");
            wr.WriteLine("begin");
            wr.WriteLine(ti.AfterConstruction.TrimEnd());
            wr.WriteLine("  inherited;");
            wr.WriteLine("end;");
            wr.WriteLine();
          }
          foreach (Метод m in ti.PropertyAccessors) СгенерироватьМетод(ti, m);
          foreach (Метод m in ti.Methods) СгенерироватьМетод(ti, m);
        }
        wr.WriteLine("end.");
      }
    }

    private void ИмплементацияГлобальныхФункций() {
      wr.WriteLine("{ Global Functions }");
      wr.WriteLine();
      foreach (Function f in GlobalFunctions) {
        wr.WriteLine(f.Заголовок);
        wr.WriteLine("begin");
        wr.WriteLine(f.Тело);
        wr.WriteLine("end;");
        wr.WriteLine();
      }
    }

    private void ЗаголовкиГлобальныхФункций() {
      wr.WriteLine("{ Global Functions }");
      wr.WriteLine();
      foreach (Function f in GlobalFunctions) wr.WriteLine(f.Заголовок);
      wr.WriteLine();
    }

    private static void ОписаниеТипа(TypeInterface ti) {
      wr.WriteLine("{ " + ti.TypeName + " }");
      wr.WriteLine();
      wr.WriteLine("  " + ti.TypeName + " = " + ti.TypeType);
      if (ti.Fields.Count > 0) {
        wr.WriteLine("  private");
        foreach (string s in ti.Fields) wr.WriteLine("    " + s);
      }
      wr.WriteLine("  protected");
      wr.WriteLine("    { " + ti.InterfaceName + " }");
      foreach (Метод m in ti.PropertyAccessors) wr.WriteLine("    " + m.Декларация);
      foreach (Метод m in ti.Methods) wr.WriteLine("    " + m.Декларация);
      if (ti.AfterConstruction != "") {
        wr.WriteLine("  public");
        wr.WriteLine("    procedure AfterConstruction; override;");
      }
      wr.WriteLine("  end;");
      wr.WriteLine();
    }

    private static void ОписаниеИнтерфейса(TypeInterface ti) {
      wr.WriteLine("{ " + ti.InterfaceName + " }");
      wr.WriteLine();
      wr.WriteLine("  " + ti.InterfaceName + " = " + ti.InterfaceType);
      wr.WriteLine("    ['{" + Guid.NewGuid().ToString().ToUpper() + "}']");
      if (ti.PropertyAccessors.Count > 0) {
        wr.WriteLine("    { Property Accessors }");
        foreach (Метод m in ti.PropertyAccessors) wr.WriteLine("    " + m.Декларация);
      }
      wr.WriteLine("    { Methods & Properties }");
      foreach (Метод m in ti.Methods) wr.WriteLine("    " + m.Декларация);
      foreach (string p in ti.Properties) wr.WriteLine("    " + p);
      wr.WriteLine("  end;");
      wr.WriteLine();
    }

    private static void СгенерироватьМетод(TypeInterface ti, Метод m) {
      wr.WriteLine(m.типМетода + " " + ti.TypeName + "." + m.Заголовок);
      wr.WriteLine("begin");
      wr.WriteLine(m.Тело);
      wr.WriteLine("end;");
      wr.WriteLine();
    }
  }

  public class TypeInterface {
    public List<Метод> Methods = new List<Метод>();
    public List<Метод> PropertyAccessors = new List<Метод>();
    public List<string> Properties = new List<string>();
    public List<string> Fields = new List<string>();
    public string InterfaceName;
    public string InterfaceType;
    public string TypeName;
    public string TypeType;
    public string AfterConstruction = "";
  }

  public class Метод {
    public string типМетода;
    public string Декларация { get { return типМетода + " " + Заголовок; } }
    public string Заголовок;
    public string Тело;

    public Метод(string типМетода, string Заголовок, string Тело) {
      this.типМетода = типМетода;
      this.Заголовок = Заголовок;
      this.Тело = Тело;
    }
  }

  public class Function {
    public string Заголовок;
    public string Тело;

    public Function(string Заголовок, string Тело) {
      this.Заголовок = Заголовок;
      this.Тело = Тело;
    }
  }
}