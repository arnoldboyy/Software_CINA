unit uHome;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,uPacientes,uNutriologos,uConsultorios;

type

  { TfrmHome }

  TfrmHome = class(TForm)
    frmHome: TImage;
    frmHome2: TImage;
    frmHome3: TImage;
    frmHome4: TImage;
    frmHome5: TImage;
    frmHome6: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure frmHome2Click(Sender: TObject);
    procedure frmHome3Click(Sender: TObject);
    procedure frmHome4Click(Sender: TObject);
    procedure frmHomeClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private

  public

  end;

var
  frmHome: TfrmHome;

implementation

{$R *.lfm}

{ TfrmHome }

procedure TfrmHome.Label3Click(Sender: TObject);
begin

end;

procedure TfrmHome.Label1Click(Sender: TObject);
begin

end;

procedure TfrmHome.FormCreate(Sender: TObject);
begin
  frmHome.Picture.LoadFromFile('imgs\agendaIMG.png');
  frmHome2.Picture.LoadFromFile('imgs\enfermeraIMG.png');
  frmHome4.Picture.LoadFromFile('imgs\estadisticasIMG.png');
  frmHome5.Picture.LoadFromFile('imgs\pacientesIMG.png');






end;

procedure TfrmHome.frmHome2Click(Sender: TObject);
begin
  frmNutriologos.ShowModal;
end;

procedure TfrmHome.frmHome3Click(Sender: TObject);
begin
  frmConsultorios.ShowModal;
end;

procedure TfrmHome.frmHome4Click(Sender: TObject);
begin

end;

procedure TfrmHome.frmHomeClick(Sender: TObject);
begin
  frmPacientes.ShowModal;
end;

end.

