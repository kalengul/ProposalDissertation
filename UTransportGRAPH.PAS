unit UTransportGRAPH;

interface

Uses USklad,
     SysUtils, //FreeAndNill
     Graphics,
     UReliabilityGraph,
     UReliability,
     ComObj;

type
  TTransportNode = class;
  TNS = class;
  TElementNS = class;
  TGraphStructure = class;
  TListAction = class;

  ArrayProcessOne = array of Double;

TTransportArc = class
  Node:TTransportNode;
  NexTTransportArc:TTransportArc;
  TypeArc:Byte;
  LengthArc:Double;
  constructor Create;
  end;

TProduction = class
              NameProduction:string;
              CostProduction:Double;
              TimeProduction:Double;
              KolProductIneration:LongWord;
              HistFailure:THistArr;
              constructor Create;
              end;

TStatProduction = record
              Name:string;
              HistFailure,HistRecov,HistItog:THistArr;
              MFailure,MRecover:Double;
              Save:Boolean;
              end;

TProductionQuere = record
  NameProduction:string;
  CostProduction:Double;
  TimeProduction:Double;
  Node:TTransportNode;
  TimeEnd:Double;
  GoProcess:Boolean;
  end;

TQueryProduction = class
  ArrayProduction:array of TProductionQuere;
  constructor Create;
  procedure AddProduction(NewProduction:TProduction; Node:TTransportNode; TimeStart:Double);
  Procedure DelProduction(NameProduction:string);
  end;

TManufact = class
  Name:string;
  LoadProduction:Boolean;
  MaxPower,Power:Double;
  CostProgon:Double;
  ManufactQuery:TQueryProduction;
  SetProduction:array of TProduction;
  TimeProcess:ArrayProcessOne;
  ProductionProcessName:string;
  function SearchManufact(NameProduction:string):Word;
  function SearchManufactP(NameProduction:string):TProduction;
  procedure LoadManufactFile(NameFile:string);
  Function GiveFirstProductionOnPower(Time:Double; var Node:TTransportNode; var NameProduct:String; var TimeProduction,CostProduction:Double):boolean;
  procedure GoProductionManufact(NodeCreate:TTransportNode; Time:Double);
  Procedure ClearManufact;
  constructor Create;
  end;

TTransportNode = class
  Name:string;
  Sklad:TSklad;
  Ns:array of TGraphStructure;
  StatProduction:array of TStatProduction;
  Manufact:TManufact;
  ARZ:TManufact;
  TypeNode:Byte;
  NexTTransportNode:TTransportNode;
  Arc:TTransportArc;
  NodeFinish:Byte;
  Par:Double;
  x,y:LongWord;
  constructor Create;
  procedure SborStat;
  procedure AddProduction(Production:TProduction);
  procedure AddProductionNameAndHist(NameProduction:string; Hist:THistArr);
  procedure qSort(l,r:LongInt);
  procedure SortProduction;
  function SearchStatProductionMax:LongWord;
  function SearchProductionName(Name:String):LongWord;
  function SearchDihotomiProductionName(Name:String):LongWord;
  function SearchElementMax:TElementNs;
  function AddArc(TypeArc:Byte; LengthArc:Double):TTransportArc;
  end;

TElementNS = class
  Name:String;
  LastTime:Double;
  TimeFailure:double;
  TimeEndFailure:Double;
  Failure:Byte;
  Zakon:Byte;
  Parametr1,Parametr2:Double;
  MFailure: array [0..1] of double;
  HistFailure: array [0..20] of Double;
  NextElement:TElementNS;
  NS:TNS;
  EnabledProduction:Boolean;
  SizeProduction:Double;
  constructor Create;
  destructor Destroy;   override;
  function GoTimeFailure (ThisTime:Double):Double;
  procedure GoFailure (Time:Double; var EndModel:Boolean);
  end;

TNS = class
      Name:string;
      FirstElement:TElementNS;
      Node:TTransportNode;
      Failure:Byte;
      LastTime:Double;
      TimeFailure:double;
      TimeWaiting:double;
      function SearchElementName(Name:String):TElementNs;
      procedure ClearSost;
      function AddElementNS (Name:string; Zakon:Byte; Par1,PAr2:Double):TElementNs;
      function RecoverElement (Name:string; Time:Double; ElementEndModel:Boolean; var EndModel:Boolean):Boolean;
      procedure GoAllFailure;
      procedure LoadElementFile(NameFile:string);
      constructor Create;
      destructor Destroy;  override;
      end;


TSaveFailure = record
               Name:string[20];
               KolFailure:array [0..1] of Double;
               ArrayHistKolFailure: array [0..20] of Double;
               end;


TArrayStatProtocol = array of TStatProtocol;

TGraphStructure = class
  Name:String;
  Nomber:string;
  TransportNode:TTransportNode;
  GraphLevel0:TGraph;
  MainNode:TStructureNode;
  StatistiksNode:Array of TStatistics;
  StatProtocol:TArrayStatProtocol;
  ListAction:TListAction;
  LoadProduction:Boolean;
  GoPeopleService:Boolean;
  Constructor Create;
  Destructor Destroy;    override;
  Procedure LoadGraphFile (NameFile:String);
  procedure LoadSostGraphFile(NameFile:string);
  Procedure SaveGraphFile (NameFile:String);
  Procedure ClearSostStructure;
  Procedure ClearStatistics;
  procedure GoStructureEvent;
  function RecoverElement (Name:string; Time:Double):Boolean;
  Procedure GoAllEvent;
  Procedure GoGraphAllEventFailure(CurrentGraph:TGraph);

  Procedure AllNodeChangeKoef(CurrentGraph:TGraph);
  Function SearchStatistikNode(Node:TStructureNode):TStatistics;

  Function AddStatisticsNode(Node:TStructureNode):TStatistics;
  Procedure SaveStat;
  Function AddNewProtocol(TypeP:byte; NodeP:TStructureNode):TStatProtocol;
  Function SearchStatistikProtocol(Node:TStructureNode):TStatProtocol;
  Procedure SaveStatExcel;
  Procedure SaveStatFailureTextFile(NameFile:string);
  procedure SaveStatRecoveryTextFile(NameFile:string);
  procedure SaveHistFailureTextFile(NameFile:string);
  Procedure SaveFailureFile;
  procedure NewProgonStat;
  end;

TAction = class
   Name:String;
   Node:TStructureNode;
   Time:Double;
   TypeAction:Byte; //0-включение 1-хранение и выключение 3-демонтаж 4-монтаж 5-настройка
   KoefAction:Double; //Коэффициент влияния(1-норма)
   ListAction:TListAction;
   NextAction:TAction;
   Constructor Create;
   Destructor Destroy;  override;
   Procedure Go;
   end;

TListAction = class
   FirstArrayAction,
   CurrentArrayAction:TAction;
//   NomAction:LongWord;
   Structure:TGraphStructure;
   Constructor Create;
   Destructor Destroy; override;
   Procedure AddAction(var NewAction:TAction);
   Procedure LoadAction(Structure:TGraphStructure; NameFile:String);
   Procedure AddSbsAction;
//   procedure qSort(l,r:LongInt);
   Procedure SortAction;
   end;  


function AddNode (Name:string; TypeNode:Byte):TTransportNode;
function SearchMinTime(NodeNat,NodeKon:TTransportNode):Double;
function SearchNodeName(Name:String):TTransportNode;
function SearchNodeXY(x,y:Double):TTransportNode;
function SearchCreateNode(Element:string):TTransportNode;
function SearchSkladTOElement(NodeNS:TTransportNode):TTransportNode;
function SearchFailureElementGraph(Node:TTransportNode; ElementName:String; var MinTime:Double):TTransportNode;
function GoSearchFailure(TimeSearch:Double; Node:TTransportNode; ElementName:string; ElementEndModel:Boolean):Boolean;
function GoSearchRecover(TimeSearch:Double; Node:TTransportNode; ElementName:string):Boolean;
function SearchNodeMaxNS:TTransportNode;
function SearchSkladMinLength(NodeNat:TTransportNode; VolumeElement:Double):TTransportNode;
Procedure PaintNode(Canvas:TCanvas);
procedure SaveTransportGraphFile(NameFile:String);
procedure LoadGraph(NameFile:string);
procedure InitializationTransportGraph;
procedure FinalizationTransportGraph;
procedure AddAllProductionGraph(ProductionNode:TTransportNode);
procedure AddAllStatGraphToNode;
Procedure GoEndStatAllNode(KolProgon:LongWord);
procedure PlusHist(HistA,HistB:THistArr; var ResultHist:THistArr);
procedure MinusHist(HistA,HistB:THistArr; var ResultHist:THistArr);
Procedure CopyHist(HistA:THistArr; var ResultHist:THistArr);
Procedure VivodHist(Canvas:TCanvas; Heigth,Weigth:Word; HistA,HistB,HistC:THistArr);
procedure GoAllEventManufacture;
procedure GoToARZ(Node:TStructureNode; Structure:TGraphStructure; Time:Double);
procedure SaveAllTransportGraphTextFile;
procedure DelAlltransportGraphStructure;

var
  FirsTTransportNode:TTransportNode;
  CostTransport:Double;
  TimeProcessTransport:ArrayProcessOne;
  NameElementProcessTransport:string;
  TimeTransportProgon,TimeStorageProgon:Double;
  TimeTransport,TimeStorage:array [0..1] of double;

  CostService:Double;
  PeopleService,MaxPeopleService:Double;

  GoTransfer:Byte;
  Mx,My,Dx,Dy:Double;
  MsExcel: Variant;
  MaxLevel:Word;
  MaxTime:double;
  KolStructure:Word;

const
  deltpaint=15;

implementation

uses UEventSBS,USBS,UVolna,UMain,UMainStructure;

Procedure PaintNode(Canvas:TCanvas);
var
  CNode:TTransportNode;
  CArc:TTransportArc;
  xn,yn:LongWord;
  CNS:TGraphStructure;
  i:LongWord;
begin

CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  xn:=Trunc(CNode.x*dx+mx);
  yn:=Trunc(CNode.y*dy+my);
  Canvas.TextOut(xn-deltpaint,yn-deltpaint-15,CNode.Name);
  Canvas.Rectangle(xn+deltpaint,yn+deltpaint,xn-deltpaint,yn-deltpaint);
  If CNode.Sklad<>nil then
    begin
    Canvas.Rectangle(xn+deltpaint-2,yn+deltpaint-2,xn-deltpaint+2,yn-deltpaint+2);
    Canvas.Rectangle(xn-deltpaint,yn+deltpaint,xn-deltpaint-4,yn+deltpaint-2*Trunc(deltpaint*CNode.Sklad.VolumeSklad/CNode.Sklad.MaxVolumeSklad));
    end;

  If Length(CNode.Ns)<>0 then
    begin
    Canvas.MoveTo(xn+deltpaint div 3,Yn);
    Canvas.LineTo(xn-deltpaint div 3-1,Yn);
    Canvas.MoveTo(xn,Yn+deltpaint div 3);
    Canvas.LineTo(xn,Yn-deltpaint div 3);
    Canvas.MoveTo(xn-deltpaint div 3-1,Yn+deltpaint div 5);
    Canvas.LineTo(xn-deltpaint div 3-1,Yn-deltpaint div 5);
    For i:=0 to Length(CNode.Ns)-1 do
      begin
      Canvas.MoveTo(xn-deltpaint+2,yn+deltpaint+i*15);
      Canvas.LineTo(xn-deltpaint+2,yn+deltpaint+(i+1)*15);
      Canvas.LineTo(xn,yn+deltpaint+(i+1)*15);
      IF CNode.Ns[i].MainNode=nil then
        Canvas.Font.Color:=clBlue
      else
      IF CNode.Ns[i].MainNode.BoolFailure=2 then
        Canvas.Font.Color:=clRed
      else
        Canvas.Font.Color:=clGreen;
      Canvas.TextOut(xn-deltpaint+6,yn+deltpaint+i*15+2,CNode.NS[i].Name+' - '+CNode.NS[i].Nomber);
      Canvas.Font.Color:=clGray;
      end;
    end;
  CArc:=CNode.Arc;
  While CArc<>nil do
    begin
    Canvas.MoveTo(xn,yn);
    Canvas.LineTo(Trunc(CArc.Node.x*dx+mx),Trunc(CArc.Node.y*dy+my));
    CArc:=CArc.NexTTransportArc;
    end;
  CNode:=CNode.NexTTransportNode;
  end;

end;

Procedure VivodHist(Canvas:TCanvas; Heigth,Weigth:Word; HistA,HistB,HistC:THistArr);
var
  NomHist:LongWord;
  MaxHist,MaxZnat:Double;
  ShagX,ShagY:Double;
  ArrVivodZnat:array [1..3] of Double;
  ArrVivodNom:array [1..3] of Byte;
  i:Byte;
  VivodColor:TColor;
begin
Canvas.Pen.Color:=clBtnFace;
Canvas.Brush.Color:=clBtnFace;
Canvas.Rectangle(0,0,Weigth,Heigth);
Canvas.FloodFill(0,0,clBtnFace,fsBorder);
Canvas.Pen.Color:=clBlack;
If HistA<>nil then
  MaxHist:=Length(HistA)
else
  MAxHist:=0;
If (HistB<>nil) and (Length(HistB)>MaxHist) then
  MaxHist:=Length(HistB);
If (HistC<>nil) and (Length(HistC)>MaxHist) then
  MaxHist:=Length(HistC);

MaxZnat:=0;
If (HistA<>nil) and (Length(HistA)<>0) then
  For NomHist:=0 to Length(HistA)-1 do
    If  HistA[NomHist]>MaxZnat then
      MaxZnat:=HistA[NomHist];

If (HistB<>nil) and (Length(HistB)<>0) then
  For NomHist:=0 to Length(HistB)-1 do
    If  HistB[NomHist]>MaxZnat then
      MaxZnat:=HistB[NomHist];

If (HistC<>nil) and (Length(HistC)<>0) then
  For NomHist:=0 to Length(HistC)-1 do
    If  HistC[NomHist]>MaxZnat then
      MaxZnat:=HistC[NomHist];

Canvas.MoveTo(10,Heigth-20);
Canvas.LineTo(Weigth-10,Heigth-20);
Canvas.MoveTo(20,Heigth-10);
Canvas.LineTo(20,10);

ShagY:=(Heigth-40)/MaxZnat;
ShagX:=(Weigth-40)/MaxHist;



