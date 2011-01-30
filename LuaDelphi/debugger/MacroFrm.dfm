object frmMacro: TfrmMacro
  Left = 11
  Top = 110
  Caption = 'Lua Debugger'
  ClientHeight = 564
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS P????'
  Font.Style = []
  KeyPreview = True
  Menu = mnuMain
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 310
    Width = 688
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 287
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 432
    Width = 688
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 409
  end
  object Splitter4: TSplitter
    Left = 499
    Top = 41
    Width = 4
    Height = 269
    Align = alRight
    ExplicitHeight = 246
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnExecute: TButton
      Left = 160
      Top = 8
      Width = 49
      Height = 25
      Caption = '|>|>'
      TabOrder = 0
      OnClick = acRunExecute
    end
    object btnTrace: TButton
      Left = 272
      Top = 8
      Width = 25
      Height = 25
      Caption = '|>'
      TabOrder = 1
      OnClick = acTraceExecute
    end
    object btnPause: TButton
      Left = 208
      Top = 8
      Width = 25
      Height = 25
      Caption = '||'
      TabOrder = 2
      OnClick = acPauseExecute
    end
    object btnStop: TButton
      Left = 232
      Top = 8
      Width = 25
      Height = 25
      Caption = #166
      TabOrder = 3
      OnClick = acStopExecute
    end
    object btnStep: TButton
      Left = 296
      Top = 8
      Width = 25
      Height = 25
      Caption = '||>>'
      TabOrder = 4
      OnClick = acStepExecute
    end
    object chkDisp: TCheckBox
      Left = 440
      Top = 8
      Width = 49
      Height = 17
      Caption = '??'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object btnEval: TButton
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Caption = '??/??'
      TabOrder = 6
      OnClick = acEvalExecute
    end
    object btnUp: TButton
      Left = 320
      Top = 8
      Width = 25
      Height = 25
      Caption = '^'
      TabOrder = 7
      OnClick = acUpExecute
    end
    object cbTarget: TComboBox
      Left = 8
      Top = 8
      Width = 89
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 8
    end
    object chkInterlock: TCheckBox
      Left = 104
      Top = 8
      Width = 49
      Height = 17
      Caption = '??'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = chkInterlockClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 436
    Width = 688
    Height = 128
    Align = alBottom
    DockSite = True
    TabOrder = 1
    ExplicitTop = 425
    object pgcMessage: TPageControl
      Left = 1
      Top = 1
      Width = 686
      Height = 126
      ActivePage = TabSheet4
      Align = alClient
      TabOrder = 0
      object TabSheet3: TTabSheet
        Caption = '?????'
        object memMessage: TMemo
          Left = 0
          Top = 0
          Width = 678
          Height = 95
          Align = alClient
          TabOrder = 0
        end
      end
      object TabSheet4: TTabSheet
        Caption = '?????'
        ImageIndex = 1
        object memConsole: TMemo
          Left = 0
          Top = 0
          Width = 678
          Height = 95
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object pnlRight: TPanel
    Left = 503
    Top = 41
    Width = 185
    Height = 269
    Align = alRight
    TabOrder = 2
    ExplicitHeight = 258
    object pgcStack: TPageControl
      Left = 1
      Top = 1
      Width = 183
      Height = 267
      ActivePage = TabSheet6
      Align = alClient
      TabOrder = 0
      OnChange = pgcStackChange
      ExplicitHeight = 256
      object TabSheet6: TTabSheet
        Caption = '????'
        ExplicitHeight = 225
        object lstStack: TListBox
          Left = 0
          Top = 0
          Width = 175
          Height = 236
          Align = alClient
          ItemHeight = 16
          TabOrder = 0
          ExplicitHeight = 225
        end
      end
      object TabSheet7: TTabSheet
        Caption = '???????'
        ImageIndex = 1
        ExplicitHeight = 225
        object tvGlobal: TTreeView
          Left = 0
          Top = 0
          Width = 175
          Height = 236
          Align = alClient
          Indent = 19
          TabOrder = 0
          ExplicitHeight = 225
        end
      end
    end
  end
  object pnlBottom1: TPanel
    Left = 0
    Top = 314
    Width = 688
    Height = 118
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 303
    object Splitter2: TSplitter
      Left = 313
      Top = 1
      Width = 4
      Height = 116
    end
    object lstLocal: TListBox
      Left = 1
      Top = 1
      Width = 312
      Height = 116
      Align = alLeft
      ItemHeight = 16
      TabOrder = 0
    end
    object pgcWatch: TPageControl
      Left = 317
      Top = 1
      Width = 370
      Height = 116
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 1
      OnResize = pgcWatchResize
      object TabSheet1: TTabSheet
        Caption = '?????'
        object sgWatch: TStringGrid
          Left = 0
          Top = 0
          Width = 362
          Height = 85
          Align = alClient
          ColCount = 2
          DefaultRowHeight = 16
          FixedCols = 0
          RowCount = 10
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
          TabOrder = 0
          OnKeyDown = sgWatchKeyDown
          OnSelectCell = sgWatchSelectCell
          OnSetEditText = sgWatchSetEditText
        end
      end
      object TabSheet2: TTabSheet
        Caption = '??????????'
        ImageIndex = 1
        object sgBreak: TStringGrid
          Left = 0
          Top = 0
          Width = 362
          Height = 85
          Align = alClient
          ColCount = 2
          DefaultColWidth = 40
          DefaultRowHeight = 16
          FixedCols = 0
          RowCount = 10
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
          ScrollBars = ssVertical
          TabOrder = 0
          OnSelectCell = sgBreakSelectCell
        end
      end
      object TabSheet5: TTabSheet
        Caption = '??????'
        ImageIndex = 2
        object lstStackTrace: TListBox
          Left = 0
          Top = 0
          Width = 362
          Height = 85
          Align = alClient
          ItemHeight = 16
          TabOrder = 0
          OnClick = lstStackTraceClick
        end
      end
    end
  end
  object pgcEdit: TPageControl
    Left = 0
    Top = 41
    Width = 499
    Height = 269
    Align = alClient
    TabOrder = 4
    OnChange = pgcEditChange
    ExplicitHeight = 258
  end
  object JvHLEditor1: TJvHLEditor
    Left = 0
    Top = 41
    Width = 499
    Height = 269
    Cursor = crIBeam
    GutterWidth = 0
    RightMarginColor = clSilver
    Completion.ItemHeight = 13
    Completion.Interval = 800
    Completion.ListBoxStyle = lbStandard
    Completion.Templates.Strings = (
      'Test1'
      'Denis')
    Completion.CaretChar = '|'
    Completion.CRLF = '/n'
    Completion.Separator = '='
    TabStops = '3 5'
    BracketHighlighting.StringEscape = #39#39
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabStop = True
    UseDockManager = False
    Colors.Comment.Style = [fsItalic]
    Colors.Comment.ForeColor = clOlive
    Colors.Comment.BackColor = clWindow
    Colors.Number.ForeColor = clNavy
    Colors.Number.BackColor = clWindow
    Colors.Strings.ForeColor = clPurple
    Colors.Strings.BackColor = clWindow
    Colors.Symbol.ForeColor = clBlue
    Colors.Symbol.BackColor = clWindow
    Colors.Reserved.Style = [fsBold]
    Colors.Reserved.ForeColor = clWindowText
    Colors.Reserved.BackColor = clWindow
    Colors.Identifier.ForeColor = clWindowText
    Colors.Identifier.BackColor = clWindow
    Colors.Preproc.ForeColor = clGreen
    Colors.Preproc.BackColor = clWindow
    Colors.FunctionCall.ForeColor = clWindowText
    Colors.FunctionCall.BackColor = clWindow
    Colors.Declaration.ForeColor = clWindowText
    Colors.Declaration.BackColor = clWindow
    Colors.Statement.Style = [fsBold]
    Colors.Statement.ForeColor = clWindowText
    Colors.Statement.BackColor = clWindow
    Colors.PlainText.ForeColor = clWindowText
    Colors.PlainText.BackColor = clWindow
    ExplicitLeft = 3
    ExplicitTop = 40
  end
  object Button1: TButton
    Left = 599
    Top = 11
    Width = 89
    Height = 25
    Caption = 'Button1'
    TabOrder = 6
    OnClick = Button1Click
  end
  object mnuMain: TMainMenu
    Left = 624
    Top = 8
    object File1: TMenuItem
      Caption = #1060#1072#1081#1083' (&F)'
      object Open1: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        Hint = '??|??????????'
        ImageIndex = 8
        ShortCut = 16463
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '?????(&S)'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = '????????(&A)...'
        OnClick = SaveAs1Click
      end
      object V2: TMenuItem
        Caption = '?????(&V)'
        OnClick = V2Click
      end
      object Close1: TMenuItem
        Caption = '???(&C)'
        OnClick = Close1Click
      end
      object L1: TMenuItem
        Caption = '??????(&L)'
        OnClick = L1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '??(&X)'
        Hint = '??|?????????????'
        ImageIndex = 43
        OnClick = Exit1Click
      end
    end
    object R1: TMenuItem
      Caption = '??&R)'
      object N2: TMenuItem
        Caption = '??(&R)'
        ShortCut = 120
        OnClick = acRunExecute
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object S1: TMenuItem
        Caption = '??????(&S)'
        ShortCut = 119
        OnClick = acStepExecute
      end
      object T1: TMenuItem
        Caption = '??????(&T)'
        ShortCut = 118
        OnClick = acTraceExecute
      end
      object C1: TMenuItem
        Caption = '??????????(&C)'
        ShortCut = 115
        OnClick = acExecuteToCursorExecute
      end
      object U1: TMenuItem
        Caption = '????????????(&U)'
        ShortCut = 8311
        OnClick = acUpExecute
      end
      object G1: TMenuItem
        Caption = '????????(&G)'
        ImageIndex = 0
        OnClick = acPauseExecute
      end
      object E1: TMenuItem
        Caption = '????????(&E)'
        ShortCut = 16497
        OnClick = acStopExecute
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object V1: TMenuItem
        Caption = '??/??(&V)...'
        ShortCut = 16502
        OnClick = acEvalExecute
      end
      object W1: TMenuItem
        Caption = '??????(&W)...'
        ShortCut = 16500
        OnClick = acAddWatchExecute
      end
    end
    object Help1: TMenuItem
      Caption = '???(&H)'
      object AboutMenuItem: TMenuItem
        Caption = '???????(&A)...'
        OnClick = AboutMenuItemClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = '.lua'
    Filter = 'lua files(*.lua)|*.lua'
    Left = 496
    Top = 8
  end
  object dlgSave: TSaveDialog
    DefaultExt = '.lua'
    Filter = 'lua files(*.lua)|*.lua'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 528
    Top = 8
  end
  object alMain: TActionList
    Left = 560
    Top = 8
    object acStop: TAction
      Caption = '????????(&E)'
      ShortCut = 16497
      OnExecute = acStopExecute
    end
    object acExecuteToCursor: TAction
      Caption = '??????????(&C)'
      ShortCut = 115
      OnExecute = acExecuteToCursorExecute
    end
    object acAddWatch: TAction
      Caption = '??????(&W)...'
      ShortCut = 8308
      OnExecute = acAddWatchExecute
    end
    object acSetBreak: TAction
      Caption = '???????????(&B)'
      ShortCut = 116
      OnExecute = acSetBreakExecute
    end
    object acTrace: TAction
      Caption = '??????(&T)'
      ShortCut = 118
      OnExecute = acTraceExecute
    end
    object acStep: TAction
      Caption = '??????(&S)'
      ShortCut = 119
      OnExecute = acStepExecute
    end
    object acUp: TAction
      Caption = '????????????(&U)'
      ShortCut = 8311
      OnExecute = acUpExecute
    end
    object acRun: TAction
      Caption = '??(&R)'
      ShortCut = 120
      OnExecute = acRunExecute
    end
    object acPause: TAction
      Caption = '????????(&G)'
      ImageIndex = 0
      OnExecute = acPauseExecute
    end
    object acEval: TAction
      Caption = '??/??(&V)...'
      ShortCut = 16502
      OnExecute = acEvalExecute
    end
  end
  object XPManifest1: TXPManifest
    Left = 592
    Top = 8
  end
  object JvHLEdPropDlg1: TJvHLEdPropDlg
    JvHLEditor = JvHLEditor1
    ColorSamples.Strings = (
      '[Default]'
      'Plain text'
      'Selected text'
      ''
      '[Pascal]'
      '{ Syntax highlighting }'
      '{$DEFINE DELPHI}'
      'procedure TMain.JvHLEditorPreviewChangeStatus(Sender: TObject);'
      'const'
      '  Modi: array [Boolean] of string[10] = ('#39#39', '#39'Modified'#39');'
      
        '  Modes: array [Boolean] of string[10] = ('#39'Overwrite'#39', '#39'Insert'#39')' +
        ';'
      'begin'
      '  with StatusBar, JvHLEditorPreview do'
      '  begin'
      '    Panels[0].Text := IntToStr(CaretY) + '#39':'#39' + IntToStr(CaretX);'
      '    Panels[1].Text := Modi[Modified];'
      '    if ReadOnly then'
      '      Panels[2].Text := '#39'ReadOnly'#39'    else'
      '    if Recording then'
      '      Panels[2].Text := '#39'Recording'#39'    else'
      '      Panels[2].Text := Modes[InsertMode];'
      '    miFileSave.Enabled := Modified;'
      '  end;'
      'end;'
      '[]'
      ''
      '[CBuilder]'
      '/* Syntax highlighting */'
      '#include "zlib.h"'
      ''
      '#define local static'
      ''
      'local int crc_table_empty = 1;'
      ''
      'local void make_crc_table()'
      '{'
      '  uLong c;'
      '  int n, k;'
      '  uLong poly;            /* polynomial exclusive-or pattern */'
      '  /* terms of polynomial defining this crc (except x^32): */'
      '  static Byte p[] = {0,1,2,4,5,7,8,10,11,12,16,22,23,26};'
      ''
      '  /* make exclusive-or pattern from polynomial (0xedb88320L) */'
      '  poly = 0L;'
      '  for (n = 0; n < sizeof(p)/sizeof(Byte); n++)'
      '    poly |= 1L << (31 - p[n]);'
      ''
      '  for (n = 0; n < 256; n++)'
      '  {'
      '    c = (uLong)n;'
      '    for (k = 0; k < 8; k++)'
      '      c = c & 1 ? poly ^ (c >> 1) : c >> 1;'
      '    crc_table[n] = c;'
      '  }'
      '  crc_table_empty = 0;'
      '}'
      '[]'
      ''
      '[VB]'
      'Rem Syntax highlighting'
      'Sub Main()'
      '  Dim S as String'
      '  If S = "" Then'
      '   '#39' Do something'
      '   MsgBox "Hallo World"'
      '  End If'
      'End Sub'
      '[]'
      ''
      '[Sql]'
      '/* Syntax highlighting */'
      'declare external function Copy'
      '  cstring(255), integer, integer'
      '  returns cstring(255)'
      '  entry_point "Copy" module_name "nbsdblib";'
      '[]'
      ''
      '[Python]'
      '# Syntax highlighting'
      ''
      'from Tkinter import *'
      'from Tkinter import _cnfmerge'
      ''
      'class Dialog(Widget):'
      '  def __init__(self, master=None, cnf={}, **kw):'
      '    cnf = _cnfmerge((cnf, kw))'
      
        '    self.widgetName = '#39'__dialog__'#39'    Widget._setup(self, master' +
        ', cnf)'
      '    self.num = self.tk.getint('
      '      apply(self.tk.call,'
      '            ('#39'tk_dialog'#39', self._w,'
      '             cnf['#39'title'#39'], cnf['#39'text'#39'],'
      '             cnf['#39'bitmap'#39'], cnf['#39'default'#39'])'
      '            + cnf['#39'strings'#39']))'
      '    try: Widget.destroy(self)'
      '    except TclError: pass'
      '  def destroy(self): pass'
      '[]'
      ''
      '[Java]'
      '/* Syntax highlighting */'
      'public class utils {'
      
        '  public static String GetPropsFromTag(String str, String props)' +
        ' {'
      '    int bi;'
      '    String Res = "";'
      '    bi = str.indexOf(props);'
      '    if (bi > -1) {'
      '      str = str.substring(bi);'
      '      bi  = str.indexOf("\"");'
      '      if (bi > -1) {'
      '        str = str.substring(bi+1);'
      '        Res = str.substring(0, str.indexOf("\""));'
      '      } else Res = "true";'
      '    }'
      '    return Res;'
      '  }'
      '[]'
      ''
      '[Html]'
      '<html>'
      '<head>'
      '<meta name="GENERATOR" content="Microsoft FrontPage 3.0">'
      '<title>JVCLmp;A Library home page</title>'
      '</head>'
      ''
      
        '<body background="zertxtr.gif" bgcolor="#000000" text="#FFFFFF" ' +
        'link="#FF0000"'
      'alink="#FFFF00">'
      ''
      
        '<p align="left">Download last JVCLmp;A Library version now - <fo' +
        'nt face="Arial"'
      
        'color="#00FFFF"><a href="http://www.torry.ru/vcl/packs/ralib.zip' +
        '"><small>ralib110.zip</small></a>'
      
        '</font><font face="Arial" color="#008080"><small><small>(575 Kb)' +
        '</small></small></font>.</p>'
      ''
      '</body>'
      '</html>'
      '[]'
      ''
      '[Perl]'
      '#!/usr/bin/perl'
      '# Syntax highlighting'
      ''
      'require "webtester.pl";'
      ''
      '$InFile = "/usr/foo/scripts/index.shtml";'
      '$OutFile = "/usr/foo/scripts/sitecheck.html";'
      '$MapFile = "/usr/foo/scripts/sitemap.html";'
      ''
      'sub MainProg {'
      #9'require "find.pl";'
      #9'&Initialize;'
      #9'&SiteCheck;'
      #9'if ($MapFile) { &SiteMap; }'
      #9'exit;'
      '}'
      '[Ini]'
      ' ; Syntax highlighting'
      ' [drivers]'
      ' wave=mmdrv.dll'
      ' timer=timer.drv'
      ''
      ' plain text'
      '[Coco/R]'
      'TOKENS'
      '  NUMBER = digit { digit } .'
      '  EOL = eol .'
      ''
      'PRODUCTIONS'
      ''
      'ExprPostfix   ='
      '                       (. Output := '#39#39'; .)'
      '      Expression<Output>  EOL'
      '                       (. ShowOutput(Output); .)'
      '    .'
      '[]')
    Left = 16
    Top = 48
  end
end
