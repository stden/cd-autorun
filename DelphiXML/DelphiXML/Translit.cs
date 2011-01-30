using System.Collections.Generic;
using csUnit;

namespace DelphiXML {
  public class Translit {
    public static string toTranslit(string str) {
      // Таблица для конвертации в транслит
      Dictionary<char, string> t = new Dictionary<char, string>();
      t.Add('а', "a");
      t.Add('б', "b");
      t.Add('в', "v");
      t.Add('г', "g");
      t.Add('д', "d");
      t.Add('е', "e");
      t.Add('ж', "zh");
      t.Add('з', "z");
      t.Add('и', "i");
      t.Add('й', "y");
      t.Add('к', "k");
      t.Add('л', "l");
      t.Add('м', "m");
      t.Add('н', "n");
      t.Add('о', "o");
      t.Add('п', "p");
      t.Add('р', "r");
      t.Add('с', "s");
      t.Add('т', "t");
      t.Add('у', "u");
      t.Add('ф', "f");
      t.Add('х', "h");
      t.Add('ц', "c");
      t.Add('ч', "ch");
      t.Add('ш', "sh");
      t.Add('щ', "shh");
      t.Add('ъ', "");
      t.Add('ы', "i");
      t.Add('ь', "");
      t.Add('э', "e");
      t.Add('ю', "u");
      t.Add('я', "ya");
      string res = "";
      for (int i = 0; i < str.Length; i++) {
        bool Прописная = (str[i] >= 'А') && (str[i] <= 'Я');
        bool Строчная = (str[i] >= 'а') && (str[i] <= 'я');
        if (Прописная || Строчная) {
          char lowerCase = str[i].ToString().ToLower()[0];
          string letter = t[lowerCase];
          if (Прописная && letter.Length >= 1) letter = letter.Substring(0, 1).ToUpper() + letter.Substring(1);
          res += letter;
        } else res += str[i];
      }
      return res;
    }
  }

  [TestFixture]
  public class TestTranslit {
    [Test]
    public void ТестированиеСлов() {
      Assert.Equals("Privet", Translit.toTranslit("Привет"));
      Assert.Equals("Ryacha", Translit.toTranslit("Ряча"));
      Assert.Equals("NeNadoMenyat'", Translit.toTranslit("NeNadoMenyat'"));
    }

    [Test]
    public void ТестированиеВсегоАлфавита() {
      Assert.Equals("ABVGDEZZhIKLMNOPRSTUFHCChShShhEUYa",
                    Translit.toTranslit("АБВГДЕЗЖИКЛМНОПРСТУФХЦЧШЩЬЭЮЯ"));
      Assert.Equals("abvgdezzhiklmnoprstufhcchshshheuya",
                    Translit.toTranslit("абвгдезжиклмнопрстуфхцчшщьэюя"));
    }
  }
}