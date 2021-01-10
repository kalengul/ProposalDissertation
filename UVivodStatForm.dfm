object FVivodStat: TFVivodStat
  Left = 192
  Top = 124
  Width = 1305
  Height = 865
  Caption = #1042#1099#1074#1086#1076' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PbVisual: TPaintBox
    Left = 8
    Top = 360
    Width = 1025
    Height = 433
  end
  object lbl1: TLabel
    Left = 544
    Top = 312
    Width = 58
    Height = 13
    Caption = #1052#1085#1086#1078#1080#1090#1077#1083#1100
  end
  object LbVibor: TListBox
    Left = 8
    Top = 8
    Width = 1265
    Height = 297
    ItemHeight = 13
    TabOrder = 0
    OnClick = LbViborClick
  end
  object LeMin: TLabeledEdit
    Left = 8
    Top = 328
    Width = 121
    Height = 21
    EditLabel.Width = 118
    EditLabel.Height = 13
    EditLabel.Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
    TabOrder = 1
    Text = '0'
    OnChange = LeMinChange
  end
  object LeMax: TLabeledEdit
    Left = 1152
    Top = 328
    Width = 121
    Height = 21
    EditLabel.Width = 123
    EditLabel.Height = 13
    EditLabel.Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
    TabOrder = 2
    OnChange = LeMaxChange
  end
  object SeShag: TSpinEdit
    Left = 544
    Top = 328
    Width = 121
    Height = 22
    MaxValue = 20000
    MinValue = 1
    TabOrder = 3
    Value = 1
    OnChange = SeShagChange
  end
end
