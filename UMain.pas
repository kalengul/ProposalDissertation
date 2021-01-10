unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,UTransportGRAPH,USklad, USBS, UEventSBS,UMainModel2, UNewTransportGraph, UReliabilityGraph, StdCtrls,
  Grids, Spin, ExtCtrls, Buttons, UVivodAeroport,UAntGraph, USolution, UAnt, UTimeStructure,
  ComCtrls, ComObj;

type
  TFModel = class(TForm)
    MeTime: TMemo;
    lbl1: TLabel;
    MeProt: TMemo;
    SgElement: TStringGrid;
    EdKol: TEdit;
    La2: TLabel;
    EdKolParIteration: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdKoef: TEdit;
    EdEndModelTime: TEdit;
    Label3: TLabel;
    EdKolResh: TEdit;
    Label4: TLabel;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    pnl6: TPanel;
    pnl7: TPanel;
    Label5: TLabel;
    SeNomResh: TSpinEdit;
    chkTime: TCheckBox;
    SgParSolution: TStringGrid;
    Label6: TLabel;
    LaParSolution: TLabel;
    SgMaxKolElement: TStringGrid;
    pnlKarta: TPanel;
    PbKarta: TPaintBox;
    SgSolution: TStringGrid;
    SdSave: TSaveDialog;
    OdLoad: TOpenDialog;
    EdTimePost: TEdit;
    EdKolIteration: TEdit;
    Label8: TLabel;
    SbSaveTime: TSpeedButton;
    SbLoadTime: TSpeedButton;
    SbAddTime: TSpeedButton;
    PbAntGraph: TPaintBox;
    EdKoefPher: TEdit;
    Label11: TLabel;
    EdKolAgent: TEdit;
    CbGoProtocolEvent: TCheckBox;
    TcMAin: TTabControl;
    GbPheromon1: TGroupBox;
    Label7: TLabel;
    EdNatKolPheromon1: TEdit;
    Label9: TLabel;
    Label12: TLabel;
    EdPheromon1: TEdit;
    EdIsparNodePheromon1: TEdit;
    GbPheromon2: TGroupBox;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    EdNatKolPheromon2: TEdit;
    EdPheromon2: TEdit;
    EdIsparNodePheromon2: TEdit;
    Label19: TLabel;
    EdKolAntProgon: TEdit;
    GbAnt: TGroupBox;
    RgTypeAntGo: TRadioGroup;
    Label20: TLabel;
    EdKoefAntElit: TEdit;
    PnProc: TPanel;
    SeShag: TSpinEdit;
    PbVisual: TPaintBox;
    LeMin: TLabeledEdit;
    LeMax: TLabeledEdit;
    Label21: TLabel;
    pnl8: TPanel;
    SeNomHist: TSpinEdit;
    Label22: TLabel;
    CbCheckElementProcess: TCheckBox;
    Label23: TLabel;
    EdElementName: TEdit;
    RgKrit: TRadioGroup;
    Label10: TLabel;
    CbProtocolAnt: TCheckBox;
    CbProtocolKolIteration: TCheckBox;
    CbProtocolElement: TCheckBox;
    SbStartKolSPR: TSpeedButton;
    Label14: TLabel;
    SbStartIteration: TSpeedButton;
    EdMOKG: TEdit;
    Label15: TLabel;
    EdMaksCost: TEdit;
    GbModel: TGroupBox;
    GbProtocol: TGroupBox;
    Panel2: TPanel;
    SbAddGraph: TSpeedButton;
    SbSaveGraph: TSpeedButton;
    SbLoadGraph: TSpeedButton;
    SbInitializationGraph: TSpeedButton;
    RgTypeEndDSS: TRadioGroup;
    Label18: TLabel;
    EdMinKG: TEdit;
    EdMaxKG: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    GbSolution: TGroupBox;
    SbSaveSolution: TSpeedButton;
    GbAnalys: TGroupBox;
    EdNatVar: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    EdKonVar: TEdit;
    Label28: TLabel;
    EdShag: TEdit;
    Label29: TLabel;
    EdKolProgonSPPR: TEdit;
    RgAnalizVariable: TRadioGroup;
    SbGoAnalize: TSpeedButton;
    SbSaveAllSolution: TSpeedButton;
    SbLoadSolution: TSpeedButton;
    SbLoadAllSolution: TSpeedButton;
    MeProtocolAnalys: TMemo;
    CbProtocolDSS: TCheckBox;
    Label30: TLabel;
    EdKolSolution: TEdit;
    Label31: TLabel;
    EdTimeProgon: TEdit;
    Label32: TLabel;
    EdTimeProgonMMK: TEdit;
    SbLoadAntGraph: TSpeedButton;
    EdParSumm: TEdit;
    Label33: TLabel;
    Label34: TLabel;
    EdMaxKolSolution: TEdit;
    EdCurrentModelTime: TEdit;
    Label35: TLabel;
    CbVivodModelTime: TCheckBox;
    RgCreateAntGraph: TRadioGroup;
    procedure btLoadClick(Sender: TObject);
    procedure btGoClick(Sender: TObject);
    procedure BtTestClick(Sender: TObject);
    procedure SeNomReshChange(Sender: TObject);
    procedure chkTimeClick(Sender: TObject);
    procedure PbKartaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PbKartaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PbKartaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtGoSkladClick(Sender: TObject);
    procedure BtVisibleClick(Sender: TObject);
    procedure BtNewTransportGraphClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtSaveGrpahClick(Sender: TObject);
    procedure BtLoadGraphClick(Sender: TObject);
    procedure BtInitializationClick(Sender: TObject);
    procedure SbSaveTimeClick(Sender: TObject);
    procedure SbLoadTimeClick(Sender: TObject);
    procedure SbAddTimeClick(Sender: TObject);
    procedure BtGoModelType2Click(Sender: TObject);
    procedure CbGoProtocolEventClick(Sender: TObject);
    procedure BtIterationClick(Sender: TObject);
    procedure BtStartTestClick(Sender: TObject);
    procedure BtAntModeClick(Sender: TObject);
    procedure SgSolutionSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TcMAinChange(Sender: TObject);
    procedure BtGoIterationClick(Sender: TObject);
    procedure CbCheckElementProcessClick(Sender: TObject);
    procedure BtSaveSolutionClick(Sender: TObject);
    procedure SeNomHistChange(Sender: TObject);
    procedure RgTypeEndDSSClick(Sender: TObject);
    procedure SbSaveAllSolutionClick(Sender: TObject);
    procedure SbLoadSolutionClick(Sender: TObject);
    procedure SbLoadAllSolutionClick(Sender: TObject);
    procedure SbStartKolSPRClick(Sender: TObject);
    procedure SbGoAnalizeClick(Sender: TObject);
    procedure SbLoadAntGraphClick(Sender: TObject);
    procedure RgKritClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TVivodElement = record
                NameNode,Name:string;
                KolZamen:Word;
                end;
TVivodMass = array of TVivodElement;

procedure VivodNS;
procedure VivodSBS;
Procedure VivodElementSkald(Sklad:TSklad);
Procedure GoIteration (NomIteration:LongWord; NomSolution:Word; var ModelTime:Double);

//Procedure PaintNode(Canvas:TCanvas);

type
  ArrayMemoryHist = array of Word;
  THist = record
          Hist:ArrayMemoryHist;              //Отображение
          typeHist:Byte;
          Name:string;
          end;

var
  FModel: TFModel;
  ModelTime:Double;
  NS:TNS;
  MsExcel: Variant;
  f:TextFile;
  VivodProcessing:Boolean;
  SettingModel:Byte;
  Bitmap : TBitmap;

  ChangeMx,ChangeDx,SetupNode:Boolean;
  XChangeMX,YChangeMY:Integer;
  GoProtocolEvent:Boolean;
  GoProtocolEventAnt:Boolean;
  BoolGoProtocolElement:Boolean;
  BoolSaveSolutionOnFile:Boolean;

  GoSaveHistBool:boolean; //Сохранение рядов распределения
  GoSaveArrayFailyreAndRecoveryBool:Boolean;

  MaxTimeModel:Double;
  MaxKolInterval:LongWord;
  GoStat:Boolean;
  EndModelTime1,EndModelTime2:Double;
  NomVivodSolution:LongWord;
  NomProgon:LongWord;

  ArrayHist:array of THist;              //Отображение

  KolDSSIterations:LongWord;                         //Количество итераций СППР
  EndSolutions:TSolutionType;
  MTimeProgon,MTimeProgonMMK:TDateTime;              //Математическое ожидание времен прогона модели и прогона ММК

  LimitKG,LimitMinKG,LimitMCost,LimitCostProduction,LimitMaxKG:Double;   //Для СППР ограничения на переменные
  AlfKoeffSumm:Double;                               //Для взвешенной суммы КГ и стоимости.



implementation

uses UMainAnt, UMainStructure;

{$R *.dfm}


procedure TFModel.btLoadClick(Sender: TObject);
var
  Node:TTransportNode;
  Sklad:TSklad;
  Element:TElementNS;
  n,j,NomNS:LongWord;
  Arr:array of string;
begin
{Sklad:=TSklad.Create;
Node:=AddNode('Одна вершина',1);
Node.Sklad:=Sklad;
NS:=TNS.Create;
NS.Node:=Node;
NS.LoadElementFile('КондТУ154.txt');}
LoadGraph('Test.txt');
//VivodNS;
Sbs:=TQueueEvent.Create;
Node:=FirsTTransportNode;
While Node<>nil do
  begin
  IF Length(Node.Ns)<>0 then
    for j:=0 to Length(Node.Ns)-1 do
      Node.NS[j].GoAllEvent;
  Node:=Node.NexTTransportNode;
  end;

VivodSBS;

n:=1;
SgMaxKolElement.Cells[0,0]:='Элемент';
SgMaxKolElement.Cells[0,1]:='Кол-во';
Node:=FirsTTransportNode;
While Node<>nil do
  begin
  IF Length(Node.Ns)<>0 then
    for NomNS:=0 to Length(Node.Ns)-1 do
    begin
//    Element:=Node.Ns[NomNS].FirstElement;
    While Element<>nil do
      begin
      j:=0;
      If n<>1 then
        While (j<n-1) and (MaxKolElement[j].name<>Element.Name) do
          Inc(j);
      If j=n-1 then
        begin
        Inc(n);
        SetLength(MaxKolElement,n-1);
        SgMaxKolElement.ColCount:=n;
        SgMaxKolElement.Cells[n-1,0]:=Element.Name;
        SgMaxKolElement.Cells[n-1,1]:='0';        
        MaxKolElement[n-2].name:=Element.Name;
        MaxKolElement[n-2].Kol:=0;
        end;
      Element:=Element.NextElement;
      end;
    end;
  Node:=Node.NexTTransportNode;
  end;
end;

procedure VivodNS;
  var
  Element:TElementNS;
  st:string;
  begin
//  FModel.MeNS.Clear;
  Element:=NS.FirstElement;
  While Element<>nil do
    begin
    st:=Element.Name;
    If Element.Failure=1 then
      St:=st+' ОТКАЗ';
//    FModel.MeNS.Lines.Add(St);
    Element:=Element.NextElement;
    end;
  end;