for NomHist:=0 to Trunc(MaxHist)-1 do
  begin
  ArrVivodZnat[1]:=0; ArrVivodZnat[2]:=0; ArrVivodZnat[3]:=0;
  If (HistA<>nil) and (Length(HistA)>NomHist) and (HistA[NomHist]>ArrVivodZnat[1]) then
    begin
    ArrVivodZnat[1]:=HistA[NomHist];
    ArrVivodNom[1]:=1;
    end;
  If (HistB<>nil) and (Length(HistB)>NomHist) then
    If (HistB[NomHist]>ArrVivodZnat[1]) then
      begin
      ArrVivodZnat[2]:=ArrVivodZnat[1];
      ArrVivodNom[2]:=ArrVivodNom[1];
      ArrVivodZnat[1]:=HistB[NomHist];
      ArrVivodNom[1]:=2;
      end
    else
      begin
      ArrVivodZnat[2]:=HistB[NomHist];
      ArrVivodNom[2]:=2;
      end;
  If (HistC<>nil) and (Length(HistC)>NomHist) then
    If (HistC[NomHist]>ArrVivodZnat[1]) then
      begin
      ArrVivodZnat[3]:=ArrVivodZnat[2];
      ArrVivodNom[3]:=ArrVivodNom[2];
      ArrVivodZnat[2]:=ArrVivodZnat[1];
      ArrVivodNom[2]:=ArrVivodNom[1];
      ArrVivodZnat[1]:=HistC[NomHist];
      ArrVivodNom[1]:=3;
      end
    else
    If (HistC[NomHist]>ArrVivodZnat[2]) then
      begin
      ArrVivodZnat[3]:=ArrVivodZnat[2];
      ArrVivodNom[3]:=ArrVivodNom[2];
      ArrVivodZnat[2]:=HistC[NomHist];
      ArrVivodNom[2]:=3;
      end
    else
      begin
      ArrVivodZnat[3]:=HistC[NomHist];
      ArrVivodNom[3]:=3;
      end;

  for i:=1 to 3 do
    begin
    case ArrVivodNom[i] of
      1:VivodColor:=clRed;
      2:VivodColor:=clGreen;
      3:VivodColor:=clBlue;
      end;
    Canvas.Brush.Color:=VivodColor;    
    Canvas.Rectangle(20+Trunc(NomHist*ShagX),Heigth-20,20+Trunc((NomHist+1)*ShagX)-Trunc((i-1)*ShagX/10),Heigth-20-Trunc(ArrVivodZnat[i]*ShagY));
    IF ArrVivodZnat[i]>0.01 then
      Canvas.FloodFill(20+Trunc(NomHist*ShagX)+1,Heigth-20-1,clBlack,fsBorder);
    Canvas.Brush.Color:=clBtnFace;
    end;
  end;

For i:=0 to Trunc(MaxHist)-1 do
  begin
  Canvas.MoveTo(20+Trunc(i*ShagX+ShagX/2),Heigth-10);
  Canvas.LineTo(20+Trunc(i*ShagX+ShagX/2),Heigth-30);
  Canvas.TextOut(20+Trunc(i*ShagX+ShagX/2),Heigth-13,IntToStr(i));
  end;

For i:=0 to Trunc(MaxZnat*10) do
  begin
  Canvas.MoveTo(10,Heigth-20-Trunc(ShagY*i/10));
  Canvas.LineTo(30,Heigth-20-Trunc(ShagY*i/10));
  Canvas.TextOut(2,Heigth-20-Trunc(ShagY*i/10),FloatToStr(i/10));
  end;  
end;

constructor TTransportNode.Create;
  begin
    inherited;
    Name:='';
    TypeNode:=0;
    NexTTransportNode:=nil;
    Arc:=nil;
    Ns:=nil;
    Sklad:=nil;
    NodeFinish:=0;
    Manufact:=Nil;
    SetLength(StatProduction,0);
  end;

constructor TTransportArc.Create;
  begin
    inherited;
    NexTTransportArc:=nil;
    Node:=nil;
    TypeArc:=0;
    LengthArc:=0;
  end;

constructor TQueryProduction.Create;
  begin
  ArrayProduction:=nil;
  end;

constructor TManufact.Create;
  begin
    inherited;
  Name:='';
  CostProgon:=0;
  Power:=0;
  MaxPower:=0;
  LoadProduction:=false;
  ManufactQuery:=TQueryProduction.Create;
  SetLength(SetProduction,0);
  SetLength(TimeProcess,0);
  ProductionProcessName:='';
  end;

constructor TProduction.Create;
  begin
  
  end;

function TTransportNode.AddArc(TypeArc:Byte; LengthArc:Double):TTransportArc;
  var
    NewArc:TTransportArc;
    CurrenTTransportArc:TTransportArc;
  begin
    NewArc:=TTransportArc.Create;
    NewArc.TypeArc:=TypeArc;
    NewArc.LengthArc:=LengthArc;
  If Arc=nil then
    Arc:=NewArc
  else
    begin
    CurrenTTransportArc:=Arc;
    While CurrenTTransportArc.NexTTransportArc<>nil do
      CurrenTTransportArc:=CurrenTTransportArc.NexTTransportArc;
    CurrenTTransportArc.NexTTransportArc:=NewArc;
    end;
  Result:=NewArc;
  end;

function AddNode (Name:string; TypeNode:Byte):TTransportNode;
  var
    NewNode:TTransportNode;
    CurrenTTransportNode:TTransportNode;
  begin
  NewNode:=TTransportNode.Create;
  NewNode.Name:=Name;
  NewNode.TypeNode:=TypeNode;
  If FirsTTransportNode=nil then
    FirsTTransportNode:=NewNode
  else
    begin
    CurrenTTransportNode:=FirsTTransportNode;
    While CurrenTTransportNode.NexTTransportNode<>nil do
      CurrenTTransportNode:=CurrenTTransportNode.NexTTransportNode;
    CurrenTTransportNode.NexTTransportNode:=NewNode;
    end;
  Result:=NewNode;
  end;

function SearchNodeName(Name:String):TTransportNode;
  var
    CurrenTTransportNode:TTransportNode;
  begin
  CurrenTTransportNode:=FirsTTransportNode;
  While (CurrenTTransportNode<>nil) and (CurrenTTransportNode.Name<>Name) do
    CurrenTTransportNode:=CurrenTTransportNode.NexTTransportNode;
  Result:=CurrenTTransportNode;
  end;

function SearchCreateNode(Element:string):TTransportNode;
  var
    CurrenTTransportNode:TTransportNode;
  begin
  CurrenTTransportNode:=FirsTTransportNode;
  While (CurrenTTransportNode<>nil) and ((CurrenTTransportNode.Manufact=nil) or ((CurrenTTransportNode.Manufact<>nil) and (CurrenTTransportNode.Manufact.SearchManufact(Element)=65535)))do
    CurrenTTransportNode:=CurrenTTransportNode.NexTTransportNode;
  Result:=CurrenTTransportNode;
  end;

function SearchNodeXY(x,y:Double):TTransportNode;
  var
    CurrenTTransportNode:TTransportNode;
  begin
  CurrenTTransportNode:=FirsTTransportNode;
  While (CurrenTTransportNode<>nil) and not ((CurrenTTransportNode.x+deltpaint>x) and (CurrenTTransportNode.x-deltpaint<x) and (CurrenTTransportNode.y-deltpaint<y) and (CurrenTTransportNode.y+deltpaint>y)) do
    CurrenTTransportNode:=CurrenTTransportNode.NexTTransportNode;
  Result:=CurrenTTransportNode;
  end;


function TTransportNode.SearchElementMax:TElementNs;
var
  CElement:TElementNS;
  NomNS:LongWord;
  MaxElement:TElementNS;
  Max:Double;
begin
MaX:=0;
MaxElement:=nil;
IF Length(Ns)<>0 then
For NomNS:=0 to Length(Ns) do
  begin
//  CElement:=NS[NomNS].FirstElement;
  While CElement<>nil do
    begin
    If (not CElement.EnabledProduction) and (CElement.MFailure[0]>Max) then
      begin
      Max:=CElement.MFailure[0];
      MaxElement:=CElement;
      end;
    CElement:=CElement.NextElement;
    end;
  end;
Result:=MaxElement;
end;

function GoSearchRecover(TimeSearch:Double; Node:TTransportNode; ElementName:string):Boolean;
  var
    Time:Double;
    SearchNode,CurrentNode:TTransportNode;
    ElementSklad,MinElementSklad:TElementSklad;
    NewEvent:TEventAddElement;
    MinTime:Double;
    n:LongWord;
  begin
  CurrentNode:=FirsTTransportNode;
  SearchNode:=nil;
  MinTime:=1000000000000000;
  while CurrentNode<>nil do
    begin
    if CurrentNode<>Node then
      begin
      Time:=MinTimeGraphVolna(Node,CurrentNode);
      If (SearchNode=nil) or (Time<MinTime) then
        begin
        IF CurrentNode.Sklad<>nil then
          ElementSklad:=CurrentNode.Sklad.SearchElement(ElementName);
        IF (ElementSklad<>nil) and (ElementSklad.kolvo<>0) then
          begin
          MinTime:=Time;
          SearchNode:=CurrentNode;
          MinElementSklad:=ElementSklad;
          end;
        end;
      end;
    CurrentNode:=CurrentNode.NexTTransportNode;
    end;

  if SearchNode<>nil then
    begin
    MinElementSklad.DecreaseElement(TimeSearch);
    if (SearchNode.Sklad.NameElementProcess=ElementName) and (Length(SearchNode.Sklad.AllTimeProcess)<>0) then
      begin
      n:=Length(SearchNode.Sklad.AllTimeProcess)-1;
      While (n>1) and (SearchNode.Sklad.AllTimeProcess[n-1].TimeRecover=0) do
        Dec(n);
      SearchNode.Sklad.AllTimeProcess[n].TimeRecover:=TimeSearch;
      end;
    MinElementSklad.TimeWaiting:=MinElementSklad.TimeWaiting+MinTime;  //Добавление времени транспортировки
    NewEvent:=TEventAddElement.Create;
    NewEvent.Name:=ElementName;
    NewEvent.Node:=Node;
    NewEvent.EventTime:=TimeSearch+MinTime;
    if ElementName=NameElementProcessTransport then
      begin
      n:=Length(TimeProcessTransport);
      SetLength(TimeProcessTransport,n+1);
      TimeProcessTransport[n]:=MinTime;
      end;
    TimeTransportProgon:=TimeTransportProgon+MinTime;
    SBS.AddEvent(NewEvent);
    if VivodProcessing then
      Writeln(f,FloatToStr(TimeSearch)+'   '+Node.Name+'   ВОССТАНОВЛЕНИЕ Эл-та '+ElementName+'  ВОССТАНОВЛЕН Эл-т ЧАСТИ '+SearchNode.Name+'     Время ожидания элемента '+FloatToStr(Time));
    If GoProtocolEvent then
      FModel.MeProt.Lines.Add(FloatToStr(TimeSearch)+'   '+Node.Name+'   ВОССТАНОВЛЕНИЕ Эл-та '+ElementName+'  ВОССТАНОВЛЕН Эл-т ЧАСТИ '+SearchNode.Name+'     Время ожидания элемента '+FloatToStr(Time));


    Result:=True;
    end
  else
    Result:=False;
  end;

Procedure GoEndStatAllNode(KolProgon:LongWord);
var
  CNode:TTransportNode;
  i,j,k,s,n:LongWord;
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  If Length(CNode.Ns)<>0 then
  For i:=0 to Length(CNode.Ns)-1 do
    If Length(CNode.Ns[i].StatistiksNode)<>0 then
    for j:=0 to Length(CNode.Ns[i].StatistiksNode)-1 do
      begin
      If Length(CNode.Ns[i].StatistiksNode[j].ArrayHistKolFailure)<>0 then
      For k:=0 to Length(CNode.Ns[i].StatistiksNode[j].ArrayHistKolFailure)-1 do
        CNode.Ns[i].StatistiksNode[j].ArrayHistKolFailure[k]:=CNode.Ns[i].StatistiksNode[j].ArrayHistKolFailure[k]/KolProgon;
      If Length(CNode.Ns[i].StatistiksNode[j].ArrayHistKolRecovery)<>0 then
      For k:=0 to Length(CNode.Ns[i].StatistiksNode[j].ArrayHistKolRecovery)-1 do
        CNode.Ns[i].StatistiksNode[j].ArrayHistKolRecovery[k]:=CNode.Ns[i].StatistiksNode[j].ArrayHistKolRecovery[k]/KolProgon;
      If (Length(CNode.Ns[i].StatistiksNode[j].TimeFailure)<>0) then
        begin
        n:=Length(CNode.Ns[i].StatistiksNode[j].TimeFailure);
        For s:=0 to n-1 do
        If CNode.Ns[i].StatistiksNode[j].TimeFailure[s].TimeRecover-0.0001<0 then
          begin
          CNode.Ns[i].StatistiksNode[j].TimeFailure[s].TimeRecover:=EndModelTime2;
//          FModel.MeProt.Lines.Add(IntToStr(CNode.Ns[i].StatistiksNode[j].TimeFailure[s].NomProgon)+' '+CNode.Ns[i].Nomber+' '+CNode.Ns[i].StatistiksNode[j].NameNode+' Time='+FloatTOStr(CNode.Ns[i].StatistiksNode[j].TimeFailure[s].TimeFailure)+' Не восстановлен')
          end;
        end;
      end;
  If (Length(CNode.Sklad.AllTimeProcess)<>0) then
    begin
    n:=Length(CNode.Sklad.AllTimeProcess);
    For s:=0 to n-1 do
    If CNode.Sklad.AllTimeProcess[s].TimeRecover-0.0001<0 then
      begin
      CNode.Sklad.AllTimeProcess[s].TimeRecover:=EndModelTime2;
//      FModel.MeProt.Lines.Add(' Time='+FloatTOStr(CNode.Sklad.AllTimeProcess[s].TimeFailure)+' Не восстановлен')
      end;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
end;

function GoSearchFailure(TimeSearch:Double; Node:TTransportNode; ElementName:string; ElementEndModel:Boolean):Boolean;
  var
    Time:Double;
    SearchNode:TTransportNode;
    NewEvent:TEventAddElement;
    n:LongWord;
  begin
  SearchNode:=SearchFailureElementGraph(Node,ElementName,Time);
  If SearchNode<>nil then
    begin
    NewEvent:=TEventAddElement.Create;
    NewEvent.Name:=ElementName;
    NewEvent.Node:=SearchNode;
    NewEvent.EventTime:=TimeSearch+Time;
    TimeTransportProgon:=TimeTransportProgon+Time;
    if ElementName=NameElementProcessTransport then
      begin
      n:=Length(TimeProcessTransport);
      SetLength(TimeProcessTransport,n+1);
      TimeProcessTransport[n]:=Time;
      end;
    NewEvent.FlagEndModel:=ElementEndModel;
    SBS.AddEvent(NewEvent);
    if VivodProcessing then
    Writeln(f,FloatToStr(TimeSearch)+'   '+Node.Name+'   ВОССТАНОВЛЕНИЕ Эл-та '+ElementName+'  ВОССТАНОВЛЕН Эл-т ЧАСТИ '+SearchNode.Name+'     Время ожидания элемента '+FloatToStr(Time));
    Result:=True;
    end
  else
    Result:=False;
  end;

