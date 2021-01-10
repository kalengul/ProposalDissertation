program Model2;

uses
  Forms,
  UMain in 'UMain.pas' {FModel},
  UTransportGRAPH in 'UTransportGRAPH.PAS',
  USBS in 'USBS.pas',
  UEventSBS in 'UEventSBS.pas',
  USklad in 'USklad.pas',
  UMainModel2 in 'UMainModel2.pas',
  UVolna in 'UVolna.pas',
  UNewTransportGraph in 'UNewTransportGraph.pas' {FNewTransportGraph},
  UAddNS in 'UAddNS.pas' {FAddNs},
  UMainStructure in 'UMainStructure.pas' {FMain},
  UReliabilityGraph in 'UReliabilityGraph.pas',
  UVivodAeroport in 'UVivodAeroport.pas' {FVivodAeroport},
  UAntGraph in 'UAntGraph.pas',
  UMainAnt in 'UMainAnt.pas' {FMainAnt},
  USolution in 'USolution.pas',
  UAnt in '..\œ–Œ√–¿ÃÃ¿\UAnt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFModel, FModel);
  Application.CreateForm(TFNewTransportGraph, FNewTransportGraph);
  Application.CreateForm(TFAddNs, FAddNs);
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFVivodAeroport, FVivodAeroport);
  Application.CreateForm(TFMainAnt, FMainAnt);
  Application.Run;

  end.