procedure VivodSBS;
  var
    Event:TEvent;
    st:string;
  begin
//  FModel.meSBS.Clear;
  Event:=SBS.FirstEvent;
  While Event<>nil do
    begin
    Str(Event.EventTime:10:2,st);
//    If (Event is TEventFailure) then
//      FModel.meSBS.Lines.Add(st+' ->'+(Event as TEventFailure).Element.Name+' ОТКАЗ');
    If (Event is TEventAddElement) then
//      FModel.meSBS.Lines.Add(st+' ->'+(Event as TEventAddElement).Name+' ДОБАВЛЕНИЕ');
    Event:=Event.NextEvent;
    end;
  end;

procedure qSort(Solution:TPlanRecover; l,r:LongWord);
var i,j:LongInt;
    w,q:TRecover;
begin
  i := l; j := r;
  q := Solution.PlanRecover[(l+r) div 2];
  repeat
    while (Solution.PlanRecover[i].Time < q.Time) do
      inc(i);
    while (q.Time < Solution.PlanRecover[j].Time) do
      dec(j);
    if (i <= j) then
      begin
      w:=Solution.PlanRecover[i]; Solution.PlanRecover[i]:=Solution.PlanRecover[j]; Solution.PlanRecover[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSort(Solution,l,j);
  if (i < r) then qSort(Solution,i,r);
end;

procedure VivodPlanReover(Solution:TPlanRecover);
  var
    i,n:LongWord;
  begin
    n:=Length(Solution.PlanRecover);
  qSort(Solution,0,n-1);
  FModel.SgElement.RowCount:=n+1;
  FModel.SgElement.Cells[1,0]:='Часть';
  FModel.SgElement.Cells[2,0]:='Элемент';
  FModel.SgElement.Cells[0,0]:='Время';
  FModel.SgElement.Cells[3,0]:='Время отк.';
  FModel.SgElement.Cells[4,0]:='Время ожид.';
  For i:=0 to n-1 do
    begin
    If Solution.PlanRecover[i].Node<>nil then
      FModel.SgElement.Cells[1,i+1]:=Solution.PlanRecover[i].Node.Name;
    FModel.SgElement.Cells[2,i+1]:=Solution.PlanRecover[i].Name;
    FModel.SgElement.Cells[0,i+1]:=FloatToStr(Solution.PlanRecover[i].Time);
    FModel.SgElement.Cells[3,i+1]:=FloatToStr(Solution.PlanRecover[i].TimeFailure);
    FModel.SgElement.Cells[4,i+1]:=FloatToStr(Solution.PlanRecover[i].TimeCost);
    end;
  end;

procedure VivodTabledPlanReover(Solution:TPlanRecover);
  var
    n,i,j:LongWord;
    VivodArr:TVivodMass;
    NMin:LongWord;
    NameMin,NodeNameMin:string;
    Prom:TVivodElement;
    st:string;
  begin
  FModel.SgParSolution.Cells[0,1]:='Общая НС';
  FModel.SgParSolution.Cells[0,2]:='По Элементам';
  FModel.SgParSolution.Cells[1,0]:='Время отказа';
  FModel.SgParSolution.Cells[2,0]:='Время ожидания';
  Str(Solution.TimeFailureOb:8:2,st);
  FModel.SgParSolution.Cells[1,1]:=st;
  Str(Solution.TimeFailure:8:2,st);
  FModel.SgParSolution.Cells[1,2]:=st;
  Str(Solution.TimeWaitingOb:8:2,st);
  FModel.SgParSolution.Cells[2,1]:=st;
  Str(Solution.TimeWaiting:8:2,st);
  FModel.SgParSolution.Cells[2,2]:=st;
  Str(Solution.ParSolution:8:2,st);
  FModel.LaParSolution.Caption:=st;
  n:=0;
  For i:=0 to FModel.SgElement.ColCount-1 do
    For j:=0 to FModel.SgElement.RowCount-1 do
      FModel.SgElement.Cells[i,j]:='';
  For i:=0 to Length(Solution.PlanRecover)-1 do
    begin
    j:=0;
    If n<>0 then
      While (j<n) and  ((VivodArr[j].NameNode<>Solution.PlanRecover[i].Node.Name) or (VivodArr[j].Name<>Solution.PlanRecover[i].Name)) do
        Inc(j);
    If j=n then
      begin
      Inc(n);
      SetLength(VivodArr,n);
      VivodArr[n-1].NameNode:=Solution.PlanRecover[i].Node.Name;
      VivodArr[n-1].Name:=Solution.PlanRecover[i].Name;
      VivodArr[n-1].KolZamen:=0;
      end;
    end;
  for i:=0 to n-2 do
    begin
    NameMin:='яяяяяяяяяяяяяяя';
    NodeNameMin:='яяяяяяяяяяяяяяя';
    For j:=i to n-1 do
      If (NodeNameMin>VivodArr[j].NameNode) or (NodeNameMin=VivodArr[j].NameNode) and (NameMin>VivodArr[j].Name) then
        begin
        NodeNameMin:=VivodArr[j].NameNode;
        NameMin:=VivodArr[j].Name;
        NMin:=j;
        end;
    If NMin<>i then
      begin
      Prom:=VivodArr[NMin]; VivodArr[NMin]:=VivodArr[i]; VivodArr[i]:=Prom;
      end;
    end;
  FModel.SgElement.ColCount:=n;
  for i:=0 to n-1 do
    begin
    FModel.SgElement.Cells[i,0]:=VivodArr[i].NameNode;
    FModel.SgElement.Cells[i,1]:=VivodArr[i].Name;
    end;
  if FModel.chkTime.Checked then
    begin
    FModel.SgElement.RowCount:=Length(Solution.PlanRecover)+3;
    For i:=0 to Length(Solution.PlanRecover)-1 do
      begin
      j:=0;
      While (j<n) and  ((VivodArr[j].NameNode<>Solution.PlanRecover[i].Node.Name) or (VivodArr[j].Name<>Solution.PlanRecover[i].Name)) do
        Inc(j);
      Str(Solution.PlanRecover[i].Time:8:2,st);
      FModel.SgElement.Cells[j,i+1]:=st;
      end;
    end
  else
  For i:=0 to Length(Solution.PlanRecover)-1 do
    begin
    j:=0;
    While (j<n) and  ((VivodArr[j].NameNode<>Solution.PlanRecover[i].Node.Name) or (VivodArr[j].Name<>Solution.PlanRecover[i].Name)) do
      Inc(j);
    Inc(VivodArr[j].KolZamen);
    If VivodArr[j].KolZamen>FModel.SgElement.RowCount-2 then
      FModel.SgElement.RowCount:=VivodArr[j].KolZamen+2;
    Str(Solution.PlanRecover[i].Time:8:2,st);
    FModel.SgElement.Cells[j,VivodArr[j].KolZamen+1]:=st;
    end;
  end;

function SearchMaxPlanRecover(Solution:TPlanRecover):LongWord;
  var
    i,n:LongWord;
  begin
  n:=Length(Solution.PlanRecover);

  end;

Procedure SaveProtocolRecovery(Solution:TPlanRecover; NameFile:String);
  var
    i,n:LongWord;
    st:string;
  begin
  writeLn(f,st);
  Writeln(f,Solution.NameSolution);
  n:=Length(Solution.PlanRecover);
  st:=FloatToStr(Solution.TimeFailureOb)+'     '+FloatToStr(Solution.TimeWaitingOb);
  writeLn(f,st);
  st:=FloatToStr(Solution.TimeFailure)+'     '+FloatToStr(Solution.TimeWaiting);
  writeLn(f,st);
  For i:=0 to n-1 do
    begin
    st:='';
    If Solution.PlanRecover[i].Node<>nil then
      St:=st+Solution.PlanRecover[i].Node.Name;
    St:=st+'@'+Solution.PlanRecover[i].Name+'@'+FloatToStr(Solution.PlanRecover[i].Time)+'@'+FloatToStr(Solution.PlanRecover[i].TimeFailure)+'@'+FloatToStr(Solution.PlanRecover[i].TimeCost)+'@;';
    Writeln(f,st)
    end;
  end;

procedure VivodSostGraph;
var
  CNode:TTransportNode;
  ElementSklad:TElementSklad;
  Element:TElementNS;
  NomNs:Longword;
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  If CNode.Sklad<> nil then
    begin
    ElementSklad:=CNode.Sklad.FirstElement;
    While ElementSklad<>nil do
      begin
      Writeln(f,CNode.Name+' на СКЛАДЕ имеется элемент '+ElementSklad.Name+' в количестве '+IntToStr(ElementSklad.kolvo)+' время ожидания элемента '+FloatToStr(ElementSklad.TimeWaiting));
      ElementSklad:=ElementSklad.NextElement;
      end;
    end;
  If Length(CNode.Ns)<>0 then
  For NomNs:=0 to Length(CNode.Ns)-1 do
    begin
//    Element:=CNode.Ns[NomNS].FirstElement;
    While Element<>nil do
      begin
      Writeln(f,CNode.Name+' в НС имеется элемент '+Element.Name+' время отказа элемента '+FloatToStr(Element.TimeFailure));
      Element:=Element.NextElement;
      end;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
end;

Procedure LoadRecovery(Solution:TPlanRecover; NameFile:String);
  var
    i,n:LongWord;
    st:string;
    Node:TTransportNode;
  begin
  n:=0;
  SetLength(Solution.PlanRecover,0);
  AssignFile(f,NameFile);
  Reset(f);
  While Not EOF(f) do
    begin
    Readln(f,st);
    Inc(n);
    SetLength(Solution.PlanRecover,n);
    Node:=SearchNodeName(Copy(St,1,pos('@',st)-1));
    Solution.PlanRecover[n-1].Node:=Node;
    Delete(St,1,pos('@',st));
    Solution.PlanRecover[n-1].Name:=Copy(St,1,pos('@',st)-1);
    Delete(St,1,pos('@',st));
    Solution.PlanRecover[n-1].Time:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    Solution.PlanRecover[i].TimeFailure:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    Solution.PlanRecover[i].TimeCost:=StrToFloat(Copy(St,1,pos('@',st)-1));
    end;
  end;

procedure TFModel.btGoClick(Sender: TObject);
var
  Node,CNode:TTransportNode;
  MinLength,leng:Double;
  Element:TElementNS;
  Recover,OptimRecover:TPlanRecover;
  NomMax:LongWord;
  NameElement:string;
  NodeElement:TTransportNode;
  NomSolution,KolSolution,Recov,j,sk:LongWord;
  EnabledBool:Boolean;
  z:Byte;
  k:LongWord;
  TF,TW:Double;
  EndTime:Double;
  NomNS:LongWord;
begin
for k:=1 to SgMaxKolElement.ColCount-1 do
  MaxKolElement[k-1].Kol:=StrToInt(SgMaxKolElement.Cells[k,1]);
 VivodProcessing:=False;
  AssignFile(f,'Протокол решение.txt');
  Rewrite(f);
NomModel2:=StrToInt(EdKol.Text);
KolNotChangeIterMode2:=StrToInt(EdKolParIteration.Text);
Koef:=StrToFloat(EdKoef.Text);
ModelEndTime:= StrToFloat(EdEndModelTime.Text);
NomExcel:=2;
NomExcel1:=2;
KolSolution:=1;
NomSolution:=0;
Solution:=TSolution.Create;
SetLength(Solution.Recover,1);
Solution.Recover[NomSolution]:=TPlanRecover.Create;
Solution.Recover[NomSolution].NameSolution:='Основное решение';
Recover:=Solution.Recover[NomSolution];
SetLength(Recover.PlanRecover,NomSolution);
Node:=FirsTTransportNode;
GoTransfer:=0;
while Node<>nil do
  begin
  if Length(Node.Ns)<>0 then
    For NomNS:=0 to Length(Node.Ns)-1 do
      Node.Ns[NomNS].GoAllEvent;
  Node:=Node.NexTTransportNode;
  end;

//VivodPlanReover(Recover);
GoTransfer:=1;
for z:=1 to StrToInt(EdKolResh.Text) do
  begin

  VivodProcessing:=True;
  Writeln(f);
  DoProgon(Recover,NameElement);
  Writeln(f);
  VivodSostGraph;
  VivodProcessing:=False;

  Recover.TimeFailureOb:=0;
  Recover.TimeWaitingOb:=0;
  Recover.TimeFailure:=0;
  Recover.TimeWaiting:=0;
  For k:=1 to KolNotChangeIterMode2 do
    begin
    DoProgon(Recover,NameElement);

    Recover.GoTimeOb(k);             //Вычисление общего времени
    SaveAllGraphTime(TF,TW);
    if k=1 then
      begin
      Recover.TimeFailure:=TF;
      Recover.TimeWaiting:=TW;
      end
    else
      begin
      Recover.TimeFailure:=(Recover.TimeFailure*(k-1)+TF)/k;
      Recover.TimeWaiting:=(Recover.TimeWaiting*(k-1)+TW)/k;
      end;
//    Recover.GoMaxTime(k,False);    //Вычисление сумарного времени
    end;
  Recover.TimeFailure:=Recover.TimeFailure/Length(Recover.PlanRecover);  
  SaveProtocolRecovery(Recover,'Протокол решение №'+IntTostr(NomSolution)+'.txt');
    

  //Обнуление складов
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    If Length(CNode.Ns)<>0 then
    For NomNS:=0 to Length(CNode.Ns)-1 do
      FreeAndNil(CNode.NS[NomNS].GraphLevel0);
    If CNode.Sklad<>nil then
      CNode.Sklad.ClearSklad;
    CNode:=CNode.NexTTransportNode;
    end;

    repeat
    Recover:=Solution.SearchOptimumSolution;   //Ищем решение, которое оптимально
    OptimRecover:=Recover;
    Writeln(f);
    Writeln(f,'Оптимальное решение - '+Recover.NameSolution);
    NomMax:=Recover.GoMaxTime(1,True);                 //Ищем элемент, который дольше всего ожидает
    NameElement:=Recover.PlanRecover[NomMax].Name;
    NodeElement:=Recover.PlanRecover[NomMax].Node;
    //Выбираем склад, в который добавим данный элемент
    sk:=Length(OptimRecover.NodeNameArray);
    MinLength:=100000000000000;
    node:=nil;
    CNode:=FirsTTransportNode;
    While CNode<>nil do
      begin
      If (CNode<>NodeElement) and (CNode.Sklad<>nil) and (CNode.Ns=nil) then
        begin
        leng:=SearchMinTime(CNode,NodeElement);
        j:=0;
        IF sk<>0 then
          While (j<sk) and (NodeElement.Name+'->'+NameElement+'->'+CNode.Name<>OptimRecover.NodeNameArray[j]) do
            Inc(j);
        If (Leng<MinLength) and ((sk=0) or (j=sk)) then
          begin
          MinLength:=leng;
          Node:=CNode;
          end;
        end;
      CNode:=CNode.NexTTransportNode;
      end;
    If Node=nil then
      begin
      Inc(sk);                               //Добавляем перемещение в список, что бы не повторять
      SetLength(OptimRecover.NodeNameArray,sk);
      OptimRecover.NodeNameArray[sk-1]:='n '+NameElement;
      end;
    until Node<>nil;

  Inc(sk);                               //Добавляем перемещение в список, что бы не повторять
  SetLength(OptimRecover.NodeNameArray,sk);
  OptimRecover.NodeNameArray[sk-1]:=NodeElement.Name+'->'+NameElement+'->'+Node.Name;

  Solution.CopyRecover(NomSolution);         //Создаем новое решение копией оптимального решения
  Inc(KolSolution);
  Recover:=Solution.Recover[KolSolution-1];
  NomSolution:=KolSolution-1;
  Recover.DeleteRecover(NameElement,NodeElement);    //Удаляем из нового решения неэфективный элемент
  //SaveProtocolRecovery(Recover,'Протокол решение №'+IntTostr(NomSolution)+'.txt');

  AddAllRecoverTime(Recover,Node,NameElement);//Запускаем добавление
  ClearRecoverSost(EndTime);
  qSort(Recover,0,Length(Recover.PlanRecover)-1);
  end;


  VivodProcessing:=True;
  Writeln(f);
  DoProgon(Recover,NameElement);
  Writeln(f);
  VivodSostGraph;
  VivodProcessing:=False;

  Recover.TimeFailureOb:=0;
  Recover.TimeWaitingOb:=0;
  Recover.TimeFailure:=0;
  Recover.TimeWaiting:=0;
  For k:=1 to KolNotChangeIterMode2 do
    begin
    DoProgon(Recover,NameElement);

    Recover.GoTimeOb(k);             //Вычисление общего времени
    SaveAllGraphTime(TF,TW);
    if k=1 then
      begin
      Recover.TimeFailure:=TF;
      Recover.TimeWaiting:=TW;
      end
    else
      begin
      Recover.TimeFailure:=(Recover.TimeFailure*(k-1)+TF)/k;
      Recover.TimeWaiting:=(Recover.TimeWaiting*(k-1)+TW)/k;
      end;
//    Recover.GoMaxTime(k,False);    //Вычисление сумарного времени
    end;
  SaveProtocolRecovery(Recover,'Протокол решение №'+IntTostr(NomSolution)+'.txt');

CloseFile(f);
VivodTabledPlanReover(Solution.Recover[FModel.SeNomResh.Value]);
end;

procedure TFModel.BtTestClick(Sender: TObject);
var
  j,n:LongWord;
  z:Double;
  m:ArrayZnat;
  koefApr:ArrayDet;
  MOshA:Double;
  MNerA:Double;
  Recover:TPlanRecover; Node:TTransportNode; ElementName:string;
begin
{  Solution:=TSolution.Create;
SetLength(Solution.Recover,1);
Solution.Recover[NomSolution]:=TPlanRecover.Create;
Solution.Recover[NomSolution].NameSolution:='Основное решение';
Recover:=Solution.Recover[NomSolution];}
    n:=0;
    For j:=0 to 200 do
      begin
//      FModel.MeProt.Lines.Add(Node.Name+' '+ElementName+' '+'  2000*0.005*j='+FloatToStr(2000*0.005*j));
      GoParametrElement (Recover,Node,0,ElementName,2000*0.005*j,1,z,MNerA,MOshA);
//      VivodToExcel (ElementName,2000*0.05*j,1,MNerA,MOshA,0);
      Inc(n);
      SetLength(m,n);
      m[n-1][0]:=2000*0.005*j;
      m[n-1][1]:=MNerA*koef+MOshA*(1-koef);
      end;
    GoKoefParabola(m,koefApr);
end;

procedure TFModel.SeNomReshChange(Sender: TObject);
begin
VivodTabledPlanReover(Solution.Recover[FModel.SeNomResh.Value]);
end;

procedure TFModel.chkTimeClick(Sender: TObject);
begin
VivodTabledPlanReover(Solution.Recover[FModel.SeNomResh.Value]);
end;

procedure TFModel.PbKartaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Node:TTransportNode;
begin
{ChangeMx:=True;
XChangeMX:=x;
YChangeMY:=y;   }
Node:=SearchNodeXY(x,y);
IF Node<>nil then
  begin
  VivodTransportNode:=Node;
  FVivodAeroport.ShowModal;
  end;
end;

procedure TFModel.PbKartaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
ChangeMx:=false;
end;

procedure TFModel.PbKartaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if ChangeMx then
  begin
  mx:=mx+x-XChangeMX;
  my:=my+y-YChangeMY;
  PaintNode(PbKarta.Canvas);
  end;
end;

procedure TFModel.BtGoSkladClick(Sender: TObject);
var
  CNode:TTransportNode;
  CElement:TElementNS;
  CSklad:TSklad;
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  CNode:=SearchNodeMaxNS;
  if CNode<>nil then
    begin
    CElement:=CNode.SearchElementMax;
    IF CElement<>nil then
      begin
//      CSklad:=SearchskladMinLength(CNode,CElement.SizeProduction);
      end;
    end;
  end;
end;

procedure TFModel.BtVisibleClick(Sender: TObject);
begin
pnlKarta.Visible:=not pnlKarta.Visible;
pnl4.Visible:=not pnl4.Visible;
PaintNode(PbKarta.Canvas);
end;

procedure TFModel.BtNewTransportGraphClick(Sender: TObject);
begin
FNewTransportGraph.ShowModal;
PaintNode(PbKarta.Canvas);
end;

procedure TFModel.FormCreate(Sender: TObject);
begin
Dx:=1;
Dy:=1;
Mx:=0;
MY:=0;
MaxKolInterval:=0;
GoProtocolEvent:=False;
SgSolution.Cells[0,0]:='№';
SgSolution.Cells[1,0]:='Время кон.';
SgSolution.Cells[2,0]:='Время мод2';
SgSolution.Cells[3,0]:='КГ';
SgSolution.Cells[4,0]:='Стоимость';
SgSolution.Cells[5,0]:='Кол-во';
SgSolution.ColWidths[0]:=50;
SgSolution.ColWidths[1]:=80;
SgSolution.ColWidths[2]:=80;
SgSolution.ColWidths[3]:=110;
SgSolution.ColWidths[4]:=110;
SgSolution.ColWidths[5]:=50;
Bitmap := TBitmap.Create;
Bitmap.Width := PbKarta.Width;
Bitmap.Height := PbKarta.Height;
Bitmap.LoadFromFile('RUS.bmp');
PbKarta.Canvas.Draw(0,0,Bitmap);
end;

procedure TFModel.BtSaveGrpahClick(Sender: TObject);
begin
If SdSave.Execute then
  begin
  SaveTransportGraphFile(SdSave.FileName);
  ShowMessage('Граф сохранен в файл '+SdSave.FileName);
  end;

end;

procedure TFModel.BtLoadGraphClick(Sender: TObject);
begin
If OdLoad.Execute then
  begin
  LoadGraph(OdLoad.FileName);
  ShowMessage('Граф загружен из файла '+SdSave.FileName);
  PaintNode(PbKarta.Canvas);
  end;
end;

procedure TFModel.BtInitializationClick(Sender: TObject);
begin
  SBS:=TQueueEvent.Create;
  MaxTimeModel:=StrToFloat(MeTime.Lines.Strings[MaxKolInterval-1]);
SettingModel:=1;
InitializationTransportGraph;
  PaintNode(PbKarta.Canvas);
//  VivodSBSToMemoEdit(FModel.MeSBS);
end;

procedure TFModel.SbSaveTimeClick(Sender: TObject);
begin
IF SdSave.Execute then
  MeTime.Lines.SaveToFile(SdSave.FileName);
end;

procedure TFModel.SbLoadTimeClick(Sender: TObject);
begin
If OdLoad.Execute then
  MeTime.Lines.LoadFromFile(OdLoad.FileName);
end;

procedure TFModel.SbAddTimeClick(Sender: TObject);
begin
Inc(MaxKolInterval);
MeTime.Lines.Add(EdTimePost.Text);
end;

Procedure ClearAllTransportGraph;
var
  CNode:TTransportNode;
  NomProduction:Word;
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  if Length(CNode.StatProduction)<>0 then
  For NomProduction:=0 to Length(CNode.StatProduction)-1 do
    begin
    CNode.StatProduction[NomProduction].MFailure:=0;
    CNode.StatProduction[NomProduction].MRecover:=0;
    SetLength(CNode.StatProduction[NomProduction].HistFailure,0);
    SetLength(CNode.StatProduction[NomProduction].HistRecov,0);
    SetLength(CNode.StatProduction[NomProduction].HistItog,0);
    end;

  CNode:=CNode.NexTTransportNode;
  end;
end;

procedure AddAllElementSolutionToSbs(NomSolution:Word);
var
  NomElement,Value:Word;
  NewEvent:TEventAddElement;
begin
If Length(ArraySolution)>NomSolution then
  begin
  If Length(ArraySolution[NomSolution].ElementArray)<>0 then
  For NomElement:=0 to Length(ArraySolution[NomSolution].ElementArray)-1 do
    for Value:=1 to ArraySolution[NomSolution].ElementArray[NomElement].Value do
      begin
      NewEvent:=TEventAddElement.Create;
      NewEvent.Name:=ArraySolution[NomSolution].ElementArray[NomElement].Element;
      NewEvent.Node:=SearchNodeName(ArraySolution[NomSolution].ElementArray[NomElement].NameTransportNode);
      NewEvent.EventTime:=ArraySolution[NomSolution].ElementArray[NomElement].Time;
      end;
  end;
end;

Procedure VivodElementSkald(Sklad:TSklad);
var
  Element:TElementSklad;
begin
 Element:=Sklad.FirstElement;
 While Element<>nil do
   begin
   FModel.MeProt.Lines.Add(Element.Name+' '+IntToStr(Element.kolvo));
   Element:=Element.NextElement;
   end;
end;

Procedure VivodKG(Me:TMemo; ModelTime:Double);
var
    CNode:TTransportNode;
    NomNs:Word;
begin
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    If Length(CNode.Ns)<>0 then
    for NomNs:=0 to Length(CNode.Ns)-1 do
      begin
      Me.Lines.Add(CNode.Ns[NomNs].Name+' '+CNode.Ns[NomNs].Nomber+' KG='+FloatToStr((CNode.Ns[NomNs].MainNode.Stat.TimeOsn[0][0]+CNode.Ns[NomNs].MainNode.Stat.TimeOsn[1][0])/ModelTime));
      Me.Lines.Add(' Time[0]='+FloatToStr(CNode.Ns[NomNs].MainNode.Stat.TimeOsn[0][0])+' Time[1]='+FloatToStr(CNode.Ns[NomNs].MainNode.Stat.TimeOsn[1][0])+' Time[2]='+FloatToStr(CNode.Ns[NomNs].MainNode.Stat.TimeOsn[2][0]))
      end;
    CNode:=CNode.NexTTransportNode;
    end;
end;

Procedure GoIteration (NomIteration:LongWord; NomSolution:Word; var ModelTime:Double);
var
  StartModel2Time:Double;
  KolEvent:Double;
begin
GoProtocolEvent:=FModel.CbGoProtocolEvent.Checked;
  If GoProtocolEvent then
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Запуск');
StartModel2Time:=0;
KolProgon:=NomIteration;
SettingModel:=1;
ModelTime:=0;
GoStat:=True;
InitializationTransportGraph;
If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Заносятся события поставки ЗЧ');
ArraySolution[NomSolution].GoSolutionToEvent;
GoAllEventManufacture;
//AddAllElementSolutionToSbs(NomSolution);
//If GoProtocolEvent then
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Старт прогона №'+IntToStr(NomIteration));
KolEvent:=0;

//If GoProtocolEvent then
//VivodSBSToMemoEdit(FModel.MeSBS);
While ModelTime<EndModelTime2 do
  begin
  KolEvent:=KolEvent+1;
  If ModelTime>EndModelTime1 then
    SettingModel:=2;
  ProcessingEvent(ModelTime);
  ModelTime:=SBS.FirstEvent.EventTime;
  IF FModel.CbVivodModelTime.Checked then
    FModel.EdCurrentModelTime.Text:=FloatToStr(ModelTime);
//  PaintNode(FModel.PbKarta.Canvas);
  end;

FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Конец прогона. Количество событий - '+FloatToStr(KolEvent));
FinalizationTransportGraph;
  If GoProtocolEvent then
VivodKG(FModel.MeProt,ModelTime);
  If GoProtocolEvent then
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Конец');
end;

procedure TFModel.BtGoModelType2Click(Sender: TObject);
var
  ModelTime:Double;
begin
  SBS:=TQueueEvent.Create;
  GoIteration(1,0,ModelTime);
end;

procedure TFModel.CbGoProtocolEventClick(Sender: TObject);
begin
GoProtocolEvent:=CbGoProtocolEvent.Checked;
end;

procedure TFModel.BtIterationClick(Sender: TObject);
Var
  ModelTime:Double;
  NomIteration,kolIteration:LongWord;
begin
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  СТАРТ');
  SBS:=TQueueEvent.Create;
  MaxTimeModel:=StrToFloat(MeTime.Lines.Strings[MaxKolInterval-1]);
  Koliteration:=StrToInt(EdKolIteration.Text);
For NomIteration:=1 to Koliteration do
  begin
  GoIteration(NomIteration,0,ModelTime);
  end;
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение статистики');
GoEndStatAllNode(Koliteration);
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сбор статистики по аэропортам');
AddAllStatGraphToNode;
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  КОНЕЦ');

end;

procedure TFModel.BtStartTestClick(Sender: TObject);
Var
  NomIteration:LongWord;
  EndModelTime,ModelTime:Double;
  StartModel2Time:Double;
begin
  SBS:=TQueueEvent.Create;
For NomIteration:=1 to StrToInt(EdKolIteration.Text) do
  begin
  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  НАЧАЛО Итерация № '+IntToStr(NomIteration));
  If GoProtocolEvent then
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Запуск');
EndModelTime:=StrToFloat(FModel.MeTime.Lines.Strings[0]);
StartModel2Time:=0;
KolProgon:=NomIteration;
SettingModel:=1;
ModelTime:=0;
InitializationTransportGraph;
  If GoProtocolEvent then
FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Конец прогона');
FinalizationTransportGraph;
  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  КОНЕЦ Итерация № '+IntToStr(NomIteration));

  end;
end;

procedure TFModel.BtAntModeClick(Sender: TObject);
begin
FMainAnt.ShowModal;
end;

function CheckExcelRun: boolean;
begin
  try
    MsExcel:=GetActiveOleObject('Excel.Application');
    Result:=True;
  except
    Result:=false;
  end;
end;

procedure VivodArraySolutionToExcel(Solution:TSolutionType);
  var
    Row:LongWord;
    NomElement:LongWord;
begin
CheckExcelRun;
//Row:=MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[1,1];
Row:=MsExcel.ActiveWorkBook.ActiveSheet.Cells[1,1];
Inc(Row);
//MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[1,1]:=Row;
MsExcel.ActiveWorkBook.ActiveSheet.Cells[1,1]:=Row;
If Length(Solution.ElementArray)<>0 then
For NomElement:=0 to Length(Solution.ElementArray)-1 do
  begin
//  MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[Row,2+NomElement]:=ElementArray[NomElement].Value;
  MsExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2+NomElement]:=Solution.ElementArray[NomElement].Value;
  If Row=2 then
  MsExcel.ActiveWorkBook.ActiveSheet.Cells[1,2+NomElement]:=Solution.ElementArray[NomElement].Element;