function SearchFailureElementGraph(Node:TTransportNode; ElementName:String; var MinTime:Double):TTransportNode;
  var
    CurrenTTransportNode,SearchNode:TTransportNode;
    CurrentElement:TStructureNode;
    ElementSklad,CurrentElementSklad:TElementSklad;
    Time:Double;
    NomNs:LongWord;
  begin
  CurrenTTransportNode:=FirsTTransportNode;
  MinTime:=10000000000000000;
  SearchNode:=nil;
  ElementSklad:=Node.Sklad.SearchElement(ElementName);
  If ElementSklad=nil then
    begin
    ElementSklad:=TElementSklad.Create;
    ElementSklad.Name:=ElementName;
    If Node.Sklad.FirstElement=nil then
      Node.Sklad.FirstElement:=ElementSklad
    else
      begin
      CurrentElementSklad:=Node.Sklad.FirstElement;
      While CurrentElementSklad.NextElement<>nil do
        CurrentElementSklad:=CurrentElementSklad.NextElement;
      CurrentElementSklad.NextElement:=ElementSklad;
      end;
    end;

  While (CurrenTTransportNode<>nil) do
    begin
    if Length(CurrenTTransportNode.Ns)<>0 then
    For NomNS:=0 to Length(CurrenTTransportNode.Ns)-1 do
      begin
      CurrentElement:=CurrenTTransportNode.Ns[NomNS].GraphLevel0.SearchFailureNodeGraphName(ElementName);
      if (CurrentElement<>nil) then
        begin
        Time:=MinTimeGraphVolna(Node,CurrenTTransportNode);
        If Time<MinTime then
          begin
          MinTime:=Time;
          SearchNode:=CurrenTTransportNode;
          end;
        end;
      end;
    CurrenTTransportNode:=CurrenTTransportNode.NexTTransportNode;
    end;
  if SearchNode<>nil then       //Добавление времени транспортировки
    begin
    ElementSklad.TimeWaiting:=ElementSklad.TimeWaiting+MinTime;
    end;

  Result:=SearchNode;
  end;

procedure GoAllEventManufacture;
var
  Node:TTransportNode;
begin
Node:=FirsTTransportNode;
while Node<>nil do
  begin
  if Node.Manufact<>nil then
    Node.Manufact.GoProductionManufact(Node,0);
  Node:=Node.NexTTransportNode;
  end;
end;

function SearchSkladTOElement(NodeNS:TTransportNode):TTransportNode;
var
  CurrentNode,SearchNode:TTransportNode;
  TimeToNS:Double;
begin
CurrentNode:=FirsTTransportNode;
TimeToNS:=100000000000;
SearchNode:=nil;
While CurrentNode<>nil do
  begin
  If (CurrentNode.Sklad<>nil)and (CurrentNode<>NodeNS) and (TimeToNS>SearchMinTime(NodeNS,CurrentNode)) then
    begin
    SearchNode:=CurrentNode;
    TimeToNS:=SearchMinTime(NodeNS,CurrentNode);
    end;
  CurrentNode:=CurrentNode.NexTTransportNode;
  end;
Result:=SearchNode;
end;

procedure GoToARZ(Node:TStructureNode; Structure:TGraphStructure; Time:Double);
var
  NodeARZ,CurrentNode,SkladNode:TTransportNode;
  TimeToARZ,TimeGo:Double;
  NomProduct,NomProduction:Word;
  st:string;
  NewEventCreate:TEventCreate;
  NameProduction:string;
  TimeProduction,CostProduction:Double;
begin
CurrentNode:=FirsTTransportNode;
TimeToARZ:=100000000000;
NodeARZ:=nil;
While CurrentNode<>nil do
  begin
  If (CurrentNode.ARZ<>nil) then
    TimeGo:=SearchMinTime(Structure.TransportNode,CurrentNode);
  If (Node.Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) and (CurrentNode.ARZ<>nil) then
    begin
    FModel.MeProt.Lines.Add(CurrentNode.ARZ.Name+' '+FloatToStr(TimeToARZ)+' '+FloatToStr(TimeGo));
    end;
  If (CurrentNode.ARZ<>nil) and (CurrentNode.ARZ.SearchManufact(Node.Name)<>65000) and (TimeToARZ>TimeGo) then
    begin
    NodeARZ:=CurrentNode;
    TimeToARZ:=TimeGo;
    end;
  CurrentNode:=CurrentNode.NexTTransportNode;
  end;
