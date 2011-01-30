object frmEval: TfrmEval
  Left = 435
  Top = 237
  Caption = '??/??'
  ClientHeight = 231
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS P????'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 11
    Top = 53
    Width = 42
    Height = 16
    Caption = '??????'
  end
  object Label2: TLabel
    Left = 11
    Top = 256
    Width = 28
    Height = 16
    Caption = '????'
  end
  object Label3: TLabel
    Left = 11
    Top = 107
    Width = 14
    Height = 16
    Caption = '??'
  end
  object edtIdent: TEdit
    Left = 11
    Top = 75
    Width = 353
    Height = 24
    TabOrder = 0
  end
  object memValue: TMemo
    Left = 11
    Top = 128
    Width = 353
    Height = 119
    TabOrder = 1
  end
  object edtNewValue: TEdit
    Left = 11
    Top = 277
    Width = 353
    Height = 24
    TabOrder = 2
  end
  object btnEval: TButton
    Left = 11
    Top = 11
    Width = 100
    Height = 33
    Caption = '??(&V)'
    TabOrder = 3
    OnClick = btnEvalClick
  end
  object btnChange: TButton
    Left = 128
    Top = 11
    Width = 100
    Height = 33
    Caption = '??(&M)'
    TabOrder = 4
    OnClick = btnChangeClick
  end
end
