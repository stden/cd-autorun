object FormOrImageEditor: TFormOrImageEditor
  Left = 184
  Top = 142
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'TOrImage picture effects editor'
  ClientHeight = 263
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonReset: TButton
    Left = 7
    Top = 236
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 2
    OnClick = ButtonResetClick
  end
  object ButtonOK: TButton
    Left = 208
    Top = 235
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 632
    Height = 233
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 3
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Main seting'
      object Label1: TLabel
        Left = 3
        Top = 9
        Width = 43
        Height = 13
        Caption = 'Brigness:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 63
        Top = 9
        Width = 21
        Height = 13
        Caption = '-255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 596
        Top = 9
        Width = 18
        Height = 13
        Caption = '255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 3
        Top = 41
        Width = 39
        Height = 13
        Caption = 'Contrast'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 63
        Top = 41
        Width = 21
        Height = 13
        Caption = '-255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 593
        Top = 41
        Width = 24
        Height = 13
        Caption = '2550'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 139
        Top = 44
        Width = 5
        Height = 16
        Caption = 'I'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label8: TLabel
        Left = 338
        Top = 12
        Width = 5
        Height = 16
        Caption = 'I'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label9: TLabel
        Left = 3
        Top = 109
        Width = 45
        Height = 13
        Caption = 'Darkness'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 57
        Top = 108
        Width = 27
        Height = 13
        Caption = '-2550'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 596
        Top = 109
        Width = 18
        Height = 13
        Caption = '255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 537
        Top = 112
        Width = 5
        Height = 16
        Caption = 'I'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label13: TLabel
        Left = 3
        Top = 144
        Width = 45
        Height = 13
        Caption = 'Lightness'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 57
        Top = 143
        Width = 27
        Height = 13
        Caption = '-2550'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 596
        Top = 144
        Width = 18
        Height = 13
        Caption = '255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 537
        Top = 147
        Width = 5
        Height = 16
        Caption = 'I'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label21: TLabel
        Left = 3
        Top = 176
        Width = 39
        Height = 13
        Caption = 'Splitlight'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 78
        Top = 176
        Width = 6
        Height = 13
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 377
        Top = 176
        Width = 12
        Height = 13
        Caption = '10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label24: TLabel
        Left = 95
        Top = 179
        Width = 5
        Height = 16
        Caption = 'I'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label17: TLabel
        Left = 3
        Top = 73
        Width = 48
        Height = 13
        Caption = 'Saturation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 63
        Top = 73
        Width = 21
        Height = 13
        Caption = '-255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 593
        Top = 73
        Width = 24
        Height = 13
        Caption = '2550'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label20: TLabel
        Left = 139
        Top = 76
        Width = 5
        Height = 16
        Caption = 'I'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object TrackBarContrast: TTrackBar
        Left = 88
        Top = 28
        Width = 505
        Height = 26
        Hint = 'Contrast'
        Max = 2550
        Min = -255
        Orientation = trHorizontal
        PageSize = 10
        Frequency = 10
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 1
        ThumbLength = 15
        TickMarks = tmTopLeft
        TickStyle = tsAuto
        OnChange = TrackBarContrastChange
      end
      object TrackBarBrightness: TTrackBar
        Left = 88
        Top = -4
        Width = 505
        Height = 26
        Hint = 'Brightness'
        Max = 255
        Min = -255
        Orientation = trHorizontal
        PageSize = 10
        Frequency = 5
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        ThumbLength = 15
        TickMarks = tmTopLeft
        TickStyle = tsAuto
        OnChange = TrackBarBrightnessChange
      end
      object TrackBarDarkness: TTrackBar
        Left = 88
        Top = 96
        Width = 505
        Height = 26
        Hint = 'Darkness'
        Max = 255
        Min = -2550
        Orientation = trHorizontal
        PageSize = 10
        Frequency = 10
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 3
        ThumbLength = 15
        TickMarks = tmTopLeft
        TickStyle = tsAuto
        OnChange = TrackBarDarknessChange
      end
      object TrackBarLightness: TTrackBar
        Left = 88
        Top = 131
        Width = 505
        Height = 26
        Hint = 'Lightness'
        Max = 255
        Min = -2550
        Orientation = trHorizontal
        PageSize = 10
        Frequency = 10
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 4
        ThumbLength = 15
        TickMarks = tmTopLeft
        TickStyle = tsAuto
        OnChange = TrackBarLightnessChange
      end
      object TrackBarSplitlight: TTrackBar
        Left = 88
        Top = 163
        Width = 280
        Height = 26
        Hint = 'Splitlight'
        Orientation = trHorizontal
        PageSize = 10
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 5
        ThumbLength = 15
        TickMarks = tmTopLeft
        TickStyle = tsAuto
        OnChange = TrackBarSplitlightChange
      end
      object CheckBoxGrayscale: TCheckBox
        Left = 402
        Top = 176
        Width = 75
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Gray scale'
        TabOrder = 6
        OnClick = CheckBoxGrayscaleClick
      end
      object CheckBoxInvert: TCheckBox
        Left = 512
        Top = 176
        Width = 75
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Invert'
        TabOrder = 7
        OnClick = CheckBoxInvertClick
      end
      object TrackBarSaturation: TTrackBar
        Left = 88
        Top = 60
        Width = 505
        Height = 26
        Hint = 'Saturation'
        Max = 2550
        Min = -255
        Orientation = trHorizontal
        PageSize = 10
        Frequency = 10
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        ThumbLength = 15
        TickMarks = tmTopLeft
        TickStyle = tsAuto
        OnChange = TrackBarSaturationChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Addition effects 1'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 14
        Width = 622
        Height = 75
        Caption = 'Color OR Mono noise'
        TabOrder = 0
        object Label25: TLabel
          Left = 4
          Top = 20
          Width = 51
          Height = 13
          Caption = 'ColorNoise'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label26: TLabel
          Left = 101
          Top = 20
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label27: TLabel
          Left = 591
          Top = 20
          Width = 24
          Height = 13
          Caption = '5000'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label28: TLabel
          Left = 116
          Top = 23
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label29: TLabel
          Left = 4
          Top = 52
          Width = 54
          Height = 13
          Caption = 'MonoNoise'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label30: TLabel
          Left = 101
          Top = 52
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label31: TLabel
          Left = 116
          Top = 55
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label32: TLabel
          Left = 591
          Top = 52
          Width = 24
          Height = 13
          Caption = '5000'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object TrackBarColorNoise: TTrackBar
          Left = 109
          Top = 7
          Width = 482
          Height = 26
          Hint = 'ColorNoise'
          Max = 5000
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 25
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarColorNoiseChange
        end
        object TrackBarMonoNoise: TTrackBar
          Left = 109
          Top = 39
          Width = 482
          Height = 26
          Hint = 'MonoNoise'
          Max = 5000
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 25
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarMonoNoiseChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 1
        Top = 95
        Width = 622
        Height = 75
        Caption = 'Post. OR Solor.'
        TabOrder = 1
        object Label33: TLabel
          Left = 4
          Top = 20
          Width = 43
          Height = 13
          Caption = 'Posterize'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label34: TLabel
          Left = 101
          Top = 20
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label35: TLabel
          Left = 591
          Top = 20
          Width = 18
          Height = 13
          Caption = '500'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label36: TLabel
          Left = 116
          Top = 23
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label37: TLabel
          Left = 4
          Top = 52
          Width = 37
          Height = 13
          Caption = 'Solorize'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label38: TLabel
          Left = 101
          Top = 52
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label39: TLabel
          Left = 116
          Top = 55
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label40: TLabel
          Left = 591
          Top = 52
          Width = 18
          Height = 13
          Caption = '255'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object TrackBarPosterize: TTrackBar
          Left = 109
          Top = 7
          Width = 482
          Height = 26
          Hint = 'Posterize'
          Max = 500
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 2
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarPosterizeChange
        end
        object TrackBarSolorize: TTrackBar
          Left = 109
          Top = 39
          Width = 482
          Height = 26
          Hint = 'Solorize'
          Max = 255
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 2
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarSolorizeChange
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Addition effects 2'
      ImageIndex = 2
      object GroupBox3: TGroupBox
        Left = 1
        Top = 14
        Width = 622
        Height = 159
        Caption = 'OR add effects'
        TabOrder = 0
        object Label41: TLabel
          Left = 4
          Top = 21
          Width = 34
          Height = 13
          Caption = 'Mosaic'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label42: TLabel
          Left = 72
          Top = 21
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label43: TLabel
          Left = 295
          Top = 21
          Width = 18
          Height = 13
          Caption = '100'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label44: TLabel
          Left = 86
          Top = 24
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label45: TLabel
          Left = 4
          Top = 61
          Width = 38
          Height = 13
          Caption = 'SplitBlur'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label46: TLabel
          Left = 72
          Top = 61
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label47: TLabel
          Left = 295
          Top = 61
          Width = 18
          Height = 13
          Caption = '255'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label48: TLabel
          Left = 86
          Top = 64
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label49: TLabel
          Left = 3
          Top = 101
          Width = 62
          Height = 13
          Caption = 'GaussianBlur'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label50: TLabel
          Left = 72
          Top = 101
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label51: TLabel
          Left = 295
          Top = 101
          Width = 12
          Height = 13
          Caption = '50'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label52: TLabel
          Left = 86
          Top = 104
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label53: TLabel
          Left = 325
          Top = 21
          Width = 40
          Height = 13
          Caption = 'AntiAlias'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label54: TLabel
          Left = 388
          Top = 24
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label55: TLabel
          Left = 597
          Top = 21
          Width = 12
          Height = 13
          Caption = '50'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label56: TLabel
          Left = 325
          Top = 61
          Width = 28
          Height = 13
          Caption = 'Trace'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label57: TLabel
          Left = 388
          Top = 64
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label58: TLabel
          Left = 597
          Top = 61
          Width = 12
          Height = 13
          Caption = '10'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label59: TLabel
          Left = 325
          Top = 101
          Width = 17
          Height = 13
          Caption = 'Tile'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label60: TLabel
          Left = 388
          Top = 104
          Width = 5
          Height = 16
          Caption = 'I'
          Color = clRed
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label61: TLabel
          Left = 597
          Top = 101
          Width = 18
          Height = 13
          Caption = '100'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label62: TLabel
          Left = 372
          Top = 21
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label63: TLabel
          Left = 372
          Top = 61
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label64: TLabel
          Left = 372
          Top = 101
          Width = 6
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object TrackBarMosaic: TTrackBar
          Left = 79
          Top = 8
          Width = 215
          Height = 26
          Hint = 'Mosaic'
          Max = 100
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarMosaicChange
        end
        object TrackBarSplitBlur: TTrackBar
          Left = 79
          Top = 48
          Width = 215
          Height = 26
          Hint = 'SplitBlur'
          Max = 255
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 5
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarSplitBlurChange
        end
        object TrackBarGaussianBlur: TTrackBar
          Left = 79
          Top = 88
          Width = 215
          Height = 26
          Hint = 'GaussianBlur'
          Max = 50
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 2
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarGaussianBlurChange
        end
        object TrackBarAntiAlias: TTrackBar
          Left = 381
          Top = 8
          Width = 215
          Height = 26
          Hint = 'AntiAlias'
          Max = 50
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 3
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarAntiAliasChange
        end
        object Panel1: TPanel
          Left = 318
          Top = 9
          Width = 2
          Height = 146
          BevelOuter = bvLowered
          Caption = 'Panel1'
          TabOrder = 7
        end
        object TrackBarTrace: TTrackBar
          Left = 381
          Top = 48
          Width = 215
          Height = 26
          Hint = 'Trace'
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 4
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarTraceChange
        end
        object TrackBarTile: TTrackBar
          Left = 381
          Top = 88
          Width = 215
          Height = 26
          Hint = 'Tile'
          Max = 100
          Orientation = trHorizontal
          PageSize = 10
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 5
          ThumbLength = 15
          TickMarks = tmTopLeft
          TickStyle = tsAuto
          OnChange = TrackBarTileChange
        end
        object CheckBoxEmboss: TCheckBox
          Left = 3
          Top = 135
          Width = 96
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Emboss'
          TabOrder = 6
          OnClick = CheckBoxEmbossClick
        end
      end
    end
  end
  object PanelHint: TPanel
    Left = 445
    Top = 239
    Width = 185
    Height = 20
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 4
  end
  object ButtonCancel: TButton
    Left = 295
    Top = 235
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = ButtonCancelClick
  end
end
