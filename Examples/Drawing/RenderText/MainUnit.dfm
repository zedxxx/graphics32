object FormRenderText: TFormRenderText
  Left = 381
  Top = 128
  Caption = 'RenderText Example'
  ClientHeight = 201
  ClientWidth = 566
  Color = clBtnFace
  Constraints.MinWidth = 256
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Image: TImage32
    Left = 0
    Top = 61
    Width = 566
    Height = 140
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
    OnResize = ImageResize
  end
  object PnlControl: TPanel
    Left = 0
    Top = 0
    Width = 566
    Height = 61
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      566
      61)
    object LblEnterText: TLabel
      Left = 4
      Top = 6
      Width = 78
      Height = 13
      Caption = 'Enter text here:'
    end
    object Label1: TLabel
      Left = 386
      Top = 8
      Width = 26
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Font:'
    end
    object EditText: TEdit
      Left = 92
      Top = 4
      Width = 277
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      TabOrder = 0
      Text = 'Excellence endures 0123456789'
      OnChange = EditTextChange
    end
    object BtnRunBenchmark: TButton
      Left = 418
      Top = 32
      Width = 145
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Run Benchmark'
      TabOrder = 2
      OnClick = BtnRunBenchmarkClick
    end
    object CheckBoxAntiAlias: TCheckBox
      Left = 4
      Top = 34
      Width = 97
      Height = 17
      Caption = 'Anti-alias'
      TabOrder = 3
      OnClick = CheckBoxAntiAliasClick
    end
    object CheckBoxCanvas32: TCheckBox
      Left = 124
      Top = 34
      Width = 97
      Height = 17
      Caption = 'TCanvas32'
      TabOrder = 4
      OnClick = CheckBoxCanvas32Click
    end
    object ComboBoxFont: TComboBox
      Left = 418
      Top = 5
      Width = 145
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 1
      Text = 'ComboBoxFont'
      OnChange = ComboBoxFontChange
    end
    object CheckBoxBold: TCheckBox
      Left = 227
      Top = 34
      Width = 62
      Height = 17
      Caption = 'Bold'
      TabOrder = 5
      OnClick = CheckBoxBoldClick
    end
    object CheckBoxItalic: TCheckBox
      Left = 307
      Top = 34
      Width = 62
      Height = 17
      Caption = 'Italic'
      TabOrder = 6
      OnClick = CheckBoxItalicClick
    end
  end
end
