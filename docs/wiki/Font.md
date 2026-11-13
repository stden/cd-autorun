Font{ свойства } - создание шрифта. Возвращает Font - шрифт для Delphi.
  * **size** - размер шрифта
  * **bold** - true/false - жирный
  * **italic** - true/false - наклонный
  * **strikeout** - true/false - зачёркнутый
  * **underline** - true/false - подчёркнутый
  * **color** - (строка) цвет
  * **family** - (строка) тип, например:
    * <font face='Times New Roman'>Times New Roman</font>
    * <font face='Arial'>Arial</font>
    * <font face='Verdana'>Verdana</font>

Пример использования:
```
 -- Шрифт для всех "листиков"
  F = Font{ size=9, family="Arial", bold=false, italic=false, strikeout=false, underline=true, color="clGray" }
```