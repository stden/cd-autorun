object frmMain: TfrmMain
  Left = 219
  Top = 107
  Caption = #1044#1077#1084#1086#1085#1089#1090#1088#1072#1094#1080#1103' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1077#1081' '#1076#1074#1080#1078#1082#1072' Lua'
  ClientHeight = 641
  ClientWidth = 639
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS P????'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 213
    Top = 245
    Width = 154
    Height = 16
    Caption = '??????????????????????'
  end
  object Label2: TLabel
    Left = 309
    Top = 277
    Width = 70
    Height = 16
    Caption = '??????????'
  end
  object Label3: TLabel
    Left = 213
    Top = 309
    Width = 99
    Height = 16
    Caption = '?????(????????)'
  end
  object Label4: TLabel
    Left = 128
    Top = 405
    Width = 21
    Height = 16
    Caption = '???'
  end
  object Label5: TLabel
    Left = 341
    Top = 405
    Width = 14
    Height = 16
    Caption = '??'
  end
  object memLog: TMemo
    Left = 331
    Top = 427
    Width = 289
    Height = 204
    ScrollBars = ssVertical
    TabOrder = 27
  end
  object btnTest1: TButton
    Left = 11
    Top = 11
    Width = 100
    Height = 22
    Caption = 'TEST1'
    TabOrder = 1
    OnClick = btnTest1Click
  end
  object btnDebugger: TButton
    Left = 11
    Top = 469
    Width = 100
    Height = 34
    Caption = '????'
    TabOrder = 2
    OnClick = btnDebuggerClick
  end
  object btnAbout: TButton
    Left = 11
    Top = 512
    Width = 100
    Height = 33
    Caption = 'About'
    TabOrder = 3
    OnClick = btnAboutClick
  end
  object btnStop: TButton
    Left = 11
    Top = 427
    Width = 100
    Height = 33
    Cancel = True
    Caption = '??'
    TabOrder = 4
    OnClick = btnStopClick
  end
  object edtFile1: TEdit
    Left = 117
    Top = 11
    Width = 87
    Height = 24
    TabOrder = 5
    Text = 'hello.lua'
  end
  object edtFile2: TEdit
    Left = 117
    Top = 43
    Width = 87
    Height = 24
    TabOrder = 6
    Text = 'echo.lua'
  end
  object edtArg2: TEdit
    Left = 309
    Top = 43
    Width = 87
    Height = 24
    TabOrder = 7
    Text = 'lua'
  end
  object edtFile3: TEdit
    Left = 117
    Top = 75
    Width = 87
    Height = 24
    TabOrder = 8
    Text = 'lib.lua'
  end
  object edtArg3_1: TEdit
    Left = 309
    Top = 75
    Width = 87
    Height = 24
    TabOrder = 9
    Text = '1'
  end
  object edtArg3_2: TEdit
    Left = 405
    Top = 75
    Width = 87
    Height = 24
    TabOrder = 10
    Text = '2'
  end
  object edtFile4: TEdit
    Left = 117
    Top = 107
    Width = 87
    Height = 24
    TabOrder = 11
    Text = 'lib.lua'
  end
  object edtFunc4: TEdit
    Left = 213
    Top = 107
    Width = 87
    Height = 24
    TabOrder = 12
    Text = 'factorial'
  end
  object edtArg4: TEdit
    Left = 309
    Top = 107
    Width = 87
    Height = 24
    TabOrder = 13
    Text = '5'
  end
  object edtFile5: TEdit
    Left = 117
    Top = 139
    Width = 87
    Height = 24
    TabOrder = 14
    Text = 'lib.lua'
  end
  object edtFunc5: TEdit
    Left = 213
    Top = 139
    Width = 87
    Height = 24
    TabOrder = 15
    Text = 'sum'
  end
  object edtFunc3: TEdit
    Left = 213
    Top = 75
    Width = 87
    Height = 24
    TabOrder = 16
    Text = 'add'
  end
  object btnTest2: TButton
    Left = 11
    Top = 43
    Width = 100
    Height = 22
    Caption = 'TEST2'
    TabOrder = 17
    OnClick = btnTest2Click
  end
  object btnTest3: TButton
    Left = 11
    Top = 75
    Width = 100
    Height = 22
    Caption = 'TEST3'
    TabOrder = 18
    OnClick = btnTest3Click
  end
  object btnTest4: TButton
    Left = 11
    Top = 107
    Width = 100
    Height = 22
    Caption = 'TEST4'
    TabOrder = 19
    OnClick = btnTest4Click
  end
  object btnTest5: TButton
    Left = 11
    Top = 139
    Width = 100
    Height = 22
    Caption = 'TEST5'
    TabOrder = 20
    OnClick = btnTest5Click
  end
  object btnTest7: TButton
    Left = 11
    Top = 203
    Width = 100
    Height = 22
    Caption = 'TEST7'
    TabOrder = 0
    OnClick = btnTest7Click
  end
  object edtArg5: TEdit
    Left = 309
    Top = 139
    Width = 183
    Height = 24
    TabOrder = 21
    Text = '1,2,3,4,5,6,7,8,9,10'
  end
  object edtFile7: TEdit
    Left = 117
    Top = 203
    Width = 87
    Height = 24
    TabOrder = 22
    Text = 'lib.lua'
  end
  object edtFunc7: TEdit
    Left = 213
    Top = 203
    Width = 87
    Height = 24
    TabOrder = 23
    Text = 'dir'
  end
  object edtArg7: TEdit
    Left = 309
    Top = 203
    Width = 87
    Height = 24
    TabOrder = 24
    Text = '*.*'
  end
  object btnTest8: TButton
    Left = 11
    Top = 235
    Width = 100
    Height = 22
    Caption = 'TEST8'
    TabOrder = 25
    OnClick = btnTest8Click
  end
  object edtFile8: TEdit
    Left = 117
    Top = 235
    Width = 87
    Height = 24
    TabOrder = 26
    Text = 'synerror.lua'
  end
  object btnTest6: TButton
    Left = 11
    Top = 171
    Width = 100
    Height = 22
    Caption = 'TEST6'
    TabOrder = 28
    OnClick = btnTest6Click
  end
  object edtFile6: TEdit
    Left = 117
    Top = 171
    Width = 87
    Height = 24
    TabOrder = 29
    Text = 'lib.lua'
  end
  object edtFunc6: TEdit
    Left = 213
    Top = 171
    Width = 87
    Height = 24
    TabOrder = 30
    Text = 'multret'
  end
  object btnTest9: TButton
    Left = 11
    Top = 267
    Width = 100
    Height = 22
    Caption = 'TEST9'
    TabOrder = 31
    OnClick = btnTest9Click
  end
  object edtFile9: TEdit
    Left = 117
    Top = 267
    Width = 87
    Height = 24
    TabOrder = 32
    Text = 'global.lua'
  end
  object edtFunc9: TEdit
    Left = 213
    Top = 267
    Width = 87
    Height = 24
    TabOrder = 33
    Text = 'global_data'
  end
  object btnClear: TButton
    Left = 11
    Top = 555
    Width = 100
    Height = 33
    Caption = '???'
    TabOrder = 34
    OnClick = btnClearClick
  end
  object btnTest10: TButton
    Left = 11
    Top = 299
    Width = 100
    Height = 22
    Caption = 'TEST10'
    TabOrder = 35
    OnClick = btnTest10Click
  end
  object edtFile10: TEdit
    Left = 117
    Top = 299
    Width = 87
    Height = 24
    TabOrder = 36
    Text = 'infinite.lua'
  end
  object memRetValue: TMemo
    Left = 117
    Top = 427
    Width = 204
    Height = 204
    ScrollBars = ssVertical
    TabOrder = 37
  end
  object btnTest11: TButton
    Left = 11
    Top = 331
    Width = 100
    Height = 22
    Caption = 'TEST11'
    TabOrder = 38
    OnClick = btnTest11Click
  end
  object edtFile11: TEdit
    Left = 117
    Top = 331
    Width = 87
    Height = 24
    TabOrder = 39
    Text = 'call.lua'
  end
  object edtArg11_1: TEdit
    Left = 309
    Top = 331
    Width = 87
    Height = 24
    TabOrder = 40
    Text = 'echo.lua'
  end
  object btnTest12: TButton
    Left = 11
    Top = 363
    Width = 100
    Height = 22
    Caption = 'TEST12'
    TabOrder = 41
    OnClick = btnTest12Click
  end
  object edtFile12: TEdit
    Left = 117
    Top = 363
    Width = 87
    Height = 24
    TabOrder = 42
    Text = 'multret.lua'
  end
  object edtArg11_2: TEdit
    Left = 405
    Top = 331
    Width = 87
    Height = 24
    TabOrder = 43
    Text = 'hello'
  end
  object XPManifest: TXPManifest
    Left = 584
    Top = 8
  end
end
