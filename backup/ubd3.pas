unit uBd3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBCtrls, ExtCtrls, ComCtrls, PReport, list;

type

  { TfrmNutriologos }

  TfrmNutriologos = class(TForm)
    btnPrimero: TButton;
    btnAnterior: TButton;
    btnSiguiente: TButton;
    btnUltimo: TButton;
    btnSalir: TButton;
    DataSource1: TDataSource;
    eDBGrupo: TDBEdit;
    eDBEdad: TDBEdit;
    eDBNombre: TDBEdit;
    eDBMatricula: TDBEdit;
    impresora: TPReport;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblConectar: TLabel;
    Connection: TMySQL80Connection;
    Buscar: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Altas: TPanel;
    Panel3: TPanel;
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
    procedure btnPrimeroClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnAltasClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure eDBMatriculaChange(Sender: TObject);


    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure nRegistros();
    function obNumero():Integer;
    procedure BuscarClick(Sender: TObject);
    procedure AltasClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);

  private

  public
   procedure conectarBD;
   procedure createColumnMatricula(matricula : string; x, y : integer);
   procedure createColumnNombre(nombre : string; x, y : integer);
   procedure createColumnGrupo(grupo, x, y : integer);
   procedure createColumnEdad(edad, x, y : integer);
  end;

var
  frmNutriologos: TfrmNutriologos;

implementation

{$R *.lfm}

{ TfrmNutriologos }

function TfrmNutriologos.obNumero():Integer;
var
  numRegActual:Integer;
  begin
    Query.Last;
    numRegActual:=Query.RecNo;
    Result:=numRegActual;
  end;

procedure TfrmNutriologos.BuscarClick(Sender: TObject);
begin
  frmList.ShowModal;
end;

procedure TfrmNutriologos.AltasClick(Sender: TObject);

  var
  numReg:Integer;
begin
    if Altas.Caption='Nuevo' then
    begin
      numReg:=obNumero;
      Query.Open;
      Query.Insert;
      Altas.Caption:='Guardar';
      Exit

    end
    else
    begin
      Query.Post;
      Query.ApplyUpdates;
      Altas.Caption:='Nuevo';
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

    Panel1.Caption:='Guardar';
  end
  else
  begin
    Query.Post;
    Query.UpdateMode:=upWhereAll;
    Query.ApplyUpdates;
    Panel1.Caption:='Modificar';

    Query.Refresh;
    nRegistros();

    ShowMessage('Reporte actualizado');

  end;
end;

procedure TfrmNutriologos.Panel3Click(Sender: TObject);
begin
  if Query.RecordCount>0 then
  begin
    Query.Delete;
    Query.UpdateMode:=upWhereAll;
    Query.ApplyUpdates;
    Query.Close;
    Query.Open;
    nRegistros();
  end;
end;

procedure TfrmNutriologos.Panel5Click(Sender: TObject);
  var
    relativeY : integer;
  begin


    relativeY:=120;

    Query.First;
    while not Query.EOF do
    begin

      relativeY += 40;
      createColumnMatricula(Query.FieldByName('Matricula').AsString, 40, relativeY);
      createColumnNombre(Query.FieldByName('nombre').AsString, 192, relativeY);
      createColumnGrupo(Query.FieldByName('grupo').AsInteger, 508, relativeY);
      createColumnEdad(Query.FieldByName('edad').AsInteger, 352, relativeY);

      Query.Next;
    end;

    impresora.FileName:='Reporte de Nutriologos.pdf';
    impresora.BeginDoc;
    impresora.Print(PRPage1);
    impresora.EndDoc;

    ShowMessage('Reporte de Nutriologos generado!');

end;



procedure TfrmNutriologos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   Connection.Close();
end;

procedure TfrmNutriologos.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    Query.Close;
    CanClose:=True;
end;