IF NodeARZ<>nil then
  begin
  NomProduct:=NodeARZ.ARZ.SearchManufact(Node.Name);
  SkladNode:=SearchSkladTOElement(Structure.TransportNode);
  NodeARZ.ARZ.ManufactQuery.AddProduction(NodeARZ.ARZ.SetProduction[NomProduct],SkladNode,Time+TimeToARZ);
  If GoProtocolEvent then
    begin
    Str(Time:12:2,st);
    FModel.MeProt.Lines.Add(st+' ЛА - '+Structure.Name+' - '+Structure.Nomber+' Элемент -> '+Node.Name+' на АРЗ ->'+NodeARZ.ARZ.Name+' Время в дороге '+FloatTOStr(TimeToARZ)+' Склад назначения - '+SkladNode.Name);
    end;
  If (Node.Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
    begin
    Str(Time:12:2,st);
    FModel.MeProt.Lines.Add(st+' ЛА - '+Structure.Name+' - '+Structure.Nomber+' Элемент -> '+Node.Name+' на АРЗ ->'+NodeARZ.ARZ.Name+' Время в дороге '+FloatTOStr(TimeToARZ)+' Склад назначения - '+SkladNode.Name);
    end;

      If (Node.Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
        for NomProduction:=0 to Length(NodeARZ.ARZ.SetProduction)-1 do
          FModel.MeProt.Lines.Add(IntToStr(NomProduction)+' '+NodeARZ.ARZ.SetProduction[NomProduction].NameProduction);

  If NodeARZ.ARZ.GiveFirstProductionOnPower(TimeToARZ+Time,SkladNode,NameProduction,TimeProduction,CostProduction) then
    begin
    //Запускаем новое восстановление на АРЗ
    NewEventCreate:=TEventCreate.Create;
    NewEventCreate.NameProduction:=NameProduction;
    NewEventCreate.TimeProduction:=TimeProduction;
    NewEventCreate.CostProduction:=CostProduction;
    NewEventCreate.NodeCreate:=NodeARZ; 
    NewEventCreate.CreateOrRecover:=False;
    NewEventCreate.NodeTransport:=Structure.TransportNode;
    NewEventCreate.EventTime:=TimeToARZ+Time+TimeProduction;
    SBS.AddEvent(NewEventCreate);
     If GoProtocolEvent then
       begin
       FModel.MeProt.Lines.Add(st+' В ремонт добавлена новая часть: '+NameProduction+' Мощность предприятия - '+FloatToStr(NodeARZ.ARZ.Power));
       end;
    end;
  end;
end;

procedure LoadGraph(NameFile:string);
  var
    f:TextFile;
    st:string;
    Name:string;
    TypeArc:Byte;
    LengthArc:Double;
    Node:TTransportNode;
    Arc:TTransportArc;
    Sklad:TSklad;
    Ns:TGraphStructure;
    Manuf:TManufact;
    NodeN,NodeK:TTransportNode;
    NomNS,MaxNs:LongWord;
  begin
  KolStructure:=0;
  AssignFile(f,NameFile);
  Reset(f);
  Readln(f,st);
  CostService:=StrToFloat(st);
  Readln(f,st);
  CostTransport:=StrToFloat(st);
  while not Eof(f) do
    begin
    Readln(f,st);
    If st[1]='n' then
      begin
      Delete(St,1,2);
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      Node:=AddNode(Name,1);
//      Delete(St,1,pos('@',st));
      Node.x:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      Node.y:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));

      If st[1]='1' then
        begin
        Sklad:=TSklad.Create;
        Node.Sklad:=Sklad;
        Delete(St,1,pos('@',st));
        Node.Sklad.MaxVolumeSklad:=StrToFloat(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        Node.Sklad.CostSklad:=StrToFloat(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        end
      else
        Delete(St,1,pos('@',st));
      if st[1]='1' then
        begin
        Delete(St,1,pos('@',st));
        MaxNs:=StrToInt(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        IF MaxNs<>0 then
        for NomNS:=0 to MaxNs-1 do
          begin
          Ns:=TGraphStructure.Create;
          Inc(KolStructure);
          Ns.Name:=Copy(St,1,pos('@',st)-1);
          Delete(St,1,pos('@',st));
          Ns.Nomber:=Copy(St,1,pos('@',st)-1);
          Delete(St,1,pos('@',st));
          SetLength(Node.Ns,NomNS+1);
          Node.Ns[NomNs]:=Ns;
          end;
        end
      else
        Delete(St,1,pos('@',st));
      If St[1]='1' then
        begin
        Delete(St,1,pos('@',st));
        Manuf:=TManufact.Create;
        Node.Manufact:=Manuf;
        Manuf.Name:=Copy(St,1,pos('@',st)-1);
        end;
        Delete(St,1,pos('@',st));
      If St[1]='1' then
        begin
        Delete(St,1,pos('@',st));
        Manuf:=TManufact.Create;
        Node.ARZ:=Manuf;
        Manuf.Name:=Copy(St,1,pos('@',st)-1);
        end;
      end
    else
      begin
      Delete(St,1,2);
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      NodeN:=SearchNodeName(Name);
      TypeArc:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      LengthArc:=StrToFloat(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      Arc:=NodeN.AddArc(TypeArc,LengthArc);
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      NodeK:=SearchNodeName(Name);
      Arc.Node:=NodeK;
      Arc:=NodeK.AddArc(TypeArc,LengthArc);
      Arc.Node:=NodeN;
      end;
    end;
  CloseFile(f);
  end;

constructor TNS.Create;
  begin
    inherited;
    FirstElement:=nil;
    NOde:=nil;
    LastTime:=0;
    TimeWaiting:=0;
    TimeFailure:=0;
  end;

constructor TElementNS.Create;
  var
    i:Byte;
  begin
    inherited;
  Zakon:=255;
  NextElement:=Nil;
  NS:=nil;
  Name:='';
  TimeEndFailure:=0;
  TimeFailure:=0;
  LastTime:=0;
  for i:=0 to 1 do
    MFailure[i]:=0;
  For i:=0 to 20 do
    HistFailure[i]:=0;
  EnabledProduction:=false;    
  end;

destructor TElementNS.Destroy;
  begin
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление элемента НС');
  Zakon:=255;
  NextElement:=Nil;
  NS:=nil;
  Name:='';
  TimeEndFailure:=0;
  TimeFailure:=0;
  LastTime:=0;
  inherited;
  end;

destructor TNS.Destroy;
  var
    DelElement,CElement:TElementNS;
  begin
    If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление  НС');

    CElement:=FirstElement;
    While CElement<>nil do
      begin
      DelElement:=CElement;
      CElement:=CElement.NextElement;
      FreeAndNil(DelElement);
      end;
    FirstElement:=nil;
    NOde:=nil;
    LastTime:=0;
    TimeWaiting:=0;
    TimeFailure:=0;
    inherited;
  end;

function TNS.AddElementNS (Name:string; Zakon:Byte; Par1,PAr2:Double):TElementNs;
  var
    NewElement:TElementNS;
    CurrentElement:TElementNS;
  begin
    NewElement:=TElementNS.Create;
    NewElement.Name:=Name;
    NewElement.Zakon:=Zakon;
    NewElement.Parametr1:=Par1;
    NewElement.Parametr2:=PAr2;
    NewElement.NS:=Self;
  if FirstElement=nil then
    FirstElement:=NewElement
  else
    begin
    CurrentElement:=FirstElement;
    While CurrentElement.NextElement<>nil do
      CurrentElement:=CurrentElement.NextElement;
    CurrentElement.NextElement:=NewElement;
    end;
  Result:=NewElement;
  end;

function TNS.SearchElementName(Name:String):TElementNs;
  var
    CurrentElement:TElementNS;
  begin
  CurrentElement:=FirstElement;
  While (CurrentElement<>nil) and (CurrentElement.Name<>Name) do
    CurrentElement:=CurrentElement.NextElement;
  Result:=CurrentElement;
  end;

procedure TNS.ClearSost;
  var
    CurrentElement:TElementNS;
  begin
  CurrentElement:=FirstElement;
  While (CurrentElement<>nil)  do
    begin
    CurrentElement.LastTime:=0;
    CurrentElement.TimeFailure:=0;
    CurrentElement.Failure:=0;
    CurrentElement:=CurrentElement.NextElement;
    end;
  TimeWaiting:=0;
  TimeFailure:=0;
  Failure:=0;
  end;

function TGraphStructure.RecoverElement (Name:string; Time:Double):Boolean;
  var
    CurrentElement,CElement:TStructureNode;
//    Event:TEventFailureTEventFailure;
  begin
  CurrentElement:=GraphLevel0.SearchFailureNodeGraphName(Name);
  If (Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
    FModel.MeProt.Lines.Add(Name+' ПОИСК - ');
  IF (CurrentElement<>nil) then
    begin
  If (Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
    FModel.MeProt.Lines.Add(Name+' ЗАМЕНА - ');    
    CurrentElement.BoolSearchFailure:=2;
    UMainStructure.Structure:=Self;
    CurrentElement.GoSwitch(1,'Замена',255);
    Result:=True;
    end
  else
    Result:=False;
  end;

function TNS.RecoverElement (Name:string; Time:Double; ElementEndModel:Boolean; var EndModel:Boolean):Boolean;
  var
    CurrentElement,CElement:TElementNS;
    Event:TEventFailure;
  begin
  CurrentElement:=SearchElementName(Name);
  IF (CurrentElement<>nil) and (CurrentElement.Failure=1)  then
    begin
    CurrentElement.Failure:=0;
    CurrentElement.TimeFailure:=CurrentElement.TimeFailure+Time-CurrentElement.LastTime;
    if VivodProcessing then
      Writeln(f,FloatToStr(Time)+'   '+Node.Name+'   ВОССТАНОВЛЕНИЕ Эл-та '+Name+'  ВОССТАНОВЛЕН элемент ЧАСТИ     Время отказа элемента '+FloatToStr(Time-CurrentElement.LastTime));
    CElement:=FirstElement;
    While (CElement<>nil) and (CElement.Failure<>1) do
      CElement:=CElement.NextElement;
    if CElement=nil then
      begin
      Failure:=0;
      TimeFailure:=TimeFailure+Time-LastTime;
      if VivodProcessing then
        Writeln(f,FloatToStr(Time)+'   '+Node.Name+'   ВОССТАНОВЛЕНИЕ  ЧАСТИ     Время отказа части '+FloatToStr(Time-LastTime));
      end;
    Event:=TEventFailure.Create;
    Event.Structure:=UMainStructure.Structure;
//    Event.Element:=CurrentElement;
    Event.EventTime:=CurrentElement.GoTimeFailure(Time);
    SBS.AddEvent(Event);
    EndModel:=ElementEndModel;
    Result:=True;
    end
  else
    Result:=False;
  end;

procedure TNS.GoAllFailure;
  var
    Event:TEventFailure;
    CurrentElement:TElementNS;
  begin
  CurrentElement:=FirstElement;
  While CurrentElement<>nil do
    begin
    Event:=TEventFailure.Create;
    Event.Structure:=UMainStructure.Structure;
//    Event.Element:=CurrentElement;
    Event.EventTime:=CurrentElement.GoTimeFailure(0);
    SBS.AddEvent(Event);
    CurrentElement:=CurrentElement.NextElement;
    end;
  end;

function TElementNs.GoTimeFailure (ThisTime:Double):Double;
  var
    i:word;
    s:Double;
  begin
  Randomize;
  Case Zakon of
    0: Result:=ThisTime+Parametr1;
    1: Result:=ThisTime+Random(Trunc(Parametr2-Parametr1))*random+Parametr1;
    2: begin
       s:=0;
       For i:=1 to 24 do
         s:=s+Random;
       result:=ThisTime+(s-12)*sqrt(Parametr2)+Parametr1;
       end;
    3: result:=ThisTime-ln(Random+0.000000000001)/(1-Parametr1);
    end;
  end;

procedure TElementNs.GoFailure (Time:Double; var EndModel:Boolean);
  var
    ElementSklad:TElementSklad;
    i,j,Nom,n:Word;
    MinTime:Double;
    Event:TEventFailure;
    EventSklad:TEventAddElement;
    CNode:TTransportNode;
    SearchTime:Double;
    MinTimeLength:Double;
    MinNode:TTransportNode;
    MinElementSklad:TElementSklad;
  begin
  IF (NS.Node<>nil) and (NS.Node.Sklad<>nil) then
    begin
    //Поиск элемента на складе части
    ElementSklad:=NS.Node.Sklad.SearchElement(Name);
    if (ElementSklad<>nil) and (ElementSklad.kolvo<>0) then
      begin
      //Выбор элемента с минимальным временем
      MinTime:=10000000000000000;
      n:=Length(ElementSklad.TimeEnabled);
      For i:=0 to n-1 do
        if ElementSklad.TimeEnabled[i]<MinTime then
          begin
          MinTime:=ElementSklad.TimeEnabled[i];
          nom:=i;
          end;
      //Сохранение времени
      ElementSklad.TimeWaiting:=ElementSklad.TimeWaiting+(Time-MinTime);
      NS.TimeWaiting:=NS.TimeWaiting+(Time-MinTime);
      //Удаление элмента со склада
      Dec(ElementSklad.kolvo);
      if Nom<>n-1 then
        for j:=Nom to n-2 do
          ElementSklad.TimeEnabled[j]:=ElementSklad.TimeEnabled[j+1];
      SetLength(ElementSklad.TimeEnabled,n-1);
      //Создание события отказа элемента
      EndModel:=(ElementSklad.FlagEndModel) and (ElementSklad.TimeEndModel=MinTime);
      Event:=TEventFailure.Create;
      Event.Structure:=UMAinStructure.Structure;
//      Event.Element:=Self;
      Event.EventTime:=GoTimeFailure(Time);
      SBS.AddEvent(Event);
      if VivodProcessing then
        Writeln(f,FloatToStr(Time)+'   '+Ns.Node.Name+'   ОТКАЗ Эл-т '+Name+'  ВОССТАНОВЛЕН СО СКЛАДА ЧАСТИ     Время ожидания элемента '+FloatToStr(Time-MinTime))
      end
    else
      begin
      //Переводим элемент и систему в состояние ОТКАЗ
      If NS.Failure<>1 then
        begin
        NS.LastTime:=Time;
        NS.Failure:=1;
        end;
      LastTime:=Time;
      Failure:=1;
      TimeEndFailure:=Time;
      //Поиск элемента на другом складе
      IF GoTransfer=1 then
      begin
      CNode:=FirsTTransportNode;
      MinTimeLength:=10000000;
      MinNode:=nil;
      While CNode<>nil do
        begin
        //У вешины есть склад?
        If (CNode.Sklad<>nil) and (CNode.Ns=nil) then
          begin
          ElementSklad:=CNode.Sklad.SearchElement(Self.Name);
          //На складе есть требуемый элемент?
          if (ElementSklad<>nil) and (ElementSklad.kolvo<>0) then
             begin
             //Поиск кратчайшего пути со склада до части
             SearchTime:=SearchMinTime(CNode,Self.NS.Node);
             //Сравнение с минимальным
             If SearchTime<MinTimeLength then
               begin
               MinTimeLength:=SearchTime;
               MinNode:=CNode;
               MinElementSklad:=ElementSklad;
               end;
             end;
          end;
        CNode:=CNode.NexTTransportNode;
        end;
      //Если возможна доставка элемента со склада
      IF MinNode<>nil then
        begin
        //Выбор элемента с минимальным временем
        MinTime:=10000000000000000;
        n:=Length(MinElementSklad.TimeEnabled);
        For i:=0 to n-1 do
          if MinElementSklad.TimeEnabled[i]<MinTime then
            begin
            MinTime:=MinElementSklad.TimeEnabled[i];
            nom:=i;
            end;
        //Сохранение времени
        MinElementSklad.TimeWaiting:=MinElementSklad.TimeWaiting+(Time-MinTime)+MinTimeLength;
        NS.TimeWaiting:=NS.TimeWaiting+(Time-MinTime)+MinTimeLength;
        //Запланировать доставку
        EventSklad:=TEventAddElement.Create;
        EventSklad.Name:=MinElementSklad.Name;
        EventSklad.Node:=Self.NS.Node;
        EventSklad.EventTime:=SBS.ModelTime+MinTimeLength;
        EventSklad.FlagEndModel:=false; 
        If MinTime=MinElementSklad.TimeEndModel then
          begin
          EventSklad.FlagEndModel:=MinElementSklad.FlagEndModel;
          MinElementSklad.FlagEndModel:=False;
          MinElementSklad.TimeEndModel:=0;
          end;
        SBS.AddEvent(EventSklad);
        //Удаление элмента со склада
        Dec(MinElementSklad.kolvo);
        if Nom<>n-1 then
          for j:=Nom to n-2 do
            MinElementSklad.TimeEnabled[j]:=MinElementSklad.TimeEnabled[j+1];
        SetLength(MinElementSklad.TimeEnabled,n-1);
        if VivodProcessing then
        Writeln(f,FloatToStr(Time)+'   '+Ns.Node.Name+'   ОТКАЗ Эл-т '+Name+'  ВОССТАНОВЛЕН СО СКЛАДА '+MinNode.NAme+'     Время ожидания элемента '+FloatToStr(Time-MinTime+MinTimeLength)+'   Время в пути '+FloatToStr(MinTimeLength));

        end
      else
       if VivodProcessing then
        Writeln(f,FloatToStr(Time)+'   '+Ns.Node.Name+'   ОТКАЗ Эл-т '+Name+'  ВОССТАНОВЛЕНИЕ НЕВОЗМОЖНО');
      end
      else
      if VivodProcessing then
        Writeln(f,FloatToStr(Time)+'   '+Ns.Node.Name+'   ОТКАЗ Эл-т '+Name+'  ТРАНСПОРТИРОВКА ОТКЛЮЧЕНА');

      end;
    end;

  end;

function SearchMinTime(NodeNat,NodeKon:TTransportNode):Double;
  begin
  Result:=MinTimeGraphVolna(NodeNat,NodeKon);
  end;

procedure TNS.LoadElementFile(NameFile:string);
  var
    f:TextFile;
    FPAr:file of TSaveFailure;
    ElementFile:TSaveFailure;
    St:string;
    Name:string;
    Zakon,i:Byte;
    par1,par2:double;
    Element,DelElement,PreElement:TElementNS;
  begin
  AssignFile(f,NameFile+'.txt');
  Reset(f);
  Readln(f,st);
  While St[1]<>';' do
    begin
    Par2:=-1;
    Name:=Copy(St,1,pos('@',st)-1);
    Delete(St,1,pos('@',st));
    Zakon:=StrToInt(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    par1:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    If (Zakon=1) or (Zakon=2) then
      par2:=StrToFloat(Copy(St,1,pos('@',st)-1));
    AddElementNS(Name,Zakon,par1,par2);
    Readln(f,st);
    end;
  CloseFile(f);
  AssignFile(FPAr,NameFile+'.par');
  Reset(FPAr);
  While not Eof (FPAr) do
    begin
    read(FPar,ElementFile);
    Element:=SearchElementName(ElementFile.Name);
    If Element=nil then
      Element:=AddElementNS(ElementFile.Name,0,0,0);
    Element.MFailure[0]:=Element.MFailure[0]+ElementFile.KolFailure[0];
    IF Element.MFailure[1]=0 then
      Element.MFailure[1]:=ElementFile.KolFailure[1];
    For i:=0 to 20 do
      Element.HistFailure[i]:=Element.HistFailure[i]+ElementFile.ArrayHistKolFailure[i]
    end;
  CloseFile(FPAr);
  AssignFile(f,NameFile+'.enb');
  Reset(f);
  While not Eof (f) do
    begin
    Readln(f,st);
    Name:=Copy(St,1,pos('@',st)-1);
    Delete(St,1,pos('@',st));
    Element:=SearchElementName(Name);
    IF Element<>nil then
      begin
      Element.EnabledProduction:=True;
      Element.SizeProduction:=StrToFloat(Copy(St,1,pos('@',st)-1));
      end;
    end;
  CloseFile(f);
  Element:=FirstElement;
  PreElement:=nil;
  while Element<>nil do
    begin
    DelElement:=Element;
    Element:=Element.NextElement;
    If not DelElement.EnabledProduction then
      begin
      If PreElement=nil then
        FirstElement:=Element
      else
        PreElement.NextElement:=Element;
      FreeAndNil(DelElement);
      end
    else
      PreElement:=DelElement;
    end;
  end;

function SearchNodeMaxNS:TTransportNode;
var
  CNode,MaxNode:TTransportNode;
  MaxKolNs:LongWord;
begin
CNode:=FirsTTransportNode;
MaxKolNs:=0;
While CNode<>nil do
  begin
  If (CNode.NodeFinish=0) and (Length(CNode.Ns)>MaxKolNs) then
    begin
    MaxKolNs:=Length(CNode.Ns);
    MaxNode:=CNode;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
Result:=MaxNode;
end;

function SearchSkladMinLength(NodeNat:TTransportNode; VolumeElement:Double):TTransportNode;
var
  CNode:TTransportNode;
  Min,Leng:Double;
  MinNode:TTransportNode;
begin
CNode:=FirsTTransportNode;
MinNode:=nil;
Min:=MaxInt;
while CNode<>nil do
  begin
  Leng:=SearchMinTime(NodeNat,CNode);
  if (CNode<>NodeNat) and(CNode.Sklad<>nil) and (CNode.Sklad.MaxVolumeSklad-CNode.Sklad.VolumeSklad>VolumeElement) and (Leng<Min) then
    begin
    Min:=Leng;
    MinNode:=CNode;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
Result:=MinNode;
end;



Constructor TGraphStructure.Create;
  begin
  inherited;
  LoadProduction:=False;
  GraphLevel0:=nil;
  MainNode:=nil;
  SetLength(StatProtocol,0);
  SetLength(StatistiksNode,0)
  end;
Destructor TGraphStructure.Destroy;
  var
    i:word;
  begin
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление Структуры');

{  if GraphLevel0<>nil then
    GraphLevel0.Destroy;}
  If Length(StatProtocol)<>0 then
  for i:=0 to Length(StatProtocol)-1 do
    FreeAndNil(StatProtocol[i]);
  Finalize(StatProtocol);
  If Length(StatistiksNode)<>0 then
  for i:=0 to Length(StatistiksNode)-1 do
    FreeAndNil(StatistiksNode[i]);
  Finalize(StatistiksNode);
  inherited;
  end;

Procedure TGraphStructure.ClearStatistics;
  var
    i:LongWord;
  begin
  for i:=0 to Length(StatistiksNode)-1 do
    begin
    StatistiksNode[i].NomFailure:=0;
    StatistiksNode[i].NomRecovery:=0;
    end;

  end;

Procedure TGraphStructure.ClearSostStructure;
  var
   n:LongWord;
  begin
    GraphLevel0.SaveTime;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Выключение структуры '+Name+': '+Nomber);
    GraphLevel0.SwitchOFF;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Сохранение статистики структуры '+Name+': '+Nomber);
    SaveStat;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Сохранение КГ структуры '+Name+': '+Nomber);
  n:=Length(MainNode.ArrayKG);
  SetLength(MainNode.ArrayKG,n+1);
  MainNode.ArrayKG[n]:=(MainNode.Time[0]+MainNode.Time[1])/ModelTime;
    If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Сохранение статистики структуры '+Name+': '+Nomber);
    NewProgonStat;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление списка действий структуры '+Name+': '+Nomber);
  FreeAndNil(ListAction);
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Очистка структуры'+Name+': '+Nomber);
  IF GraphLevel0<>nil then
    GraphLevel0.Clear;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Конец Конец'+Name+': '+Nomber);
  end;

procedure TGraphStructure.GoStructureEvent;
  begin
  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Создание всех событий отказов структуры '+Name+': '+Nomber);
  GoAllEvent;
  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Создание действий структуры '+Name+': '+Nomber);
  Self.ListAction:=TListAction.Create;
  Self.ListAction.Structure:=Self;
  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка действий структуры '+Name+': '+Nomber);
  Self.ListAction.LoadAction(Self,Name+'-Действие.txt');
  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Обнуление статистики '+Name+': '+Nomber);
  ClearStatistics;
  end;

Procedure TGraphStructure.AllNodeChangeKoef(CurrentGraph:TGraph);
  var
  CurrenTStructureNode:TStructureNode;
  begin
  CurrenTStructureNode:=CurrentGraph.Node;
  While CurrenTStructureNode<>nil do
    begin
   If CurrenTStructureNode.BoolRegularly=0 then
      CurrenTStructureNode.SwitchOFF;
    If CurrenTStructureNode.SubGraph<>nil then
      AllNodeChangeKoef(CurrenTStructureNode.SubGraph);
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

Procedure TGraphStructure.GoGraphAllEventFailure(CurrentGraph:TGraph);
  var
  CurrenTStructureNode:TStructureNode;
  CurrentFailure:TListFailure;
  begin
  CurrenTStructureNode:=CurrentGraph.Node;
  While CurrenTStructureNode<>nil do
    begin
    CurrentFailure:=CurrenTStructureNode.Failure;
    While (CurrentFailure<>nil) {and not((CurrentFailure.TypeRegulary=CurrenTStructureNode.BoolRegularly) and (CurrentFailure.TypeFailure=CurrenTStructureNode.BoolFailure))} do
      begin
      If (CurrentFailure.TypeRegulary=CurrenTStructureNode.BoolRegularly) and (CurrentFailure.TypeFailure=CurrenTStructureNode.BoolFailure) then
        CurrentFailure.GoFailure;
      CurrentFailure:=CurrentFailure.NextFailure;
      end;
    If CurrenTStructureNode.SubGraph<>nil then
      GoGraphAllEventFailure(CurrenTStructureNode.SubGraph);
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

Procedure TGraphStructure.GoAllEvent;
  begin
  GoGraphAllEventFailure(GraphLevel0);
  end;

Function GoTypeAction(Name:String):Byte;
  begin
  If Name='Выключение' then
    Result:=0
  else If Name='Включение' then
    Result:=1
  else If Name='Демонтаж' then
    Result:=2
  else If Name='Монтаж' then
    Result:=3
  else If Name='Настройка' then
    Result:=4
  else
    Result:=255;
  end;

Procedure TGraphStructure.LoadGraphFile (NameFile:String);
  var
  f:TextFile;
  St:String;
  Name:String;
  Time:String;
  TypeReliabilityFailure,TypeR,TypeF:Byte;
  CurrentGraph,AndGraph:TGraph;
  CurrenTStructureNode,AndNode:TStructureNode;
  CurrentRelationArc:TRelationArc;
  CurrentChReliability:TChangeReliability;
  CurrentAction:TActionList;
  CurrentElementAction:TElementActionList;
  ExpReliability:TExpFailure;
  NormReliability:TNormalFailure;
  LisTStructureNode:TArrayOFNode;
  NomNode:Byte;
  SearchStat:TStatistics;
  begin
  //Загрузка Элементов и их отказов
  LoadProduction:=True;
  AssignFile (f,NameFile);
  reset(f);
  GraphLevel0:=TGraph.Create;
  GraphLevel0.Name:='Level0';
  While Not EOF(f) do
    begin
    CurrentGraph:=GraphLevel0;
    Readln(f,st);
    IF st[1]=':' then
      begin
      Name:=Copy(St,2,pos('@',st)-2);
      Delete(St,1,pos('@',st));
      MainNode:=CurrentGraph.SearchNodeName(Name);
      Readln(f,st);
      end;

    //Загрузка элемента
    While St[1]<>':' do
      begin
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
      If CurrenTStructureNode<>nil then
        begin
        If CurrenTStructureNode.SubGraph=nil then
          begin
          CurrenTStructureNode.SubGraph:=TGraph.Create;
          CurrenTStructureNode.SubGraph.FatherNodeGraph:=CurrenTStructureNode;
          CurrenTStructureNode.SubGraph.Name:=CurrenTStructureNode.Graph.Name+'->'+CurrenTStructureNode.Name;
          end;
        CurrentGraph:=CurrenTStructureNode.SubGraph;
        Delete(St,1,pos('@',st));
        end
      else
        begin
        CurrenTStructureNode:=CurrentGraph.AddNode(false,Name);
        //Добавление элемента статистики
        SearchStat:=SearchStatistikNode(CurrenTStructureNode);
        If SearchStat=nil then
          SearchStat:=AddStatisticsNode(CurrenTStructureNode);
        SearchStatistikProtocol(CurrenTStructureNode);
        CurrenTStructureNode.Stat:=SearchStat;
        If St[1]<>':' then
          begin
          CurrenTStructureNode.SubGraph:=TGraph.Create;
          CurrenTStructureNode.SubGraph.FatherNodeGraph:=CurrenTStructureNode;
          CurrenTStructureNode.SubGraph.Name:=CurrenTStructureNode.Graph.Name+'->'+CurrenTStructureNode.Name;
          CurrentGraph:=CurrenTStructureNode.SubGraph;
          Delete(St,1,pos('@',st))
          end;
        end;
      end;
      //Считывание времени включения
      Delete(St,1,1);
{      Time:=Copy(St,1,pos('@',st)-1);
      try
        CurrenTStructureNode.TimeToSwitch:=StrToFloat(Time);
      except
        CurrenTStructureNode.TimeToSwitch:=0; //ОШИБКА
      end;                      }
      //Отказ верхнего уровня
      Delete(St,1,pos('@',st));
      Time:=Copy(St,1,pos('@',st)-1);
      try
        CurrenTStructureNode.ImpactLevel:=StrToInt(Time);
      except
        CurrenTStructureNode.ImpactLevel:=0; //ОШИБКА
      end;
      //Автовостановление
        Delete(St,1,pos('@',st));
      If (Length(st)<>0) and (st[1]<>':') then
        begin
        TypeReliabilityFailure:=StrToInt(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        Case TypeReliabilityFailure of
          1: begin
               ExpReliability:=TExpFailure.Create;
               ExpReliability.La:=StrToFloat(Copy(St,1,pos('@',st)-1));
               Delete(St,1,pos('@',st));
               CurrenTStructureNode.AutoRenovation:=ExpReliability;
               end;
          2: begin
             NormReliability:=TNormalFailure.Create;
             NormReliability.Mx:=StrToFloat(Copy(St,1,pos('@',st)-1));
             Delete(St,1,pos('@',st));
             NormReliability.Dx:=StrToFloat(Copy(St,1,pos('@',st)-1));
             Delete(St,1,pos('@',st));
             CurrenTStructureNode.AutoRenovation:=NormReliability;
             end;
          end;
        end;
      //Считывание отказов
      While (Length(st)<>0) and (st[1]=':') do
        begin
        Delete(St,1,1);
        TypeR:=StrToInt(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        TypeF:=StrToInt(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        TypeReliabilityFailure:=StrToInt(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        Case TypeReliabilityFailure of
          1: begin
               ExpReliability:=TExpFailure.Create;
               ExpReliability.La:=StrToFloat(Copy(St,1,pos('@',st)-1));
               Delete(St,1,pos('@',st));
               CurrenTStructureNode.AddFailure(TypeR,TypeF,ExpReliability);
               end;
          2: begin
             NormReliability:=TNormalFailure.Create;
             NormReliability.Mx:=StrToFloat(Copy(St,1,pos('@',st)-1));
             Delete(St,1,pos('@',st));
             NormReliability.Dx:=StrToFloat(Copy(St,1,pos('@',st)-1));
             Delete(St,1,pos('@',st));
//             CurrenTStructureNode.Time[TypeR]:=Random*(NormReliability.Mx/10);
             CurrenTStructureNode.AddFailure(TypeR,TypeF,NormReliability);
             end;
          end;
        end;
    end;
  CloseFile(f);
  //Дублирование
  AssignFile(f,'(Double)'+NameFile);
  Reset(f);
  While Not EOF (f) do
    begin
    Readln(F,St);
    CurrentGraph:=GraphLevel0;
    //Загрузка элемента, который является дублирующим
    While St[1]<>':' do
      begin
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
      If (CurrenTStructureNode<>nil) and (St[1]<>':') then
        begin
        CurrentGraph:=CurrenTStructureNode.SubGraph;
        Delete(St,1,pos('@',st));
        end;
      end;
    Delete(St,1,1);
    CurrenTStructureNode.KolParallelNode:=StrToInt(st);

    Readln(F,St);
    //Загружаем все элементы, которые дублируют
    While st[1]<>';' do
      begin
      AndGraph:=GraphLevel0;
      While St[1]<>':' do
        begin
        Name:=Copy(St,1,pos('@',st)-1);
        Delete(St,1,pos('@',st));
        AndNode:=AndGraph.SearchNodeName(Name);
        If (AndNode<>nil) and (St[1]<>':') then
          begin
          AndGraph:=AndNode.SubGraph;
          Delete(St,1,pos('@',st));
          end;
        end;
      If AndNode<>nil then
        CurrenTStructureNode.AddDoubleArc(AndNode);
      Readln(F,St);
      end;

    end;
  CloseFile(f);
  //Датчики
  AssignFile(f,'(Sensor)'+NameFile);
  Reset(f);
  While Not EOF (f) do
    begin
    Readln(F,St);
    CurrentGraph:=GraphLevel0;
    //Загрузка элемента, у которого есть датчики
    While St[1]<>':' do
      begin
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
      If (CurrenTStructureNode<>nil) and (St[1]<>':') then
        begin
        CurrentGraph:=CurrenTStructureNode.SubGraph;
        Delete(St,1,pos('@',st));
        end;
      end;

    Readln(F,St);
    //Загружаем все датчики
    While st[1]<>';' do
      begin
      AndGraph:=GraphLevel0;
      While St[1]<>':' do
        begin
        Name:=Copy(St,1,pos('@',st)-1);
        Delete(St,1,pos('@',st));
        AndNode:=AndGraph.SearchNodeName(Name);
        If (AndNode<>nil) and (St[1]<>':') then
          begin
          AndGraph:=AndNode.SubGraph;
          Delete(St,1,pos('@',st));
          end;
        end;
      CurrenTStructureNode.AddSensorArc(AndNode);
      Readln(F,St);
      end;

    end;
  CloseFile(f);

  //Зависимые отказы
  AssignFile(f,'(Relation)'+NameFile);
  Reset(f);
  While Not EOF (f) do
    begin
    Readln(F,St);
    CurrentGraph:=GraphLevel0;
    //Загрузка элемента, от которого зависят другие элементы
    While St[1]<>':' do
      begin
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
      If (CurrenTStructureNode<>nil) and (St[1]<>':') then
        begin
        CurrentGraph:=CurrenTStructureNode.SubGraph;
        Delete(St,1,pos('@',st));
        end;
      end;

    Readln(F,St);
    //Загружаем все зависимые элементы
    While st[1]<>';' do
      begin
      AndGraph:=GraphLevel0;
      While St[1]<>':' do
        begin
        Name:=Copy(St,1,pos('@',st)-1);
        Delete(St,1,pos('@',st));
        AndNode:=AndGraph.SearchNodeName(Name);
        If (AndNode<>nil) and (St[1]<>':') then
          begin
          AndGraph:=AndNode.SubGraph;
          Delete(St,1,pos('@',st));
          end;
        end;
      CurrentRelationArc:=CurrenTStructureNode.AddRelationArc(AndNode);
      CurrentChReliability:=TChangeReliability.Create;
      CurrentRelationArc.ChangeReliability:=CurrentChReliability;
      Delete(St,1,1);
      CurrentRelationArc.TypeRegulary:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      CurrentRelationArc.TypeFailure:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      CurrentChReliability.TypeChange:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      CurrentChReliability.ParChangeMx:=StrToFloat(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));

      Readln(F,St);
      end;

    end;
  CloseFile(f);
  
  //Последовательность включения
  AssignFile(f,'(ActionList)'+NameFile);
  Reset(f);
  While Not EOF (f) do
    begin
    Readln(F,St);
    CurrentGraph:=GraphLevel0;
    //Загрузка элемента
    While St[1]<>':' do
      begin
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
      If (CurrenTStructureNode<>nil) and (St[1]<>':') then
        begin
        CurrentGraph:=CurrenTStructureNode.SubGraph;
        Delete(St,1,pos('@',st));
        end;
      end;
    Delete(St,1,1);
    CurrentAction:=CurrenTStructureNode.AddActionArc(Copy(St,1,pos('@',st)-1));
    CurrentAction.TypeAction:=GoTypeAction(CurrentAction.NameAction);
    Delete(St,1,pos('@',st));
    Time:=Copy(St,1,pos('@',st)-1);
    CurrentAction.TimeAction:=StrToFloat(Time);
    Delete(St,1,pos('@',st));
    Time:=Copy(St,1,pos('@',st)-1);
    CurrentAction.KoefAction:=StrToFloat(Time);
    Delete(St,1,pos('@',st));
    Readln(F,St);
    //Загружаем все, что надо включить перед
    While st[1]<>';' do
      begin
      If St[1]<>'@' then
      begin
        AndGraph:=GraphLevel0;
        While St[1]<>':' do
          begin
          Name:=Copy(St,1,pos('@',st)-1);
          Delete(St,1,pos('@',st));
          AndNode:=AndGraph.SearchNodeName(Name);
          If (AndNode<>nil) and (St[1]<>':') then
            begin
            AndGraph:=AndNode.SubGraph;
            Delete(St,1,pos('@',st));
            end;
          end;
        Delete(St,1,1);
        If St[1]<>'|' then
          begin
          Name:=Copy(St,1,pos('@',st)-1);
          CurrentElementAction:=CurrentAction.AddActionListArc(Name,GoTypeAction(Name),AndNode);
          Delete(St,1,pos('@',st));
          Name:=Copy(St,1,pos('@',st)-1);
          CurrentElementAction.StartToFinish:=StrToInt(Name);
          end
        else
          begin
          CurrentElementAction:=CurrentAction.AddActionListArc('Включение',1,AndNode);
          While Length(st)>1 do
            begin
            Delete(St,1,1);
            AndGraph:=GraphLevel0;
            While St[1]<>':' do
              begin
              Name:=Copy(St,1,pos('@',st)-1);
              Delete(St,1,pos('@',st));
              AndNode:=AndGraph.SearchNodeName(Name);
              If (AndNode<>nil) and (St[1]<>':') then
                begin
                AndGraph:=AndNode.SubGraph;
                Delete(St,1,pos('@',st));
                end;
              end;
            Delete(St,1,1);
            NomNode:=Length(CurrentElementAction.Node);
            SetLength(CurrentElementAction.Node,NomNode+1);
            CurrentElementAction.Node[NomNode]:=AndNode;
            end;
          end;
        end
      else
        begin
        Delete(St,1,1);
        AndGraph:=GraphLevel0;
        While St[1]<>':' do
          begin
          Name:=Copy(St,1,pos('@',st)-1);
          Delete(St,1,pos('@',st));
          AndNode:=AndGraph.SearchNodeName(Name);
          If (AndNode<>nil) and (St[1]<>':') then
            begin
            AndGraph:=AndNode.SubGraph;
            Delete(St,1,pos('@',st));
            end;
          end;
          Delete(St,1,1);
        Name:=Copy(St,1,pos('@',st)-1);
        CurrentAction.AddSearchFailure(AndNode,StrToFloat(Name));
        end;
      Readln(F,St);
      end;

    end;
  CloseFile(f);   

  end;

procedure TGraphStructure.LoadSostGraphFile(NameFile:string);
var
  f:TextFile;
  st:string;
  Name:string;
  CurrenTStructureNode:TStructureNode;
  CurrentGraph:TGraph;
begin
  AssignFile (f,NameFile);
  reset(f);
  While Not EOF(f) do
    begin
    CurrentGraph:=GraphLevel0;
    Readln(f,st);
    //Поиск элемента
    While St[1]<>':' do
      begin
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
      If (CurrenTStructureNode<>nil) and (st[1]<>':') then
        begin
        CurrentGraph:=CurrenTStructureNode.SubGraph;
        Delete(St,1,pos('@',st));
        end
      end;
    Delete(st,1,1);  
    CurrenTStructureNode.SostTime[0]:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    CurrenTStructureNode.SostTime[1]:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    CurrenTStructureNode.SostTime[2]:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    CurrenTStructureNode.SostTime[3]:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    CurrenTStructureNode.BoolSostRegularly:=StrToInt(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    CurrenTStructureNode.BoolSostFailure:=StrToInt(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    CurrenTStructureNode.BoolSostAvailability:=StrToInt(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    end;
end;

Procedure TGraphStructure.SaveGraphFile (NameFile:String);
  begin
  end;

procedure SaveAllTransportGraphTextFile;
  var
    f:TextFile;
    CNode:TTransportNode;
    CAction:TAction;
    NomNs,i:Word;
    st:string;
    CGraph:TGraph;
    CEl:TElementSklad;
  begin
  If FModel.SdSave.Execute then
    begin
    AssignFile(f,FModel.SdSave.FileName);
    Rewrite(f);
    CNode:=FirsTTransportNode;
    While CNode<>nil do
      begin
      St:=CNode.Name+' '+IntToStr(CNode.TypeNode)+' '+IntToStr(CNode.NodeFinish)+' '+FloatToStr(CNode.Par);
      Writeln(f,st);
      St:=' ';
      if Length(CNode.StatProduction)<>0 then
      For I:=0 to Length(CNode.StatProduction)-1 do
        St:=st+CNode.StatProduction[i].Name+' '+FloatToStr(CNode.StatProduction[i].MFailure)+' '+FloatToStr(CNode.StatProduction[i].MRecover);
      Writeln(f,st);
      If CNode.Ns<>nil then
        For NomNS:=0 to Length(CNode.Ns)-1 do
          begin
          St:=CNode.Ns[NomNs].Name+' '+CNode.Ns[NomNs].Nomber+' '+BoolToStr(CNode.Ns[NomNs].GoPeopleService)+' '+BoolToStr(CNode.Ns[NomNs].LoadProduction);
          IF CNode.Ns[NomNs].ListAction.FirstArrayAction<>nil then
            begin
            st:='Action';
            Writeln(f,st);
            CAction:=CNode.Ns[NomNs].ListAction.FirstArrayAction;
            st:='';
            while CAction<>nil do
              begin
              St:=St+' '+CAction.Name;
              CAction:=CAction.NextAction;
              end;
            Writeln(f,st);
            end;
          If Length(CNode.Ns[NomNs].StatistiksNode)<>0 then
            begin
            Writeln(f,'Statistics');
            for i:=0 to Length(CNode.Ns[NomNs].StatistiksNode)-1 do
              begin
              st:=CNode.Ns[NomNs].StatistiksNode[i].NameNode+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].NomFailure)+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].NomRecovery)+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].KolFailure[0])+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].KolRecovery[0]);
              Writeln(f,st);
              St:=FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].TimeOsn[0][0])+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].TimeOsn[1][0])+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].TimeOsn[2][0])+' '+FloatToStr(CNode.Ns[NomNs].StatistiksNode[i].TimeOsn[3][0]);
              Writeln(f,st);
              end;
            end;
           end;
      If CNode.Sklad<>nil then
        begin
        St:='Sklad '+CNode.Sklad.NameElementProcess+' '+FloatTOStr(CNode.Sklad.CostSklad)+' '+FloatTOStr(CNode.Sklad.VolumeSklad);
        Writeln(f,st);
        CEl:=CNode.Sklad.FirstElement;
        While CEl<>nil do
          begin
          St:=St+CEl.Name+' '+IntToStr(CEl.kolvo)+' '+FloatToStr(CEl.TimeWaiting);
          Writeln(f,st);
          CEl:=CEl.NextElement;
          end;
        end;
      If CNode.Manufact<>nil then
        begin
        St:=CNode.Manufact.Name+' '+FloatToStr(CNode.Manufact.MaxPower)+' '+FloatToStr(CNode.Manufact.Power)+' '+FloatToStr(CNode.Manufact.CostProgon);
        Writeln(f,st);
        st:='';
        if Length(CNode.Manufact.ManufactQuery.ArrayProduction)<>0 then
        For i:=0 to Length(CNode.Manufact.ManufactQuery.ArrayProduction)-1 do
          st:=st+CNode.Manufact.ManufactQuery.ArrayProduction[i].NameProduction+' ';
        Writeln(f,st);
        end;
      If CNode.ARZ<>nil then
        begin
        St:=CNode.ARZ.Name+' '+FloatToStr(CNode.ARZ.MaxPower)+' '+FloatToStr(CNode.ARZ.Power)+' '+FloatToStr(CNode.ARZ.CostProgon);
        Writeln(f,st);
        st:='';
        if Length(CNode.ARZ.ManufactQuery.ArrayProduction)<>0 then
        For i:=0 to Length(CNode.ARZ.ManufactQuery.ArrayProduction)-1 do
          st:=st+CNode.ARZ.ManufactQuery.ArrayProduction[i].NameProduction+' ';
        Writeln(f,st);
        end;
      CNode:=CNode.NexTTransportNode;
      end;
    CloseFile(f);
    end;
  end;

