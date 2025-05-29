unit uAgenda;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql57conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  Calendar, EditBtn, ExtCtrls, StdCtrls, DBCtrls, ComCtrls, PopupNotifier,
  SynHighlighterJava, DateUtils, uConstantes;

type
  TAlumno = record
    Matricula: integer;
    Nombre: string;
  end;

  TPaciente = record
    ID: integer;
    Nombre: string;
  end;

  TConsultorio = record
    ID: integer;
    NombreAula: string;
  end;

  { TfrmAgenda }

  TfrmAgenda = class(TForm)
    btnAgregar: TButton;
    DataSource1: TDataSource;
    dtpFecha: TDateEdit;
    cmbNutri: TComboBox;
    cmbPaciente: TComboBox;
    cmbConsultorio: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lvConsultas: TListView;
    MySQL57Connection1: TMySQL57Connection;
    Panel1: TPanel;
    PopupNotifier1: TPopupNotifier;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    tmpHoraFin: TTimeEdit;
    tmpHoraIn: TTimeEdit;
    procedure dtpFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmpHoraFinAcceptTime(Sender: TObject; var ATime: TDateTime;
      var AcceptTime: boolean);
    procedure tmpHoraFinChange(Sender: TObject);

    procedure tmpHoraInAcceptTime(Sender: TObject; var ATime: TDateTime;
      var AcceptTime: boolean);
    procedure btnAgregarClick(Sender: TObject);
  private
    FAlumnos: array of TAlumno;
    FPacientes: array of TPaciente;
    FConsultorios: array of TConsultorio;
    procedure CargarAlumnos;
    procedure CargarPacientes;
    procedure CargarConsultorios;
    procedure VerificarDisponibilidad;
    procedure InsertarConsulta;
    procedure ActualizarListView;
    function VerificarHoras: boolean;
    procedure MostrarNotificacionSobreComponente(Mensaje: string;
      Componente: TWinControl);
  public

  end;

var
  frmAgenda: TfrmAgenda;

implementation

{$R *.lfm}

{ TfrmAgenda }

procedure TfrmAgenda.FormCreate(Sender: TObject);
begin
  // Configurar la conexión a la base de datos
  MySQL57Connection1.HostName := BD_Host;
  MySQL57Connection1.Password := BD_Passw;
  MySQL57Connection1.DatabaseName := BD_Name;
  MySQL57Connection1.UserName := BD_User;

  try
    MySQL57Connection1.Connected := True;
    SQLTransaction1.Active := True;

    // Cargar los datos
    CargarAlumnos;
    CargarPacientes;
    CargarConsultorios;

    // Configurar autocompletar en los ComboBox
    cmbNutri.AutoComplete := True;
    cmbNutri.AutoDropDown := True;
    cmbPaciente.AutoComplete := True;
    cmbPaciente.AutoDropDown := True;
    cmbConsultorio.AutoComplete := True;
    cmbConsultorio.AutoDropDown := True;

    // Configurar fecha y hora iniciales
    dtpFecha.Date := Now;
    tmpHoraIn.Time := Time;
    tmpHoraFin.Time := IncHour(Time, 1);

    // Deshabilitar el botón Agregar al inicio
    btnAgregar.Enabled := False;

    ActualizarListView;

    //// Añadir evento para comprobar disponibilidad
    //tmpHoraIn.OnChange := @tmpHoraInAcceptTime;
    //dtpFecha.OnChange := @tmpHoraInAcceptTime;
    //cmbNutri.OnChange := @tmpHoraInAcceptTime;
    //cmbPaciente.OnChange := @tmpHoraInAcceptTime;
    //cmbConsultorio.OnChange := @tmpHoraInAcceptTime;
  except
    on E: Exception do
      ShowMessage('Error al conectar a la base de datos: ' + E.Message);
  end;
end;

procedure TfrmAgenda.FormShow(Sender: TObject);
begin
  cmbNutri.ItemIndex := 0;
end;

procedure TfrmAgenda.tmpHoraFinAcceptTime(Sender: TObject; var ATime: TDateTime;
  var AcceptTime: boolean);
begin
  if VerificarHoras then
  begin
    // Verificar disponibilidad de la fecha y rango de hora
    VerificarDisponibilidad;
    VerificarDisponibilidad;
  end;
end;

procedure TfrmAgenda.tmpHoraFinChange(Sender: TObject);
begin

end;

