object InstallWizardForm: TInstallWizardForm
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'InstallWizardForm'
  ClientHeight = 294
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TsPanel
    Left = 0
    Top = 248
    Width = 562
    Height = 46
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkSoft
    BevelOuter = bvLowered
    BevelWidth = 3
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object SkipButton: TsButton
      Left = 464
      Top = 8
      Width = 91
      Height = 25
      Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = SkipButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object PageControl1: TsPageControl
    Left = 0
    Top = 0
    Width = 562
    Height = 248
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    SkinData.SkinSection = 'PAGECONTROL'
    object TabSheet1: TsTabSheet
      Caption = 'TabSheet1'
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      object Label2: TsLabel
        Left = 16
        Top = 72
        Width = 328
        Height = 13
        Caption = #1044#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1084#1086#1076#1077#1083#1080' '#1042#1072#1084' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1099' '#1089#1083#1077#1076#1091#1102#1097#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object Label3: TsLabel
        Left = 16
        Top = 168
        Width = 448
        Height = 13
        Caption = 
          #1055#1086#1089#1083#1077' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1085#1077#1076#1086#1089#1090#1072#1102#1097#1080#1093' '#1082#1086#1084#1087#1086#1085#1077#1085#1090' '#1087#1088#1086#1080#1079#1086#1081#1076#1077#1090' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' ' +
          #1079#1072#1087#1091#1089#1082' '#1084#1086#1076#1077#1083#1080'.'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object Image1: TImage
        Left = 448
        Top = 104
        Width = 40
        Height = 25
      end
      object Label4: TsLabel
        Left = 16
        Top = 104
        Width = 31
        Height = 13
        Caption = 'Label4'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object TopPanel: TsPanel
        Left = 0
        Top = 0
        Width = 554
        Height = 57
        Align = alTop
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        SkinData.SkinSection = 'PANEL'
        object Label1: TsLabel
          Left = 16
          Top = 16
          Width = 94
          Height = 13
          Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1089#1080#1089#1090#1077#1084#1099
          ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
      end
      object InstallButton: TsButton
        Left = 464
        Top = 213
        Width = 90
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
        TabOrder = 1
        OnClick = InstallButtonClick
        SkinData.SkinSection = 'BUTTON'
      end
    end
    object TabSheet2: TsTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
end