//  MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[1,2+NomElement]:=ElementArray[NomElement].Element;
  end;
MsExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2+NomElement+1]:=Solution.MCost;
MsExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2+NomElement+2]:=Solution.MMinKoefGot;
MsExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2+NomElement+3]:=Solution.MKoefGot;
MsExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2+NomElement+4]:=Solution.MMaxKoefGot;
//MsExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2+NomElement+5]:=MTimeProgon;
end;

procedure StartDSS;
var
  KolElement:Word;
  CurrentSklad:TAntNodeSklad;
  kolIteration:LongWord;
  NomSolution,NomNewSolution,NomSearchSolution,NomAnt:Word;
  NomSearchEndSolution:Word;
  Kol:word;
  TimeManufacturing:Double;
  NomPost:Word;
  AntEnd:Boolean;
  KolantIteration:Word;
  KolPheromon1,KolPheromon2,IsparNode1,IsparNode2,IsparArc1,IsparArc2:Double;
  Koef:Word;
  KolDoubleSolution, NomDoubleSolution:LongWord;
  TimeNatProgon,TimeNatProgonMMK:TDateTime;
begin
with FModel do
begin
MTimeProgon:=0;
KolDSSIterations:=0;
EndSolutions:=nil;
BoolGoProtocolElement:=False;
GoSaveArrayFailyreAndRecoveryBool:=True;
GoSaveHistBool:=True;
GoProtocolEventAnt:=CbProtocolAnt.Checked;