procedure TfrmNutriologos.FormCreate(Sender: TObject);
begin
  conectarBD;

  Query.DataBase:=Connection;
  Query.UsePrimaryKeyAsKey:=False;
  Query.SQL.Text:='Select * from Nutris';
  DataSource1.DataSet:=Query;
  if Connection.Connected then
  begin
    lblConectar.Caption:='Conectada';
  end;
    Query.Open;
    eDBMatricula.DataField:='matricula';
    eDBMatricula.DataSource:=DataSource1;
    eDBNombre.DataField:='nombre';
    eDBNombre.DataSource:=DataSource1;
    eDBGrupo.DataField:='grupo';
    eDBGrupo.DataSource:=DataSource1;
    eDBEdad.DataField:='edad';
    eDBEdad.DataSource:=DataSource1;

    nRegistros;

end;



procedure TfrmNutriologos.conectarBD;
begin
  Connection.HostName:='localhost';
  Connection.Password:='root';
  Connection.Port:=3306;
  Connection.DatabaseName:='ProgramacionVisual';
  Connection.UserName:='root';
  Connection.Connected:=True;
  Connection.KeepConnection:=True;

  Transacion.DataBase:=Connection;
  Transacion.Action:=caCommit;
  Transacion.Active:=True;
end;

procedure TfrmNutriologos.createColumnMatricula(matricula: string; x, y: integer);
var
  labelMatricula : TPRLabel;
begin
  labelMatricula := TPRLabel.Create(nil);

  with labelMatricula do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption:=matricula;
  end;
end;

procedure TfrmNutriologos.createColumnNombre(nombre: string; x, y: integer);
var
  labelNombre : TPRLabel;
begin
  labelNombre := TPRLabel.Create(nil);

  with labelNombre do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption:=nombre;
  end;
end;

procedure TfrmNutriologos.createColumnGrupo(grupo,x, y: integer);
var
  labelGrupo : TPRLabel;
begin
  labelGrupo := TPRLabel.Create(nil);

  with labelGrupo do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption:=IntToStr(grupo);
  end;

end;

procedure TfrmNutriologos.createColumnEdad(edad, x, y: integer);
var
  labelEdad : TPRLabel;
begin
  labelEdad := TPRLabel.Create(nil);

  with labelEdad do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption:=IntToStr(edad);
  end;

end;

procedure TfrmNutriologos.nRegistros();
var
  i:Integer;
  begin
    i:=Query.RecNo;
  end;

procedure TfrmNutriologos.btnSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNutriologos.btnAltasClick(Sender: TObject);
begin

end;



procedure TfrmNutriologos.btnEliminarClick(Sender: TObject);
begin
  if Query.RecordCount>0 then
  begin
    Query.Delete;
    Query.UpdateMode:=upWhereAll;
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
  relativeY : integer;
begin


  relativeY:=120;

  Query.First;
  while not Query.EOF do
  begin

    relativeY += 40;
    createColumnMatricula(Query.FieldByName('matricula').AsString, 40, relativeY);
    createColumnNombre(Query.FieldByName('nombre').AsString, 192, relativeY);
    createColumnEdad(Query.FieldByName('edad').AsInteger, 352, relativeY);
    createColumnGrupo(Query.FieldByName('grupo').AsInteger, 508, relativeY);

    Query.Next;
  end;

  impresora.FileName:='Reporte de presonas.pdf';
  impresora.BeginDoc;
  impresora.Print(PRPage1);
  impresora.EndDoc;

  ShowMessage('Reporte generado!');
end;

procedure TfrmNutriologos.eDBMatriculaChange(Sender: TObject);
begin

end;




procedure TfrmNutriologos.btnPrimeroClick(Sender: TObject);
begin
  Query.First;
  nRegistros();
end;

procedure TfrmNutriologos.btnAnteriorClick(Sender: TObject);
begin
  Query.Prior;
  nRegistros();
end;

procedure TfrmNutriologos.btnSiguienteClick(Sender: TObject);
begin
  Query.Next;
  nRegistros();
end;

procedure TfrmNutriologos.btnUltimoClick(Sender: TObject);
begin
  Query.Last;
  nRegistros();
end;


end.