Function TGraphStructure.SearchStatistikNode(Node:TStructureNode):TStatistics;
  var
  i:Word;
  begin
  i:=0;
  While (i<Length(StatistiksNode)) and (StatistiksNode[i].NameNode<>Node.Graph.Name+'->'+Node.Name) do
    inc(i);
  If i=Length(StatistiksNode) then
    Result:=nil
  else
    begin
    if StatistiksNode[i].Node=nil then
      StatistiksNode[i].Node:=Node;
    Result:=StatistiksNode[i];
    end;
  end;

Function  TGraphStructure.AddStatisticsNode(Node:TStructureNode):TStatistics;
  var
  n:LongWord;
  begin
  n:=Length(StatistiksNode);
  Inc(n);
  setLength(StatistiksNode,n);
  StatistiksNode[n-1]:=TStatistics.Create;
  StatistiksNode[n-1].NameNode:=Node.Graph.Name+'->'+Node.Name;
  StatistiksNode[n-1].Node:=Node;
  Result:=StatistiksNode[n-1];
  end;

procedure TGraphStructure.NewProgonStat;
  var
    i,j,n:LongWord;
  begin
  n:=Length(StatistiksNode);
  For i:=0 to n-1 do
    begin
    StatistiksNode[i].NomFailure:=0;
    StatistiksNode[i].NomRecovery:=0;
    end;
  end;