if FModel.RgTypeEndDSS.ItemIndex=1 then       //Занесение значений пределов для СППР
  begin
  LimitKG:=StrToFloat(EdMOKG.Text);
  LimitMinKG:=StrToFloat(EdMinKG.Text);
  LimitMaxKG:=StrToFloat(EdMaxKG.Text);
  LimitMCost:=StrToFloat(EdMaksCost.Text);
  end;
AlfKoeffSumm:=StrToFloat(EdParSumm.Text);    //Занесение значения взвешенной суммы для ММК СППР

MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  СТАРТ');
NameElementProcessTransport:='';//??????????????????????????????????????????????????????????????????????
SBS:=TQueueEvent.Create;

MaxTimeModel:=StrToFloat(MeTime.Lines.Strings[MaxKolInterval-1]);
Koliteration:=StrToInt(EdKolIteration.Text);
NatKolPheromon1:=StrToFloat(EdNatKolPheromon1.Text);
NatKolPheromon2:=StrToFloat(EdNatKolPheromon2.Text);
KolPheromon1:=StrToFloat(EdPheromon1.Text);
KolPheromon2:=StrToFloat(EdPheromon2.Text);
IsparNode1:=StrToFloat(EdIsparNodePheromon1.Text);
IsparNode2:=StrToFloat(EdIsparNodePheromon2.Text);
PheromonPar:=StrToFloat(EdKoefPher.Text);

