program Model;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  UGraphStructure in 'UGraphStructure.pas',
  UReliabilityGraph in '..\опнцпюллю лндекэ ╧2\UReliabilityGraph.pas',
  UAction in 'UAction.pas',
  USBS in 'USBS.pas',
  UDistributions in 'UDistributions.pas',
  UReliability in 'UReliability.pas',
  UVivod in 'UVivod.pas',
  UEventSBS in 'UEventSBS.pas',
  UVisualGraph in 'UVisualGraph.pas',
  UVivodForm in 'UVivodForm.pas' {FVivod},
  UFormVivodParameters in 'UFormVivodParameters.pas' {FVivodParameters},
  UVivodStat in 'UVivodStat.pas' {FStat},
  UVivodProtocol in 'UVivodProtocol.pas' {FVivodProtocol},
  UVivodStatForm in '..\опнцпюллю лндекэ ╧2\UVivodStatForm.pas' {FVivodStat};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFVivod, FVivod);
  Application.CreateForm(TFVivodParameters, FVivodParameters);
  Application.CreateForm(TFStat, FStat);
  Application.CreateForm(TFVivodProtocol, FVivodProtocol);
  Application.CreateForm(TFVivodStat, FVivodStat);
  Application.Run;

  end.
