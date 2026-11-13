{------------------------------------------------------------------------------
              Property editor form for TOrImage component
         (c) 20.03.03 by Yurij Orishenko  e-mail: yraor@omen.ru
-------------------------------------------------------------------------------
}

unit OrImageEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OrImage;

type
  TFormOrImageEditor = class(TForm)
    ButtonReset: TButton;
    ButtonOK: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    TrackBarContrast: TTrackBar;
    TrackBarBrightness: TTrackBar;
    TrackBarDarkness: TTrackBar;
    TrackBarLightness: TTrackBar;
    TrackBarSplitlight: TTrackBar;
    CheckBoxGrayscale: TCheckBox;
    CheckBoxInvert: TCheckBox;
    TrackBarSaturation: TTrackBar;
    GroupBox1: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    TrackBarColorNoise: TTrackBar;
    TrackBarMonoNoise: TTrackBar;
    GroupBox2: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    TrackBarPosterize: TTrackBar;
    TrackBarSolorize: TTrackBar;
    GroupBox3: TGroupBox;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    TrackBarMosaic: TTrackBar;
    TrackBarSplitBlur: TTrackBar;
    TrackBarGaussianBlur: TTrackBar;
    TrackBarAntiAlias: TTrackBar;
    Panel1: TPanel;
    TrackBarTrace: TTrackBar;
    TrackBarTile: TTrackBar;
    CheckBoxEmboss: TCheckBox;
    PanelHint: TPanel;
    ButtonCancel: TButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBarBrightnessChange(Sender: TObject);
    procedure TrackBarContrastChange(Sender: TObject);
    procedure TrackBarSaturationChange(Sender: TObject);
    procedure TrackBarDarknessChange(Sender: TObject);
    procedure TrackBarLightnessChange(Sender: TObject);
    procedure TrackBarSplitlightChange(Sender: TObject);
    procedure CheckBoxGrayscaleClick(Sender: TObject);
    procedure CheckBoxInvertClick(Sender: TObject);
    procedure TrackBarColorNoiseChange(Sender: TObject);
    procedure TrackBarMonoNoiseChange(Sender: TObject);
    procedure TrackBarPosterizeChange(Sender: TObject);
    procedure TrackBarSolorizeChange(Sender: TObject);
    procedure TrackBarMosaicChange(Sender: TObject);
    procedure TrackBarSplitBlurChange(Sender: TObject);
    procedure TrackBarGaussianBlurChange(Sender: TObject);
    procedure TrackBarAntiAliasChange(Sender: TObject);
    procedure TrackBarTraceChange(Sender: TObject);
    procedure TrackBarTileChange(Sender: TObject);
    procedure CheckBoxEmbossClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateAddEffects_2Controls;
  public
    { Public declarations }
    OrImage: TOrImage;                    // Point to editing TOrImage component
    procedure UpdateAllEffectsControls;
  end;


implementation

{$R *.DFM}

const strTrueORFalse: array[Boolean]of string = ('false','true');


procedure TFormOrImageEditor.UpdateAddEffects_2Controls;
begin
  if OrImage<> nil then with OrImage do
  begin
    TrackBarMosaic.Position:=PicMosaic;
    TrackBarSplitBlur.Position:=PicSplitBlur;
    TrackBarGaussianBlur.Position:=PicGaussianBlur;
    TrackBarAntiAlias.Position:=PicAntiAlias;
    TrackBarTrace.Position:=PicTrace;
    TrackBarTile.Position:=PicTile;
    CheckBoxEmboss.Checked:=PicEmboss;
    PanelHint.Caption:='';
  end;
end;

procedure TFormOrImageEditor.UpdateAllEffectsControls;
begin
  if OrImage<> nil then with OrImage do
  begin
    TrackBarBrightness.Position:=PicBrightness;
    TrackBarContrast.Position:=PicContrast;
    TrackBarDarkness.Position:=PicDarkness;
    TrackBarLightness.Position:=PicLightness;
    TrackBarSplitlight.Position:=PicSplitlight;
    CheckBoxGrayscale.Checked:=PicGrayscale;
    CheckBoxInvert.Checked:=PicInvert;
    TrackBarColorNoise.Position:=PicColorNoise;
    TrackBarMonoNoise.Position:=PicMonoNoise;
    TrackBarPosterize.Position:=PicPosterize;
    TrackBarSolorize.Position:=PicSolorize;
    TrackBarMosaic.Position:=PicMosaic;
    TrackBarSplitBlur.Position:=PicSplitBlur;
    TrackBarGaussianBlur.Position:=PicGaussianBlur;
    TrackBarAntiAlias.Position:=PicAntiAlias;
    TrackBarTrace.Position:=PicTrace;
    TrackBarTile.Position:=PicTile;
    TrackBarSaturation.Position:=PicSaturation;
    CheckBoxEmboss.Checked:=PicEmboss;
    PanelHint.Caption:='';
  end;
end;

procedure TFormOrImageEditor.ButtonOKClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TFormOrImageEditor.ButtonResetClick(Sender: TObject);
begin
  if OrImage<> nil then
  begin
    OrImage.ResetEffects;                  // Return to default values and original picture
    UpdateAllEffectsControls;
  end;
end;