NomPost:=0;
TimeManufacturing:=0;
EndModelTime1:=StrToFloat(FModel.MeTime.Lines.Strings[NomPost]);
EndModelTime2:=StrToFloat(FModel.MeTime.Lines.Strings[NomPost+1]);

if FirstNodeAntGraph=nil then
begin
NameGraphFile:='Test';
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создается решение №0');
SetLength(ArraySolution,1);
ArraySolution[0]:=TSolutionType.Create;
NomSolution:=0;
ArraySolution[NomSolution].TimeEnd:=EndModelTime1;
ArraySolution[NomSolution].TimeToModel2:=EndModelTime2;
TimeNatProgon:=Now;
For NomProgon:=1 to Koliteration do
  begin
  GoIteration(NomProgon,NomSolution,ModelTime);
  end;
MTimeProgon:=Now-TimeNatProgon;
EdTimeProgon.Text:=FormatDateTime('hh:nn:ss - zzz', MTimeProgon);

  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение статистики');
GoEndStatAllNode(Koliteration);
  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сбор статистики по аэропортам');
AddAllStatGraphToNode;
  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Подсчет критериев решения ');
ArraySolution[NomSolution].GoKoef(0,ModelTime);
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Kg='+FloatToStr(ArraySolution[NomSolution].MKoefGot)+' Cost='+FloatToStr(ArraySolution[NomSolution].MCost));
    SgSolution.Cells[0,NomSolution+1]:=IntToStr(NomSolution);
    SgSolution.Cells[1,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].TimeToModel2);
    SgSolution.Cells[2,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].TimeEnd);
    SgSolution.Cells[3,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].MKoefGot);
    SgSolution.Cells[4,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].MCost);
    SgSolution.Cells[5,NomSolution+1]:='1';
    If BoolSaveSolutionOnFile then
      begin
      MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение решений в файл');
      SaveArraySolutionAsTextFile;
      end;    


MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создается граф муравьев');
AddAllHistSklad;
CreateAntGraph;
SaveAntGraphFromTextFile('AntGraph.txt');
  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создаются дуги в графе муравьев');
AddAllAntArc;

  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Занесение статистики транспортного графа в решение');
AddResultToSolution(NomSolution);
  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создается начальная вершина графа муравьев');
CreateAntNode;
end
 else
 ClearAllAntGraph;

AddAllCostCreateProductionOnAntGraph;  //Добавление стоимости производства на граф решений
EdMaxKolSolution.Text:=FloatToStr(GiveKolSolution);

KolElement:=0;
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  KolElement:=KolElement+CurrentSklad.KolElement;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;

AntEnd:=False;
KolAntIteration:=0;
GoSaveArrayFailyreAndRecoveryBool:=false;
GoSaveHistBool:=False;
While not AntEnd do
begin
TimeNatProgonMMK:=Now;
If TcMAin.TabIndex=1 then
  PaintAntGraph(PbKarta.Canvas,PbKarta.Height,PbKarta.Width);
  Inc(KolDSSIterations);
  Inc(KolAntIteration);
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  ИТЕРАЦИЯ №'+IntToStr(KolAntIteration));
    If CbProtocolDSS.Checked then
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создаются муравьи');
  CreateAnt(StrToInt(EdKolAgent.Text));
    If CbProtocolDSS.Checked then
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Муравьи запускаются на граф');
  AntGoGraph;
//  DelAlltransportGraphStructure;

  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Количество элементов = '+IntToStr(KolElement));
  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Запуск перемещения муравьев');
for NomAnt:=0 to Length(Ant)-1 do
  begin
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Запускается муравей №'+IntToStr(NomAnt));
  While Length(Ant[NomAnt].Way)<KolElement do
    Ant[NomAnt].GoNextNode(RgKrit.ItemIndex);
  NomNewSolution:=NomSolution;
  NomSearchSolution:=Ant[NomAnt].SearchWayAndSolution(NomSolution,TimeManufacturing);
  If NomSearchSolution=6400 then
    begin
    //Создание нового решения
    NomNewSolution:=AddCopySolution(NomSolution);
    SgSolution.RowCount:=NomNewSolution+2;
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создано решение №'+IntToStr(NomNewSolution));
    EdKolSolution.Text:=IntToStr(NomNewSolution);
      If CbProtocolDSS.Checked then
      MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Добавляются времена поставки ЗЧ, исходя из путя мурявья');

    Ant[NomAnt].AddSolutionFromWay(TimeManufacturing,ArraySolution[NomNewSolution].ElementArray);

      If CbProtocolDSS.Checked then
      MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Очистка статистики графа');
    ClearAllTransportGraph;
    EndModelTime1:=StrToFloat(FModel.MeTime.Lines.Strings[NomPost+1]);
    ArraySolution[NomNewSolution].TimeEnd:=EndModelTime1;
    ArraySolution[NomNewSolution].TimeToModel2:=EndModelTime2;
    //Проведение эксперимента с новым решением
    TimeNatProgon:=Now;
    For NomProgon:=1 to Koliteration do
      begin
      GoIteration(NomProgon,NomNewSolution,ModelTime);
      end;
    MTimeProgon:=Now-TimeNatProgon;
    EdTimeProgon.Text:=FormatDateTime('hh:nn:ss - zzz', Now-TimeNatProgon);

    If CbProtocolDSS.Checked then
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение статистики');
    GoEndStatAllNode(Koliteration);
    If CbProtocolDSS.Checked then
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сбор статистики по аэропортам');
    AddAllStatGraphToNode;
    If CbProtocolDSS.Checked then
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Подсчет критериев решения ');
    ArraySolution[NomNewSolution].GoKoef(0,ModelTime);
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Kg='+FloatToStr(ArraySolution[NomNewSolution].MKoefGot)+' Cost='+FloatToStr(ArraySolution[NomNewSolution].MCost));
    If CbProtocolDSS.Checked then
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Занесение статистики транспортного графа в решение');
    AddResultToSolution(NomNewSolution);
    Inc(ArraySolution[NomNewSolution].KolAgent);
    SgSolution.Cells[0,NomNewSolution+1]:=IntToStr(NomNewSolution);
    SgSolution.Cells[1,NomNewSolution+1]:=FloatToStr(ArraySolution[NomNewSolution].TimeToModel2);
    SgSolution.Cells[2,NomNewSolution+1]:=FloatToStr(ArraySolution[NomNewSolution].TimeEnd);
    SgSolution.Cells[3,NomNewSolution+1]:=FloatToStr(ArraySolution[NomNewSolution].MKoefGot);
    SgSolution.Cells[4,NomNewSolution+1]:=FloatToStr(ArraySolution[NomNewSolution].MCost);
    SgSolution.Cells[5,NomNewSolution+1]:='1';
    EdKolSolution.Text:=IntToStr(NomNewSolution+1);
    AddSolutionToParettoSet(NomNewSolution);
    VivodArraySolutionToExcel(ArraySolution[NomNewSolution]);
    If BoolSaveSolutionOnFile then
      begin
      MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение решений в файл');
      SaveArraySolutionAsTextFile;
      end;
    If TcMAin.TabIndex=2 then
      PaintSolutions(PbKarta.Canvas,PbKarta.Height,PbKarta.Width,5000,5000);
    end
  else
    begin
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Выбрано стандартное решение №'+IntToStr(NomSearchSolution));
    NomNewSolution:=NomSearchSolution;
    Inc(ArraySolution[NomNewSolution].KolAgent);
    Kol:=StrToInt(SgSolution.Cells[5,NomNewSolution+1]);
    SgSolution.Cells[5,NomNewSolution+1]:=IntToStr(Kol+1);
    if NomDoubleSolution<>NomNewSolution then
      begin
      NomDoubleSolution:=NomNewSolution;
      KolDoubleSolution:=1;
      end
    else
      begin
      Inc(KolDoubleSolution);
      IF KolDoubleSolution>=15 then
        ClearAllAntGraph;
      end;
    end;
  //Сохранение статистики прогонов
  If GoProtocolEvent then
  If CbProtocolDSS.Checked then
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение статитсики прогонов');
  Ant[NomAnt].MKoefGot:=ArraySolution[NomNewSolution].MKoefGot;
  Ant[NomAnt].MCost:=ArraySolution[NomNewSolution].MCost;
  end;
SortAnt(RgKrit.ItemIndex);
for NomAnt:=0 to Length(Ant)-1 do
  begin
  case RgTypeAntGo.ItemIndex of
    0:Koef:=1;
    1:if NomAnt=0 then
        Koef:=StrToInt(EdKoefAntElit.Text)
      else
        koef:=1;
    2:if NomAnt<StrToInt(EdKoefAntElit.Text) then
        koef:=StrToInt(EdKoefAntElit.Text)-NomAnt
      else
        koef:=1;
  end;
  case FModel.RgTypeEndDSS.ItemIndex of
    0: Ant[NomAnt].AddPheromonToGraph((KolPheromon1/(1-Ant[NomAnt].MKoefGot+0.001))*Koef,(KolPheromon2/(Ant[NomAnt].MCost+0.001))*Koef);
    1: begin
       IF (Ant[NomAnt].MKoefGot<LimitKG) and (Ant[NomAnt].MCost<=LimitMCost) then  Ant[NomAnt].AddPheromonToGraph((KolPheromon1/(LimitKG-Ant[NomAnt].MKoefGot+0.001))*Koef,(KolPheromon2*sqrt(LimitMCost-Ant[NomAnt].MCost+0.001))*Koef);
       IF (Ant[NomAnt].MKoefGot<LimitKG) and (Ant[NomAnt].MCost>=LimitMCost) then  Ant[NomAnt].AddPheromonToGraph((KolPheromon1/(LimitKG-Ant[NomAnt].MKoefGot+0.001))*Koef,(KolPheromon2/sqrt(Ant[NomAnt].MCost-LimitMCost))*Koef);
       IF (Ant[NomAnt].MKoefGot>LimitKG) and (Ant[NomAnt].MCost<=LimitMCost) then  Ant[NomAnt].AddPheromonToGraph((KolPheromon1*100000*(Ant[NomAnt].MKoefGot-LimitKG+0.001))*Koef,(KolPheromon2*sqrt(LimitMCost-Ant[NomAnt].MCost+0.00123))*Koef);
       IF (Ant[NomAnt].MKoefGot>LimitKG) and (Ant[NomAnt].MCost>=LimitMCost) then  Ant[NomAnt].AddPheromonToGraph((KolPheromon1*100000*(Ant[NomAnt].MKoefGot-LimitKG+0.001))*Koef,(KolPheromon2/sqrt(Ant[NomAnt].MCost-LimitMCost))*Koef);
       end;
    end;
  end;

