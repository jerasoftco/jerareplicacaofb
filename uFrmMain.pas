{******************************************************************************}
{ Jera Replicação                                                              }
{  App desenvolvido para criar replicação para o banco de dados Firebird 4.0+. }
{ Ajusta a replicação tanto do lado servidor como do lado réplica. Permite     }
{ desligar a réplica tanto do lado servidor quanto do lado réplica             }
{                                                                              }
{ Cria agendamento para o envio dos arquivos da réplica via FTP, utilizando o  }
{ software livre Winscp.exe                                                    }
{                                                                              }
{ App desenvolvido em Delphi 13, utilizando o Framewok Firemonkey e componente }
{ de acesso Firedac para conexão ao Firebird                                   }
{                                                                              }
{ Podem ser agendadas várias replicações tanto do lado servidor quanto do lado }
{ replica. Basta informar as pastas de cada banco de dados.                    }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Jera Soft Co. Ltda                     }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do Github da        }
{ Jera Soft localizado em https://github.com/jerasoftco/jerareplicacaofb.git   }
{                                                                              }
{  Este App é software livre; você pode redistribuí-la e/ou modificá-lo        }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta App é distribuída na expectativa de que seja útil, porém, SEM          }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Jera Soft Co. Ltda - contato@jerasoft.com.br - www.jerasoft.com.br           }
{ Rua Coronel José Custódio, 230, sala 33 - Campestre/MG - 37730-000           }
{******************************************************************************}

unit uFrmMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Layouts,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.IBBase,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.EditBox,
  FMX.NumberBox;

type
  TFrmMain = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    EdtFDBFile: TEdit;
    Label1: TLabel;
    BtnOpenFDB: TSpeedButton;
    Path1: TPath;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    BtnPathFB: TSpeedButton;
    Path2: TPath;
    Layout6: TLayout;
    Label2: TLabel;
    EdtFirebirdPath: TEdit;
    OpenDLG: TOpenDialog;
    BtnOK: TSpeedButton;
    Path3: TPath;
    BtnFechar: TSpeedButton;
    Path4: TPath;
    MMHistorico: TMemo;
    FDConnection1: TFDConnection;
    Qry: TFDQuery;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    Layout7: TLayout;
    SpeedButton1: TSpeedButton;
    Path5: TPath;
    Layout8: TLayout;
    Label3: TLabel;
    EdtPathBase: TEdit;
    Layout9: TLayout;
    Edit1: TEdit;
    Label4: TLabel;
    EdtUsuario: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    EdtPassword: TEdit;
    Label7: TLabel;
    EdtPorta: TNumberBox;
    Layout10: TLayout;
    BtnArquivoFTP: TSpeedButton;
    Path6: TPath;
    Label8: TLabel;
    EdtUsuarioFTP: TEdit;
    Label9: TLabel;
    EdtPortaFTP: TNumberBox;
    Label10: TLabel;
    EdtHostFTP: TEdit;
    ChkCriarAgendamento: TCheckBox;
    Label11: TLabel;
    EdtNomeAppEnvio: TEdit;
    Label12: TLabel;
    EdtNomeServicoEnvio: TEdit;
    Rectangle1: TRectangle;
    RbMaster: TRadioButton;
    RbMasterOff: TRadioButton;
    ChkFileCopy: TCheckBox;
    ChkCriarFTP: TCheckBox;
    Rectangle2: TRectangle;
    RbClient: TRadioButton;
    RbCancelarClient: TRadioButton;
    EdtPwdFtp: TEdit;
    Label13: TLabel;
    procedure BtnOpenFDBClick(Sender: TObject);
    procedure BtnPathFBClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnArquivoFTPClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function ShellExecuteAndWait(Operation, FileName, Parameter, Directory: String; Show: Word; bWait: Boolean): Longint;
    procedure _Master;
    procedure _MasterOff;
    procedure _Client;
    procedure _ClientOff;
    procedure ExtractResourceToFile(const ResName, FileName: string);
    procedure Descompactar;
    procedure StopFB(const AFileBat: string);
    procedure StartFB(const AFileBat: string);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  System.IOUtils,
  WinApi.ShellApi,
  WinApi.Windows,
  Jera.Loading,
  System.Zip;

