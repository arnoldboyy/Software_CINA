program ProjectCINA;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uNutriologos, uBuscarNutriologos, ulogin, uPacientes,
  uconsultorios, uBuscarpacientes, uBuscarconsultorios,
uMenuPrincipal, uCreditos, uAgenda, uConstantes
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TfrmNutriologos, frmNutriologos);
  Application.CreateForm(TfrmBuscarNutriologos, frmBuscarNutriologos);
  Application.CreateForm(TfrmPacientes, frmPacientes);
  Application.CreateForm(TfrmConsultorios, frmConsultorios);
  Application.CreateForm(TfrmBuscarPacientes, frmBuscarPacientes);
  Application.CreateForm(TfrmBuscarConsultorios, frmBuscarConsultorios);
  Application.CreateForm(TfrmMenuPrincipal, frmMenuPrincipal);
  Application.CreateForm(TfrmCreditos, frmCreditos);
  Application.CreateForm(TfrmAgenda,frmAgenda);
  Application.Run;
end.

