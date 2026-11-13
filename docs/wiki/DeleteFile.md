
```
DeleteFile( FileName ) -- удалить файл
```

Возвращает true - если файл удалён успешно и false в противном случае.

Пример использования:
```
  -- Удаление ярлыка программы с рабочего стола
  DeleteFile( ShellFolder("Desktop").."\\"..ProductName..".lnk" )
```