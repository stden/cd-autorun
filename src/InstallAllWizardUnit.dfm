object InstallAllWizardForm: TInstallAllWizardForm
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = #1046#1091#1088#1085#1072#1083' '#1074' '#1046#1091#1088#1085#1072#1083#1077' - '#1091#1089#1090#1072#1085#1086#1074#1082#1072' '#1085#1072' '#1082#1086#1084#1087#1100#1102#1090#1077#1088
  ClientHeight = 297
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TsPanel
    Left = 0
    Top = 235
    Width = 554
    Height = 62
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    DesignSize = (
      554
      62)
    object CancelButton: TsButton
      Left = 472
      Top = 32
      Width = 75
      Height = 25
      Hint = #1047#1072#1082#1088#1099#1090#1100' Wizard'
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = CancelButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object BackButton: TsButton
      Left = 296
      Top = 32
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '< '#1053#1072#1079#1072#1076
      Enabled = False
      TabOrder = 1
      OnClick = BackButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
    object NextButton: TsButton
      Left = 377
      Top = 32
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1083#1077#1077' >'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = NextButtonClick
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object PageControl1: TsPageControl
    Left = 0
    Top = 0
    Width = 554
    Height = 235
    ActivePage = WelcomeStep
    Align = alClient
    TabOrder = 1
    SkinData.SkinSection = 'PAGECONTROL'
    object WelcomeStep: TsTabSheet
      Caption = 'WelcomeStep'
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      object WizardImage: TImage
        Left = 0
        Top = 0
        Width = 161
        Height = 225
        Align = alLeft
        ExplicitHeight = 232
      end
      object WelcomeText: TsLabel
        Left = 184
        Top = 16
        Width = 65
        Height = 13
        Caption = 'WelcomeText'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
    end
    object Step1: TsTabSheet
      Caption = 'Step1'
      ImageIndex = 1
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object InstallButton: TsButton
        Left = 380
        Top = 174
        Width = 75
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
        TabOrder = 0
        SkinData.SkinSection = 'BUTTON'
      end
    end
    object TabSheet1: TsTabSheet
      Caption = 'TabSheet1'
      ImageIndex = 2
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet2: TsTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 3
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
