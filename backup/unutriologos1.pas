unit uNutriologos1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql55conn, SQLDB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    lst: TListView;
    MySQL55Connection1: TMySQL55Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  ListItem: TListItem;
begin
  SQLQuery1.SQL.Text := 'SELECT * FROM alumnos1';
  SQLQuery1.Open;
  lst.Clear;
  while not SQLQuery1.EOF do
  begin
    ListItem := lst.Items.Add;
    ListItem.Caption := SQLQuery1.FieldByName('id').AsString;
    ListItem.SubItems.Add(SQLQuery1.FieldByName('nombre').AsString);
    ListItem.SubItems.Add(SQLQuery1.FieldByName('apellido').AsString);
    ListItem.SubItems.Add(SQLQuery1.FieldByName('email').AsString);
    ListItem.SubItems.Add(SQLQuery1.FieldByName('edad').AsString);
    SQLQuery1.Next;
  end;
  SQLQuery1.Close;
  end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MySQL55Connection1.HostName := 'localhost';
  MySQL55Connection1.UserName := 'root';
  MySQL55Connection1.Password := 'root';
  MySQL55Connection1.DatabaseName := 'ProgramacionVisual';
  MySQL55Connection1.Connected := True;

end;



end.

