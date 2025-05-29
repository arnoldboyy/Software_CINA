unit uReport;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, PReport;

type

  { TfrmReport }

  TfrmReport = class(TForm)
    impresora: TPReport;
    PRLabel1: TPRLabel;
    PRLayoutPanel1: TPRLayoutPanel;
    PRPage1: TPRPage;
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure printPdf;
  end;

var
  frmReport: TfrmReport;

implementation

{$R *.lfm}

{ TfrmReport }

procedure TfrmReport.FormCreate(Sender: TObject);
begin
  impresora.FileName:='Test.pdf';
  impresora.BeginDoc;
  impresora.Print(PRPage1);
  impresora.EndDoc;     
  ShowMessage('Creado');
end;

procedure TfrmReport.printPdf;
begin
end;

end.























