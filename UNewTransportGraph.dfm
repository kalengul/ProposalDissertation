object FNewTransportGraph: TFNewTransportGraph
  Left = 192
  Top = 124
  Width = 1305
  Height = 675
  Caption = 'FNewTransportGraph'
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
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 637
    Align = alLeft
    TabOrder = 0
    object LaSost: TLabel
      Left = 0
      Top = 24
      Width = 32
      Height = 13
      Caption = 'LaSost'
    end
    object BtNewNode: TButton
      Left = 16
      Top = 88
      Width = 121
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1074#1077#1088#1096#1080#1085#1091
      TabOrder = 0
      OnClick = BtNewNodeClick
    end
    object BtNewArc: TButton
      Left = 16
      Top = 120
      Width = 121
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1074#1103#1079#1100
      TabOrder = 1
      OnClick = BtNewArcClick
    end
    object EdNewNode: TEdit
      Left = 16
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'EdNewNode'
    end
    object BtAddSkald: TButton
      Left = 16
      Top = 208
      Width = 137
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1083#1072#1076
      TabOrder = 3
      OnClick = BtAddSkaldClick
    end
    object EdVolumeSklad: TEdit
      Left = 16
      Top = 184
      Width = 65
      Height = 21
      TabOrder = 4
      Text = 'EdVolumeSklad'
    end
    object BtAddNS: TButton
      Left = 16
      Top = 240
      Width = 137
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1072#1101#1088#1086#1076#1088#1086#1084
      TabOrder = 5
      OnClick = BtAddNSClick
    end
    object BtAddManufacture: TButton
      Left = 16
      Top = 304
      Width = 137
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      TabOrder = 6
      OnClick = BtAddManufactureClick
    end
    object BtAddRecover: TButton
      Left = 16
      Top = 368
      Width = 137
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1040#1056#1047
      TabOrder = 7
      OnClick = BtAddRecoverClick
    end
    object EdRecoverCoeff: TEdit
      Left = 16
      Top = 336
      Width = 121
      Height = 21
      TabOrder = 8
      Text = 'EdRecoverCoeff'
    end
    object EdManufactureNAme: TEdit
      Left = 16
      Top = 280
      Width = 121
      Height = 21
      TabOrder = 9
      Text = 'EdManufactureNAme'
    end
    object EdCostSklad: TEdit
      Left = 88
      Top = 184
      Width = 65
      Height = 21
      TabOrder = 10
      Text = 'EdCostSklad'
    end
  end
  object pnl2: TPanel
    Left = 185
    Top = 0
    Width = 1104
    Height = 637
    Align = alClient
    TabOrder = 1
    object PbGraph: TPaintBox
      Left = 1
      Top = 1
      Width = 1102
      Height = 635
      Align = alClient
      OnMouseDown = PbGraphMouseDown
    end
  end
end
