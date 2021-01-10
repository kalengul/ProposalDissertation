object FVivodProtocol: TFVivodProtocol
  Left = 192
  Top = 107
  Width = 1234
  Height = 497
  Caption = #1042#1099#1074#1086#1076' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1086#1096#1080#1073#1086#1082
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
  object CbProtocol: TComboBox
    Left = 0
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = CbProtocolChange
  end
  object MeProtocol: TMemo
    Left = 0
    Top = 32
    Width = 1225
    Height = 433
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
