object frmMain: TfrmMain
  Left = 175
  Top = 93
  Caption = '??.lua'
  ClientHeight = 566
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS P????'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Image1: TImage
    Left = 320
    Top = 11
    Width = 727
    Height = 748
  end
  object memCode: TMemo
    Left = 11
    Top = 11
    Width = 300
    Height = 417
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 437
    Width = 300
    Height = 322
    Caption = '??'
    TabOrder = 1
    object lblName: TLabel
      Left = 107
      Top = 139
      Width = 3
      Height = 16
    end
    object btnRun: TButton
      Left = 192
      Top = 53
      Width = 76
      Height = 34
      Caption = 'Run'
      TabOrder = 0
      OnClick = btnRunClick
    end
    object btnForward: TButton
      Left = 192
      Top = 171
      Width = 76
      Height = 33
      Caption = '??'
      TabOrder = 1
      OnClick = btnForwardClick
    end
    object btnBack: TButton
      Left = 21
      Top = 171
      Width = 79
      Height = 33
      Caption = '??'
      TabOrder = 2
      OnClick = btnBackClick
    end
    object btnRight: TButton
      Left = 192
      Top = 213
      Width = 76
      Height = 34
      Caption = '???'
      TabOrder = 3
      OnClick = btnRightClick
    end
    object chkRegist: TCheckBox
      Left = 21
      Top = 21
      Width = 98
      Height = 23
      Caption = '????'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object edtLength: TEdit
      Left = 107
      Top = 171
      Width = 54
      Height = 24
      TabOrder = 5
      Text = '100'
    end
    object edtAngle: TEdit
      Left = 107
      Top = 213
      Width = 54
      Height = 24
      TabOrder = 6
      Text = '45'
    end
    object udAngle: TUpDown
      Left = 161
      Top = 213
      Width = 20
      Height = 24
      Associate = edtAngle
      Min = -1000
      Max = 1000
      Position = 45
      TabOrder = 7
      Thousands = False
    end
    object udLength: TUpDown
      Left = 161
      Top = 171
      Width = 20
      Height = 24
      Associate = edtLength
      Min = -1000
      Max = 1000
      Position = 100
      TabOrder = 8
      Thousands = False
    end
    object btnLeft: TButton
      Left = 21
      Top = 213
      Width = 79
      Height = 34
      Caption = '???'
      TabOrder = 9
      OnClick = btnLeftClick
    end
    object btnGraphClear: TButton
      Left = 21
      Top = 256
      Width = 76
      Height = 33
      Caption = '???'
      TabOrder = 10
      OnClick = btnGraphClearClick
    end
    object btnCreate: TButton
      Left = 21
      Top = 128
      Width = 76
      Height = 33
      Caption = '??'
      TabOrder = 11
      OnClick = btnCreateClick
    end
    object btnDestroy: TButton
      Left = 192
      Top = 128
      Width = 76
      Height = 33
      Caption = '??'
      TabOrder = 12
      OnClick = btnDestroyClick
    end
    object btnLoad: TButton
      Left = 21
      Top = 53
      Width = 76
      Height = 34
      Caption = 'LOAD'
      TabOrder = 13
      OnClick = btnLoadClick
    end
    object btnSave: TButton
      Left = 107
      Top = 53
      Width = 76
      Height = 34
      Caption = 'SAVE'
      TabOrder = 14
      OnClick = btnSaveClick
    end
    object chkHide: TCheckBox
      Left = 181
      Top = 21
      Width = 98
      Height = 23
      Caption = '???'
      TabOrder = 15
    end
    object btnColor: TButton
      Left = 107
      Top = 256
      Width = 76
      Height = 33
      Caption = '?'
      TabOrder = 16
      OnClick = btnColorClick
    end
    object pnlColor: TPanel
      Left = 192
      Top = 256
      Width = 76
      Height = 33
      Color = clBlack
      TabOrder = 17
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = '.lua'
    Filter = 'lua files *.lua|*.lua'
    Left = 384
    Top = 288
  end
  object dlgSave: TSaveDialog
    DefaultExt = '.lua'
    Filter = 'lua files *.lua|*.lua'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 384
    Top = 312
  end
  object dlgColor: TColorDialog
    Left = 240
    Top = 512
  end
  object XPManifest: TXPManifest
    Left = 760
    Top = 528
  end
end