Procedure TGraphStructure.SaveStat;
  begin
  Self.GraphLevel0.SaveStatGraph;
  end;

Function TGraphStructure.AddNewProtocol(TypeP:byte; NodeP:TStructureNode):TStatProtocol;
  var
  n:word;
  begin
  n:=Length(StatProtocol);
  Inc(n);
  SetLength(StatProtocol,n);
  StatProtocol[n-1]:=TStatProtocol.Create(TypeP,NodeP);
  NodeP.StatProtocol:=StatProtocol[n-1];
  Result:=StatProtocol[n-1];
  end;

Function TGraphStructure.SearchStatistikProtocol(Node:TStructureNode):TStatProtocol;
  var
  i:Word;
  begin
  i:=0;
  While (i<Length(StatProtocol)) and (StatProtocol[i].NameNode<>Node.Graph.Name+'->'+Node.Name) do
    inc(i);
  If i=Length(StatProtocol) then
    Result:=nil
  else
    begin
    Node.StatProtocol:=StatProtocol[i];
    Result:=StatProtocol[i];
    end;
  end;

Procedure SaveSubGraphExcel(CurrentGraph:TGraph; Level:Word; var Row:LongWord);
  var
  CurrenTStructureNode:TStructureNode;
  i,k:LongWord;
  s:Byte;
  begin
    s:=7;
  IF CurrentGraph<>nil then begin
  CurrenTStructureNode:=CurrentGraph.Node;
  While CurrenTStructureNode<>nil do
    begin
{    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+Level]:=CurrenTStructureNode.Name;
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+1]:=CurrenTStructureNode.Stat.TimeOsn[1,0];
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+2]:=CurrenTStructureNode.Stat.TimeOsn[0,0];
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+3]:=CurrenTStructureNode.Stat.TimeOsn[2,0];
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+4]:=CurrenTStructureNode.Stat.TimeOsn[3,0];

    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+6]:=CurrenTStructureNode.Stat.MaxKolRecovery;

    Inc(Row);
    If CurrenTStructureNode.SubGraph<>nil then
      SaveSubGraphExcel(CurrenTStructureNode.SubGraph,Level+1,Row);
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;}
    end;
    end;
  end;

Procedure TGraphStructure.SaveStatExcel;
  var
  CurrentGraph:TGraph;
  Level:Word;
  Row:LongWord;
  s:Byte;
  begin
    s:=7;
  MsExcel := CreateOleObject('Excel.Application');
  MsExcel.Workbooks.Open['E:\КАФЕДРА\ДИССЕРТАЦИЯ\ПРОГРАММА\Пример1.xls'];
  CurrentGraph:=Self.GraphLevel0;
  row:=1;
  MaxLevel:=6;

    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+1]:='Время работы';
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+2]:='Время Простоя';
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+3]:='Время Отказа';
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+4]:='Время Отсутствия';
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+5]:='Время ИТОГ';
    MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[Row,S+MaxLevel+6]:='Колич Замен';


  row:=2;
  SaveSubGraphExcel(Self.GraphLevel0,1,Row);
  MsExcel.ActiveWorkbook.Close; 
  MsExcel.Application.Quit;

  end;

Procedure TGraphStructure.SaveStatFailureTextFile(NameFile:string);
  var
    i,j,n:LongWord;
    f:TextFile;
    St:string;
  begin
  AssignFile(f,NameFile);
  Rewrite(f);
  n:=Length(StatistiksNode);
  For i:=0 to n-1 do
    IF Length(StatistiksNode[i].ArrayFailure)<>0 then
    begin
    st:=StatistiksNode[i].NameNode+'; M='+FloatToStr(StatistiksNode[i].KolFailure[0])+' D='+FloatToStr(StatistiksNode[i].KolFailure[1]-Sqr(StatistiksNode[i].KolFailure[0]))+'; Max='+IntToStr(Length(StatistiksNode[i].ArrayFailure))+';';
    For j:=0 to Length(StatistiksNode[i].ArrayFailure)-1 do
      begin
      st:=st+' (Do='+FloatTOStr(StatistiksNode[i].ArrayFailure[j].DoubleElement[0])+';Lev='+FloatTOStr(StatistiksNode[i].ArrayFailure[j].LevelOtkaz[0])+'; Time='+FloatTOStr(StatistiksNode[i].ArrayFailure[j].Time[0])+'); ';
      end;
    Writeln(f,st);

    end;
  CloseFile(f);
  end;

procedure TGraphStructure.SaveFailureFile;
  var
    i,j,n:LongWord;
    f:File of TSaveFailure;
    St:TSaveFailure;
    str:string;
  begin
  AssignFile(f,Self.Name+'.par');
  Rewrite(f);
  n:=Length(StatistiksNode);
  For i:=0 to n-1 do
    begin
    str:=StatistiksNode[i].NameNode;
    While Pos('>',str)<>0 do
      Delete(str,1,Pos('>',str));
    st.Name:=str;
//    St.Structure:=Self.Name;
//    St.Graph:=StatistiksNode[i].Node.Graph.Name;
    For j:=0 to 1 do
      St.KolFailure[j]:=StatistiksNode[i].KolFailure[j];
    For j:=0 to 20 do
      St.ArrayHistKolFailure[j]:=StatistiksNode[i].ArrayHistKolFailure[j]/KolProgon;
    Write(f,st);

    end;
  CloseFile(f);
  end;

Procedure TGraphStructure.SaveHistFailureTextFile(NameFile:string);
  var
    i,j,n:LongWord;
    f:TextFile;
    St:string;
  begin
  AssignFile(f,NameFile);
  Rewrite(f);
  n:=Length(StatistiksNode);
  For i:=0 to n-1 do
    begin
    st:=StatistiksNode[i].NameNode+'@';
    For j:=0 to Length(StatistiksNode[i].ArrayHistKolFailure)-1 do
      begin
      st:=st+FloatTOStr(StatistiksNode[i].ArrayHistKolFailure[j]/KolProgon)+'@';
      end;
    Writeln(f,st);

    end;
  CloseFile(f);
  end;

Procedure TGraphStructure.SaveStatRecoveryTextFile(NameFile:string);
  var
    i,j,n:LongWord;
    f:TextFile;
    St:string;
  begin
  AssignFile(f,NameFile);
  Rewrite(f);
  n:=Length(StatistiksNode);
  For i:=0 to n-1 do
    IF Length(StatistiksNode[i].ArrayRecovery)<>0 then
    begin
    st:=StatistiksNode[i].NameNode+'; '+FloatToStr(StatistiksNode[i].KolRecovery[0])+'; '+IntToStr(Length(StatistiksNode[i].ArrayRecovery))+'; ';
    For j:=0 to Length(StatistiksNode[i].ArrayRecovery)-1 do
      begin
      st:=st+FloatTOStr(StatistiksNode[i].ArrayRecovery[j][0])+'; ';
      end;
    Writeln(f,st);

    end;
  CloseFile(f);
  end;

procedure SaveTransportGraphFile(NameFile:String);
  var
    CNode:TTransportNode;
    CArc:TTransportArc;
    F:TextFile;
    St:string;
    i:LongWord;
  begin
  AssignFile(f,NameFile);
  Rewrite(f);
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    St:='n;'+CNode.Name+'@'+FloatToStr(CNode.x)+'@'+FloatToStr(CNode.y)+'@';
    If CNode.Sklad=nil then
      St:=St+'0@'
    else
      St:=St+'1@'+FloatToStr(CNode.Sklad.MaxVolumeSklad)+'@';
    If Length(CNode.Ns)<>0 then
      begin
      St:=st+'1@'+IntToStr(Length(CNode.Ns))+'@';
      for i:=0 to Length(CNode.Ns)-1 do
        St:=St+CNode.Ns[i].Name+'@';
      end;
    IF (CNode.Ns=nil) or (Length(CNode.NS)=0) then
      St:=St+'0@';
    If CNode.Manufact<>nil then
      St:=St+'1@'+CNode.Manufact.Name+'@'
    else
      St:=St+'0@';
    If CNode.ARZ<>nil then
      St:=St+'1@'+CNode.ARZ.Name+'@'
    else
      St:=St+'0@';
    Writeln(f,st);  
    CNode:=CNode.NextTransportNode;
    end;
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    CArc:=CNode.Arc;
    While CArc<>nil do
      begin
      Writeln(f,'a;'+CNode.Name+'@'+IntToStr(CArc.TypeArc)+'@'+FloatToStr(CArc.LengthArc)+'@'+CArc.Node.Name+'@');
      CArc:=CArc.NexTTransportArc;
      end;
    CNode:=CNode.NextTransportNode;
    end;
  CloseFile(f);
  end;

procedure InitializationTransportGraph;
var
  CNode:TTransportNode;
  NomNS:LongWord;

begin
SBS.clear;
TimeTransportProgon:=0;
TimeStorageProgon:=0;
CNode:=FirsTTransportNode;
while CNode<>nil do
  begin
  if Length(CNode.Ns)<>0 then
    For NomNS:=0 to Length(CNode.Ns)-1 do
      begin
      if not CNode.Ns[NomNS].LoadProduction then
        begin
        FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка структуры '+CNode.Ns[NomNS].Name+': '+CNode.Ns[NomNS].Nomber);
        CNode.Ns[NomNS].LoadGraphFile(CNode.Ns[NomNS].Name+'.txt');
        CNode.Ns[NomNS].LoadSostGraphFile(CNode.Ns[NomNS].Name+'@'+CNode.Ns[NomNS].Nomber+'.txt')
        end;

      UMAinStructure.Structure:=CNode.Ns[NomNS];

      CNode.Ns[NomNS].GraphLevel0.Clear;      
      CNode.Ns[NomNS].GoStructureEvent;
      CNode.Ns[NomNS].TransportNode:=CNode;
      end;

  If CNode.Sklad<>nil then
    CNode.Sklad.ClearSklad;
  CNode:=CNode.NexTTransportNode;
  end;
CNode:=FirsTTransportNode;
while CNode<>nil do
  begin
  If CNode.Manufact<>nil then
    begin
    if not CNode.Manufact.LoadProduction then
      begin
      FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка производства '+CNode.Manufact.Name);
      CNode.Manufact.LoadManufactFile(CNode.Manufact.Name+'.txt');
      AddAllProductionGraph(CNode);
      end;
    CNode.Manufact.ClearManufact;
    end;
  If CNode.ARZ<>nil then
    begin
    if not CNode.ARZ.LoadProduction then
      begin
      FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка АРЗ '+CNode.ARZ.Name);
      CNode.ARZ.LoadManufactFile(CNode.ARZ.Name+'.txt');
      AddAllProductionGraph(CNode);
      end;
    CNode.ARZ.ClearManufact;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
end;

procedure FinalizationTransportGraph;
var
  CNode:TTransportNode;
  NomNS:LongWord;

begin
CNode:=FirsTTransportNode;
while CNode<>nil do
  begin
  if Length(CNode.Ns)<>0 then
    For NomNS:=0 to Length(CNode.Ns)-1 do
      CNode.Ns[NomNS].ClearSostStructure;
  If CNode.Manufact<>nil then
    begin
    SetLength(CNode.Manufact.ManufactQuery.ArrayProduction,0);
    CNode.Manufact.Power:=0;
    end;
  If CNode.ARZ<>nil then
    begin
    SetLength(CNode.ARZ.ManufactQuery.ArrayProduction,0);
    CNode.ARZ.Power:=0;
    end;

  CNode:=CNode.NexTTransportNode;
  end;

