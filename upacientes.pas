unit uPacientes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, mysql57conn, SQLDB, DB, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBCtrls, ExtCtrls, Menus, PReport,
  uBuscarpacientes, uConstantes;

type

  { TfrmPacientes }

  TfrmPacientes = class(TForm)
    Altas: TPanel;

    btnFormer: TImage;
    btnNext: TImage;
    Buscar: TPanel;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    eDBDireccion: TDBMemo;
    eDBNombre: TDBMemo;
    eDBFechaNac: TDBEdit;
    eDBTelefono: TDBEdit;
    impresora: TPReport;
    Label2: TLabel;
    Label3: TLabel;
    Label14: TLabel;
    Label5: TLabel;
    lblConectar: TLabel;
    Connection: TMySQL57Connection;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    panelReport: TPRLayoutPanel;
    PRLabel1: TPRLabel;
    PRLabel2: TPRLabel;
    PRLabel3: TPRLabel;
    D: TPRLabel;
    Dir: TPRLabel;
    PRPage1: TPRPage;
    PRRect1: TPRRect;
    Query: TSQLQuery;
    Transacion: TSQLTransaction;

    procedure AltasClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);


    procedure btnExportarClick(Sender: TObject);
    procedure btnFormerClick(Sender: TObject);

    procedure btnNextClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure BuscarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    function obNumero():Integer;

    procedure nRegistros;
    procedure Panel1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
  private

  public
    procedure ConectarBD;
    procedure createColumnNombre(nombre : string; x, y : integer);
   procedure createColumnfechaNac(fechaNac: TDateTime; x, y: integer);
   procedure createColumnTelefono(telefono:  string; x, y : integer);
   procedure createColumnDireccion(direccion : string; x, y : integer);
  end;

var
  frmPacientes: TfrmPacientes;

implementation

{$R *.lfm}
function TfrmPacientes.obNumero():Integer;
var
  numRegActual:Integer;
  begin
    Query.Last;
    numRegActual:=Query.RecNo;
    Result:=numRegActual;
  end;

procedure TfrmPacientes.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
   Connection.Close();
end;

procedure TfrmPacientes.Button2Click(Sender: TObject);
begin

end;



procedure TfrmPacientes.btnAnteriorClick(Sender: TObject);
begin

end;

procedure TfrmPacientes.AltasClick(Sender: TObject);
var
 numReg:Integer;
begin
   if Altas.Caption='Altas' then
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
     Altas.Caption:='Altas';
     Query.Refresh;
     nRegistros;
   end;

end;



procedure TfrmPacientes.btnExportarClick(Sender: TObject);
 var
  relativeY : integer;
begin


  relativeY:=120;

  Query.First;
  while not Query.EOF do
  begin

    relativeY += 40;
    createColumnNombre(Query.FieldByName('nombre').AsString, 40, relativeY);
    createColumnfechaNac(Query.FieldByName('fechaNac').AsDateTime, 160, relativeY);
    createColumnDireccion(Query.FieldByName('direccion').AsString, 260, relativeY);
    createColumnTelefono(Query.FieldByName('telefono').AsString, 425, relativeY);


    Query.Next;
  end;

  impresora.FileName:='Reporte de Pacientes.pdf';
  impresora.BeginDoc;
  impresora.Print(PRPage1);
  impresora.EndDoc;

  ShowMessage('Reporte generado!');

end;

procedure TfrmPacientes.btnFormerClick(Sender: TObject);
begin
  Query.Prior;
  nRegistros();
end;



procedure TfrmPacientes.btnNextClick(Sender: TObject);
begin
  Query.Next;
  nRegistros();
end;

procedure TfrmPacientes.btnSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPacientes.BuscarClick(Sender: TObject);
begin
  frmBuscarPacientes.ShowModal;
end;


  procedure TfrmPacientes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    Query.Close;
    CanClose:=True;
end;

procedure TFrmPacientes.FormCreate(Sender: TObject);
begin

  conectarBD;

  Query.DataBase:=Connection;
  Query.UsePrimaryKeyAsKey:=False;
  Query.SQL.Text:='Select * from paciente';
  DataSource1.DataSet:=Query;
  if Connection.Connected then
  begin
    lblConectar.Caption:='Conectada';
  end;
    Query.Open;
    eDBNombre.DataField:='nombre';
    eDBNombre.DataSource:=DataSource1;
    eDBFechaNac.DataField:='fechaNac';
    eDBFechaNac.DataSource:=DataSource1;
    eDBTelefono.DataField:='telefono';
    eDBTelefono.DataSource:=DataSource1;
    eDBDireccion.DataField:='Direccion';
    eDBDireccion.DataSource:=DataSource1;

    nRegistros;
    btnNext.Picture.LoadFromFile('imgs\siguiente.png');
      btnFormer.Picture.LoadFromFile('imgs\anterior.png');

end;

procedure TfrmPacientes.img1Click(Sender: TObject);
begin

end;

procedure TfrmPacientes.Label3Click(Sender: TObject);
begin

end;

 procedure TfrmPacientes.conectarBD;
begin
  Connection.HostName := BD_Host;
  Connection.Password := BD_Passw;
  Connection.Port := BD_Port;
  Connection.DatabaseName := BD_Name;
  Connection.UserName := BD_User;
  Connection.Connected:=True;
  Connection.KeepConnection:=True;

  Transacion.DataBase:=Connection;
  Transacion.Action:=caCommit;
  Transacion.Active:=True;
end;

 procedure TfrmPacientes.nRegistros();
var
  i:Integer;
  begin
    i:=Query.RecNo;
  end;

procedure TfrmPacientes.Panel1Click(Sender: TObject);
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

procedure TfrmPacientes.Panel3Click(Sender: TObject);
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

procedure TfrmPacientes.Panel4Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPacientes.Panel5Click(Sender: TObject);
 var
   relativeY : integer;
 begin


   relativeY:=120;

   Query.First;
   while not Query.EOF do
   begin

     relativeY += 40;
     createColumnNombre(Query.FieldByName('nombre').AsString, 40, relativeY);
     createColumnfechaNac(Query.FieldByName('fechaNac').AsDateTime, 160, relativeY);
     createColumnDireccion(Query.FieldByName('direccion').AsString, 260, relativeY);
     createColumnTelefono(Query.FieldByName('telefono').AsString, 425, relativeY);


     Query.Next;
   end;

   impresora.FileName:='Reporte de Pacientes.pdf';
   impresora.BeginDoc;
   impresora.Print(PRPage1);
   impresora.EndDoc;

   ShowMessage('Reporte generado!');


end;

 procedure TfrmPacientes.createColumnNombre(nombre: string; x, y: integer);
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


procedure TfrmPacientes.createColumnfechaNac(fechaNac: TDateTime; x, y: integer);
var
  labelfechaNac : TPRLabel;
begin
  labelfechaNac := TPRLabel.Create(nil);

  with labelfechaNac do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption := DateToStr(fechaNac);
  end;
end;

procedure TfrmPacientes.createColumnTelefono(telefono: string; x, y: integer);
var
  labelTelefono : TPRLabel;
begin
  labelTelefono:= TPRLabel.Create(nil);

  with labelTelefono do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption:=telefono;
  end;

end;

procedure TfrmPacientes.createColumnDireccion(direccion: string; x, y: integer);
var
  labelDireccion : TPRLabel;
begin
  labelDireccion := TPRLabel.Create(nil);

  with labelDireccion do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;

    Caption:=direccion;
  end;

end;
end.

