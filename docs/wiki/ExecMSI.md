
```
 ExecMSI( MSI_FileName ) 
```

- запуск MSI-файла (файла инсталлятора в формате Microsoft)

Функция ожидает завершение файла.

Пример использования:

```
-- Выполнение установки FoxitReader
ExecMSI("msi\\FoxitReader30.msi");
```