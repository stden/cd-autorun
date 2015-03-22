
```
  RegGetValue( имя_ключа, имя_значения, значение ) 
```

```
  RegGetValue( имя_ключа, имя_значения ) 
```

> Пример:

```
     Message("HKEY_CLASSES_ROOT\\.pdf - Content Type = "..RegGetValue("HKEY_CLASSES_ROOT\\.pdf","Content Type"))
```