DecreasePheromonAllGraph(IsparArc1,IsparArc2,IsparNode1,IsparNode2);
case FModel.RgTypeEndDSS.ItemIndex of
  0:  AntEnd:=StrToInt(EdKolAntProgon.Text)<KolAntIteration;
  1:  begin
      NomSearchEndSolution:=0;
      While NomSearchEndSolution<Length(ArraySolution) do
        begin
        If (ArraySolution[NomSearchEndSolution].KolAgent>0) and
           (ArraySolution[NomSearchEndSolution].MKoefGot>=LimitKG) and
           (ArraySolution[NomSearchEndSolution].MMinKoefGot>=LimitMinKG) and
           (ArraySolution[NomSearchEndSolution].MMaxKoefGot>=LimitMaxKG) and
           (ArraySolution[NomSearchEndSolution].MCost<=LimitMCost) then
           begin
           EndSolutions:=ArraySolution[NomSearchEndSolution];
           AntEnd:=True;
           end;
        Inc(NomSearchEndSolution);
        end;
      end;
  end;
EdTimeProgonMMK.Text:=FormatDateTime('hh:nn:ss - zzz', Now-TimeNatProgonMMK);
MTimeProgonMMK:=Now-TimeNatProgonMMK;
end;
GoParettoSet;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  КОНЕЦ');
TimeManufacturing:=EndModelTime1;
end;
end;

procedure TFModel.SbStartKolSPRClick(Sender: TObject);
begin
MsExcel := CreateOleObject('Excel.Application');
MsExcel.Workbooks.Open['E:\КАФЕДРА\ДИССЕРТАЦИЯ\ПРОГРАММА\Пример1.xls'];
BoolSaveSolutionOnFile:=True;
if FModel.RgTypeEndDSS.ItemIndex=1 then       //Занесение значений пределов для СППР
  begin
  LimitKG:=StrToFloat(EdMOKG.Text);
  LimitMinKG:=StrToFloat(EdMinKG.Text);
  LimitMaxKG:=StrToFloat(EdMaxKG.Text);
  LimitMCost:=StrToFloat(EdMaksCost.Text);
  end;
if RgTypeEndDSS.ItemIndex=0 then
  LimitCostProduction:=1000000000000
else
  LimitCostProduction:=LimitMCost;
AlfKoeffSumm:=StrToFloat(EdParSumm.Text);    //Занесение значения взвешенной суммы для ММК СППР
StartDSS;
end;

procedure TFModel.SgSolutionSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  NomElement:Word;
  MaxKolElement:LongWord;
  DeltElement:LongWord;
  PosSklad,PosElement:Word;
  CurrentNameSklad:string;
  KolElement:Word;
  CurrentSklad:TAntNodeSklad;
begin
If Length(ArraySolution[ARow-1].ElementArray)<>0 then
begin
NomVivodSolution:=ARow-1;
PbKarta.Canvas.Rectangle(0,0,PbKarta.Width,PbKarta.Height);
  PaintAntGraph(PbKarta.Canvas,PbKarta.Height,PbKarta.Width);
CurrentNameSklad:=ArraySolution[ARow-1].ElementArray[0].NameTransportNode;
MaxKolElement:=0;
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  MaxKolElement:=MaxKolElement+CurrentSklad.KolElement+1;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
DeltElement:=Trunc((PbKarta.Width-25*MaxKolElement)/MaxKolElement);
PosSklad:=20;
PosElement:=PosSklad+10;
KolElement:=0;
For NomElement:=0 to Length(ArraySolution[ARow-1].ElementArray)-1 do
  begin
  If NomElement<>0 then
    PbKarta.Canvas.LineTo(PosElement,75+(ArraySolution[ARow-1].ElementArray[NomElement].Value)*20+10);
  MeProt.Lines.Add(ArraySolution[ARow-1].ElementArray[NomElement].NameTransportNode+' ->'+ArraySolution[ARow-1].ElementArray[NomElement].Element+' '+IntToStr(ArraySolution[ARow-1].ElementArray[NomElement].Value));
  IF ArraySolution[ARow-1].ElementArray[NomElement].NameTransportNode<>CurrentNameSklad then
    begin
    CurrentNameSklad:=ArraySolution[ARow-1].ElementArray[NomElement].NameTransportNode;
    PosSklad:=PosSklad+(25+DeltElement)*KolElement;
    KolElement:=0;
    end;
  PbKarta.Canvas.Rectangle(PosElement,75+(ArraySolution[ARow-1].ElementArray[NomElement].Value+1)*20,PosElement+25,75+(ArraySolution[ARow-1].ElementArray[NomElement].Value)*20);
  PbKarta.Canvas.MoveTo(PosElement+25,75+(ArraySolution[ARow-1].ElementArray[NomElement].Value)*20+10);
  PosElement:=PosElement+DeltElement+25;
  Inc(KolElement);
  end;
end;
end;

procedure DrawProc;
var
  i,NomHist,NomFirstHist:LongWord;
  max:LongWord;
  nShag,Mnosh:Word;
  kol,z:LongWord;
  st:string;
  NHist:LongWord;
  TimeMax,TimeMin:Double;
  x1,x2,y1,y2:LongWord;
begin
with FModel do
  begin
  PbKarta.Canvas.Rectangle(0,0,PbKarta.Width,PbKarta.Height);

  if Length(ArrayHist)<>0 then
    begin
    NomFirstHist:=SeNomHist.Value-1;
    NomHist:=0;
    while (NomFirstHist+NomHist<Length(ArrayHist)) and (NomHist<5) do
      begin
      NHist:=Length(ArrayHist[NomFirstHist+NomHist].Hist);
      max:=0;
      for i:=0 to NHist-1 do
        if max<ArrayHist[NomFirstHist+NomHist].Hist[i] then
          max:=ArrayHist[NomFirstHist+NomHist].Hist[i];
      case ArrayHist[NomFirstHist+NomHist].typeHist of
        1: PbKarta.Canvas.Pen.Color:=clGreen;
        2: PbKarta.Canvas.Pen.Color:=clBlue;
        3: PbKarta.Canvas.Pen.Color:=clFuchsia;
        4: PbKarta.Canvas.Pen.Color:=clRed;
        end;
      nShag:=Trunc((PbKarta.Width-20)/NHist)+1;
      IF max<>0 then
      For i:=0 to NHist-1 do
        begin
        x1:=10+i*nShag;
        x2:=10+(i+1)*nShag;
        y1:=Trunc(PbKarta.Height/5)*(NomHist+1)-20;
        y2:=Trunc((PbKarta.Height/5)*(NomHist+1)-20-(PbKarta.Height/5-20)*ArrayHist[NomFirstHist+NomHist].Hist[i]/max);
        PbKarta.Canvas.Rectangle(x1,y1,x2,y2);

        end;

      PbKarta.Canvas.Pen.Color:=clBlack;
      PbKarta.Canvas.MoveTo(5,Trunc(PbKarta.Height/5)*(NomHist+1)-20);
      PbKarta.Canvas.LineTo(PbKarta.Width-10,Trunc(PbKarta.Height/5)*(NomHist+1)-20);
      PbKarta.Canvas.MoveTo(10,Trunc(PbKarta.Height/5)*(NomHist));
      PbKarta.Canvas.LineTo(10,Trunc(PbKarta.Height/5)*(NomHist+1)-20);
      PbKarta.Canvas.TextOut(60,Trunc(PbKarta.Height/5)*(NomHist)+10,ArrayHist[NomFirstHist+NomHist].Name);
      i:=0;
      IF Max<>0 then
      While i<=max do
        begin
        z:=Trunc(Trunc(PbKarta.Height/5)*(NomHist+1)-20-(Trunc(PbKarta.Height/5)-20)*i/max);
        PbKarta.Canvas.MoveTo(5,z);
        PbKarta.Canvas.LineTo(15,z);
        Str(i/StrToFloat(EdKolIteration.Text):6:4,st);
        PbKarta.Canvas.TextOut(12,z+2,st);
        If Max>300 then
          i:=i+100*(max div 300)
        else
        if max>100 then
          i:=i+30
        else
        If max>10 then
          i:=i+3
        else
          i:=i+1;
        end;
      For i:=0 to 20 do
        begin
        z:=Trunc(10+(PbKarta.Width-20)*i/20);
        PbKarta.Canvas.MoveTo(z,Trunc(PbKarta.Height/5)*(NomHist+1)-15);
        PbKarta.Canvas.LineTo(z,Trunc(PbKarta.Height/5)*(NomHist+1)-25);
        TimeMin:=StrToFloat(LeMin.Text);
        TimeMax:=StrToFloat(LeMax.Text);
        Str(Trunc(i/20*(TimeMax-TimeMin)+TimeMin),st);
        PbKarta.Canvas.TextOut(z,Trunc(PbKarta.Height/5)*(NomHist+1)-15,st);
        end;       
      inc(NomHist);
      end;
    end;
  end;
end;

procedure GoHistOne(ArrayStat:ArrayProcessOne;  var Hist:ArrayMemoryHist);
var
  i:LongWord;
  shag:Double;
  Mnosh:word;
  nHist:LongWord;
  TimeMin,TimeMax:Double;
begin
If Length(ArrayStat)<>0 then
begin
Mnosh:=FModel.SeShag.Value;
nHist:=Trunc((FModel.PbVisual.Width-20)/Mnosh)+1;
SetLength(Hist,nHist+1);
For i:=0 to nHist do
  Hist[i]:=0;
TimeMin:=StrToFloat(FModel.LeMin.Text);
TimeMax:=StrToFloat(FModel.LeMax.Text);
Shag:=nhist/(TimeMax-TimeMin);
For i:=0 to Length(ArrayStat)-1 do
  begin
    IF ArrayStat[i]>TimeMin then
      Inc(Hist[Trunc((ArrayStat[i]-TimeMin)*shag)]);
  end;
end;
end;

procedure GoHistDouble(ArrayStat:TArrayProcessDouble;  var Hist:ArrayMemoryHist);
var
  i,Nnat,NKon,N:LongWord;
  shag:Double;
  Mnosh:word;
  nHist:LongWord;
  TimeMin,TimeMax:Double;
begin
If Length(ArrayStat)<>0 then
begin
Mnosh:=FModel.SeShag.Value;
nHist:=Trunc((FModel.PbVisual.Width-20)/Mnosh)+1;
SetLength(Hist,nHist+1);
{For i:=0 to nHist do
  Hist[i]:=0;   }
TimeMin:=StrToFloat(FModel.LeMin.Text);
TimeMax:=StrToFloat(FModel.LeMax.Text);
Shag:=nhist/(TimeMax-TimeMin);
For i:=0 to Length(ArrayStat)-1 do
  begin
  Nnat:=Trunc((ArrayStat[i].TimeFailure-TimeMin)*shag);
  NKon:=Trunc((ArrayStat[i].TimeRecover-TimeMin)*shag);
  //Протокол
//  FModel.MeProt.Lines.Add(IntToStr(Nnat)+' '+IntToStr(Nkon)+': '+FLoatToStr(ArrayStat[i].TimeFailure)+' '+FLoatToStr(ArrayStat[i].TimeRecover));
  IF Nnat<NKon then
  if Nnat<>NKon then
    For n:=Nnat to NKon do
      Inc(Hist[n])
  else
    Inc(Hist[Nnat]);
  end;
end;
end;

procedure GoCreateAllHist;
var
  n,NomNs,NomStatistics:LongWord;
  CurrentNode:TTransportNode;
  Mnosh:word;
