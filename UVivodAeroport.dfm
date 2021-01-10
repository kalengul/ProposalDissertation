object FVivodAeroport: TFVivodAeroport
  Left = 192
  Top = 147
  Width = 1305
  Height = 784
  Caption = #1044#1072#1085#1085#1099#1077' '#1086#1073' '#1072#1101#1088#1086#1087#1086#1088#1090#1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 353
    Height = 440
    Align = alLeft
    TabOrder = 0
    object pnl4: TPanel
      Left = 1
      Top = 1
      Width = 351
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 181
        Height = 13
        Caption = #1051#1077#1090#1072#1090#1077#1083#1100#1085#1099#1077' '#1072#1087#1087#1072#1088#1090#1099' '#1074' '#1072#1101#1088#1086#1087#1086#1088#1090#1091
      end
    end
    object pnl5: TPanel
      Left = 1
      Top = 42
      Width = 351
      Height = 397
      Align = alClient
      TabOrder = 1
      object SgLA: TStringGrid
        Left = 1
        Top = 1
        Width = 349
        Height = 395
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 440
    Width = 1289
    Height = 306
    Align = alBottom
    TabOrder = 1
    object PbVivodInformation: TPaintBox
      Left = 1
      Top = 1
      Width = 1287
      Height = 304
      Align = alClient
    end
  end
  object pnl3: TPanel
    Left = 353
    Top = 0
    Width = 360
    Height = 440
    Align = alLeft
    TabOrder = 2
    object pnl6: TPanel
      Left = 1
      Top = 1
      Width = 358
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 108
        Height = 13
        Caption = #1058#1088#1077#1073#1091#1077#1084#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      end
    end
    object pnl7: TPanel
      Left = 1
      Top = 42
      Width = 358
      Height = 397
      Align = alClient
      TabOrder = 1
      object LbElements: TListBox
        Left = 1
        Top = 1
        Width = 356
        Height = 395
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnMouseUp = LbElementsMouseUp
      end
    end
  end
end