{$R *.fmx}


procedure TFrmMain.BtnArquivoFTPClick(Sender: TObject);
var
  ArqBAT: string;
  ArqBATF: string;
  AFileA: string;
begin
  if EdtUsuarioFTP.Text.IsEmpty then
    raise Exception.Create('Nome do usuário de FTP não informado!');

  if LowerCase(TDirectory.GetCurrentDirectory) <> 'c:\jera soft co' then
    raise Exception.Create('Obrigatoriamente deve ser executado na pasta "c:\jera soft co"!');

  TJeraLoading.Show(FrmMain, 'Gerando arquivo...');
  var AStr := TStringList.Create;
  try
    MMHistorico.Lines.Add('Replicacao.zip');
    ExtractResourceToFile('replicacao_zip', TPath.Combine(TDirectory.GetCurrentDirectory, 'replicacao.zip'));

    MMHistorico.Lines.Add('Descompactando Replicacao.zip');
    Descompactar;
    if not TFile.Exists('C:\Jera Soft Co\winscp\WinSCP.com') then
      raise Exception.Create('Erro ao descompactar recursos!');

    MMHistorico.Lines.Add('Salvando arquivo Replica.bat');
    var ADirA := TPath.Combine(EdtPathBase.Text, 'Archive');
    AStr.Add('@echo off');
    AStr.Add('@echo  Enviando REPLICA');
    AStr.Add('');
    AStr.Add('"C:\Jera Soft Co\winscp\WinSCP.com" ^');
    AStr.Add('  /ini=nul ^');
    AStr.Add('  /command ^');
    AStr.Add('    "open ftp://' + EdtUsuarioFTP.Text + ':' + EdtPwdFTP.Text + ':' + EdtPortaFTP.Text + '/" ^');
    AStr.Add('    "put -delete ""' + ADirA + '\*"" /" ^');
    AStr.Add('    "exit"');
    AFileA := TPath.Combine('Winscp', EdtNomeAppEnvio.Text + '.bat');
    AStr.SaveToFile(AFileA);

    MMHistorico.Lines.Add('Compilando arquivo ' + EdtNomeAppEnvio.Text + '.bat');
    ArqBAT := TPath.Combine(TPath.GetLibraryPath, 'ExeCompiler.bat');
    AStr.Clear;
    AStr.Add('Bat_To_Exe_Converter.exe /bat ".\WinSCP\' + EdtNomeAppEnvio.Text + '.bat" /exe ".\WinSCP\' + EdtNomeAppEnvio.Text + '.exe" /upx /overwrite /invisible');
    AStr.SaveToFile(ArqBAT);
    ShellExecuteAndWait('open',ArqBAT, '', '', 0, True);

    if ChkCriarAgendamento.IsChecked then
    begin
      MMHistorico.Lines.Add('Criando agendamento');
      ArqBATF := TPath.Combine(TPath.GetLibraryPath, 'TaskAgend.bat');
      AStr.Clear;
      AStr.Add('schtasks /create /sc MINUTE /mo 1 /tn "' + EdtNomeServicoEnvio.Text + '" /tr "\"C:\Jera Soft Co\WinSCP\' + EdtNomeAppEnvio.Text + '.exe\"" /ru SYSTEM');
      AStr.SaveToFile(ArqBATF);

      ShellExecuteAndWait('open', ArqBATF, '', '', 0, True);
    end;
  finally
    if TFile.Exists(AFileA) then
      TFile.Delete(AFileA);
    if TFile.Exists(ArqBAT) then
      TFile.Delete(ArqBAT);
    if TFile.Exists(ArqBATF) then
      TFile.Delete(ArqBATF);
    FreeAndNil(AStr);
    TJeraLoading.Hide;
  end;
end;

procedure TFrmMain.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.BtnOKClick(Sender: TObject);
begin
  if not TFile.Exists(EdtFDBFile.Text) then
    raise Exception.Create('Arquivo FDB não encontrado!');
  try
    FDPhysFBDriverLink1.VendorLib := TPath.Combine(EdtFirebirdPath.Text, 'FBClient.dll');
    FDConnection1.Params.Database := EdtFDBFile.Text;
    FDConnection1.Params.UserName := EdtUsuario.Text;
    FDConnection1.Params.Password := EdtPassword.Text;
    FDConnection1.Params.Values['Port'] := EdtPorta.Text;
    FDConnection1.Params.Values['Server'] := 'localhost';
    if RbMaster.IsChecked then
      _Master
    else if RbClient.IsChecked then
      _Client
    else if RbMasterOff.IsChecked then
      _MasterOff
    else if RbCancelarClient.IsChecked then
      _ClientOff;
  finally
    if FDConnection1.Connected then
      FDConnection1.Close;
  end;
end;

procedure TFrmMain.BtnOpenFDBClick(Sender: TObject);
begin
  if not OpenDLG.Execute then
    Exit;

  EdtFDBFile.Text := OpenDLG.FileName;
end;

procedure TFrmMain.BtnPathFBClick(Sender: TObject);
var
  ADir: string;
begin
  ADir := EdtPathBase.Text;
  if not SelectDirectory('Selecione a pasta do Firebird', System.IOUtils.TPath.GetPathRoot(ADir), ADir) then
    Exit;

  EdtPathBase.Text := ADir;
end;

procedure TFrmMain.Descompactar;
var
  Descomp: TZipFile;
begin
  var AFile := TPath.Combine(TDirectory.GetCurrentDirectory, 'replicacao.zip');
  Descomp := TZipFile.Create;
  try
    if FileExists(AFile) then
    begin
      Descomp.Open(AFile, zmReadWrite);
      Descomp.ExtractAll(TDirectory.GetCurrentDirectory);
      Descomp.Close;
    end;
  finally
    Descomp.free;
  end;
end;

procedure TFrmMain.ExtractResourceToFile(const ResName, FileName: string);
var
  ResHandle, FileHandle: HRSRC;
  ResData: THandle;
  ResSize: DWORD;
  Buffer: Pointer;
  BytesWritten: DWORD;
begin
  // Localizar o recurso
  ResHandle := FindResource(HInstance, PChar(ResName), RT_RCDATA);
  if ResHandle = 0 then
    raise Exception.Create('Recurso não encontrado.');

  // Carregar o recurso
  ResData := LoadResource(HInstance, ResHandle);
  if ResData = 0 then
    raise Exception.Create('Não foi possível carregar o recurso.');

  // Obter o tamanho do recurso
  ResSize := SizeofResource(HInstance, ResHandle);

  // Bloquear o recurso na memória
  Buffer := LockResource(ResData);

  // Criar um arquivo externo
  FileHandle := CreateFile(PChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Não foi possível criar o arquivo externo.');

  try
    // Escrever o conteúdo do recurso no arquivo externo
    if not WriteFile(FileHandle, Buffer^, ResSize, BytesWritten, nil) then
      raise Exception.Create('Não foi possível escrever o arquivo externo.');
  finally
    // Fechar o arquivo
    CloseHandle(FileHandle);
  end;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if TFile.Exists('C:\Jera Soft Co\Bat_To_Exe_Converter.exe') then
    TFile.Delete('C:\Jera Soft Co\Bat_To_Exe_Converter.exe');
  if TFile.Exists('C:\Jera Soft Co\replicacao.zip') then
    TFile.Delete('C:\Jera Soft Co\\replicacao.zip');
end;

function TFrmMain.ShellExecuteAndWait(
  Operation, FileName, Parameter, Directory: String;
  Show: Word;
  bWait: Boolean): Longint;
var
  bOK: Boolean;
  Info: TShellExecuteInfo;
begin
  FillChar(Info, SizeOf(Info), Chr(0));
  Info.cbSize := SizeOf(Info);
  Info.fMask := SEE_MASK_NOCLOSEPROCESS;
  Info.lpVerb := PChar(Operation);
  Info.lpFile := PChar(FileName);
  Info.lpParameters := PChar(Parameter);
  Info.lpDirectory := PChar(Directory);
  Info.nShow := Show;
  bOK := Boolean(ShellExecuteEx(@Info));
  if bOK then
  begin
    if bWait then
    begin
      while WaitForSingleObject(Info.hProcess, 100) = WAIT_TIMEOUT do
        bOK := GetExitCodeProcess(Info.hProcess, DWORD(Result));
    end
    else
      Result := 0;
  end;
  if not bOK then
    Result := -1;
end;

procedure TFrmMain.StartFB(const AFileBat: string);
begin
  var AStr := TStringList.Create;
  try
    MMHistorico.Lines.Add('Iniciando serviço do Firebird');
    if not TFile.Exists(AFileBat) then
    begin
      AStr.Add('net start FirebirdServerFirebird_Jerasoft');
      AStr.SaveToFile(AFileBat);
    end;
    ShellExecuteAndWait('open', AFileBat, '', '', 0, True);
  finally
    FreeAndNil(AStr);
  end;
end;

procedure TFrmMain.StopFB(const AFileBat: string);
begin
  var AStr := TStringList.Create;
  try
    MMHistorico.Lines.Add('Parando serviço do Firebird');
    if not TFile.Exists(AFileBat) then
    begin
      AStr.Add('net stop FirebirdServerFirebird_Jerasoft');
      AStr.SaveToFile(AFileBat);
    end;
    ShellExecuteAndWait('open', AFileBat, '', '', 0, True);
  finally
    FreeAndNil(AStr);
  end;
end;

procedure TFrmMain._Client;
var
  AStr: TStringList;
  ArqBAT: string;
  arq: TextFile;
  AArqFBStart: string;
  AArqFBStop: string;
begin
  MMHistorico.Lines.Clear;
  AStr := TStringList.Create;
  TJeraLoading.Show(Self, 'Configurando banco de replica');
  try
    MMHistorico.Lines.Add('Alterando arquivo Replication.conf');
    var
    AFileCONF := TPath.Combine(EdtFirebirdPath.Text, 'Replication.conf');
    AStr.LoadFromFile(AFileCONF);
    if AStr.IndexOf('database = ' + EdtFDBFile.Text) = -1 then
    begin
      var
      ADirJ := EdtPathBase.Text;
      if not TDirectory.Exists(ADirJ) then
        TDirectory.CreateDirectory(ADirJ);

      AStr.Add('database = ' + EdtFDBFile.Text);
      AStr.Add('{');
      AStr.Add('    journal_source_directory = ' + ADirJ);
      AStr.Add('}');
      AStr.SaveToFile(AFileCONF);
    end;

    ArqBAT := TPath.Combine(EdtFirebirdPath.Text, 'ReplicaClientON.bat');

    AArqFBStop := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTOP.bat');
    StopFB(AArqFBStop);

    MMHistorico.Lines.Add('Executando comandos de Replica no arquivo FDB');
    AssignFile(arq, ArqBAT);
    Rewrite(arq);
    Writeln(arq, '"' + EdtFirebirdPath.Text + '\gfix.exe" -replica read_only "' + EdtFDBFile.Text + '" -user SYSDBA', '');
    CloseFile(arq);
    var IRet := ShellExecuteAndWait('open', ArqBAT, '', EdtFirebirdPath.Text, 0, True);

    if IRet >= 0 then
      MMHistorico.Lines.Add('Comandos de Replica no arquivo FDB executado com sucesso!')
    else
      MMHistorico.Lines.Add('Falha ao executar comandos de Replica no arquivo FDB!');

    AArqFBStart := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTART.bat');
    StartFB(AArqFBStart);
  finally
    MMHistorico.Lines.Add('Processo terminado');
    FreeAndNil(AStr);
    FDConnection1.Connected := False;
    TFile.Delete(ArqBAT);
    if TFile.Exists(AArqFBStart) then
      TFile.Delete(AArqFBStart);
    if TFile.Exists(AArqFBStop) then
      TFile.Delete(AArqFBStop);
    TJeraLoading.Hide;
  end;
end;

procedure TFrmMain._ClientOff;
var
  AStr: TStringList;
  ArqBAT: string;
  AArqFBStart: string;
  AArqFBStop: string;
begin
  MMHistorico.Lines.Clear;
  AStr := TStringList.Create;
  try
    TJeraLoading.Show(Self, 'Retirando Replicação do Banco de Replica');
    MMHistorico.Lines.Add('Alterando arquivo Replication.conf');
    var AFileCONF := TPath.Combine(EdtFirebirdPath.Text, 'Replication.conf');
    AStr.LoadFromFile(AFileCONF);
    var IIdx := AStr.IndexOf('database = ' + EdtFDBFile.Text);
    if IIdx > -1 then
    begin
      var IConta := IIdx + 4;
      for var I := IConta - 1 downto IIdx do
      begin
        AStr.Delete(I);
      end;
      AStr.SaveToFile(AFileCONF);
    end;
    var arq: TextFile;

    AArqFBStop := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTOP.bat');
    StopFB(AArqFBStop);
    ArqBAT := TPath.Combine(EdtFirebirdPath.Text, 'ReplicaClientOFF.bat');

    MMHistorico.Lines.Add('Executando comandos de Replica no arquivo FDB');
    AssignFile(arq, ArqBAT);
    Rewrite(arq);
    Writeln(arq, '"' + EdtFirebirdPath.Text + '\gfix.exe" -replica none "' + EdtFDBFile.Text + '" -user SYSDBA', '');
    CloseFile(arq);
    var IRet := ShellExecuteAndWait('open',ArqBAT, '',EdtFirebirdPath.Text, 0, True);

    if IRet >= 0 then
      MMHistorico.Lines.Add('Comandos de Replica no arquivo FDB executado com sucesso!')
    else
      MMHistorico.Lines.Add('Falha ao executar comandos de Replica no arquivo FDB!');

    AArqFBStart := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTART.bat');
    StartFB(AArqFBStart);
  finally
    MMHistorico.Lines.Add('Processo terminado');
    FreeAndNil(AStr);
    FDConnection1.Connected := False;
    TFile.Delete(ArqBAT);
    if TFile.Exists(AArqFBStart) then
      TFile.Delete(AArqFBStart);
    if TFile.Exists(AArqFBStop) then
      TFile.Delete(AArqFBStop);
    TJeraLoading.Hide;
  end;
end;

procedure TFrmMain._Master;
var
  AStr: TStringList;
  AArqFBStart: string;
  AArqFBStop: string;
begin
  if ChkCriarFTP.IsChecked and
    EdtUsuarioFTP.Text.IsEmpty then
    raise Exception.Create('Usuário do FTP não informado!');

  TJeraLoading.Show(Self, 'Configurando Replicação Banco Principal');
  AStr := TStringList.Create;
  try
    var
    ADirJ := TPath.Combine(EdtPathBase.Text, 'Journal');
    var
    ADirA := TPath.Combine(EdtPathBase.Text, 'Archive');

    if not TDirectory.Exists(ADirJ) then
      TDirectory.CreateDirectory(ADirJ);

    if not TDirectory.Exists(ADirA) then
      TDirectory.CreateDirectory(ADirA);

    AArqFBStop := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTOP.bat');
    AArqFBStart := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTART.bat');

    MMHistorico.Lines.Clear;
    StopFB(AArqFBStop);
    if ChkFileCopy.IsChecked then
    begin
      var ANewFile := TPath.Combine(ADirA, ExtractFileName(EdtFDBFile.Text));
      if not TFile.Exists(ANewFile) then
      begin
        MMHistorico.Lines.Add('Copiando o arquivo para ' + ANewFile);
        TFile.Copy(EdtFDBFile.Text, ANewFile, False);
        MMHistorico.Lines.Add('Arquivo copiado');
      end
      else
        MMHistorico.Lines.Add('Arquivo existente ' + ANewFile);
    end;

    MMHistorico.Lines.Add('Alterando arquivo Replication.conf');
    var AFileCONF := TPath.Combine(EdtFirebirdPath.Text, 'Replication.conf');
    AStr.LoadFromFile(AFileCONF);
    if AStr.IndexOf('database = ' + EdtFDBFile.Text) = -1 then
    begin
      AStr.Add('database = ' + EdtFDBFile.Text);
      AStr.Add('{');
      AStr.Add('    journal_directory = ' + ADirJ);
      AStr.Add('    journal_archive_directory = ' + ADirA);
      AStr.Add('    journal_archive_timeout = 10');
      AStr.Add('}');
      AStr.SaveToFile(AFileCONF);
    end;

    StartFB(AArqFBStart);
    MMHistorico.Lines.Add('Executando comandos no banco de dados');
    FDConnection1.Connected := True;
    Qry.Close;
    Qry.SQL.Text := 'ALTER DATABASE INCLUDE ALL TO PUBLICATION;';
    Qry.ExecSQL;
    Qry.SQL.Text := 'ALTER DATABASE ENABLE PUBLICATION;';
    Qry.ExecSQL;
    FDConnection1.Close;

    StopFB(AArqFBStop);
    StartFB(AArqFBStart);
  finally
    if not ChkCriarFTP.IsChecked then
      MMHistorico.Lines.Add('Processo terminado');
    FreeAndNil(AStr);
    FDConnection1.Connected := False;
    if TFile.Exists(AArqFBStart) then
      TFile.Delete(AArqFBStart);
    if TFile.Exists(AArqFBStop) then
      TFile.Delete(AArqFBStop);
    TJeraLoading.Hide;
  end;
  if ChkCriarFTP.IsChecked then
    BtnArquivoFTP.OnClick(nil);
end;

procedure TFrmMain._MasterOff;
var
  AStr: TStringList;
  ArqBATF: string;
  AArqFBStart: string;
  AArqFBStop: string;
begin
  TJeraLoading.Show(Self, 'Retirando Replicação do Banco Principal');
  MMHistorico.Lines.Clear;
  AStr := TStringList.Create;
  try
    MMHistorico.Lines.Add('Alterando arquivo Replication.conf');
    var AFileCONF := TPath.Combine(EdtFirebirdPath.Text, 'Replication.conf');
    AStr.LoadFromFile(AFileCONF);
    var IIdx := AStr.IndexOf('database = ' + EdtFDBFile.Text);
    if IIdx > -1 then
    begin
      var IConta := IIdx + 6;
      for var I := IConta - 1 downto IIdx do
      begin
        AStr.Delete(I);
      end;
      AStr.SaveToFile(AFileCONF);
    end;
    MMHistorico.Lines.Add('Executando comandos no banco de dados');
    FDConnection1.Connected := True;
    Qry.Close;
    Qry.SQL.Text := 'alter database disable PUBLICATION;';
    Qry.ExecSQL;
    Qry.SQL.Text := 'alter database exclude all from PUBLICATION;';
    Qry.ExecSQL;

    ArqBATF := TPath.Combine(TPath.GetLibraryPath, 'TaskAgend.bat');
    AStr.Clear;
    AStr.Add('schtasks /delete /tn "JeraFTPReplica" /f');
    AStr.SaveToFile(ArqBATF);

    ShellExecuteAndWait('open', ArqBATF, '', '', 0, True);

    AArqFBStop := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTOP.bat');
    AArqFBStart := TPath.Combine(TDirectory.GetCurrentDirectory, 'FBSTART.bat');
    StopFB(AArqFBStop);
    StartFB(AArqFBStart);
  finally
    MMHistorico.Lines.Add('Processo terminado');
    TFile.Delete(ArqBATF);
    FreeAndNil(AStr);
    FDConnection1.Connected := False;
    // Excluir dados de FTP e agendamentos
    if TDirectory.Exists(TPath.Combine(TDirectory.GetCurrentDirectory, 'WinSCP')) then
    begin
      try
        TDirectory.Delete(TPath.Combine(TDirectory.GetCurrentDirectory, 'WinSCP'), True);
      except
      end;
    end;

    if TFile.Exists(TPath.Combine(TDirectory.GetCurrentDirectory, 'Bat_To_Exe_Converter.exe')) then
    begin
      try
        TFile.Delete(TPath.Combine(TDirectory.GetCurrentDirectory, 'Bat_To_Exe_Converter.exe'));
      except
      end;
    end;
    if TFile.Exists(AArqFBStart) then
      TFile.Delete(AArqFBStart);
    if TFile.Exists(AArqFBStop) then
      TFile.Delete(AArqFBStop);
    TJeraLoading.Hide;
  end;
end;

end.