TimeTransport[1]:=(TimeTransport[1]*(KolProgon-1)+sqr(TimeTransportProgon))/KolProgon;
TimeTransport[0]:=(TimeTransport[0]*(KolProgon-1)+TimeTransportProgon)/KolProgon;
TimeStorage[1]:=(TimeStorage[1]*(KolProgon-1)+sqr(TimeStorageProgon))/KolProgon;
TimeStorage[0]:=(TimeStorage[0]*(KolProgon-1)+TimeStorageProgon)/KolProgon;

If GoProtocolEvent then
 FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   ОЧИСТКА СБС');
Sbs.clear;
end;

procedure TQueryProduction.AddProduction(NewProduction:TProduction; Node:TTransportNode; TimeStart:Double);
  var
    i,j,n:Word;
  begin
  i:=0;
  n:=Length(ArrayProduction);
  If n<>0 then
  begin
  While (i<n) and (not (ArrayProduction[i].GoProcess)) and (ArrayProduction[i].TimeEnd<TimeStart+NewProduction.TimeProduction) do
    Inc(i);
  SetLength(ArrayProduction,n+1);
  If i<>n then
    for j:=n-1 downto i do
      ArrayProduction[j+1]:=ArrayProduction[j];
  end
  else
    SetLength(ArrayProduction,1);
  ArrayProduction[i].NameProduction:=NewProduction.NameProduction;
  ArrayProduction[i].CostProduction:=NewProduction.CostProduction;
  ArrayProduction[i].TimeProduction:=NewProduction.TimeProduction;
  ArrayProduction[i].Node:=Node;
  ArrayProduction[i].TimeEnd:=TimeStart+NewProduction.TimeProduction;
  ArrayProduction[i].GoProcess:=False;
  end;

Procedure TQueryProduction.DelProduction(NameProduction:string);
  var
    i,j,n:Word;
  begin
  i:=0;
  n:=Length(ArrayProduction);
  if n<>0  then
    begin
    while (i<n) and not ((ArrayProduction[i].NameProduction=NameProduction) and (ArrayProduction[i].GoProcess)) do
      Inc(i);
    if i<n then
      begin
      if i<>n-1 then
        for j:=i to n-2 do
          ArrayProduction[j]:=ArrayProduction[j+1];
      SetLength(ArrayProduction,n-1);
      end;
    end;
  end;

procedure TManufact.LoadManufactFile(NameFile:string);
  var
    f:TextFile;
    n:LongWord;
    st:string;
  begin
  AssignFile(f,NameFile);
  Reset(f);
  n:=0;
  LoadProduction:=True;
  Readln(f,st);
  MaxPower:=StrToFloat(st);
  Power:=0;
  While not Eof(f) do
    begin
    Readln(f,st);
    Inc(n);
    SetLength(SetProduction,n);
    SetProduction[n-1]:=TProduction.Create;
    SetProduction[n-1].NameProduction:=Copy(St,1,pos('@',st)-1);
    Delete(St,1,pos('@',st));
    SetProduction[n-1].CostProduction:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    SetProduction[n-1].TimeProduction:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    end;
  CloseFile(F);
  end;

Procedure TManufact.ClearManufact;
var
  i:LongWord;
begin
CostProgon:=0;
For i:=0 to Length(SetProduction)-1 do
  SetProduction[i].KolProductIneration:=0;
end;

Function TManufact.GiveFirstProductionOnPower(Time:Double; var Node:TTransportNode; var NameProduct:String; var TimeProduction,CostProduction:Double):boolean;
var
  i,j,n:Word;
begin
i:=0;
n:=Length(ManufactQuery.ArrayProduction);
While (i<n) and (((ManufactQuery.ArrayProduction[i].GoProcess) or (Time<ManufactQuery.ArrayProduction[i].TimeEnd-ManufactQuery.ArrayProduction[i].TimeProduction)  or (ManufactQuery.ArrayProduction[i].CostProduction/ManufactQuery.ArrayProduction[i].TimeProduction+Power>MaxPower))) do
  inc(i);
If i<n then
  begin
  Power:=Power+ManufactQuery.ArrayProduction[i].CostProduction/ManufactQuery.ArrayProduction[i].TimeProduction;
  ManufactQuery.ArrayProduction[i].GoProcess:=True;
  Node:=ManufactQuery.ArrayProduction[i].Node;
  NameProduct:=ManufactQuery.ArrayProduction[i].NameProduction;
  TimeProduction:=ManufactQuery.ArrayProduction[i].TimeProduction;
  CostProduction:=ManufactQuery.ArrayProduction[i].CostProduction;
  IF ManufactQuery.ArrayProduction[i].NameProduction=ProductionProcessName then
    begin
    n:=Length(TimeProcess);
    SetLength(TimeProcess,n+1);
    TimeProcess[n]:=Time-(ManufactQuery.ArrayProduction[i].TimeEnd-ManufactQuery.ArrayProduction[i].TimeProduction);
    end;

  Result:=True;
  end
else
  Result:=False;
end;

procedure TManufact.GoProductionManufact(NodeCreate:TTransportNode; Time:Double);
var
  Node:TTransportNode;
  NameProduction:string;
  TimeProduction,CostProduction:Double;
  NewEventCreate:TEventCreate;
  i,n:LongWord;
begin
While GiveFirstProductionOnPower(Time,Node,NameProduction,TimeProduction,CostProduction) do
  begin
  If GoProtocolEvent then
    begin
    FModel.MeProt.Lines.Add(' Производство - '+Name+' Мощность - '+FloatToStr(Power)+' Новая ЗЧ - "'+NameProduction+'" Время производства - '+FloatToStr(Time+TimeProduction)+' Склад назначения - '+Node.Name);
    end;
  NewEventCreate:=TEventCreate.Create;
  NewEventCreate.NameProduction:=NameProduction;
  NewEventCreate.TimeProduction:=TimeProduction;
  NewEventCreate.CostProduction:=CostProduction;
  NewEventCreate.NodeCreate:=NodeCreate;
  NewEventCreate.CreateOrRecover:=True;
  NewEventCreate.NodeTransport:=Node;
  NewEventCreate.EventTime:=Time+TimeProduction;
  SBS.AddEvent(NewEventCreate);
  end;
If GoProtocolEvent then
  begin
  n:=Length(ManufactQuery.ArrayProduction);
  if n<>0 then
  for i:=0 to n-1 do
    IF not ManufactQuery.ArrayProduction[i].GoProcess then
    begin
    FModel.MeProt.Lines.Add(' Производство - '+Name+' Очередь на производство: ЗЧ - "'+ManufactQuery.ArrayProduction[i].NameProduction);
    end;
  end;
end;

function TManufact.SearchManufact(NameProduction:string):Word;
var
  NomProduction:word;
