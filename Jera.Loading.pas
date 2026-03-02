unit Jera.Loading;

interface

uses System.SysUtils,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Layouts,
  FMX.Forms,
  FMX.Graphics,
  FMX.Ani,
  FMX.VirtualKeyboard,
  FMX.Platform,
  System.UIConsts;

type
  TJeraLoading = class
  private
    class var Layout: TLayout;
    class var Fundo: TRectangle;
    class var Arco: TArc;
    class var Mensagem: TLabel;
    class var Animacao: TFloatAnimation;

    class var LayoutToast: TLayout;
    class var FundoToast: TRectangle;
    class var AnimacaoToast: TFloatAnimation;
    class var MensagemToast: TLabel;
    class procedure DeleteToast(Sender: TObject);
  public
    class function Aberto: Boolean;
    class procedure Show(
      const Frm: TFmxObject;
      const msg: string;
      const AColor: TAlphaColor = TAlphaColorRec.Black);
    class procedure SetMessage(const msg: string);
    class procedure Hide;
    class procedure ToastMessage(
      const Frm: TFmxObject;
      const msg: string;
      cor_fundo: Cardinal = TAlphaColorRec.Black;
      cor_fonte: Cardinal = TAlphaColorRec.White;
      alinhamento: TAlignLayout = TAlignLayout.Bottom;
      duracao: integer = 4;
      ARadiusX: integer = 20;
      ARadiusY: integer = 20);
  end;

implementation

uses
  System.Classes,
  System.StrUtils;

{ TJeraLonding }

class function TJeraLoading.Aberto: Boolean;
begin
  Result := Assigned(Layout);
end;

class procedure TJeraLoading.DeleteToast(Sender: TObject);
begin
  if Assigned(FundoToast) then
  begin
    FundoToast.Visible := false;
    try
      if Assigned(MensagemToast) then
        MensagemToast.Free;

      if Assigned(AnimacaoToast) then
        AnimacaoToast.Free;

      if Assigned(FundoToast) then
        FundoToast.Free;

      if Assigned(LayoutToast) then
        LayoutToast.Free;
    except
    end;
  end;

  MensagemToast := nil;
  AnimacaoToast := nil;
  FundoToast := nil;
  LayoutToast := nil;
end;

class procedure TJeraLoading.Hide;
begin
  try
    if Assigned(Layout) then
    begin
      try
        if Assigned(Mensagem) then
          Mensagem.Free;
      except
      end;

      try
        if Assigned(Animacao) then
          Animacao.Free;
      except
      end;

      try
        if Assigned(Arco) then
          Arco.Free;
      except
      end;

      try
        if Assigned(Fundo) then
          Fundo.Free;
      except
      end;

      try
        if Assigned(Layout) then
          Layout.Free;
      except
      end;
    end;
  finally
    Mensagem := nil;
    Animacao := nil;
    Arco := nil;
    Layout := nil;
    Fundo := nil;
  end;
end;

class procedure TJeraLoading.SetMessage(const msg: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Mensagem.Text := msg;
      Application.ProcessMessages;
    end);
end;

class procedure TJeraLoading.Show(
  const Frm: TFmxObject;
  const msg: string;
  const AColor: TAlphaColor);
var
  FService: IFMXVirtualKeyboardService;
