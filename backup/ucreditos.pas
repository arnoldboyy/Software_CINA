unit uCreditos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, uConstantes;

type

  { TfrmCreditos }

  TfrmCreditos = class(TForm)
    Avatar1: TImage;
    Avatar2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Panel4: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
  private

  public

  end;

var
  frmCreditos: TfrmCreditos;

implementation

{$R *.lfm}

{ TfrmCreditos }

procedure TfrmCreditos.FormCreate(Sender: TObject);
begin
  Avatar1.Picture.LoadFromFile(Application.Location + 'imgs/avatarCristofer.png');
  Avatar2.Picture.LoadFromFile(Application.Location + 'imgs/avatarArnold.png');
end;

procedure TfrmCreditos.Panel4Click(Sender: TObject);
begin
  Close;
end;

end.

