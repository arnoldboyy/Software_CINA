unit uNutriologos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, mysql57conn, SQLDB, DB, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBCtrls, ExtCtrls, ComCtrls, Buttons, DBExtCtrls,
  PReport, uBuscarNutriologos, uConstantes;

type

  { TfrmNutriologos }

  TfrmNutriologos = class(TForm)
    DataSource1: TDataSource;
    eDBNombre: TDBMemo;
    eDBGrupo: TDBEdit;
    eDBfechaNac: TDBEdit;
    eDBMatricula: TDBEdit;
    btnNext: TImage;
    btnFormer: TImage;
    impresora: TPReport;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblConectar: TLabel;
    Buscar: TPanel;
    Connection: TMySQL57Connection;
    Panel1: TPanel;
    Panel2: TPanel;
    Altas: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;

    PRLabel1: TPRLabel;
    panelReport: TPRLayoutPanel;
    PRLabel2: TPRLabel;
    PRLabel3: TPRLabel;
    PRLabel4: TPRLabel;
    PRLabel5: TPRLabel;
    PRPage1: TPRPage;
    PRRect1: TPRRect;
    Query: TSQLQuery;
    Transacion: TSQLTransaction;
    procedure btnNextClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnAltasClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure eDBMatriculaChange(Sender: TObject);
    procedure eDBNombreClick(Sender: TObject);


    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnFormerClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure eDBNombreChange(Sender: TObject);
    procedure nRegistros();
    function obNumero(): integer;
    procedure BuscarClick(Sender: TObject);
    procedure AltasClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure Panel8Click(Sender: TObject);

  private

  public
    procedure conectarBD;
    procedure createColumnMatricula(matricula, x, y: integer);
    procedure createColumnNombre(nombre: string; x, y: integer);
    procedure createColumnGrupo(grupo, x, y: integer);
    procedure createColumnfechaNac(fechaNac: TDateTime; x, y: integer);
  end;

var
  frmNutriologos: TfrmNutriologos;

implementation

{$R *.lfm}

{ TfrmNutriologos }

function TfrmNutriologos.obNumero(): integer;
var
  numRegActual: integer;
begin
  Query.Last;
  numRegActual := Query.RecNo;
  Result := numRegActual;
end;

procedure TfrmNutriologos.BuscarClick(Sender: TObject);
begin
  frmBuscarNutriologos.ShowModal;
end;

procedure TfrmNutriologos.AltasClick(Sender: TObject);
var
  numReg: integer;
begin
  if Altas.Caption = 'Altas' then
  begin
    numReg := obNumero;
    Query.Open;
    Query.Insert;
    Altas.Caption := 'Guardar';
    Exit;

  end
  else
  begin
    Query.Post;
    Query.ApplyUpdates;
    Altas.Caption := 'Altas';
    Query.Refresh;
    nRegistros;
  end;
end;

procedure TfrmNutriologos.Panel1Click(Sender: TObject);
begin
  if Panel1.Caption = 'Modificar' then
  begin
    Query.Open;
    Query.Edit;

    Panel1.Caption := 'Guardar';
  end
  else
  begin
    Query.Post;
    Query.UpdateMode := upWhereAll;
    Query.ApplyUpdates;
    Panel1.Caption := 'Modificar';

    Query.Refresh;
    nRegistros();

    ShowMessage('Reporte actualizado');

  end;
end;

procedure TfrmNutriologos.Panel3Click(Sender: TObject);
begin
  if Query.RecordCount > 0 then
  begin
    Query.Delete;
    Query.UpdateMode := upWhereAll;
    Query.ApplyUpdates;
    Query.Close;
    Query.Open;
    nRegistros();
  end;
end;

procedure TfrmNutriologos.Panel4Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmNutriologos.Panel5Click(Sender: TObject);
var
  relativeY: integer;
begin

  relativeY := 120;

  Query.First;
  while not Query.EOF do
  begin

    relativeY += 40;

    createColumnMatricula(Query.FieldByName('Matricula').AsInteger, 40, relativeY);
    createColumnNombre(Query.FieldByName('nombre').AsString, 192, relativeY);
    createColumnGrupo(Query.FieldByName('grupo').AsInteger, 508, relativeY);


    createColumnfechaNac(Query.FieldByName('fechaNac').AsDateTime, 352, relativeY);


    Query.Next;
  end;

  impresora.FileName := 'Reporte de Nutriologos.pdf';
  impresora.BeginDoc;
  impresora.Print(PRPage1);
  impresora.EndDoc;

  ShowMessage('Reporte de Nutriologos generado!');

end;

procedure TfrmNutriologos.Panel6Click(Sender: TObject);
begin
  Query.Prior;
  nRegistros();
end;

procedure TfrmNutriologos.Panel7Click(Sender: TObject);
begin
  Query.Next;
  nRegistros();
end;

procedure TfrmNutriologos.Panel8Click(Sender: TObject);
begin
  Query.Last;
  nRegistros();
end;



procedure TfrmNutriologos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Connection.Close();
end;

procedure TfrmNutriologos.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Query.Close;
  CanClose := True;
end;