begin
  // Panel de fundo opaco...
  Fundo := TRectangle.Create(Frm);
  Fundo.Opacity := 0;
  Fundo.Parent := Frm;
  Fundo.Visible := true;
  Fundo.Align := TAlignLayout.Contents;
  Fundo.Fill.Color := AColor;
  Fundo.Fill.Kind := TBrushKind.Solid;
  Fundo.Stroke.Kind := TBrushKind.None;
  Fundo.Visible := true;

  // Layout contendo o texto e o arco...
  Layout := TLayout.Create(Frm);
  Layout.Opacity := 0;
  Layout.Parent := Frm;
  Layout.Visible := true;
  Layout.Align := TAlignLayout.Contents;
  Layout.Width := 250;
  Layout.Height := 78;
  Layout.Visible := true;

  // Arco da animacao...
  Arco := TArc.Create(Frm);
  Arco.Visible := true;
  Arco.Parent := Layout;
  Arco.Align := TAlignLayout.Center;
  Arco.Margins.Bottom := 55;
  Arco.Width := 50;
  Arco.Height := 50;
  Arco.EndAngle := 280;
  Arco.Stroke.Color := $FFFEFFFF;
  Arco.Stroke.Thickness := 2;
  Arco.Position.X := trunc((Layout.Width - Arco.Width) / 2);
  Arco.Position.Y := 0;

  // Animacao...
  Animacao := TFloatAnimation.Create(Frm);
  Animacao.Parent := Arco;
  Animacao.StartValue := 0;
  Animacao.StopValue := 360;
  Animacao.Duration := 0.8;
  Animacao.Loop := true;
  Animacao.PropertyName := 'RotationAngle';
  Animacao.AnimationType := TAnimationType.InOut;
  Animacao.Interpolation := TInterpolationType.Linear;
  Animacao.Start;

  // Label do texto...
  Mensagem := TLabel.Create(Frm);
  Mensagem.Parent := Layout;
  Mensagem.Align := TAlignLayout.Center;
  Mensagem.Margins.Top := 100;
  Mensagem.Font.Size := 13;
  Mensagem.Height := 100;
  Mensagem.Width := 250;
  Mensagem.FontColor := $FFFEFFFF;
  Mensagem.TextSettings.HorzAlign := TTextAlign.Center;
  Mensagem.TextSettings.VertAlign := TTextAlign.Leading;
  Mensagem.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Mensagem.Text := msg;
  Mensagem.VertTextAlign := TTextAlign.Leading;
  Mensagem.Trimming := TTextTrimming.None;
  Mensagem.TabStop := false;
  Mensagem.SetFocus;

  // Exibe os controles...
  FMX.Ani.TAnimator.AnimateFloat(
    Fundo,
    'Opacity',
    0.7);
  FMX.Ani.TAnimator.AnimateFloat(
    Layout,
    'Opacity',
    1);
  Layout.BringToFront;

  // Esconde o teclado virtual...
  TPlatformServices.Current.SupportsPlatformService(
    IFMXVirtualKeyboardService,
    IInterface(FService));
  if (FService <> nil) then
  begin
    FService.HideVirtualKeyboard;
  end;
  FService := nil;
end;

class procedure TJeraLoading.ToastMessage(
  const Frm: TFmxObject;
  const msg: string;
  cor_fundo: Cardinal;
  cor_fonte: Cardinal;
  alinhamento: TAlignLayout;
  duracao: integer;
  ARadiusX: integer;
  ARadiusY: integer);
var
  FService: IFMXVirtualKeyboardService;
  function CountStr: integer;
  var
    I: integer;
  begin
    Result := 0;
    I := Pos(
      #13,
      msg);
    while I > 0 do
    begin
      Result := Result + 1;
      I := PosEx(
        #13,
        msg,
        I + 1);
    end;
  end;