begin
CurrentNode:=FirsTTransportNode;
n:=0;
SetLength(ArrayHist,0);
while CurrentNode<>nil do
  begin
  if (CurrentNode.Manufact<>nil) and (Length(CurrentNode.Manufact.TimeProcess)<>0) then
    begin
    SetLength(ArrayHist,n+1);
    ArrayHist[n].typeHist:=1;
    ArrayHist[n].Name:=CurrentNode.Name;
    GoHistOne(CurrentNode.Manufact.TimeProcess,ArrayHist[n].Hist);
    Inc(n);
    end;
  if (CurrentNode.ARZ<>nil) and (Length(CurrentNode.ARZ.TimeProcess)<>0) then
    begin
    SetLength(ArrayHist,n+1);
    ArrayHist[n].typeHist:=2;
    ArrayHist[n].Name:=CurrentNode.Name;
    GoHistOne(CurrentNode.ARZ.TimeProcess,ArrayHist[n].Hist);
    Inc(n);
    end;
  If CurrentNode.Ns<>nil then
    begin
    For NomNs:=0 to Length(CurrentNode.Ns)-1 do
      begin
      SetLength(ArrayHist,n+1);
      ArrayHist[n].typeHist:=4;
      ArrayHist[n].Name:=CurrentNode.Ns[NomNs].Name+' '+CurrentNode.Ns[NomNs].Nomber;
      For NomStatistics:=0 to Length(CurrentNode.Ns[NomNs].StatistiksNode)-1 do
        if CurrentNode.Ns[NomNs].StatistiksNode[NomStatistics].GoSaveTime then
        GoHistDouble(CurrentNode.Ns[NomNs].StatistiksNode[NomStatistics].TimeFailure,ArrayHist[n].Hist);
      Inc(n);
      end;
    end;
  If (CurrentNode.Sklad<>nil) and (Length(CurrentNode.Sklad.AllTimeProcess)<>0) then
    begin
    SetLength(ArrayHist,n+1);
    ArrayHist[n].typeHist:=5;
    ArrayHist[n].Name:=CurrentNode.Name;
    GoHistDouble(CurrentNode.Sklad.AllTimeProcess,ArrayHist[n].Hist);
    Inc(n);
    end;
  CurrentNode:=CurrentNode.NexTTransportNode;
  end;
CurrentNode:=FirsTTransportNode;
while CurrentNode<>nil do
  begin
  If CurrentNode.Ns<>nil then
    begin
    SetLength(ArrayHist,n+1);
    ArrayHist[n].typeHist:=4;
    ArrayHist[n].Name:=CurrentNode.Name;
    For NomNs:=0 to Length(CurrentNode.Ns)-1 do
      begin
      For NomStatistics:=0 to Length(CurrentNode.Ns[NomNs].StatistiksNode)-1 do
        if CurrentNode.Ns[NomNs].StatistiksNode[NomStatistics].GoSaveTime then
        GoHistDouble(CurrentNode.Ns[NomNs].StatistiksNode[NomStatistics].TimeFailure,ArrayHist[n].Hist);
      end;
    Inc(n);
    end;
    CurrentNode:=CurrentNode.NexTTransportNode;
  end;
SetLength(ArrayHist,n+1);
ArrayHist[n].typeHist:=5;
ArrayHist[n].Name:='Склады общее';
CurrentNode:=FirsTTransportNode;
while CurrentNode<>nil do
  begin
  If (CurrentNode.Sklad<>nil) and (Length(CurrentNode.Sklad.AllTimeProcess)<>0) then
    begin
    GoHistDouble(CurrentNode.Sklad.AllTimeProcess,ArrayHist[n].Hist);
    end;
    CurrentNode:=CurrentNode.NexTTransportNode;
  end;
Inc(n);
CurrentNode:=FirsTTransportNode;
SetLength(ArrayHist,n+1);
ArrayHist[n].typeHist:=4;
ArrayHist[n].Name:='Отказы общее';
while CurrentNode<>nil do
  begin
  If CurrentNode.Ns<>nil then
    begin
    For NomNs:=0 to Length(CurrentNode.Ns)-1 do
      begin
      For NomStatistics:=0 to Length(CurrentNode.Ns[NomNs].StatistiksNode)-1 do
        if CurrentNode.Ns[NomNs].StatistiksNode[NomStatistics].GoSaveTime then
        GoHistDouble(CurrentNode.Ns[NomNs].StatistiksNode[NomStatistics].TimeFailure,ArrayHist[n].Hist);
      end;
    end;
    CurrentNode:=CurrentNode.NexTTransportNode;
  end;
    Inc(n);
if (Length(TimeProcessTransport)<>0) then
  begin
  SetLength(ArrayHist,n+1);
  ArrayHist[n].typeHist:=3;
  ArrayHist[n].Name:='Транспорт';
  GoHistOne(TimeProcessTransport,ArrayHist[n].Hist);
  Inc(n);  
  end;

end;

procedure TFModel.TcMAinChange(Sender: TObject);
begin
{PbKarta.Visible:=True;
PbKarta.Enabled:=True;
PnProc.Visible:=False;}
PbKarta.Canvas.Rectangle(0,0,PbKarta.Width,PbKarta.Height);
IF TcMAin.TabIndex=0 then
  begin
  Bitmap := TBitmap.Create;
Bitmap.Width := PbKarta.Width;
Bitmap.Height := PbKarta.Height;
Bitmap.LoadFromFile('RUS.bmp');
PbKarta.Canvas.Draw(0,0,Bitmap);
  end;



case TcMAin.TabIndex of
  0:PaintNode(PbKarta.Canvas);
  1:PaintAntGraph(PbKarta.Canvas,PbKarta.Height,PbKarta.Width);
  2:PaintSolutions(PbKarta.Canvas,PbKarta.Height,PbKarta.Width,8760,StrToInt(MeTime.Lines.Strings[1]));
  3:begin
{    PbKarta.Visible:=False;
    PbKarta.Enabled:=False;  }
//    PnProc.Visible:=True;
//    PbVisual.Visible:=True;
    GoCreateAllHist;
    DrawProc;
    end;
  end;
end;

procedure GoModel;
var
  NomNs,NomStat:LongWord;
  st:string;
  CurrentNode:TTransportNode;
  NomSolution:LongWord;
  KolIteration:LongWord;
  ModelTime:Double;
begin
with FModel do
begin
BoolGoProtocolElement:=FModel.CbProtocolElement.Checked;
GoSaveArrayFailyreAndRecoveryBool:=True;
GoSaveHistBool:=True;
GoProtocolEventAnt:=CbProtocolAnt.Checked;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  СТАРТ');
InitializationTransportGraph;
If CbCheckElementProcess.Checked then
  begin
  NameElementProcessTransport:=EdElementName.Text;
  CurrentNode:=FirsTTransportNode;
  while CurrentNode<>nil do
    begin
{    If (CurrentNode.Sklad<>nil) and ( CurrentNode.Sklad.SearchElement(NameElementProcessTransport)<>nil) then
      CurrentNode.Sklad.SearchElement(NameElementProcessTransport);}
    IF CurrentNode.Manufact<>nil then
      CurrentNode.Manufact.ProductionProcessName:=NameElementProcessTransport;
    IF CurrentNode.ARZ<>nil then
      CurrentNode.ARZ.ProductionProcessName:=NameElementProcessTransport;
    IF CurrentNode.Ns<>nil then
       For NomNs:=0 to Length(CurrentNode.Ns)-1 do
         for NomStat:=0 to Length(CurrentNode.Ns[NomNS].StatistiksNode)-1 do
           begin
           st:=CurrentNode.Ns[NomNS].StatistiksNode[NomStat].NameNode ;
           while Pos('>',st)<>0 do
             Delete(st,1,Pos('>',st));
           If st=NameElementProcessTransport then
             begin
             CurrentNode.Ns[NomNS].StatistiksNode[NomStat].GoSaveTime:=True;
             end;
           end;
    IF CurrentNode.Sklad<>nil then
      CurrentNode.Sklad.NameElementProcess:=NameElementProcessTransport;
    CurrentNode:=CurrentNode.NexTTransportNode;
    end;
  end
else
  NameElementProcessTransport:='';

//FinalizationTransportGraph;

MaxTimeModel:=StrToFloat(MeTime.Lines.Strings[MaxKolInterval-1]);
EndModelTime1:=StrToFloat(FModel.MeTime.Lines.Strings[1]);
EndModelTime2:=StrToFloat(FModel.MeTime.Lines.Strings[1]);

Koliteration:=StrToInt(EdKolIteration.Text);
SBS:=TQueueEvent.Create;
NameGraphFile:='Test';
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Загрузка решения');
NomSolution:=Length(ArraySolution);
SetLength(ArraySolution,NomSolution+1);
ArraySolution[NomSolution]:=TSolutionType.Create;
If OdLoad.Execute then
  begin
  LoadOneSolutionAsTextFile(OdLoad.FileName,NomSolution);
  ShowMessage('Решение загружено из файла '+SdSave.FileName);
  end;
//ArraySolution[NomSolution]                                                         !!!!!!!!!!!!!!!!!!!!!!!

//ClearAllTransportGraph;

For NomProgon:=1 to Koliteration do
  begin
  GoIteration(NomProgon,NomSolution,ModelTime);
  end;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение статистики');
GoEndStatAllNode(Koliteration);
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сбор статистики по аэропортам');
AddAllStatGraphToNode;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Подсчет критериев решения ');
ArraySolution[NomSolution].GoKoef(0,ModelTime);
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Kg='+FloatToStr(ArraySolution[NomSolution].MKoefGot)+' Cost='+FloatToStr(ArraySolution[NomSolution].MCost));
//MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+' Disp Kg='+FloatToStr(ArraySolution[NomSolution].DKoefGot)+' Cost='+FloatToStr(ArraySolution[NomSolution].DKost));
    SgSolution.Cells[0,NomSolution+1]:=IntToStr(NomSolution);
    SgSolution.Cells[1,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].TimeToModel2);
    SgSolution.Cells[2,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].TimeEnd);
    SgSolution.Cells[3,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].MKoefGot);
    SgSolution.Cells[4,NomSolution+1]:=FloatToStr(ArraySolution[NomSolution].MCost);
    SgSolution.Cells[5,NomSolution+1]:='1';
    EdKolSolution.Text:=IntToStr(NomSolution+1);

GoParettoSet;
If BoolSaveSolutionOnFile then
begin
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сохранение в файл');
If SdSave.Execute then
  begin
  SaveOneSolutionAsTextFile(SdSave.FileName,NomSolution);
  ShowMessage('Решение сохранено в файл '+SdSave.FileName);
  end;
end;  
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  КОНЕЦ');
end;
end;

procedure TFModel.BtGoIterationClick(Sender: TObject);
begin
BoolSaveSolutionOnFile:=True;
GoModel;
end;

procedure TFModel.CbCheckElementProcessClick(Sender: TObject);
begin
Label23.Visible:=CbCheckElementProcess.Checked;
EdElementName.Visible:=CbCheckElementProcess.Checked;
end;

procedure TFModel.BtSaveSolutionClick(Sender: TObject);
begin
If SdSave.Execute then
  begin
  SaveOneSolutionAsTextFile(SdSave.FileName,NomVivodSolution);
  ShowMessage('Решение сохранено в файл '+SdSave.FileName);
  end;
