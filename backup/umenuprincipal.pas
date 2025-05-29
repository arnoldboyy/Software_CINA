unit uMenuPrincipal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, PopupNotifier, uNutriologos, uPacientes,
  uconsultorios, uCreditos, uConstantes, uAgenda, mysql57conn, SQLDB, DB;

type

  { TfrmMenuPrincipal }

  TfrmMenuPrincipal = class(TForm)
    Agenda: TImage;
    Consultorios: TImage;
    DataSource1: TDataSource;
    Estadisticas: TImage;
    frmHome3: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lvConsultas: TListView;
    MySQL57Connection1: TMySQL57Connection;
    Nutriologos: TImage;
    Pacientes: TImage;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure ActualizarListView;
    procedure AgendaClick(Sender: TObject);
    procedure ConsultoriosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NutriologosClick(Sender: TObject);
    procedure PacientesClick(Sender: TObject);
    procedure Panel10Click(Sender: TObject);
  private

  public

  end;

var
  frmMenuPrincipal: TfrmMenuPrincipal;

implementation

{$R *.lfm}

{ TfrmMenuPrincipal }

procedure TfrmMenuPrincipal.ActualizarListView;
begin
  try
    SQLQuery1.SQL.Text :=
      'SELECT n.nombre AS Nutriologo, p.nombre AS Paciente, c.nombreAula AS Consultorio, '
      + 'a.fecha, a.horaInicio, a.horaFinal ' + 'FROM agenda a ' +
      'JOIN nutriologo n ON a.matricula = n.matricula ' +
      'JOIN paciente p ON a.idPaciente = p.idPaciente ' +
      'JOIN consultorio c ON a.idConsultorio = c.idConsultorio ' +
      'where a.fecha = :fechaa ORDER BY a.fecha, a.horaInicio';
    SQLQuery1.ParamByName('fechaa').AsDate := Now;
    SQLQuery1.Open;

    lvConsultas.Items.Clear;
    while not SQLQuery1.EOF do
    begin
      with lvConsultas.Items.Add do
      begin
        Caption := DateToStr(SQLQuery1.FieldByName('fecha').AsDateTime);
        SubItems.Add(TimeToStr(SQLQuery1.FieldByName('horaInicio').AsDateTime) +
          ' - ' + TimeToStr(SQLQuery1.FieldByName('horaFinal').AsDateTime));
        SubItems.Add(SQLQuery1.FieldByName('Consultorio').AsString);
        SubItems.Add(SQLQuery1.FieldByName('Nutriologo').AsString);
      end;
      SQLQuery1.Next;
    end;

    SQLQuery1.Close;
  except
    on E: Exception do
      ShowMessage('Error al actualizar ListView: ' + E.Message);
  end;
end;

procedure TfrmMenuPrincipal.AgendaClick(Sender: TObject);
begin
  frmAgenda.ShowModal;
end;

procedure TfrmMenuPrincipal.ConsultoriosClick(Sender: TObject);
begin
  frmConsultorios.ShowModal;
end;

procedure TfrmMenuPrincipal.FormCreate(Sender: TObject);
begin
  // Configurar la conexión a la base de datos
  MySQL57Connection1.HostName := BD_Host;
  MySQL57Connection1.Password := BD_Passw;
  MySQL57Connection1.DatabaseName := BD_Name;
  MySQL57Connection1.UserName := BD_User;

  try
    MySQL57Connection1.Connected := True;
    SQLTransaction1.Active := True;

    ActualizarListView;
  except
    on E: Exception do
      ShowMessage('Error al conectar a la base de datos: ' + E.Message);
  end;

  Agenda.Picture.LoadFromFile(Application.Location + 'imgs/agendaIMG.png');
  Nutriologos.Picture.LoadFromFile(Application.Location + 'imgs/enfermeraIMG.png');
  Pacientes.Picture.LoadFromFile(Application.Location + 'imgs/pacientesIMG.png');
  Consultorios.Picture.LoadFromFile(Application.Location + 'imgs/hospitalIMG.png');
  Estadisticas.Picture.LoadFromFile(Application.Location + 'imgs/estadisticasIMG.png');

end;

procedure TfrmMenuPrincipal.NutriologosClick(Sender: TObject);
begin
  frmNutriologos.ShowModal;
end;

procedure TfrmMenuPrincipal.PacientesClick(Sender: TObject);
begin
  frmPacientes.ShowModal;
end;

procedure TfrmMenuPrincipal.Panel10Click(Sender: TObject);
begin
  frmCreditos.ShowModal;
end;

end.
