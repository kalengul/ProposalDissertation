object FMainAnt: TFMainAnt
  Left = 192
  Top = 124
  Width = 1305
  Height = 675
  Caption = #1052#1077#1090#1086#1076' '#1084#1091#1088#1072#1074#1100#1080#1085#1099#1093' '#1082#1086#1083#1086#1085#1080#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 637
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 248
      Width = 104
      Height = 13
      Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1092#1077#1088#1086#1084#1086#1085
    end
    object Label2: TLabel
      Left = 8
      Top = 288
      Width = 123
      Height = 13
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1092#1077#1088#1086#1084#1086#1085#1072
    end
    object Label3: TLabel
      Left = 8
      Top = 376
      Width = 104
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1075#1077#1085#1090#1086#1074
    end
    object Label4: TLabel
      Left = 8
      Top = 416
      Width = 123
      Height = 13
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1092#1077#1088#1086#1084#1086#1085#1072
    end
    object Label5: TLabel
      Left = 8
      Top = 456
      Width = 126
      Height = 13
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1080#1089#1087#1072#1088#1077#1085#1080#1103
    end
    object MeProt: TMemo
      Left = 0
      Top = 0
      Width = 425
      Height = 241
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object EdNatPher: TEdit
      Left = 8
      Top = 264
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '0,1'
    end
    object EdKoefPher: TEdit
      Left = 8
      Top = 304
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '100'
    end
    object BtCreateAntGraph: TButton
      Left = 8
      Top = 336
      Width = 129
      Height = 33
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1075#1088#1072#1092
      TabOrder = 3
      OnClick = BtCreateAntGraphClick
    end
    object BtAddSolution: TButton
      Left = 144
      Top = 256
      Width = 169
      Height = 33
      Caption = 'BtAddSolution'
      TabOrder = 4
      OnClick = BtAddSolutionClick
    end
    object BtLoadSolution: TButton
      Left = 144
      Top = 296
      Width = 169
      Height = 33
      Caption = 'BtLoadSolution'
      TabOrder = 5
      OnClick = BtLoadSolutionClick
    end
    object BtGoAnt: TButton
      Left = 8
      Top = 496
      Width = 169
      Height = 33
      Caption = 'BtGoAnt'
      TabOrder = 6
      OnClick = BtGoAntClick
    end
    object EdKolAgent: TEdit
      Left = 8
      Top = 392
      Width = 121
      Height = 21
      TabOrder = 7
      Text = '50'
    end
    object EdKoefPheromon: TEdit
      Left = 8
      Top = 432
      Width = 121
      Height = 21
      TabOrder = 8
      Text = '200'
    end
    object EdKoefIspar: TEdit
      Left = 8
      Top = 472
      Width = 121
      Height = 21
      TabOrder = 9
      Text = 'EdKoefIspar'
    end
  end
  object pnl2: TPanel
    Left = 441
    Top = 0
    Width = 848
    Height = 637
    Align = alClient
    TabOrder = 1
    object PbAntGraph: TPaintBox
      Left = 1
      Top = 161
      Width = 846
      Height = 475
      Align = alClient
    end
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 846
      Height = 160
      Align = alTop
      TabOrder = 0
    end
  end
end