procedure TfrmNutriologos.FormCreate(Sender: TObject);
begin
  conectarBD;

  Query.DataBase := Connection;
  Query.UsePrimaryKeyAsKey := False;
  Query.SQL.Text := 'Select * from nutriologo';
  DataSource1.DataSet := Query;
  if Connection.Connected then
  begin
    lblConectar.Caption := 'Conectada';
  end;
  Query.Open;
  eDBMatricula.DataField := 'matricula';
  eDBMatricula.DataSource := DataSource1;
  eDBNombre.DataField := 'nombre';
  eDBNombre.DataSource := DataSource1;
  eDBGrupo.DataField := 'grupo';
  eDBGrupo.DataSource := DataSource1;
  eDBfechaNac.DataField := 'fechaNac';
  eDBfechaNac.DataSource := DataSource1;

  nRegistros;
  btnNext.Picture.LoadFromFile('imgs\siguiente.png');
  btnFormer.Picture.LoadFromFile('imgs\anterior.png');
end;

procedure TfrmNutriologos.btnFormerClick(Sender: TObject);
begin
  Query.Prior;
  nRegistros();
end;

procedure TfrmNutriologos.Label5Click(Sender: TObject);
begin

end;

procedure TfrmNutriologos.eDBNombreChange(Sender: TObject);
begin

end;



procedure TfrmNutriologos.conectarBD;
begin
  try
    Connection.HostName := BD_Host;
    Connection.Password := BD_Passw;
    Connection.Port := BD_Port;
    Connection.DatabaseName := BD_Name;
    Connection.UserName := BD_User;
    Connection.Connected := True;
    Connection.KeepConnection := True;

    Transacion.DataBase := Connection;
    Transacion.Action := caCommit;
    Transacion.Active := True;

  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;

end;




procedure TfrmNutriologos.createColumnMatricula(matricula, x, y: integer);
var
  labelMatricula: TPRLabel;
begin
  labelMatricula := TPRLabel.Create(nil);

  with labelMatricula do
  begin
    Parent := panelReport;
    left := x;
    Top := y;


    Caption := IntToStr(matricula);
  end;
end;

procedure TfrmNutriologos.createColumnNombre(nombre: string; x, y: integer);
var
  labelNombre: TPRLabel;
begin
  labelNombre := TPRLabel.Create(nil);

  with labelNombre do
  begin
    Parent := panelReport;
    left := x;
    Top := y;

    Caption := nombre;
  end;
end;

procedure TfrmNutriologos.createColumnGrupo(grupo, x, y: integer);
var
  labelGrupo: TPRLabel;
begin
  labelGrupo := TPRLabel.Create(nil);

  with labelGrupo do
  begin
    Parent := panelReport;
    left := x;
    Top := y;

    Caption := IntToStr(grupo);
  end;

end;




procedure TfrmNutriologos.createColumnfechaNac(fechaNac: TDateTime; x, y: integer);
var
  labelfechaNac: TPRLabel;
begin
  labelfechaNac := TPRLabel.Create(nil);

  with labelfechaNac do
  begin
    Parent := panelReport;
    left := x;
    Top := y;

    Caption := DateToStr(fechaNac);

  end;

end;

procedure TfrmNutriologos.nRegistros();
var
  i: integer;
begin
  i := Query.RecNo;
end;

procedure TfrmNutriologos.btnSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNutriologos.btnNextClick(Sender: TObject);
begin
  Query.Next;
  nRegistros();
end;

procedure TfrmNutriologos.btnAltasClick(Sender: TObject);
begin

end;



procedure TfrmNutriologos.btnEliminarClick(Sender: TObject);
begin
  if Query.RecordCount > 0 then
  begin
    Query.Delete;
    Query.UpdateMode := upWhereAll;
    Query.ApplyUpdates;
    Query.Close;
    Query.Open;
    nRegistros();
  end;
end;

procedure TfrmNutriologos.btnBuscarClick(Sender: TObject);
begin

end;



procedure TfrmNutriologos.btnExportarClick(Sender: TObject);
var
  relativeY: integer;
begin

  relativeY := 120;

  Query.First;
  while not Query.EOF do
  begin

    relativeY += 40;
    createColumnMatricula(Query.FieldByName('matricula').AsInteger, 40, relativeY);
    createColumnNombre(Query.FieldByName('nombre').AsString, 192, relativeY);
    createColumnGrupo(Query.FieldByName('grupo').AsInteger, 352, relativeY);
    createColumnfechaNac(Query.FieldByName('fechaNac').AsDateTime, 508, relativeY);


    Query.Next;
  end;

  impresora.FileName := 'Reporte de presonas.pdf';
  impresora.BeginDoc;
  impresora.Print(PRPage1);
  impresora.EndDoc;

  ShowMessage('Reporte generado!');
end;

procedure TfrmNutriologos.eDBMatriculaChange(Sender: TObject);
var
  matricula: string;
  i: integer;
begin

  matricula := eDBMatricula.Text;


  for i := 1 to Length(matricula) do
  begin
    if not (matricula[i] in ['0'..'9']) then
    begin

      ShowMessage('La matrícula solo puede contener números.');
      Exit;
    end;
  end;
end;

procedure TfrmNutriologos.eDBNombreClick(Sender: TObject);
begin

end;




end.
