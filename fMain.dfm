object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Prime Numbers Counter'
  ClientHeight = 259
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object mStatus: TMemo
    AlignWithMargins = True
    Left = 4
    Top = 51
    Width = 456
    Height = 208
    Margins.Left = 4
    Margins.Top = 0
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alClient
    ReadOnly = True
    TabOrder = 0
    ExplicitLeft = 6
    ExplicitTop = 54
    ExplicitWidth = 267
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 0
    Width = 464
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 2
    ExplicitWidth = 275
    DesignSize = (
      464
      51)
    object lNumber: TLabel
      Left = 156
      Top = 16
      Width = 48
      Height = 15
      Caption = 'count to:'
    end
    object btnStart: TButton
      Left = 6
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnAddThread: TButton
      Left = 385
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Add thread'
      Enabled = False
      TabOrder = 1
      OnClick = btnAddThreadClick
      ExplicitLeft = 196
    end
    object edNumber: TNumberBox
      Left = 210
      Top = 13
      Width = 121
      Height = 23
      MinValue = 10.000000000000000000
      MaxValue = 100000000.000000000000000000
      TabOrder = 2
      Value = 10.000000000000000000
    end
  end
end
