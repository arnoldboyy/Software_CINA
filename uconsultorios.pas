unit uconsultorios;

{$mode ObjFPC}{$H+}

interface

uses
   Classes, SysUtils, mysql80conn, mysql57conn, SQLDB, DB, Forms, Controls,
   Graphics, Dialogs, StdCtrls, DBCtrls, ExtCtrls, Menus, PReport,
   uBuscarconsultorios, uConstantes;

type

  { TfrmConsultorios }

  TfrmConsultorios = class(TForm)
    Altas: TPanel;
    btnFormer: TImage;
    btnNext: TImage;
    Buscar: TPanel;
    Button2: TButton;
    D: TPRLabel;
    DataSource1: TDataSource;
    eDBNota: TDBMemo;
    eDBUbicacion: TDBMemo;
    eDBNombreAula: TDBMemo;
    impresora: TPReport;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    PRPage1: TPRPage;
    PRRect1: TPRRect;
    Query: TSQLQuery;
    Transacion: TSQLTransaction;
    procedure AltasClick(Sender: TObject);
    procedure btnFormerClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure BuscarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    function obNumero():Integer;
    procedure nRegistros;
    procedure Panel1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
  private

  public
    procedure ConectarBD;
    procedure createColumnNombreAula(nombreAula : string; x, y : integer);
    procedure createColumnUbicacion(ubicacion:  string; x, y : integer);
    procedure createColumnNota(nota : string; x, y : integer);

  end;

var
  frmConsultorios: TfrmConsultorios;

implementation

{$R *.lfm}

{ TfrmConsultorios }
function TfrmConsultorios.obNumero():Integer;
var
  numRegActual:Integer;
  begin
    Query.Last;
    numRegActual:=Query.RecNo;
    Result:=numRegActual;
  end;



procedure TfrmConsultorios.FormCreate(Sender: TObject);
begin

  conectarBD;

  Query.DataBase:=Connection;
  Query.UsePrimaryKeyAsKey:=False;
  Query.SQL.Text:='Select * from consultorio';
  DataSource1.DataSet:=Query;
  if Connection.Connected then
  begin
    lblConectar.Caption:='Conectada';
  end;
    Query.Open;
    eDBNombreAula.DataField:='nombreAula';
    eDBNombreAula.DataSource:=DataSource1;
    eDBUbicacion.DataField:='ubicacion';
    eDBUbicacion.DataSource:=DataSource1;
    eDBNota.DataField:='nota';
    eDBNota.DataSource:=DataSource1;

    nRegistros;
    btnNext.Picture.LoadFromFile('imgs\siguiente.png');
      btnFormer.Picture.LoadFromFile('imgs\anterior.png');
end;

procedure TfrmConsultorios.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;

procedure TfrmConsultorios.BuscarClick(Sender: TObject);
begin
  frmBuscarconsultorios.ShowModal;
end;

procedure TfrmConsultorios.AltasClick(Sender: TObject);
var
  numReg: Integer;
begin
  if Altas.Caption = 'Altas' then
  begin
    // Validación de campos
    if (Trim(eDBNombreAula.Text) = '') or (Length(eDBNombreAula.Text) > 100) then
    begin
      ShowMessage('Por favor ingrese un nombre de aula válido (máx. 100 caracteres).');
      Exit;
    end;

    if (Trim(eDBUbicacion.Text) = '') or (Length(eDBUbicacion.Text) > 100) then
    begin
      ShowMessage('Por favor ingrese una ubicación válida (máx. 100 caracteres).');
      Exit;
    end;

    if (Trim(eDBNota.Text) = '') or (Length(eDBNota.Text) > 255) then
    begin
      ShowMessage('Por favor ingrese una nota válida (máx. 255 caracteres).');
      Exit;
    end;

    numReg := obNumero;
    Query.Open;
    Query.Insert;
    Query.FieldByName('nombreAula').AsString := eDBNombreAula.Text;
    Query.FieldByName('ubicacion').AsString := eDBUbicacion.Text;
    Query.FieldByName('nota').AsString := eDBNota.Text;
    Altas.Caption := 'Guardar';
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

procedure TfrmConsultorios.btnFormerClick(Sender: TObject);
begin
    Query.Prior;
  nRegistros();
end;

procedure TfrmConsultorios.btnNextClick(Sender: TObject);
begin
  Query.Next;
  nRegistros();
end;

procedure TfrmConsultorios.nRegistros();
var
  i:Integer;
  begin
    i:=Query.RecNo;
  end;

procedure TfrmConsultorios.Panel1Click(Sender: TObject);
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

procedure TfrmConsultorios.Panel3Click(Sender: TObject);
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

procedure TfrmConsultorios.Panel4Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultorios.Panel5Click(Sender: TObject);
var
   relativeY : integer;
 begin


   relativeY:=120;

   Query.First;
   while not Query.EOF do
   begin

     relativeY += 40;
     createColumnNombreAula(Query.FieldByName('nombreAula').AsString, 40, relativeY);
     createColumnUbicacion(Query.FieldByName('ubicacion').AsString, 160, relativeY);
     createColumnNota(Query.FieldByName('nota').AsString, 360, relativeY);


     Query.Next;
   end;

   impresora.FileName:='Reporte de Consultorios.pdf';
   impresora.BeginDoc;
   impresora.Print(PRPage1);
   impresora.EndDoc;

   ShowMessage('Reporte generado!');


end;

procedure TfrmConsultorios.FormCloseQuery(Sender: TObject; var CanClose: Boolean
  );
begin

end;


procedure TfrmConsultorios.ConectarBD;
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

procedure TfrmConsultorios.createColumnNombreAula(nombreAula: string; x, y: integer);
var
  labelNombreAula : TPRLabel;
begin
  labelNombreAula := TPRLabel.Create(nil);

  with labelNombreAula do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;
    Caption:=nombreAula;
  end;

end;



procedure TfrmConsultorios.createColumnUbicacion(ubicacion: string; x, y: integer);
var
  labelUbicacion : TPRLabel;
begin
  labelUbicacion := TPRLabel.Create(nil);

  with labelUbicacion do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;
    Caption:=ubicacion;
  end;


end;

procedure TfrmConsultorios.createColumnNota(nota: string; x, y: integer);
var
  labelNota : TPRLabel;
begin
  labelNota := TPRLabel.Create(nil);

  with labelNota do
  begin
    Parent := panelReport;
    left := x;
    Top:= y;
    Caption:=nota;
  end;

end;

end.