//ArraySolution[ARow-1]
end;

procedure TFModel.SeNomHistChange(Sender: TObject);
begin
    DrawProc;
end;

procedure TFModel.RgTypeEndDSSClick(Sender: TObject);
begin
Label14.Visible:=RgTypeEndDSS.ItemIndex=1;
Label18.Visible:=RgTypeEndDSS.ItemIndex=1;
Label25.Visible:=RgTypeEndDSS.ItemIndex=1;
Label24.Visible:=RgTypeEndDSS.ItemIndex=1;
EdMinKG.Visible:=RgTypeEndDSS.ItemIndex=1;
EdMinKG.Enabled:=RgTypeEndDSS.ItemIndex=1;
EdMaxKG.Visible:=RgTypeEndDSS.ItemIndex=1;
EdMaxKG.Enabled:=RgTypeEndDSS.ItemIndex=1;
EdMOKG.Visible:=RgTypeEndDSS.ItemIndex=1;
EdMOKG.Enabled:=RgTypeEndDSS.ItemIndex=1;
Label15.Visible:=RgTypeEndDSS.ItemIndex=1;
EdMaksCost.Visible:=RgTypeEndDSS.ItemIndex=1;
EdMaksCost.Enabled:=RgTypeEndDSS.ItemIndex=1;

Label19.Visible:=RgTypeEndDSS.ItemIndex=0;
EdKolAntProgon.Visible:=RgTypeEndDSS.ItemIndex=0;
EdKolAntProgon.Enabled:=RgTypeEndDSS.ItemIndex=0;
end;

procedure TFModel.SbSaveAllSolutionClick(Sender: TObject);
begin
SaveArraySolutionAsTextFile;
end;

procedure TFModel.SbLoadSolutionClick(Sender: TObject);
var
   NomSolution:LongWord;
begin
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Загрузка решения');
NomSolution:=Length(ArraySolution);
SetLength(ArraySolution,NomSolution+1);
ArraySolution[NomSolution]:=TSolutionType.Create;
If OdLoad.Execute then
  begin
  LoadOneSolutionAsTextFile(OdLoad.FileName,NomSolution);
  ShowMessage('Решение загружено из файла '+SdSave.FileName);
  end;
end;

procedure TFModel.SbLoadAllSolutionClick(Sender: TObject);
begin
LoadArraySolutionAsTextFile;
end;



procedure TFModel.SbGoAnalizeClick(Sender: TObject);
var
  KolIterationAnalys,KolEndIterationAnalys:LongWord;
  BEnd:Boolean;
  NomSolutionAnalys:LongWord;
  MKolIteration,MCostSolution,MKGSolution,MMinKGSolution,MMAxKGSolution:Double;
  Col,Row:LongWord;
begin
MsExcel := CreateOleObject('Excel.Application');                                  //Открытие файла Excel для записи результатов
MsExcel.Workbooks.Open['E:\КАФЕДРА\ДИССЕРТАЦИЯ\ПРОГРАММА МОДЕЛЬ №2\Анализ.xls'];
Row:=3;
MTimeProgonMMK:=0;                                //Обнуление времени прогона ММК

BoolSaveSolutionOnFile:=True;                     //Сохранение Решения в файл

MeProtocolAnalys.Visible:=true;                   //Визуализация протокола прогонов аналитического модуля
MeProtocolAnalys.Enabled:=true;

case RgAnalizVariable.ItemIndex of                //Установка начальных значений
 0: EdKolAgent.Text:=EdNatVar.Text;
 1: EdKoefAntElit.Text:=EdNatVar.Text;
 2: EdKoefPher.Text:=EdNatVar.Text;
 3: EdNatKolPheromon1.Text:=EdNatVar.Text;
 4: EdPheromon1.Text:=EdNatVar.Text;
 5: EdIsparNodePheromon1.Text:=EdNatVar.Text;
 6: EdNatKolPheromon2.Text:=EdNatVar.Text;
 7: EdPheromon2.Text:=EdNatVar.Text;
 8: EdIsparNodePheromon2.Text:=EdNatVar.Text;
 end;

if FModel.RgTypeEndDSS.ItemIndex=1 then       //Занесение значений пределов для СППР
  begin
  LimitKG:=StrToFloat(EdMOKG.Text);
  LimitMinKG:=StrToFloat(EdMinKG.Text);
  LimitMaxKG:=StrToFloat(EdMaxKG.Text);
  LimitMCost:=StrToFloat(EdMaksCost.Text);
  end;
AlfKoeffSumm:=StrToFloat(EdParSumm.Text);    //Занесение значения взвешенной суммы для ММК СППР
if RgTypeEndDSS.ItemIndex=0 then             //Установка ограничения на стоимость для ММК
  LimitCostProduction:=10000000000000000
else
  LimitCostProduction:=LimitMCost;

BEnd:=False;
KolEndIterationAnalys:=StrToInt(EdKolProgonSPPR.Text);    //Загрука количества прогонов для подсчета характеристик аналитической программы
While not BEnd do
  begin
  MKolIteration:=0; MCostSolution:=0; MKGSolution:=0; MMinKGSolution:=0; MMAxKGSolution:=0;
  For KolIterationAnalys:=1 to KolEndIterationAnalys do                                      //Запуск необходимого количества итераций анализа
    begin
    MeProtocolAnalys.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  НОМЕР ПРОГОНА - '+inttostr(KolIterationAnalys));
    If Length(ArraySolution)<>0 then                                                         //Обнуление "принятия" решений
      for NomSolutionAnalys:=0 to Length(ArraySolution)-1 do
        ArraySolution[NomSolutionAnalys].KolAgent:=0;

    StartDSS;                                                                                //ЗАПУСК СППР

    MKolIteration:=MKolIteration+KolDSSIterations;
    IF EndSolutions<>nil then                                                                //Сохранение статистики
      begin
      MCostSolution:=MCostSolution+EndSolutions.MCost;
      MKGSolution:=MKGSolution+EndSolutions.MKoefGot;
      MMinKGSolution:=MMinKGSolution+EndSolutions.MMinKoefGot;
      MMAxKGSolution:=MMAxKGSolution+EndSolutions.MMaxKoefGot;
      if RgTypeEndDSS.ItemIndex=0 then             //Изменение ограничения на стоимость для ММК
        LimitCostProduction:=10000000000000000
      else
        LimitCostProduction:=LimitMCost-EndSolutions.MCostPersonal-EndSolutions.MCostRecover;
      end;
    end;

  MKolIteration:=MKolIteration/KolEndIterationAnalys;
  MCostSolution:=MCostSolution/KolEndIterationAnalys;
  MKGSolution:=MKGSolution/KolEndIterationAnalys;
  MMinKGSolution:=MMinKGSolution/KolEndIterationAnalys;
  MMAxKGSolution:=MMAxKGSolution/KolEndIterationAnalys;

  //Вывод в EXCEL
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,1]:=EdKolIteration.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,2]:=EdKolProgonSPPR.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,3]:=EdKolAgent.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,4]:=RgTypeAntGo.ItemIndex;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,5]:=EdKoefAntElit.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,6]:=EdNatKolPheromon1.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,7]:=EdPheromon1.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,8]:=EdIsparNodePheromon1.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,9]:=EdNatKolPheromon2.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,10]:=EdPheromon2.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,11]:=EdIsparNodePheromon2.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,12]:=EdKoefPher.Text;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,13]:=RgKrit.ItemIndex;
//  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,14]:=RgObKoef.ItemIndex;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,15]:=RgTypeEndDSS.ItemIndex;

  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,17]:=MKolIteration;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,18]:=MCostSolution;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,19]:=MMinKGSolution;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,20]:=MKGSolution;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,21]:=MMAxKGSolution;
//  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,22]:=MTimeProgonMMK;

  Inc(Row);

  //Увеличение исследуемого параметра
  case RgAnalizVariable.ItemIndex of
    0: EdKolAgent.Text:=IntToStr(StrToInt(EdKolAgent.Text)+StrToInt(EdShag.Text));
    1: EdKoefAntElit.Text:=IntToStr(StrToInt(EdKoefAntElit.Text)+StrToInt(EdShag.Text));
    2: EdKoefPher.Text:=FloatToStr(StrToFloat(EdKoefPher.Text)+StrToFloat(EdShag.Text));
    3: EdNatKolPheromon1.Text:=FloatToStr(StrToFloat(EdNatKolPheromon1.Text)+StrToFloat(EdShag.Text));
    4: EdPheromon1.Text:=FloatToStr(StrToFloat(EdPheromon1.Text)+StrToFloat(EdShag.Text));
    5: EdIsparNodePheromon1.Text:=FloatToStr(StrToFloat(EdIsparNodePheromon1.Text)+StrToFloat(EdShag.Text));
    6: EdNatKolPheromon2.Text:=FloatToStr(StrToFloat(EdNatKolPheromon2.Text)+StrToFloat(EdShag.Text));
    7: EdPheromon2.Text:=FloatToStr(StrToFloat(EdPheromon2.Text)+StrToFloat(EdShag.Text));
    8: EdIsparNodePheromon2.Text:=FloatToStr(StrToFloat(EdIsparNodePheromon2.Text)+StrToFloat(EdShag.Text));
    end;

  //Проверка критерия остановки
  case RgAnalizVariable.ItemIndex of
    0: BEnd:=StrToFloat(EdKolAgent.Text)>StrToFloat(EdKonVar.Text);
    1: BEnd:=StrToFloat(EdKoefAntElit.Text)>StrToFloat(EdKonVar.Text);
    2: BEnd:=StrToFloat(EdKoefPher.Text)>StrToFloat(EdKonVar.Text);
    3: BEnd:=StrToFloat(EdNatKolPheromon1.Text)>StrToFloat(EdKonVar.Text);
    4: BEnd:=StrToFloat(EdPheromon1.Text)>StrToFloat(EdKonVar.Text);
    5: BEnd:=StrToFloat(EdIsparNodePheromon1.Text)>StrToFloat(EdKonVar.Text);
    6: BEnd:=StrToFloat(EdNatKolPheromon2.Text)>StrToFloat(EdKonVar.Text);
    7: BEnd:=StrToFloat(EdPheromon2.Text)>StrToFloat(EdKonVar.Text);
    8: BEnd:=StrToFloat(EdIsparNodePheromon2.Text)>StrToFloat(EdKonVar.Text);
    end;
  end;
MsExcel.ActiveWorkbook.Close;          //Закрытие файла Excel
MsExcel.Application.Quit;
end;

procedure TFModel.SbLoadAntGraphClick(Sender: TObject);
begin
LoadAntGraphFromTextFile('AntGraph.txt');
AddAllAntArc;
CreateAntNode;
ShowMessage('Граф решений загружен из файла '+'AntGraph.txt');
SetLength(ArraySolution,1);
ArraySolution[0]:=TSolutionType.Create;
end;

procedure TFModel.RgKritClick(Sender: TObject);
begin
Label33.Visible:=RgKrit.ItemIndex=3;
EdParSumm.Visible:=RgKrit.ItemIndex=3;
end;

end.
