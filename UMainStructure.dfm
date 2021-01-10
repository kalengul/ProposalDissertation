object FMain: TFMain
  Left = -8
  Top = -8
  Width = 1932
  Height = 1056
  Caption = 'FMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LaGraph: TLabel
    Left = 8
    Top = 56
    Width = 3
    Height = 13
  end
  object Label6: TLabel
    Left = 816
    Top = 8
    Width = 49
    Height = 13
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083
  end
  object Label7: TLabel
    Left = 16
    Top = 176
    Width = 21
    Height = 13
    Caption = #1057#1041#1057
  end
  object Pb1: TPaintBox
    Left = 16
    Top = 272
    Width = 1881
    Height = 593
    OnMouseDown = Pb1MouseDown
  end
  object Label8: TLabel
    Left = 8
    Top = 112
    Width = 255
    Height = 37
    Caption = #1052#1086#1076#1077#1083#1100#1085#1086#1077' '#1074#1088#1077#1084#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LaModelTime: TLabel
    Left = 272
    Top = 112
    Width = 193
    Height = 37
    Caption = 'LaModelTime'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object BtLoad: TButton
    Left = 0
    Top = 8
    Width = 75
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1082#1072
    TabOrder = 0
    OnClick = BtLoadClick
  end
  object BtFailure: TButton
    Left = 80
    Top = 8
    Width = 105
    Height = 25
    Caption = #1054#1090#1082#1072#1079' '#1101#1083#1077#1084#1077#1085#1090#1072
    TabOrder = 1
    OnClick = BtFailureClick
  end
  object MeProt: TMemo
    Left = 816
    Top = 24
    Width = 569
    Height = 241
    Lines.Strings = (
      'MeProt')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object MeSBS: TMemo
    Left = 16
    Top = 192
    Width = 177
    Height = 65
    BevelInner = bvNone
    Lines.Strings = (
      'MeSBS')
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object BtSwitch: TButton
    Left = 192
    Top = 8
    Width = 89
    Height = 25
    Caption = #1042#1082#1083#1102#1095#1080#1090#1100
    TabOrder = 4
    OnClick = BtSwitchClick
  end
  object BtGoSBS: TButton
    Left = 288
    Top = 8
    Width = 73
    Height = 25
    Caption = #1064#1040#1043
    TabOrder = 5
    OnClick = BtGoSBSClick
  end
  object BtLoadAction: TButton
    Left = 0
    Top = 40
    Width = 185
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1077#1081#1089#1090#1074#1080#1081
    TabOrder = 6
    OnClick = BtLoadActionClick
  end
  object BtModelTime: TButton
    Left = 368
    Top = 8
    Width = 81
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1082
    TabOrder = 7
    OnClick = BtModelTimeClick
  end
  object EdModelTime: TEdit
    Left = 368
    Top = 40
    Width = 81
    Height = 21
    TabOrder = 8
    Text = '17520'
  end
  object BtDel: TButton
    Left = 192
    Top = 40
    Width = 73
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 9
    OnClick = BtDelClick
  end
  object BtGoStat: TButton
    Left = 456
    Top = 8
    Width = 81
    Height = 25
    Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
    TabOrder = 10
    OnClick = BtGoStatClick
  end
  object EdKolRealise: TEdit
    Left = 456
    Top = 40
    Width = 81
    Height = 21
    TabOrder = 11
    Text = '5'
  end
  object RgTypeProt: TRadioGroup
    Left = 632
    Top = 80
    Width = 169
    Height = 57
    Caption = 'RgTypeProt'
    ItemIndex = 0
    Items.Strings = (
      #1056#1072#1085#1080#1080#1081' '#1086#1090#1082#1072#1079
      #1055#1086#1079#1076#1085#1080#1081' '#1086#1090#1082#1072#1079)
    TabOrder = 12
  end
  object BtAddProt: TButton
    Left = 632
    Top = 48
    Width = 169
    Height = 33
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1088#1086#1090#1086#1082#1086#1083
    TabOrder = 13
    OnClick = BtAddProtClick
  end
  object BtOutputProtocol: TButton
    Left = 632
    Top = 8
    Width = 113
    Height = 33
    Caption = #1042#1099#1074#1086#1076' '#1087#1088#1086#1090#1086#1082#1086#1083#1086#1074
    TabOrder = 14
    OnClick = BtOutputProtocolClick
  end
  object BtSaveStatExcel: TButton
    Left = 544
    Top = 40
    Width = 73
    Height = 25
    Caption = 'to Excel'
    TabOrder = 15
    OnClick = BtSaveStatExcelClick
  end
  object BtGoToFailure: TButton
    Left = 536
    Top = 72
    Width = 81
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1082
    TabOrder = 16
    OnClick = BtGoToFailureClick
  end
  object CbElements: TComboBox
    Left = 8
    Top = 72
    Width = 521
    Height = 21
    ItemHeight = 13
    TabOrder = 17
    Text = 'CbElements'
    OnChange = CbElementsChange
  end
  object BtVivodStat: TButton
    Left = 544
    Top = 8
    Width = 73
    Height = 25
    Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
    TabOrder = 18
    OnClick = BtVivodStatClick
  end
end
