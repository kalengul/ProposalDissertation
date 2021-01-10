object FStat: TFStat
  Left = 452
  Top = 164
  Width = 826
  Height = 473
  Caption = #1042#1099#1074#1086#1076' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 8
    Top = 8
    Width = 50
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object LaName: TLabel
    Left = 72
    Top = 8
    Width = 40
    Height = 13
    Caption = 'LaName'
  end
  object Label1: TLabel
    Left = 352
    Top = 48
    Width = 77
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1086#1090#1082#1072#1079#1086#1074
  end
  object SgStat: TStringGrid
    Left = 8
    Top = 24
    Width = 337
    Height = 417
    ColCount = 3
    RowCount = 10
    TabOrder = 0
  end
  object SgFailure: TStringGrid
    Left = 352
    Top = 64
    Width = 457
    Height = 377
    ColCount = 3
    RowCount = 10
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object seNom: TSpinEdit
    Left = 448
    Top = 40
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
    OnChange = seNomChange
  end
end