procedure TfrmAgenda.tmpHoraInAcceptTime(Sender: TObject; var ATime: TDateTime;
  var AcceptTime: boolean);
begin
  // Actualizar hora final cuando cambie la hora inicial
  tmpHoraFin.Time := IncHour(tmpHoraIn.Time, 1);
  // Verificar disponibilidad de la fecha y rango de hora
  VerificarDisponibilidad;
  VerificarDisponibilidad;
end;

procedure TfrmAgenda.CargarAlumnos;
var
  Alumno: TAlumno;
begin
  try
    SQLQuery1.SQL.Text := 'SELECT matricula, nombre FROM nutriologo';
    SQLQuery1.Open;

    cmbNutri.Items.Clear;
    SetLength(FAlumnos, 0);

    while not SQLQuery1.EOF do
    begin
      Alumno.Matricula := SQLQuery1.FieldByName('matricula').AsInteger;
      Alumno.Nombre := SQLQuery1.FieldByName('nombre').AsString;

      cmbNutri.Items.Add(Alumno.Nombre);
      SetLength(FAlumnos, Length(FAlumnos) + 1);
      FAlumnos[High(FAlumnos)] := Alumno;

      SQLQuery1.Next;
    end;

    SQLQuery1.Close;
  except
    on E: Exception do
      ShowMessage('Error al cargar alumnos: ' + E.Message);
  end;
end;

procedure TfrmAgenda.CargarPacientes;
var
  Paciente: TPaciente;
begin
  try
    SQLQuery1.SQL.Text := 'SELECT idPaciente, nombre FROM paciente';
    SQLQuery1.Open;

    cmbPaciente.Items.Clear;
    SetLength(FPacientes, 0);

    while not SQLQuery1.EOF do
    begin
      Paciente.ID := SQLQuery1.FieldByName('idPaciente').AsInteger;
      Paciente.Nombre := SQLQuery1.FieldByName('nombre').AsString;

      cmbPaciente.Items.Add(Paciente.Nombre);
      SetLength(FPacientes, Length(FPacientes) + 1);
      FPacientes[High(FPacientes)] := Paciente;

      SQLQuery1.Next;
    end;

    SQLQuery1.Close;
  except
    on E: Exception do
      ShowMessage('Error al cargar pacientes: ' + E.Message);
  end;
end;

procedure TfrmAgenda.CargarConsultorios;
var
  Consultorio: TConsultorio;
begin
  try
    SQLQuery1.SQL.Text := 'SELECT idConsultorio, nombreAula FROM consultorio';
    SQLQuery1.Open;

    cmbConsultorio.Items.Clear;
    SetLength(FConsultorios, 0);

    while not SQLQuery1.EOF do
    begin
      Consultorio.ID := SQLQuery1.FieldByName('idConsultorio').AsInteger;
      Consultorio.NombreAula := SQLQuery1.FieldByName('nombreAula').AsString;

      cmbConsultorio.Items.Add(Consultorio.NombreAula);
      SetLength(FConsultorios, Length(FConsultorios) + 1);
      FConsultorios[High(FConsultorios)] := Consultorio;

      SQLQuery1.Next;
    end;

    SQLQuery1.Close;
  except
    on E: Exception do
      ShowMessage('Error al cargar consultorios: ' + E.Message);
  end;
end;

procedure TfrmAgenda.VerificarDisponibilidad;
var
  Matricula, PacienteID, ConsultorioID: integer;
begin
  // Obtener las IDs seleccionadas
  if (cmbNutri.ItemIndex >= 0) and (cmbPaciente.ItemIndex >= 0) and
    (cmbConsultorio.ItemIndex >= 0) then
  begin
    Matricula := FAlumnos[cmbNutri.ItemIndex].Matricula;
    PacienteID := FPacientes[cmbPaciente.ItemIndex].ID;
    ConsultorioID := FConsultorios[cmbConsultorio.ItemIndex].ID;
    SQLQuery1.Close;

    try
      SQLQuery1.SQL.Text :=
        'SELECT COUNT(*) AS Count FROM agenda WHERE matricula = :matricula ' +
        'AND idConsultorio = :idConsultorio AND fecha = :fecha ' +
        'AND ((horaInicio < :horaFin AND horaInicio >= :horaInicio) ' +
        'OR (horaFinal > :horaInicio AND horaFinal <= :horaFin))';
      SQLQuery1.Params.ParamByName('matricula').AsInteger := Matricula;
      SQLQuery1.Params.ParamByName('idConsultorio').AsInteger := ConsultorioID;
      SQLQuery1.Params.ParamByName('fecha').AsDate := dtpFecha.Date;
      SQLQuery1.Params.ParamByName('horaInicio').AsTime := tmpHoraIn.Time;
      SQLQuery1.Params.ParamByName('horaFin').AsTime := tmpHoraFin.Time;

      SQLQuery1.Open;

      if (SQLQuery1.FieldByName('Count').AsInteger = 0) then
        btnAgregar.Enabled := True
      else
      begin
        btnAgregar.Enabled := False;
        ShowMessage('No existe disponibilidad en esta fecha u hora.');
      end;

      SQLQuery1.Close;
    except
      on E: Exception do
        ShowMessage('Error al verificar disponibilidad: ' + E.Message);
    end;
  end
  else
  begin
    ShowMessage('Rellene todos los campos para verificar disponibilidad');
  end;
