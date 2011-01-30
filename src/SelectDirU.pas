// Диалоговое окно выбора каталога
unit SelectDirU;

interface

uses Forms, Windows, ShlObj;

// Диалог выбора каталога
function SelectDir( TitleName:string; Obj:TForm ):string;

implementation

// Диалог выбора каталога
function SelectDir( TitleName:string; Obj:TForm ):string;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result := '';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := Obj.Handle;
  BrowseInfo.pszDisplayName := @DisplayName;
  TitleName := TitleName;
  BrowseInfo.lpszTitle := PChar(TitleName);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result:=TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

end.