procedure TFormOrImageEditor.FormActivate(Sender: TObject);
begin
  if OrImage<>nil then  UpdateAllEffectsControls;
end;

procedure TFormOrImageEditor.FormCreate(Sender: TObject);
begin
  OrImage:=nil;
end;

procedure TFormOrImageEditor.TrackBarBrightnessChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicBrightness:=TrackBarBrightness.Position;
  PanelHint.Caption:='PicBrightness='+IntToStr(OrImage.PicBrightness)+' ';
end;

procedure TFormOrImageEditor.TrackBarContrastChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicContrast:=TrackBarContrast.Position;
  PanelHint.Caption:='PicContrast='+IntToStr(OrImage.PicContrast)+' ';
end;

procedure TFormOrImageEditor.TrackBarSaturationChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicSaturation:=TrackBarSaturation.Position;
  PanelHint.Caption:='PicSaturation='+IntToStr(OrImage.PicSaturation)+' ';
end;

procedure TFormOrImageEditor.TrackBarDarknessChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicDarkness:=TrackBarDarkness.Position;
  PanelHint.Caption:='PicDarkness='+IntToStr(OrImage.PicDarkness)+' ';
end;

procedure TFormOrImageEditor.TrackBarLightnessChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicLightness:=TrackBarLightness.Position;
  PanelHint.Caption:='PicLightness='+IntToStr(OrImage.PicLightness)+' ';
end;

procedure TFormOrImageEditor.TrackBarSplitlightChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicSplitlight:=TrackBarSplitlight.Position;
  PanelHint.Caption:='PicSplitlight='+IntToStr(OrImage.PicSplitlight)+' ';
end;

procedure TFormOrImageEditor.CheckBoxGrayscaleClick(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicGrayscale:=CheckBoxGrayscale.Checked;
  PanelHint.Caption:='PicGrayscale='+strTrueORFalse[OrImage.PicGrayscale]+' ';
end;

procedure TFormOrImageEditor.CheckBoxInvertClick(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicInvert:=CheckBoxInvert.Checked;
  PanelHint.Caption:='PicInvert='+strTrueORFalse[OrImage.PicInvert]+' ';
end;

procedure TFormOrImageEditor.TrackBarColorNoiseChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicColorNoise:=TrackBarColorNoise.Position;
  TrackBarMonoNoise.Position:=OrImage.PicMonoNoise;
  PanelHint.Caption:='PicColorNoise='+IntToStr(OrImage.PicColorNoise)+' ';
end;

procedure TFormOrImageEditor.TrackBarMonoNoiseChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicMonoNoise:=TrackBarMonoNoise.Position;
  TrackBarColorNoise.Position:=OrImage.PicColorNoise;
  PanelHint.Caption:='PicMonoNoise='+IntToStr(OrImage.PicMonoNoise)+' ';
end;

procedure TFormOrImageEditor.TrackBarPosterizeChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicPosterize:=TrackBarPosterize.Position;
  TrackBarSolorize.Position:=OrImage.PicSolorize;
  PanelHint.Caption:='PicPosterize='+IntToStr(OrImage.PicPosterize)+' ';
end;

procedure TFormOrImageEditor.TrackBarSolorizeChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicSolorize:=TrackBarSolorize.Position;
  TrackBarPosterize.Position:=OrImage.PicPosterize;
  PanelHint.Caption:='PicSolorize='+IntToStr(OrImage.PicSolorize)+' ';
end;

procedure TFormOrImageEditor.TrackBarMosaicChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicMosaic:=TrackBarMosaic.Position;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicMosaic='+IntToStr(OrImage.PicMosaic)+' ';
end;

procedure TFormOrImageEditor.TrackBarSplitBlurChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicSplitBlur:=TrackBarSplitBlur.Position;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicSplitBlur='+IntToStr(OrImage.PicSplitBlur)+' ';
end;

procedure TFormOrImageEditor.TrackBarGaussianBlurChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicGaussianBlur:=TrackBarGaussianBlur.Position;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicGaussianBlur='+IntToStr(OrImage.PicGaussianBlur)+' ';
end;

procedure TFormOrImageEditor.TrackBarAntiAliasChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicAntiAlias:=TrackBarAntiAlias.Position;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicAntiAlias='+IntToStr(OrImage.PicAntiAlias)+' ';
end;

procedure TFormOrImageEditor.TrackBarTraceChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicTrace:=TrackBarTrace.Position;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicTrace='+IntToStr(OrImage.PicTrace)+' ';
end;

procedure TFormOrImageEditor.TrackBarTileChange(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicTile:=TrackBarTile.Position;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicTile='+IntToStr(OrImage.PicTile)+' ';
end;

procedure TFormOrImageEditor.CheckBoxEmbossClick(Sender: TObject);
begin
  if OrImage=nil then Exit;
  OrImage.PicEmboss:=CheckBoxEmboss.Checked;
  UpdateAddEffects_2Controls;
  PanelHint.Caption:='PicEmboss='+strTrueORFalse[OrImage.PicEmboss]+' ';
end;

procedure TFormOrImageEditor.PageControl1Change(Sender: TObject);
begin
  PanelHint.Caption:='';
end;

procedure TFormOrImageEditor.ButtonCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
