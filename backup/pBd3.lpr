program pBd3;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uBd3, list, ulogin, uPacientes, uHome, uNutriologos1
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TfrmNutriologos, frmNutriologos);
  Application.CreateForm(TfrmList, frmList);
  Application.CreateForm(TfrmPacientes, frmPacientes);
  Application.CreateForm(TfrmHome, frmHome);

  Application.Run;
end.

