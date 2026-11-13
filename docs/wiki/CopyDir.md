
```
 CopyDir( fromDir, toDir ) 
```
  * **fromDir** - каталог который копировать
  * **toDir** - в какой каталог копировать

Пример - программа копирует сама себя на жёсткий диск:
```
    CopyDir( GetRunDir(), "%ProgramFiles%\cd-autorun" )
```