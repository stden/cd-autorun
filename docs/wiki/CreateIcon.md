
```
  CreateIcon(   -- создать ярлык
    "%ProgramFiles%\cd-autorun\autorun.exe" - Имя файла/каталога на который будет указывать ярлык
    LinkDir,     -- Имя каталога, где создать ярлык
    LinkName,    -- Имя ярлыка
    Arguments )  -- Параметры запуска программы
```

> В путях можно применять переменные окружения, например:
  * %ProgramFiles% -> C:\Program Files.

Пример:
```
   CreateIcon( GetRunDir(), ShellFolder("Desktop"), "Каталог с Autorun", "" )
```
> создание ярлыка на рабочем столе текущего пользователя для каталога запуска Autorun