end;

procedure TfrmAgenda.btnAgregarClick(Sender: TObject);
begin
  VerificarDisponibilidad;
  // Insertar la nueva consulta en la base de datos
  InsertarConsulta;
  // Actualizar el ListView
  ActualizarListView;
end;

procedure TfrmAgenda.InsertarConsulta;
var
  Matricula, PacienteID, ConsultorioID: integer;
begin
  // Obtener las IDs seleccionadas
  Matricula := FAlumnos[cmbNutri.ItemIndex].Matricula;
  PacienteID := FPacientes[cmbPaciente.ItemIndex].ID;
  ConsultorioID := FConsultorios[cmbConsultorio.ItemIndex].ID;

  try
    SQLQuery1.SQL.Text :=
      'INSERT INTO agenda (matricula, idPaciente, idConsultorio, fecha, horaInicio, horaFinal, semestre) '
      + 'VALUES (:matricula, :idPaciente, :idConsultorio, :fecha, :horaInicio, :horaFinal, :semestre)';
    SQLQuery1.Params.ParamByName('matricula').AsInteger := Matricula;
    SQLQuery1.Params.ParamByName('idPaciente').AsInteger := PacienteID;
    SQLQuery1.Params.ParamByName('idConsultorio').AsInteger := ConsultorioID;
    SQLQuery1.Params.ParamByName('fecha').AsDate := dtpFecha.Date;
    SQLQuery1.Params.ParamByName('horaInicio').AsTime := tmpHoraIn.Time;
    SQLQuery1.Params.ParamByName('horaFinal').AsTime := tmpHoraFin.Time;
    SQLQuery1.Params.ParamByName('semestre').AsInteger := 1;
    // Asegúrate de ajustar el semestre según sea necesario

    SQLQuery1.ExecSQL;
    SQLTransaction1.Commit;
  except
    on E: Exception do
      ShowMessage('Error al insertar la consulta: ' + E.Message);
  end;
end;

procedure TfrmAgenda.ActualizarListView;
begin
  // Cargar todas las consultas en el ListView
  try
    SQLQuery1.SQL.Text :=
      'SELECT n.nombre AS Nutriologo, p.nombre AS Paciente, c.nombreAula AS Consultorio, '
      + 'a.fecha, a.horaInicio, a.horaFinal ' + 'FROM agenda a ' +
      'JOIN nutriologo n ON a.matricula = n.matricula ' +
      'JOIN paciente p ON a.idPaciente = p.idPaciente ' +
      'JOIN consultorio c ON a.idConsultorio = c.idConsultorio ' +
      'ORDER BY a.fecha, a.horaInicio';
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

function TfrmAgenda.VerificarHoras: boolean;
begin

  if CompareTime(tmpHoraFin.Time, tmpHoraIn.Time) <= 0 then
  begin
    Result := True;
  end
  else
  begin
    ShowMessage('La hora final no puede ser menor que la hora de inicio');
    tmpHoraFin.Time := IncHour(tmpHoraIn.Time, 1);
    Result := False;
  end;
end;

procedure TfrmAgenda.MostrarNotificacionSobreComponente(Mensaje: string;
  Componente: TWinControl);
begin
  PopupNotifier1.Title := 'Notificación';
  PopupNotifier1.Text := Mensaje;

  PopupNotifier1.ShowAtPos(Componente.ClientOrigin.X, Componente.ClientOrigin.Y +
    Componente.Height);
end;


procedure TfrmAgenda.dtpFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
  var AcceptDate: boolean);
begin
  VerificarDisponibilidad;
  VerificarDisponibilidad;
end;

end.
