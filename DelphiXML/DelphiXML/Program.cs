using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Schema;

namespace DelphiXML {
  public class Program {
    public static Encoding Кодировка = Encoding.GetEncoding("Windows-1251");

    public static void Main(string[] args) {
      if (args.Length >= 2) {
        string ИмяВходногоXMLФайла = args[0];
        string ИмяВыходногоPascalФайла = args[1];
        XmlSchema Схема = ПолучитьСхемуXMLФайла(ИмяВходногоXMLФайла);
        if (args.Length == 3) {
          string ИмяФайлаДляСохраненияXSDСхемы = args[2];
          ЗаписатьXSDСхемуВФайл(Схема, ИмяФайлаДляСохраненияXSDСхемы);
        }
        foreach (DictionaryEntry de in Схема.Elements) {
          Тэг корень = Build((XmlSchemaElement) de.Value);
          (new DelphiGenerator(корень)).Сгенерировать(ИмяВыходногоPascalФайла);
          break; // обрабатываем только первый элемент
        }
      } else Console.WriteLine("DelphiXML <ИмяВходногоXMLФайла> <ИмяВыходногоPascalФайла> [<ИмяФайлаДляСохраненияXSDСхемы>]");
    }

    public static void ЗаписатьXSDСхемуВФайл(XmlSchema схема, string имяФайлаДляСохраненияXSDСхемы) {
      using (XmlTextWriter writer = new XmlTextWriter(имяФайлаДляСохраненияXSDСхемы, Кодировка)) {
        writer.Indentation = 2; // отступ - 2 пробела
        writer.IndentChar = ' ';
        writer.Formatting = Formatting.Indented;
        схема.Write(writer);
      }
    }

    public static XmlSchema ПолучитьСхемуXMLФайла(string имяВходногоXMLФайла) {
      using (XmlTextReader reader = new XmlTextReader(имяВходногоXMLФайла)) {
        XmlSchemaSet наборСхем = (new XmlSchemaInference()).InferSchema(reader); // Получаем набор XSD схем 
        foreach (XmlSchema schema in наборСхем.Schemas()) return schema; // Нужна только первая схема
      }
      throw new Exception("Из XML файла " + имяВходногоXMLФайла + " не было получено ни одной схемы!");
    }

    /// <summary>
    /// Создаём в памяти дерево по XSD схеме
    /// XSD-схема, на мой взгляд, не самый удобочитаемый и наглядный вариант представления структуры данных.
    /// Поэтому я строю своё собственное дерево, в котором структура видна более явно.
    /// Для ещё большей наглядности структура записывается в начало генерируемого Pascal файла.
    /// </summary>
    /// <param name="schemaObject"></param>
    /// <returns>Дерево тегов</returns>
    public static Тэг Build(XmlSchemaObject schemaObject) {
      if (schemaObject == null) return null;
      Тэг тэг;
      Type type = schemaObject.GetType();
      switch (type.Name) {
        case "XmlSchemaElement":
          XmlSchemaElement element = (XmlSchemaElement) schemaObject;
          тэг = Build(element.ElementSchemaType);
          if (тэг == null) {
            тэг = new Тэг();
            тэг.типТэга = ТипТэга.ПростойТип;
          }
          тэг.имяXML = element.Name;
          тэг.TypeCode = element.ElementSchemaType.TypeCode;
          тэг.Повторяется = (element.MaxOccursString == "unbounded");
          break;
        case "XmlSchemaComplexType":
          XmlSchemaComplexType complexType = (XmlSchemaComplexType) schemaObject;
          тэг = Build(complexType.Particle);
          if (тэг == null) тэг = new Тэг();
          тэг.типТэга = ТипТэга.Структура;
          foreach (XmlSchemaAttribute schemaAttribute in complexType.Attributes) {
            Атрибут атрибут = new Атрибут();
            атрибут.имяXML = schemaAttribute.Name;
            атрибут.TypeCode = schemaAttribute.AttributeSchemaType.TypeCode;
            тэг.Атрибуты.Add(атрибут);
          }
          break;
        case "XmlSchemaSequence":
          XmlSchemaSequence schemaSequence = (XmlSchemaSequence) schemaObject;
          тэг = new Тэг();
          foreach (XmlSchemaObject item in schemaSequence.Items) тэг.ВложенныеТэги.Add(Build(item));
          break;
        case "XmlSchemaSimpleType":
          XmlSchemaSimpleType simpleType = (XmlSchemaSimpleType) schemaObject;
          тэг = new Тэг();
          //   тэг.Повторяется = (simpleType.MaxOccursString == "unbounded");
          break;
        default:
          string text = "case \"" + type.Name + "\":\n " + type.Name + " x = (" + type.Name + ") schemaObject;\n" +
                        "  break;";
          Clipboard.SetText(text);
          throw new Exception(text);
      }
      if (тэг == null) throw new Exception("Не сработал switch! " + schemaObject);
      return тэг;
    }
  }

  public class Атрибут {
    public string имяXML; // Имя тэга/атрибута в XML файле
    // Идентификатор для языка программирования
    public string Id { get { return Translit.toTranslit(имяXML.Substring(0, 1).ToUpper() + имяXML.Substring(1)); } }
    // Код типа в XML (исходный код для опеределения типа)
    public XmlTypeCode TypeCode;

    public virtual string ToString(int Табуляция) {
      string res = "";
      for (int i = 0; i < Табуляция; i++) res += " ";
      res += имяXML + "(" + Id + "):" + TypeCode;
      return res;
    }

    public override string ToString() {
      return ToString(0);
    }

    public virtual string PascalType {
      get {
        switch (TypeCode) {
          case XmlTypeCode.UnsignedInt:
          case XmlTypeCode.UnsignedShort:
          case XmlTypeCode.Short:
          case XmlTypeCode.UnsignedByte:
          case XmlTypeCode.Byte:
            return "Integer";
          case XmlTypeCode.String:
            return "WideString";
          case XmlTypeCode.None:
            return "";
          case XmlTypeCode.Boolean:
            return "Boolean";
          default:
            // Метод "постепенного наращивания", если будет использован неизвестный тип, нужно добавить
            // в этот метод его обработку
            string text = TypeCode.ToString();
            Clipboard.SetText(text);
            throw new Exception(text);
        }
      }
    }
  }

  public class Тэг : Атрибут {
    public ТипТэга типТэга = ТипТэга.ПростойТип;
    public bool Повторяется = false; // Может ли многократно повторяться этот тэг в XML файле
    public List<Атрибут> Атрибуты = new List<Атрибут>();
    public List<Тэг> ВложенныеТэги = new List<Тэг>();

    public override string ToString(int Табуляция) {
      string res = "";
      for (int i = 0; i < Табуляция; i++) res += " ";
      res += имяXML + "(" + Id + "):" + TypeCode + " " + типТэга;
      if (Повторяется) res += " Повторяется";
      foreach (Атрибут a in Атрибуты) res += Utils.NewLine + a.ToString(Табуляция + 2);
      foreach (Тэг t in ВложенныеТэги) res += Utils.NewLine + t.ToString(Табуляция + 2);
      return res;
    }

    public override string PascalType {
      get {
        if (типТэга == ТипТэга.Структура) {
          if (Повторяется) return "IXML" + Id + "List";
          else return "IXML" + Id;
        } else return base.PascalType;
      }
    }
  }

  public enum ТипТэга {
    ПростойТип,
    Структура
  }
}