begin
If (Self.Name='АРЗ№1') and (NameProduction=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
  for NomProduction:=0 to Length(SetProduction)-1 do
    FModel.MeProt.Lines.Add(IntToStr(NomProduction)+' '+SetProduction[NomProduction].NameProduction);
NomProduction:=0;
While (NomProduction<Length(SetProduction)) and (SetProduction[NomProduction].NameProduction<>NameProduction) do
  Inc(NomProduction);
If NomProduction=Length(SetProduction) then
  NomProduction:=65000;
          If (NameProduction=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
            FModel.MeProt.Lines.Add(IntToStr(NomProduction)+' '+IntToStr(Length(SetProduction)));
Result:=NomProduction;
end;

function TManufact.SearchManufactP(NameProduction:string):TProduction;
var
  NomProduction:word;
begin
NomProduction:=0;
While (NomProduction<Length(SetProduction)) and (SetProduction[NomProduction].NameProduction<>NameProduction) do
  Inc(NomProduction);
If NomProduction<Length(SetProduction) then
  Result:=SetProduction[NomProduction]
end;

Constructor TAction.Create;
  begin
    inherited;
  Node:=nil;
  ListAction:=nil;
  Time:=0;
  KoefAction:=1;
  TypeAction:=0;
  NextAction:=nil;
  end;
Destructor TAction.Destroy;
  begin
//  If GoProtocolEvent then
//    FModel.MeProt.Lines.Add(' УДАЛЯЕМ ДЕЙСТВИЕ ');

  Node:=nil;
  ListAction:=nil;
  Time:=0;
  KoefAction:=1;
  TypeAction:=0;
  NextAction:=nil;
  inherited;
//  Self.Free;
  end;

Constructor TListAction.Create;
  begin
  inherited;
  FirstArrayAction:=nil;
  CurrentArrayAction:=nil;
  Structure:=nil;
  end;
Destructor TListAction.Destroy;
  var
  DelAction:TAction;
  begin
{    If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление Списка действий');
                        }
  CurrentArrayAction:=FirstArrayAction;
  DelAction:=CurrentArrayAction;
  While CurrentArrayAction<>nil do
    begin
    CurrentArrayAction:=CurrentArrayAction.NextAction;
{      If GoProtocolEvent then
      FModel.MeProt.Lines.Add(Structure.NAme+' '+Structure.Nomber+' Удаляем действие '+FloatToStr(DelAction.Time)+' '+DelAction.Name);     }
    FreeAndNil(DelAction);
    DelAction:=CurrentArrayAction;
    end;
  FirstArrayAction:=nil;
  CurrentArrayAction:=nil;
  Structure:=nil;
  inherited;
  end;

Procedure TListAction.AddSbsAction;
  var
  NewEvent:TEventAction;
  begin
//  CurrentArrayAction:=FirstArrayAction;
  If CurrentArrayAction<>nil then
    begin
     NewEvent:=TEventAction.Create;
    NewEvent.Structure:=UMAinStructure.Structure;
    NewEvent.Action:=CurrentArrayAction;
    NewEvent.EventTime:=CurrentArrayAction.Time;
    Sbs.AddEvent(NewEvent);
    CurrentArrayAction:=CurrentArrayAction.NextAction;
    end
  end;
{
procedure TListAction.qSort(l,r:LongInt);
var i,j:LongInt;
    w,q:TAction;
begin
  IF l<r then begin
  i := l; j := r;
  q := ArrayAction[(l+r) div 2];
  repeat
    while (i<r) and (ArrayAction[i].Time < q.Time) do
      inc(i);
    while (j>l) and (q.Time < ArrayAction[j].Time) do
      dec(j);
    if (i <= j) then
      begin
      w:=ArrayAction[i]; ArrayAction[i]:=ArrayAction[j]; ArrayAction[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSort(l,j);
  if (i < r) then qSort(i,r);
  end;
end;
}
Procedure TListAction.SortAction;
  begin
//  qSort(0,Length(ArrayAction)-1);
  end;

Procedure TAction.Go;
  var
    CurrentSearch:TSearchFailure;
    CurrentSearchFailure:TSearchFailure;
  begin
  //Добавление нового действия в список
  ListAction.CurrentArrayAction:=NextAction;
  ListAction.AddSbsAction;
{  CurrentSearch:=Self.ListSearchFailure;
  While Currentsearch<>nil do
    begin
    If CurrentSearch.Go then
      begin
      //Обнаружен отказ элемента
      end;
    CurrentSearch:=CurrentSearch.Create;
    end;}
  UMAinStructure.Structure:=ListAction.Structure;
  Node.GoSwitch(KoefAction,Name,TypeAction);
//  Self.Destroy;
  end;

Procedure TListAction.AddAction(var NewAction:TAction);
  var
  CAction:TAction;
  begin
  CAction:=FirstArrayAction;
  If (CAction=nil) or (CAction.Time>NewAction.Time) then
    begin
    If(CAction<>nil) and (CAction.Time>NewAction.Time) then
      NewAction.NextAction:=FirstArrayAction;
    FirstArrayAction:=NewAction;
    CurrentArrayAction:=FirstArrayAction;
    end
  else
    begin
    While (CAction.NextAction<>nil) and (CAction.NextAction.Time<NewAction.Time) do
      CAction:=CAction.NextAction;
    NewAction.NextAction:=CAction.NextAction;
    CAction.NextAction:=NewAction;
    end;

  end;

Function StrToRandomTypeInt(St:string):LongWord;
var
TypeReliability:Byte;
Par,Par1:Word;
begin
TypeReliability:=StrToInt(Copy(St,1,pos('@',st)-1));
Delete(St,1,pos('@',st));
Case TypeReliability of
  0:begin
    Par:=StrToInt(Copy(St,1,pos('@',st)-1));
    Result:=Par;
    end;
  1:begin end;
  2:begin end;
  3:begin
    Par:=StrToInt(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    Par1:=StrToInt(Copy(St,1,pos('@',st)-1));
    Randomize;
    Result:=Random(Par1-Par)+Par;
    end;
  end;
end;

Function StrToRandomTypeFloat(St:string):Double;
var
TypeReliability:Byte;
Par,Par1,x:Double;
i:byte;
begin
TypeReliability:=StrToInt(Copy(St,1,pos('@',st)-1));
Delete(St,1,pos('@',st));
Case TypeReliability of
  0:begin
    Par:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Result:=Par;
    end;
  1:begin
    Par:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Result:=-ln(Random+0.0000001)/(1-Par);
    end;
  2:begin
    Par:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    Par1:=StrToFloat(Copy(St,1,pos('@',st)-1));
    x:=0;
    Randomize;
    For i:=1 to 50 do
      x:=x+random;
    Result:=Sqrt(Par1)*(X-25)+Par;
    end;
  3:begin

    Par:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));

    Par1:=StrToFloat(Copy(St,1,pos('@',st)-1));

//    Randomize;

    Result:=Random*(Par1-Par)+Par;

    end;
  end;
end;

Procedure StrToActionNode(Structure:TGraphStructure; var St:String; var CurrenTStructureNode:TStructureNode);
var
  Name:String;
  CurrentGraph:TGraph;
begin
  CurrenTStructureNode:=nil;
      CurrentGraph:=Structure.GraphLevel0;
      While St[1]<>':' do
        begin
        Name:=Copy(St,1,pos('@',st)-1);
        Delete(St,1,pos('@',st));
        CurrenTStructureNode:=CurrentGraph.SearchNodeName(Name);
        If (CurrenTStructureNode<>nil) and (St[1]<>':') then
          begin
          CurrentGraph:=CurrenTStructureNode.SubGraph;
          Delete(St,1,pos('@',st));
          end;
        end;
end;

Procedure TListAction.LoadAction(Structure:TGraphStructure; NameFile:String);
  var
  f:TextFile;
  St:string;
  CurrenTStructureNode:TStructureNode;
  NewAction:TAction;
  i,kol:LongWord;
  KolStringBuffer,NomString:Integer;
  StringBuffer: array [-1..20] of String;
  Time,Interval:Double;
  KolAction:LongWord;
  begin
  AssignFile(f,NameFile);
  Reset(f);
//  Self.Structure:=Structure;
  KolAction:=0;
  While Not EOF (f) do
    begin
    Readln(F,St);
    If St='@d' then
      begin
      Readln(F,St);
      NewAction:=TAction.Create;
      NewAction.ListAction:=Self;
      //Загрузка элемента
      StrToActionNode(Structure,St,CurrenTStructureNode);
      Delete(St,1,1);  
      NewAction.Node:=CurrenTStructureNode;
      NewAction.Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      NewAction.Time:=StrToFloat(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      NewAction.TypeAction:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      NewAction.KoefAction:=StrToFloat(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      AddAction(NewAction);

      Inc(KolAction);
      end
    Else If St='@dk' then
      begin
      Readln(F,St);
      //Загрузка элемента
      StrToActionNode(Structure,St,CurrenTStructureNode);
      Readln(F,St);
      //Загрузка действий
      While St<>';' do
        begin
        NewAction:=TAction.Create;
        NewAction.ListAction:=Self;
        NewAction.Node:=CurrenTStructureNode;
        NewAction.Name:=Copy(St,1,pos('@',st)-1);
        Delete(St,1,pos('@',st));
        NewAction.Time:=StrToFloat(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        NewAction.TypeAction:=StrToInt(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        NewAction.KoefAction:=StrToFloat(Copy(St,1,pos('@',st)-1));
        Delete(St,1,pos('@',st));
        AddAction(NewAction);
        Readln(F,St);
        Inc(KolAction);
        end;
      end
    Else If St='@dr' then
      begin
      Readln(F,St);
      If GoProtocolEvent then
      FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка действий структуры '+Structure.Name+': '+Structure.Nomber);
      While st<>';' do
        begin
        //Получение сколько раз
        Kol:=StrToRandomTypeInt(st);
        Readln(F,St);
        KOlStringBuffer:=0;
        for i:=0 to 20 do
          StringBuffer[i]:='';
        While st<>':' do
          begin
          Inc(KOlStringBuffer);
//          SetLength(StringBuffer,KolStringBuffer);
          StringBuffer[KOlStringBuffer-1]:=St;
          Readln(F,St);
          end;
        //Вставка в последовательность
        For i:=1 to KOl do
          begin


          st:=StringBuffer[0];
{           FModel.MeProt.Lines.Add('st');
          If GoProtocolEvent then
           FModel.MeProt.Lines.Add(st);    }
          Time:=StrToRandomTypeFloat(St);


          If Time<MaxTimeModel then
          begin
          NomString:=1;
          While (NomString<20) and (StringBuffer[NomString]<>':@') do
            begin
            st:=StringBuffer[NomString];
            StrToActionNode(Structure,st,CurrenTStructureNode);
            NewAction:=TAction.Create;
            NewAction.ListAction:=Self;
            NewAction.Node:=CurrenTStructureNode;
            Delete(St,1,1);
            NewAction.Name:=Copy(St,1,pos('@',St)-1);
            Delete(St,1,pos('@',St));
            NewAction.Time:=Time;
            NewAction.TypeAction:=StrToInt(Copy(St,1,pos('@',St)-1));
            Delete(St,1,pos('@',St));
            NewAction.KoefAction:=StrToFloat(Copy(St,1,pos('@',St)-1));
            Delete(St,1,pos('@',St));
            AddAction(NewAction);
            inc(NomString);
            Inc(KolAction);
//            If KolAction mod 1000=0 then
//              FMain.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+' Загруженно '+IntToStr(KolAction)+' действий')
 
            end;

          inc(NomString);
          If (NomString<20) and (StringBuffer[NomString]<>'') then
          begin


          st:=StringBuffer[NomString];

{           FModel.MeProt.Lines.Add(IntToStr(NomString));
          If GoProtocolEvent then
           FModel.MeProt.Lines.Add(st);}
          Interval:=StrToRandomTypeFloat(St);


          inc(NomString);
          While(NomString<20) and (StringBuffer[NomString]<>':@') do
            begin
            st:=StringBuffer[NomString];
            StrToActionNode(Structure,St,CurrenTStructureNode);
            NewAction:=TAction.Create;
            NewAction.ListAction:=Self;
            NewAction.Node:=CurrenTStructureNode;
            Delete(St,1,1);
            NewAction.Name:=Copy(St,1,pos('@',St)-1);
            Delete(St,1,pos('@',St));
            NewAction.Time:=Time+interval;
            NewAction.TypeAction:=StrToInt(Copy(St,1,pos('@',St)-1));
            Delete(St,1,pos('@',St));
            NewAction.KoefAction:=StrToFloat(Copy(St,1,pos('@',St)-1));
            Delete(St,1,pos('@',St));
            AddAction(NewAction);
            inc(NomString);
            Inc(KolAction);
//            If KolAction mod 1000=0 then
//              FMain.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+' Загруженно '+IntToStr(KolAction)+' действий')
            end;
          end;
          end;
          end;
        Readln(F,St);
        end;
      end;
    end;
//  Finalize(StringBuffer);
  CloseFile(f);
  If GoProtocolEvent then
    UMain.FModel.MeProt.Lines.Add('Сортировка событий');
  SortAction;
  If GoProtocolEvent then
    UMain.FModel.MeProt.Lines.Add('Добавление события в СБС');
  AddSbsAction;
  end;

procedure AddAllProductionGraph(ProductionNode:TTransportNode);
var
  CNode:TTransportNode;
  i,NomProduct:LongWord;
begin
if ProductionNode.Manufact<>nil then
  begin
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    If Length(CNode.Ns)<>0 then
      begin
      for NomProduct:=0 to Length(ProductionNode.Manufact.SetProduction)-1 do
        begin
        i:=0;
        while (i<Length(CNode.Ns)-1) and (CNode.Ns[i].GraphLevel0<>nil) and (CNode.Ns[i].GraphLevel0.SearchNodeNameAllStructure(ProductionNode.Manufact.SetProduction[NomProduct].NameProduction)=nil) do
          Inc(i);
        If (i<Length(CNode.Ns)-1) and (CNode.Ns[i].GraphLevel0<>nil) then
          CNode.AddProduction(ProductionNode.Manufact.SetProduction[NomProduct]);
        end;
      CNode.SortProduction;
      end;
    CNode:=CNode.NexTTransportNode;
    end;
  end;
if ProductionNode.ARZ<>nil then
  begin
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    If Length(CNode.Ns)<>0 then
      begin
      for NomProduct:=0 to Length(ProductionNode.ARZ.SetProduction)-1 do
        begin
        i:=0;
        while (i<Length(CNode.Ns)-1) and (CNode.Ns[i].GraphLevel0<>nil) and (CNode.Ns[i].GraphLevel0.SearchNodeNameAllStructure(ProductionNode.ARZ.SetProduction[NomProduct].NameProduction)=nil) do
          Inc(i);
        If (i<Length(CNode.Ns)-1) and (CNode.Ns[i].GraphLevel0<>nil) then
          CNode.AddProduction(ProductionNode.ARZ.SetProduction[NomProduct]);
        end;
      CNode.SortProduction;
      end;
    CNode:=CNode.NexTTransportNode;
    end;
  end;
end;

procedure AddAllStatGraphToNode;
var
  CNode:TTransportNode;
  i,NomProduct:LongWord;
  SearchNode:TStructureNode;
begin
If GoSaveHistBool then
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  if Length(CNode.StatProduction)<>0 then
     for NomProduct:=0 to Length(CNode.StatProduction)-1 do
        begin
        If Length(CNode.Ns)<>0 then
        For i:=0 to Length(CNode.Ns)-1 do
        If (CNode.Ns[i].GraphLevel0<>nil) then        
          begin
          SearchNode:=CNode.Ns[i].GraphLevel0.SearchNodeNameAllStructure(CNode.StatProduction[NomProduct].Name);
          IF SearchNode<>nil then
            begin
            CNode.StatProduction[NomProduct].MFailure:=CNode.StatProduction[NomProduct].MFailure+SearchNode.Stat.KolFailure[0];
            CNode.StatProduction[NomProduct].MRecover:=CNode.StatProduction[NomProduct].MRecover+SearchNode.Stat.KolRecovery[0];
            PLusHist(CNode.StatProduction[NomProduct].HistFailure,SearchNode.Stat.ArrayHistKolFailure,CNode.StatProduction[NomProduct].HistFailure);
            PLusHist(CNode.StatProduction[NomProduct].HistRecov,SearchNode.Stat.ArrayHistKolRecovery,CNode.StatProduction[NomProduct].HistRecov);
            end;
          end;
        IF FModel.RgCreateAntGraph.ItemIndex=0 then
          MinusHist(CNode.StatProduction[NomProduct].HistFailure,CNode.StatProduction[NomProduct].HistRecov,CNode.StatProduction[NomProduct].HistItog)
        else
          CopyHist(CNode.StatProduction[NomProduct].HistFailure,CNode.StatProduction[NomProduct].HistItog);
        end;
  CNode:=CNode.NexTTransportNode;        
  end;
end;
end;


procedure TTransportNode.AddProduction(Production:TProduction);
var
  n,i:LongWord;
begin
n:=Length(StatProduction);
i:=0;
While (i<n) and (StatProduction[i].Name<>Production.NameProduction) do
  Inc(i);
IF i=n then
  begin
  SetLength(StatProduction,n+1);
  StatProduction[n].Name:=Production.NameProduction;
  StatProduction[n].Save:=false;
  end;
end;

procedure TTransportNode.AddProductionNameAndHist(NameProduction:string; Hist:THistArr);
var
  n,i,j,nHist:LongWord;
begin
n:=Length(StatProduction);
j:=0;
While (j<n) and (StatProduction[j].Name<>NameProduction) do
  Inc(j);
IF j=n then
  begin
  SetLength(StatProduction,n+1);
  StatProduction[n].Name:=NameProduction;
  StatProduction[n].Save:=false;
  nHist:=Length(Hist);
  SetLength(StatProduction[n].HistItog,nHist);
  for i:=0 to nHist-1 do
    StatProduction[n].HistItog[i]:=Hist[i];
  end
else
  PLusHist(StatProduction[j].HistItog,Hist,StatProduction[j].HistItog);
end;

procedure TTransportNode.SortProduction;
  begin
  qSort(0,Length(StatProduction)-1);
  end;

procedure TTransportNode.qSort(l,r:LongInt);
var i,j:LongInt;
    w,q:TStatProduction;
begin
  IF l<r then begin
  i := l; j := r;
  q := StatProduction[(l+r) div 2];
  repeat
    while (i<r) and (StatProduction[i].Name < q.Name) do
      inc(i);
    while (j>l) and (q.Name < StatProduction[j].Name) do
      dec(j);
    if (i <= j) then
      begin
      w:=StatProduction[i]; StatProduction[i]:=StatProduction[j]; StatProduction[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSort(l,j);
  if (i < r) then qSort(i,r);
  end;
end;

function TTransportNode.SearchDihotomiProductionName(Name:String):LongWord;
  var
    a,b,x:LongWord;

  begin
  a:=0;
  b:=Length(StatProduction)-1;
  x:=a;
  while (a<>b) and (StatProduction[x].Name<>Name) do
    begin
    x:=(a+b) div 2;
    If StatProduction[x].Name>Name then
      b:=x
    else
      a:=x;
    end;
  If StatProduction[x].Name=Name then
    Result:=x
  else
    Result:=MaxInt;
  end;

function TTransportNode.SearchProductionName(Name:String):LongWord;
  begin
  Result:=SearchDihotomiProductionName(Name)
  end;

procedure PlusHist(HistA,HistB:THistArr; var ResultHist:THistArr);
  var
    i,j:LongWord;
    s:LongInt;
  begin
  If Length(HistA)=0 then
    begin
    SetLength(ResultHist,Length(HistB));
    For j:=0 to Length(HistB)-1 do
     ResultHist[j]:=HistB[j];
    end
  else
  If Length(HistB)=0 then
    begin
    SetLength(ResultHist,Length(HistA));
    For j:=0 to Length(HistA)-1 do
     ResultHist[j]:=HistA[j];
    end
  else
    begin
    SetLength(ResultHist,Length(HistA)+Length(HistB)-1);
    for i:=0 to Length(ResultHist)-1 do
      ResultHist[i]:=0;
    for i:=0 to Length(HistA)-1 do
      For j:=0 to Length(HistB)-1 do
        begin
        S:=i+j;
        ResultHist[s]:=ResultHist[s]+HistA[i]*HistB[j];
        end;
    end;
  end;

procedure MinusHist(HistA,HistB:THistArr; var ResultHist:THistArr);
  var
    i,j:word;
    s:integer;
  begin
  SetLength(ResultHist,Length(HistA));
  for i:=0 to Length(ResultHist)-1 do
    ResultHist[i]:=0;
  for i:=0 to Length(HistA)-1 do
      For j:=0 to Length(HistB)-1 do
          begin
          S:=i-j;
          If s<0 then
            s:=0;
          ResultHist[s]:=ResultHist[s]+HistA[i]*HistB[j];
          end;
  end;

Procedure CopyHist(HistA:THistArr; var ResultHist:THistArr);
  var
    i:word;
  begin
  SetLength(ResultHist,Length(HistA));
  for i:=0 to Length(HistA)-1 do
     begin
     ResultHist[i]:=HistA[i];
     end;
  end;

procedure TTransportNode.SborStat;
  var
    NomStructure,NomElementStatistik,NomElementProduction:LongWord;
    CGraph:TGraph;
    CElement:TStructureNode;
  begin
  If Length(Ns)<>0 then
  For NomStructure:=0 to Length(Ns)-1 do
    begin
    For NomElementStatistik:=0 to Length(Ns[NomStructure].StatistiksNode)-1 do
      begin
      NomElementProduction:=SearchDihotomiProductionName(Ns[NomStructure].StatistiksNode[NomElementStatistik].NameNode);
      If NomElementProduction<>MaxInt then
        begin
        PlusHist(StatProduction[NomElementProduction].HistFailure,Ns[NomStructure].StatistiksNode[NomElementStatistik].ArrayHistKolFailure,StatProduction[NomElementProduction].HistFailure);
        PlusHist(StatProduction[NomElementProduction].HistRecov,Ns[NomStructure].StatistiksNode[NomElementStatistik].ArrayHistKolRecovery,StatProduction[NomElementProduction].HistRecov);
        end;
      end;
    end;
  end;

function TTransportNode.SearchStatProductionMax:LongWord;
  var
    Nom,i:LongWord;
    Max:Double;
  begin

  if Length(StatProduction)<>0 then
    begin
    Max:=0;
    Nom:=64000;
    For i:=0 to Length(StatProduction)-1 do
      if (StatProduction[i].MFailure-StatProduction[i].MRecover>Max) and (not StatProduction[i].Save) then
        begin
        Max:=StatProduction[i].MFailure-StatProduction[i].MRecover;
        Nom:=i;
        end;
    Result:=Nom;
    end
  else
    Result:=64000;
  end;

procedure DelAlltransportGraphStructure;
var
  CNode:TTransportNode;
  NomNS,i:Word;
begin
CNode:=FirsTTransportNode;
while CNode<>nil do
  begin
  if Length(CNode.Ns)<>0 then
  For NomNs:=0 to Length(CNode.Ns)-1 do
    begin
    CNode.Ns[NomNS].GraphLevel0.Destroy;
    CNode.Ns[NomNS].MainNode:=nil;
    IF Length(CNode.Ns[NomNS].StatistiksNode)<>0 then
    For i:=0 to Length(CNode.Ns[NomNS].StatistiksNode)-1 do
      FreeAndNil(CNode.Ns[NomNS].StatistiksNode[i]);
    SetLength(CNode.Ns[NomNS].StatistiksNode,0);
    CNode.Ns[NomNS].LoadProduction:=False;
    end;

  CNode:=CNode.NexTTransportNode;
  end;
end;

end.

