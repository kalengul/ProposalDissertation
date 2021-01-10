object FVivodParameters: TFVivodParameters
  Left = 456
  Top = 235
  Width = 532
  Height = 464
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1077#1088#1096#1080#1085#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 45
    Height = 13
    Caption = #1055#1086#1076#1075#1088#1072#1092
  end
  object Label5: TLabel
    Left = 176
    Top = 224
    Width = 99
    Height = 13
    Caption = #1047#1072#1074#1080#1089#1080#1084#1099#1077' '#1086#1090#1082#1072#1079#1099
  end
  object Label2: TLabel
    Left = 176
    Top = 48
    Width = 39
    Height = 13
    Caption = #1054#1090#1082#1072#1079#1099
  end
  object Label3: TLabel
    Left = 8
    Top = 224
    Width = 126
    Height = 13
    Caption = #1044#1091#1073#1083#1080#1088#1091#1102#1097#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
  end
  object Label4: TLabel
    Left = 8
    Top = 328
    Width = 43
    Height = 13
    Caption = #1044#1072#1090#1095#1080#1082#1080
  end
  object LbStructure: TListBox
    Left = 8
    Top = 24
    Width = 161
    Height = 193
    ItemHeight = 13
    TabOrder = 0
    OnClick = LbStructureClick
  end
  object SgFailure: TStringGrid
    Left = 176
    Top = 64
    Width = 337
    Height = 153
    TabOrder = 1
  end
  object LeTimeGo: TLabeledEdit
    Left = 176
    Top = 24
    Width = 89
    Height = 21
    EditLabel.Width = 77
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1088#1077#1084#1103' '#1079#1072#1087#1091#1089#1082#1072
    TabOrder = 2
  end
  object SgRelation: TStringGrid
    Left = 176
    Top = 243
    Width = 337
    Height = 182
    TabOrder = 3
  end
  object MeDouble: TMemo
    Left = 8
    Top = 240
    Width = 161
    Height = 81
    Lines.Strings = (
      'MeDouble')
    TabOrder = 4
  end
  object MeSensor: TMemo
    Left = 8
    Top = 347
    Width = 161
    Height = 81
    Lines.Strings = (
      'MeDouble')
    TabOrder = 5
  end
end
