namespace DelphiXML {
  public class Text {
    public int Tab;
    public string Res = "";

    public void Add(string str) {
      if (str != "") {
        for (int i = 0; i < Tab; i++) Res += " ";
        Res += str;
      }
      Res += Utils.NewLine;
    }

    public void Add() {
      Add("");
    }
  }
}