begin
  // Layout invisivel de fundo (nao clicavel)...
  LayoutToast := TLayout.Create(Frm);
  LayoutToast.Opacity := 0.7;
  LayoutToast.Parent := Frm;
  LayoutToast.Visible := true;
  LayoutToast.Align := TAlignLayout.Contents;
  LayoutToast.Visible := true;
  LayoutToast.HitTest := false;
  LayoutToast.BringToFront;

  // Fundo da mensagem...
  FundoToast := TRectangle.Create(Frm);
  FundoToast.Opacity := 1;
  FundoToast.Parent := LayoutToast;
  FundoToast.Height := 50;
  FundoToast.Align := alinhamento;
  FundoToast.Margins.Left := 20;
  FundoToast.Margins.Right := 20;
  FundoToast.Margins.Bottom := 20;
  FundoToast.Margins.Top := 20;
  FundoToast.Fill.Color := cor_fundo;
  FundoToast.Fill.Kind := TBrushKind.Solid;
  FundoToast.Stroke.Kind := TBrushKind.None;
  FundoToast.XRadius := ARadiusX;
  FundoToast.YRadius := ARadiusY;
  if Length(msg) < 10 then
  begin
    FundoToast.Width := Length(msg) * 10;
    FundoToast.Height := 55;
  end
  else if (Length(msg) * 10) > 300 then
  begin
    var
    FMultiplicador := 6;
    if Length(msg) > 60 then
    begin
      FMultiplicador := 2;
    end;
    FundoToast.Width := 300;
    if CountStr <= 0 then
      FundoToast.Height := (trunc(((Length(msg) * 10) / 40)) * FMultiplicador) + 10
    else
      FundoToast.Height := (trunc(((Length(msg) * 10) / 40)) * FMultiplicador
        * CountStr) + 10;
  end
  else
  begin
    if CountStr > 0 then
    begin
      FundoToast.Width := Length(msg) * 10;
      FundoToast.Height := CountStr * 40;
    end
    else
    begin
      FundoToast.Width := Length(msg) * 10;
      FundoToast.Height := 50;
    end;
  end;
  // Animacao...
  AnimacaoToast := TFloatAnimation.Create(Frm);
  AnimacaoToast.Parent := FundoToast;
  AnimacaoToast.StartValue := 0;
  AnimacaoToast.StopValue := 3;
  AnimacaoToast.Duration := duracao / 2;
  AnimacaoToast.Delay := 0;
  AnimacaoToast.AutoReverse := true;
  AnimacaoToast.PropertyName := 'Opacity';
  AnimacaoToast.AnimationType := TAnimationType.&In;
  AnimacaoToast.Interpolation := TInterpolationType.Linear;
  AnimacaoToast.OnFinish := TJeraLoading.DeleteToast;

  // Label do texto...
  MensagemToast := TLabel.Create(Frm);
  MensagemToast.Parent := FundoToast;
  MensagemToast.Align := TAlignLayout.Client;
  MensagemToast.Font.Size := 13;
  MensagemToast.FontColor := cor_fonte;
  MensagemToast.TextSettings.HorzAlign := TTextAlign.Center;
  MensagemToast.TextSettings.VertAlign := TTextAlign.Center;
  MensagemToast.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  MensagemToast.Text := msg;
  MensagemToast.VertTextAlign := TTextAlign.Center;
  MensagemToast.Trimming := TTextTrimming.None;
  MensagemToast.TabStop := false;
  // var NumLin := CountStr;
  // if (NumLin > 0) then  // Contém quebra de linha
  // begin
  // var AltLin := MensagemToast.Canvas.TextHeight('H');
  // FundoToast.Height := 30 + (NumLin * AltLin);
  // end
  // else
  // begin
  // var AltLin := MensagemToast.Canvas.TextHeight('H');
  // var LargLin := MensagemToast.Canvas.TextWidth('H');
  // var ILarg := Length(Msg) * LargLin;
  // if ILarg > MensagemToast.Width then
  // begin
  // var IFator := Trunc(ILarg / MensagemToast.Width);
  // FundoToast.Height := 30 + (IFator * AltLin);
  // end;
  // end;
  FundoToast.Visible := true;

  // Esconde o teclado virtual...
  TPlatformServices.Current.SupportsPlatformService(
    IFMXVirtualKeyboardService,
    IInterface(FService));
  if (FService <> nil) then
  begin
    FService.HideVirtualKeyboard;
  end;
  FService := nil;

  // Exibe os controles...
  AnimacaoToast.Enabled := true;
end;

end.
