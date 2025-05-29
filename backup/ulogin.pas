unit ulogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,uPacientes,uNutriologos,uMenuPrincipal;

type

  { TLogin }

  TLogin = class(TForm)
    eContrasena: TEdit;
    eUsuario: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    INGRESAR: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure INGRESARClick(Sender: TObject);
  private

  public

  end;

var
  Login: TLogin;

implementation

{$R *.lfm}

{ TLogin }



procedure TLogin.FormCreate(Sender: TObject);
begin
   Image1.Picture.LoadFromFile('imgs\logouni.png');
end;

procedure TLogin.INGRESARClick(Sender: TObject);
begin
  frmMenuPrincipal.ShowModal;
end;



end.

