object FAddNs: TFAddNs
  Left = 939
  Top = 178
  Width = 842
  Height = 735
  Caption = 'FAddNs'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 826
    Height = 65
    Align = alTop
    TabOrder = 0
    object LaName: TLabel
      Left = 328
      Top = 16
      Width = 38
      Height = 13
      Caption = 'LaName'
    end
    object Label1: TLabel
      Left = 104
      Top = 16
      Width = 36
      Height = 13
      Caption = #1048#1084#1103' '#1053#1057
    end
    object BtAddNs: TButton
      Left = 8
      Top = 8
      Width = 89
      Height = 49
      Caption = 'BtAddNs'
      TabOrder = 0
      OnClick = BtAddNsClick
    end
    object EdNameFile: TEdit
      Left = 104
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 65
    Width = 826
    Height = 632
    Align = alClient
    Caption = 'pnl1'
    TabOrder = 1
    object SgNS: TStringGrid
      Left = 1
      Top = 1
      Width = 824
      Height = 630
      Align = alClient
      TabOrder = 0
    end
  end
end
