unit MainUnit;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1 or LGPL 2.1 with linking exception
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * Alternatively, the contents of this file may be used under the terms of the
 * Free Pascal modified version of the GNU Lesser General Public License
 * Version 2.1 (the "FPC modified LGPL License"), in which case the provisions
 * of this license are applicable instead of those above.
 * Please see the file LICENSE.txt for additional information concerning this
 * license.
 *
 * The Original Code is GR32 Polygon Renderer Benchmark
 *
 * The Initial Developer of the Original Code is
 * Mattias Andersson <mattias@centaurix.com>
 *
 * Portions created by the Initial Developer are Copyright (C) 2000-2012
 * the Initial Developer. All Rights Reserved.
 *
 * ***** END LICENSE BLOCK ***** *)

interface

{$I GR32.inc}

uses
  SysUtils, Classes, Graphics, StdCtrls, Controls, Forms, Dialogs,
  GR32_Image, GR32_Paths, GR32, GR32_Polygons, GR32_Layers;

const
  TEST_DURATION = 4000;  // test for 4 seconds

type
  TTestProc = procedure(Canvas: TCanvas32);

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    cbAllTests: TCheckBox;
    cbAllRenderers: TCheckBox;
    cmbRenderer: TComboBox;
    cmbTest: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Img: TImage32;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure RunTest(TestProc: TTestProc; TestTime: Int64 = TEST_DURATION);
    procedure WriteTestResult(OperationsPerSecond: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses
  GR32_VPR2, Math, GR32_System, GR32_Resamplers, GR32_LowLevel, GR32_Brushes,
  GR32_Backends;

const
  GridScale: Integer = 40;

var
  TestRegistry: TStringList;

procedure RegisterTest(const TestName: string; Test: TTestProc);
begin
  if not Assigned(TestRegistry) then
    TestRegistry := TStringList.Create;
  TestRegistry.AddObject(TestName, TObject(@Test));
end;

procedure TMainForm.WriteTestResult(OperationsPerSecond: Integer);
begin
  Memo1.Lines.Add(Format('[%s] %s: %d op/s', [cmbTest.Text, cmbRenderer.Text,
    OperationsPerSecond]));
end;

procedure TMainForm.RunTest(TestProc: TTestProc; TestTime: Int64);
var
  Canvas: TCanvas32;
  i, t: Int64;
begin
  TestTime := TestTime * 1000;
  RandSeed := 0;
  Img.Bitmap.Clear(clWhite32);
  Canvas := TCanvas32.Create(Img.Bitmap);
  Canvas.Brushes.Add(TSolidBrush);
  Canvas.Brushes.Add(TStrokeBrush);
  Canvas.Brushes[0].Visible := True;
  Canvas.Brushes[1].Visible := False;
  try
    i := 0;
    GlobalPerfTimer.Start;
    repeat
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      TestProc(Canvas);
      t := GlobalPerfTimer.ReadValue;
      Inc(i, 10);
    until t > TestTime;
    WriteTestResult((i*1000000) div t);
  finally
    Canvas.Free;
  end;
end;

//----------------------------------------------------------------------------//
// ellipses
//----------------------------------------------------------------------------//
procedure EllipseTest(Canvas: TCanvas32);
var
  W, H: Integer;
begin
  W := Canvas.Bitmap.Width;
  H := Canvas.Bitmap.Height;
  (Canvas.Brushes[0] as TSolidBrush).FillColor := Random($ffffffff);
  Canvas.Path.Ellipse(Random(W), Random(H), Random(W shr 1), Random(H shr 1));
end;

//----------------------------------------------------------------------------//
// thin lines
//----------------------------------------------------------------------------//
procedure ThinLineTest(Canvas: TCanvas32);
var
  W, H: Integer;
begin
  W := Canvas.Bitmap.Width;
  H := Canvas.Bitmap.Height;
  Canvas.Brushes[0].Visible := False;
  Canvas.Brushes[1].Visible := True;
  with Canvas.Brushes[1] as TStrokeBrush do
  begin
    StrokeWidth := 1;
    FillColor := Random($ffffffff);
  end;
  Canvas.Path.BeginPath;
  Canvas.Path.MoveTo(Random(W), Random(H));
  Canvas.Path.LineTo(Random(W), Random(H));
  Canvas.Path.EndPath;
end;

//----------------------------------------------------------------------------//
// thick lines
//----------------------------------------------------------------------------//
procedure ThickLineTest(Canvas: TCanvas32);
var
  W, H: Integer;
begin
  W := Canvas.Bitmap.Width;
  H := Canvas.Bitmap.Height;
  Canvas.Brushes[0].Visible := False;
  Canvas.Brushes[1].Visible := True;
  with Canvas.Brushes[1] as TStrokeBrush do
  begin
    StrokeWidth := 10;
    FillColor := Random($ffffffff);
  end;
  Canvas.Path.BeginPath;
  Canvas.Path.MoveTo(Random(W), Random(H));
  Canvas.Path.LineTo(Random(W), Random(H));
  Canvas.Path.EndPath;
end;

//----------------------------------------------------------------------------//
// text
//----------------------------------------------------------------------------//
const
  STRINGS: array [0..5] of string = (
    'Graphics32',
    'Excellence endures!',
    'Hello World!',
    'Lorem ipsum dolor sit amet, consectetur adipisicing elit,' + #13#10 +
    'sed do eiusmod tempor incididunt ut labore et dolore magna' + #13#10 +
    'aliqua. Ut enim ad minim veniam, quis nostrud exercitation' + #13#10 +
    'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'The quick brown fox jumps over the lazy dog.',
    'Jackdaws love my big sphinx of quartz.');

type
  TFontEntry = record
    Name: string;
    Size: Integer;
    Style: TFontStyles;
  end;

const
  FACES: array [0..5] of TFontEntry = (
    (Name: 'Trebuchet MS'; Size: 24; Style: [fsBold]),
    (Name: 'Tahoma'; Size: 20; Style: [fsItalic]),
    (Name: 'Courier New'; Size: 14; Style: []),
    (Name: 'Georgia'; Size: 8; Style: [fsItalic]),
    (Name: 'Times New Roman'; Size: 12; Style: []),
    (Name: 'Garamond'; Size: 12; Style: [])
  );

procedure TextTest(Canvas: TCanvas32);
var
  W, H, I: Integer;
  Font: TFont;
begin
  W := Canvas.Bitmap.Width;
  H := Canvas.Bitmap.Height;
  (Canvas.Brushes[0] as TSolidBrush).FillColor := Random($ffffffff);

  I := Random(5);
  Font := Canvas.Bitmap.Font;
  Font.Name := FACES[I].Name;
  Font.Size := FACES[I].Size;
  Font.Style := FACES[I].Style;

  Canvas.RenderText(Random(W), Random(H), STRINGS[I]);
end;

//----------------------------------------------------------------------------//
// splines
//----------------------------------------------------------------------------//
function MakeCurve(const Points: TArrayOfFloatPoint; Kernel: TCustomKernel;
  Closed: Boolean; StepSize: Integer): TArrayOfFloatPoint;
var
  I, J, F, H, Index, LastIndex, Steps, R: Integer;
  K, V, W, dx, dy, X, Y: TFloat;
  Filter: TFilterMethod;
  WrapProc: TWrapProc;
  PPoint: PFloatPoint;
const
  WRAP_PROC: array[Boolean] of TWrapProc = (Clamp, Wrap);
begin
  WrapProc := Wrap_PROC[Closed];
  Filter := Kernel.Filter;
  R := Ceil(Kernel.GetWidth);
  H := High(Points);

  LastIndex := H - Ord(not Closed);
  Steps := 0;
  for I := 0 to LastIndex do
  begin
    Index := WrapProc(I + 1, H);
    dx := Points[Index].X - Points[I].X;
    dy := Points[Index].Y - Points[I].Y;
    Inc(Steps, Floor(Hypot(dx, dy) / StepSize) + 1);
  end;

  SetLength(Result, Steps);
  PPoint := @Result[0];

  for I := 0 to LastIndex do
  begin
    Index := WrapProc(I + 1, H);
    dx := Points[Index].X - Points[I].X;
    dy := Points[Index].Y - Points[I].Y;
    Steps := Floor(Hypot(dx, dy) / StepSize);
    if Steps > 0 then
    begin
      K := 1 / Steps;
      V := 0;
      for J := 0 to Steps do
      begin
        X := 0; Y := 0;
        for F := -R to R do
        begin
          Index := WrapProc(I - F, H);
          W := Filter(F + V);
          X := X + W * Points[Index].X;
          Y := Y + W * Points[Index].Y;
        end;
        PPoint^ := FloatPoint(X, Y);
        Inc(PPoint);
        V := V + K;
      end;
    end;
  end;
end;

procedure SplinesTest(Canvas: TCanvas32);
var
  Input, Points: TArrayOfFloatPoint;
  K: TSplineKernel;
  W, H, I: Integer;
begin
  W := Canvas.Bitmap.Width;
  H := Canvas.Bitmap.Height;
  SetLength(Input, 10);
  for I := 0 to High(Input) do
  begin
    Input[I].X := Random(W);
    Input[I].Y := Random(H);
  end;
  K := TSplineKernel.Create;
  try
    Points := MakeCurve(Input, K, True, 3);
  finally
    K.Free;
  end;
  (Canvas.Brushes[0] as TSolidBrush).FillColor := Random($ffffffff);
  Canvas.Path.Polygon(Points);
end;

//----------------------------------------------------------------------------//

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // set priority class and thread priority for better accuracy
  // SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);
  // SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_HIGHEST);

  cmbTest.Items := TestRegistry;
  cmbTest.ItemIndex := 0;
  PolygonRendererList.GetClassNames(cmbRenderer.Items);
  cmbRenderer.ItemIndex := 0;
  Img.SetupBitmap(True, clWhite32);
end;


procedure TMainForm.Button1Click(Sender: TObject);

  procedure PerformTest;
  begin
    RunTest(TTestProc(cmbTest.Items.Objects[cmbTest.ItemIndex]));
  end;

  procedure PerformAllTests;
  var
    I: Integer;
  begin
    for I := 0 to cmbTest.Items.Count - 1 do
    begin
      cmbTest.ItemIndex := I;
      Repaint;
      PerformTest;
    end;
  end;

  procedure TestRenderer;
  begin
    DefaultPolygonRendererClass := TPolygonRenderer32Class(PolygonRendererList[cmbRenderer.ItemIndex]);
    if cbAllTests.Checked then
      PerformAllTests
    else
      PerformTest;
  end;

  procedure TestAllRenderers;
  var
    I: Integer;
  begin
    for I := 0 to cmbRenderer.Items.Count - 1 do
    begin
      cmbRenderer.ItemIndex := I;
      TestRenderer;
    end;
  end;

begin
  if cbAllRenderers.Checked then
    TestAllRenderers
  else
    TestRenderer;
end;

initialization
  RegisterTest('Ellipses', EllipseTest);
  RegisterTest('Thin Lines', ThinLineTest);
  RegisterTest('Thick Lines', ThickLineTest);
  RegisterTest('Splines', SplinesTest);
  if Assigned(GetPlatformBackendClass.GetInterfaceEntry(ITextToPathSupport)) then
    RegisterTest('Text', TextTest);

end.