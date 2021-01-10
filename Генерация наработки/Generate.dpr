program Generate;

uses
  Forms,
  UGenerate in 'UGenerate.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
