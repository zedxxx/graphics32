unit RGBALoaderUnit;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
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
 * The Original Code is Graphics32
 *
 * The Initial Developer of the Original Code is
 * Alex A. Denisov
 *
 * Portions created by the Initial Developer are Copyright (C) 2000-2004
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$IFNDEF FPC}
  {$DEFINE Windows}
{$ENDIF}

uses
  {$IFDEF FPC}LCLIntf, LResources, {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  GR32_Image, GR32_Filters, GR32_RangeBars, ExtCtrls, ExtDlgs, Buttons;

type
  TRGBALoaderForm = class(TForm)
    Bevel1: TBevel;
    BtnCancel: TButton;
    BtnLoadAlpha: TButton;
    BtnLoadImage: TButton;
    BtnOK: TButton;
    BtnResetScales: TButton;
    ImgAlpha: TImgView32;
    ImgRGB: TImgView32;
    LblAlphaImage: TLabel;
    LblInfo: TLabel;
    LblNote: TLabel;
    LblRGBImage: TLabel;
    OpenPictureDialog: TOpenPictureDialog;
    PnlInfo: TPanel;
    BtnZoomInImage: TSpeedButton;
    BtnZoomOutImage: TSpeedButton;
    BtnZoomInAlpha: TSpeedButton;
    BtnZoomOutAlpha: TSpeedButton;
    procedure BtnLoadImageClick(Sender: TObject);
    procedure BtnLoadAlphaClick(Sender: TObject);
    procedure BtnZoomInImageClick(Sender: TObject);
    procedure BtnZoomOutImageClick(Sender: TObject);
    procedure BtnZoomInAlphaClick(Sender: TObject);
    procedure BtnZoomOutAlphaClick(Sender: TObject);
    procedure BtnResetScalesClick(Sender: TObject);
  end;

var
  RGBALoaderForm: TRGBALoaderForm;

implementation

{$R *.dfm}

{ TRGBALoaderForm }

procedure TRGBALoaderForm.BtnLoadImageClick(Sender: TObject);
begin
  with OpenPictureDialog do
    if Execute then ImgRGB.Bitmap.LoadFromFile(FileName);
end;

procedure TRGBALoaderForm.BtnLoadAlphaClick(Sender: TObject);
begin
  with OpenPictureDialog, ImgAlpha do
    if Execute then
    begin
      Bitmap.LoadFromFile(FileName);
      ColorToGrayscale(Bitmap, Bitmap);
    end;
end;

procedure TRGBALoaderForm.BtnZoomInImageClick(Sender: TObject);
begin
  ImgRGB.Scale := ImgRGB.Scale * 1.5;
end;

procedure TRGBALoaderForm.BtnZoomOutImageClick(Sender: TObject);
begin
  ImgRGB.Scale := ImgRGB.Scale / 1.5;
end;

procedure TRGBALoaderForm.BtnZoomInAlphaClick(Sender: TObject);
begin
  ImgAlpha.Scale := ImgAlpha.Scale * 1.5;
end;

procedure TRGBALoaderForm.BtnZoomOutAlphaClick(Sender: TObject);
begin
  ImgAlpha.Scale := ImgAlpha.Scale / 1.5;
end;

procedure TRGBALoaderForm.BtnResetScalesClick(Sender: TObject);
begin
  ImgRGB.Scale := 1;
  ImgAlpha.Scale := 1;
end;

end.
