{------------------------------------------------------------------------------
     Registration TOrImage component and property editor (TOrImageEditor) in VCL
         (c) 20.03.03 by Yurij Orishenko  e-mail: yraor@omen.ru
-------------------------------------------------------------------------------
}

unit OrImageRegD5;

interface

procedure Register;

implementation

Uses OrImage, OrImageEditor, DsgnIntf,
     Classes, SysUtils, Controls, Graphics, ExtCtrls, Dialogs, Forms,
     WinTypes, WinProcs, Messages;

{TOrImageEditor}

Type
  TOrImageEditor = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;


{TOrImageEditor}

procedure TOrImageEditor.Edit;
var
    FormOrImageEditor: TFormOrImageEditor;
    Comp: TOrImage;

    FBrightness: Integer;
    FContrast: Integer;
    FGrayScale: Boolean;
    FLightness: Integer;
    FDarkness: Integer;
    FSaturation: Integer;
    FSplitlight: Integer;
    FInvert: Boolean;
    FColorNoise: Integer;
    FMonoNoise: Integer;
    FPosterize: Integer;
    FSolorize: Integer;
    FEmboss: Boolean;
    FMosaic: Integer;
    FSplitBlur: Integer;
    FGaussianBlur: Integer;
    FAntiAlias: Integer;
    FTrace: Integer;
    FTile: Integer;
begin
  Comp:=(GetComponent(0) as TOrImage);  //Carently edit TOrImage
  with Comp do
  begin    // Save propertys before change
    FBrightness:=PicBrightness;
    FContrast:=PicContrast;
    FGrayScale:=PicGrayScale;
    FLightness:=PicLightness;
    FDarkness:=PicDarkness;
    FSaturation:=PicSaturation;
    FSplitlight:=PicSplitlight;
    FInvert:=PicInvert;
    FColorNoise:=PicColorNoise;
    FMonoNoise:=PicMonoNoise;
    FPosterize:=PicPosterize;
    FSolorize:=PicSolorize;
    FEmboss:=PicEmboss;
    FMosaic:=PicMosaic;
    FSplitBlur:=PicSplitBlur;
    FGaussianBlur:=PicGaussianBlur;
    FAntiAlias:=PicAntiAlias;
    FTrace:=PicTrace;
    FTile:=PicTile;
  end;
  FormOrImageEditor:=TFormOrImageEditor.Create(nil);
  try
    FormOrImageEditor.OrImage:=Comp;   //Set point to carently edit TOrImage
    if FormOrImageEditor.ShowModal<>mrOk then
  with Comp do
  begin   // Restore propertys if user press Cancel button
    PicBrightness:=FBrightness;
    PicContrast:=FContrast;
    PicGrayScale:=FGrayScale;
    PicLightness:=FLightness;
    PicDarkness:=FDarkness;
    PicSaturation:=FSaturation;
    PicSplitlight:=FSplitlight;
    PicInvert:=FInvert;
    PicColorNoise:=FColorNoise;
    PicMonoNoise:=FMonoNoise;
    PicPosterize:=FPosterize;
    PicSolorize:=FSolorize;
    PicEmboss:=FEmboss;
    PicMosaic:=FMosaic;
    PicSplitBlur:=FSplitBlur;
    PicGaussianBlur:=FGaussianBlur;
    PicAntiAlias:=FAntiAlias;
    PicTrace:=FTrace;
    PicTile:=FTile;
  end;
  finally
    FormOrImageEditor.Free;
  end;
end;

function TOrImageEditor.GetAttributes: TPropertyAttributes;
begin
  Result:= [paDialog, paReadOnly];
end;

function TOrImageEditor.GetValue: string;
begin
  Result:= '(Editor)';
end;

procedure Register;
begin
  RegisterComponents('Samples', [TOrImage]);
  RegisterPropertyEditor(TypeInfo(String), TOrImage, 'PictureEffects', TOrImageEditor);
end;

end.
