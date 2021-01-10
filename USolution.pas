unit USolution;

interface

uses UReliabilityGraph,
     SysUtils,
     Graphics;

type

TElementSolution = record
                   Element:string;                //Требуемый элемент, блок или агрегат
                   NameTransportNode:string;      //Вершина хранения данного элемента
                   Time:Double;
                   TimeCreate:Double;             //Время начала производства элемента
                   Value:Word;                    //Количество элементов
                   end;
TArrayElementSolution = array of TElementSolution;

TElementStatistics = record
                     Element:string;                          //Требуемый элемент, блок или агрегат
                     NameTransportNode:string;                //Вершина хранения данного элемента
                     HistFailure,HistRecov,HistItog:THistArr; //Гистограммы отказов, восстановления и "требования (итоговая)" для данного элемента
                     MFailure,MRecover:Double;                //Математическое ожидания количества отказов и восстановлений данного элемента
                     end;
TArrayElementStatistics = array of TElementStatistics;

TSolutionType = class
            ElementArray:TArrayElementSolution;         //Набор элементов в решении
            TimeEnd,TimeToModel2:Double;                //Времена окончания моделирования
            MKoefGot,MMinKoefGot,MMaxKoefGot,MCost:Double;  //Математические ожидания критериев оптимальности решения
            DKoefGot,DKost:Double;                          //Дисперсии критериев оптимальности решения
            MCostCreate,MCostRecover,MCostTransport,MCostSklad,MCostPersonal:Double;    //Математические ожидания роасписанной стоимости
            KolAgent:LongWord;                              //Количество использованных агентов
            ElementStatisticsArray:TArrayElementStatistics; //статистические требования в решении
            procedure GoSolutionToEvent;
            Procedure GoKoef(TypeGo:Byte; ModelTime:Double);
            Constructor Create;
            Destructor Destroy; override;
            end;

function AddCopySolution(NomSolution:Word):Word;
procedure AddElementSolution(NomSolution:word; Element:string; NameTransportNode:string; TimeCreate,Time:Double; Value:Word);
procedure AddResultToSolution(NomSolution:Word);
procedure AddSolution(NomSolution:Word);
Function ProcSearchSolution(SearchSolution:TArrayElementSolution):Word;
Procedure SaveArraySolutionAsTextFile;
procedure SaveOneSolutionAsTextFile(NameFile:string; NomSolution:LongWord);
procedure LoadArraySolutionAsTextFile;
procedure LoadOneSolutionAsTextFile(NameFile:string; NomSolution:LongWord);
Procedure SortElementArraySolution(ElementArray:TArrayElementSolution);
procedure PaintSolutions(Canvas:TCanvas; Heigth,Weigth:Word; TimeModel1,TimeModel2:Double);
Procedure AddSolutionToParettoSet(NomSolution:Word);
procedure GoParettoSet;
Procedure SortParettoSet;

var
  NameGraphFile:String;
  ArraySolution: array of TSolutionType;
  ParettoSet: array of Word;

implementation

uses  UEventSBS,USBS,
      UTransportGRAPH,
      USklad,
      UMain;

procedure PaintSolutions(Canvas:TCanvas; Heigth,Weigth:Word; TimeModel1,TimeModel2:Double);
var
  NomSolution:word;
  MaxKoefGot,MinKoefGot,MaxCost,MinCost:Double;
  dx,dy:Double;
  x,y,i:Word;
  st:string;
begin
Canvas.MoveTo(20,10);
Canvas.LineTo(20,Heigth-5);
Canvas.MoveTo(15,Heigth-15);
Canvas.LineTo(Weigth-15,Heigth-15);
MaxKoefGot:=0; MaxCost:=0; MinKoefGot:=1000000000000000; MinCost:=1000000000000000;
If Length(ArraySolution)<>0 then
  begin
  For NomSolution:=0 to Length(ArraySolution)-1 do
  if {(ArraySolution[NomSolution].TimeEnd=TimeModel1) and }(ArraySolution[NomSolution].TimeToModel2=TimeModel2) then
    begin
    If ArraySolution[NomSolution].MKoefGot>MaxKoefGot then
      MaxKoefGot:=ArraySolution[NomSolution].MKoefGot;
    If ArraySolution[NomSolution].MKoefGot<MinKoefGot then
      MinKoefGot:=ArraySolution[NomSolution].MKoefGot;
    If ArraySolution[NomSolution].MCost>MaxCost then
      MaxCost:=ArraySolution[NomSolution].MCost;
    If ArraySolution[NomSolution].MCost<MinCost then
      MinCost:=ArraySolution[NomSolution].MCost;
    end;
  dx:=(Weigth-30)/(MaxCost-MinCost+20);
  dy:=(Heigth-30)/(MaxKoefGot-MinKoefGot+0.01);
  For i:=1 to 10 do
    begin
    x:=Trunc((MaxCost-MinCost+20)/10*i*dx);
    Canvas.MoveTo(x,Heigth-10);
    Canvas.LineTo(x,Heigth-20);
    Str((MaxCost-MinCost+20)/10*i+MinCost:8:0,st);
    Canvas.TextOut(x+2,Heigth-14,st);
    y:=Trunc((MaxKoefGot-MinKoefGot+0.01)/10*i*dy);
    Canvas.MoveTo(15,Heigth-y);
    Canvas.LineTo(25,Heigth-y);
    Str((MaxKoefGot-MinKoefGot+0.01)/10*i+MinKoefGot:4:2,st);
    Canvas.TextOut(2,Heigth-y,st);
    end;
  For NomSolution:=0 to Length(ArraySolution)-1 do
  if {(ArraySolution[NomSolution].TimeEnd=TimeModel1) and }(ArraySolution[NomSolution].TimeToModel2=TimeModel2) then
    begin
      x:=20+Trunc((ArraySolution[NomSolution].MCost-MinCost+10)*dx);
      y:=Heigth-15-Trunc((ArraySolution[NomSolution].MKoefGot-MinKoefGot+0.005)*dy);
    Canvas.Ellipse(x-5,y-5,x+5,y+5);
    Canvas.TextOut(x+5,y-5,IntToStr(NomSolution));
    end;
  SortParettoSet;
  If Length(ParettoSet)<>0 then
  For NomSolution:=0 to Length(ParettoSet)-1 do
    begin
      x:=20+Trunc((ArraySolution[ParettoSet[NomSolution]].MCost-MinCost+10)*dx);
      y:=Heigth-15-Trunc((ArraySolution[ParettoSet[NomSolution]].MKoefGot-MinKoefGot+0.005)*dy);
    If NomSolution=0 then
      Canvas.MoveTo(x,y)
    else
      Canvas.LineTo(x,y);
    end;
  end;
end;

Procedure AddSolutionToParettoSet(NomSolution:Word);
var
  Nom,DelNom:Word;
  n:Word;
begin
n:=Length(ParettoSet);
If n=0 then
  begin
  SetLength(ParettoSet,1);
  ParettoSet[0]:=NomSolution;
  end
else
  begin
{  Nom:=0;
  While (Nom<n) and not ((ArraySolution[ParettoSet[Nom]].MKoefGot<ArraySolution[NomSolution].MKoefGot) and (ArraySolution[ParettoSet[Nom]].MCost>ArraySolution[NomSolution].MCost)) do
    Inc(Nom);
  IF(Nom<n) then
    begin
{    DelNom:=0;
    While (DelNom<n) do
      begin
      if (ArraySolution[ParettoSet[DelNom]].MKoefGot<ArraySolution[NomSolution].MKoefGot) and (ArraySolution[ParettoSet[DelNom]].MCost>ArraySolution[NomSolution].MCost) then
        begin
        If DelNom<n-1 then
        For Nom:=DelNom to n-2 do
          ParettoSet[Nom]:=ParettoSet[Nom+1];
        dec(n);
        SetLength(ParettoSet,n);
        end
      else
        inc(DelNom);
      end; }
    Inc(n);
    SetLength(ParettoSet,n);
    ParettoSet[n-1]:=NomSolution;
 //   end;
  end;
end;

Procedure qSortParettoSet(l,r:LongInt);

var i,j:LongInt;
    w:Word;
    q:TSolutionType;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := ArraySolution[ParettoSet[(l+r) div 2]]
  else
    q:=ArraySolution[ParettoSet[l]];
  repeat
    while (i<r) and (ArraySolution[ParettoSet[i]].MKoefGot < q.MKoefGot) do
      inc(i);
    while (j>l) and (q.MKoefGot < ArraySolution[ParettoSet[j]].MKoefGot) do
      dec(j);
    if (i <= j) then
      begin
      w:=ParettoSet[i]; ParettoSet[i]:=ParettoSet[j]; ParettoSet[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortParettoSet(l,j);
  if (i < r) then qSortParettoSet(i,r);
end;

procedure GoParettoSet;
var
  Nom,DelNom:Word;
  n:Word;
begin
  n:=Length(ParettoSet);
  DelNom:=0;
  While (DelNom<n) do
    begin
    If ArraySolution[ParettoSet[DelNom]].KolAgent=0 then
      nom:=DelNom
    else
      begin
      Nom:=0;
      While (Nom<n) and not ((ArraySolution[ParettoSet[DelNom]].MKoefGot<ArraySolution[ParettoSet[Nom]].MKoefGot) and (ArraySolution[ParettoSet[DelNom]].MCost>=ArraySolution[ParettoSet[Nom]].MCost)) do
        inc(Nom);
      end;
    If (Nom<n) then
      begin
      If DelNom<n-1 then
      For Nom:=DelNom to n-2 do
        ParettoSet[Nom]:=ParettoSet[Nom+1];
      dec(n);
      SetLength(ParettoSet,n);
      end
    else
      inc(DelNom);
    end;
end;

Procedure SortParettoSet;
var
  Nom,DelNom:Word;
  n:Word;
begin
n:=Length(ParettoSet);
If n<>0 then
  begin
  qSortParettoSet(0, Length(ParettoSet)-1);
{  DelNom:=n-1;
  While (DelNom>0) do
    begin
    if (ArraySolution[ParettoSet[DelNom-1]].MCost<ArraySolution[ParettoSet[DelNom]].MCost) then
      begin
      If DelNom<n-1 then
      For Nom:=DelNom to n-2 do
        ParettoSet[Nom]:=ParettoSet[Nom+1];
      dec(n);
      SetLength(ParettoSet,n);
      end;
    dec(DelNom);
    end;}
  end;
end;

procedure TSolutionType.GoSolutionToEvent;
  var
   // NewEvent:TEventCreate;
   NodeCreate,NodeTransport:TTransportNode;
    NomEvent,KolValue,NomProduction:Word;
    TimeCreateProduction:Double;
  begin
  If Length(ElementArray)<>0 then
  For NomEvent:=0 to Length(ElementArray)-1 do
    If ElementArray[NomEvent].Value<>0 then
    For KolValue:=1 to ElementArray[NomEvent].Value do
      begin
      //Ищем предприятие для производства
      NodeCreate:=SearchCreateNode(ElementArray[NomEvent].Element);
      NodeTransport:=SearchNodeName(ElementArray[NomEvent].NameTransportNode);
      //Добавляем В очередь на производство
      NomProduction:=NodeCreate.Manufact.SearchManufact(ElementArray[NomEvent].Element);
      TimeCreateProduction:=ElementArray[NomEvent].TimeCreate{-NodeCreate.Manufact.Production[NomProduction].TimeProduction-SearchMinTime(NodeCreate,NodeTransport)};
      If TimeCreateProduction<0 then
        TimeCreateProduction:=0;

      NodeCreate.Manufact.ManufactQuery.AddProduction(NodeCreate.Manufact.SetProduction[NomProduction],NodeTransport,TimeCreateProduction);
     // NodeCreate.Manufact.GoProductionManufact(NodeCreate,SearchNodeName(ElementArray[NomEvent].NameTransportNode),ElementArray[NomEvent].Time);
{      NewEvent:=TEventCreate.Create;
      NewEvent.NodeTransport:=SearchNodeName(ElementArray[NomEvent].NameTransportNode);
      NewEvent.NodeCreate:=SearchCreateNode(ElementArray[NomEvent].Element);
      NewEvent.Production:=NewEvent.NodeCreate.Manufact.SearchManufactP(ElementArray[NomEvent].Element);
      NewEvent.EventTime:=ElementArray[NomEvent].Time; }
//      TimeTransportProgon:=TimeTransportProgon+ElementArray[NomEvent].TimeCreate-ElementArray[NomEvent].Time;
//      Sbs.AddEvent(NewEvent);
      end;
  end;

Procedure TSolutionType.GoKoef(TypeGo:Byte; ModelTime:Double);
  var
    CNode,ManufactNode:TTransportNode;
    NomNs,NomElement,NomProduction:Word;
    Element:TElementSklad;
    i:Byte;
    KG,KG1:Double;
    KolNs:Word;
    st:string;
    ArrayKGAllVichickle:array of Double;
    nArrayKG,iArrayKG,jArrayKG,NKG:LongWord;
  begin
  st:='Стоимость ППО = ';
  CNode:=FirsTTransportNode;
  MKoefGot:=0;
  MCost:=0;
  KolNs:=0;
  MMinKoefGot:=1;
  MMaxKoefGot:=0;
  nArrayKG:=0;
  While CNode<>nil do
    begin
    If Length(CNode.Ns)<>0 then
    for NomNs:=0 to Length(CNode.Ns)-1 do
      begin
      nArrayKG:=Length(ArrayKGAllVichickle);
      NKG:=Length(CNode.Ns[NomNs].MainNode.ArrayKG);
      SetLength(ArrayKGAllVichickle,nArrayKG+NKG);
      Kg1:=0;
      for iArrayKG:=0 to NKG-1 do
        begin
        ArrayKGAllVichickle[nArrayKG+iArrayKG]:=CNode.Ns[NomNs].MainNode.ArrayKG[iArrayKG];
        KG1:=Kg1+CNode.Ns[NomNs].MainNode.ArrayKG[iArrayKG];
        end;
      KG1:=KG1/NKG;

//        FModel.MeProt.Lines.Add(CNode.Ns[NomNs].Name+' '+CNode.Ns[NomNs].Nomber+' KGot='+FloatToStr((CNode.Ns[NomNs].MainNode.Stat.TimeOsn[0][0]+CNode.Ns[NomNs].MainNode.Stat.TimeOsn[1][0])/ModelTime)+' '+FloatToStr(ModelTime));
//      for i:=0 to 3 do
//        FModel.MeProt.Lines.Add(FloatToStr(CNode.Ns[NomNs].MainNode.Stat.TimeOsn[i][0]));
      Inc(KolNs);
      KG:=(CNode.Ns[NomNs].MainNode.Stat.TimeOsn[0][0]+CNode.Ns[NomNs].MainNode.Stat.TimeOsn[1][0])/ModelTime;
      If MMinKoefGot>KG then
        MMinKoefGot:=KG;
      If MMaxKoefGot<KG then
        MMaxKoefGot:=KG;
      MKoefGot:=MKoefGot+KG;
      DKoefGot:=DKoefGot+(CNode.Ns[NomNs].MainNode.Stat.TimeOsn[0][1]+CNode.Ns[NomNs].MainNode.Stat.TimeOsn[1][1])/ModelTime-Sqr(KG);
      end;

    If CNode.Sklad<>nil then
      begin
      Element:=CNode.Sklad.FirstElement;
      While Element<>nil do
        begin
        MCosT:=MCost+Element.TimeWaiting*CNode.Sklad.CostSklad;
        Element:=Element.NextElement;
        end;
      end;
    CNode:=CNode.NexTTransportNode;
    end;

  st:=st+' Хранение ='+FloatToStr(MCosT);
  MCostSklad:=MCosT;

  ManufactNode:=FirsTTransportNode;
  While (ManufactNode<>nil) do
    begin
    If (ManufactNode.Manufact<>nil) then
      begin
      MCost:=MCost+ManufactNode.Manufact.CostProgon;
      st:=st+' Производство ='+FloatToStr(ManufactNode.Manufact.CostProgon);
      MCostCreate:=MCostCreate+ManufactNode.Manufact.CostProgon;
      end;

    If (ManufactNode.ARZ<>nil) then
      begin
      MCost:=MCost+ManufactNode.ARZ.CostProgon;
      st:=st+' АРЗ ='+FloatToStr(ManufactNode.ARZ.CostProgon);
      MCostRecover:=MCostRecover+ManufactNode.ARZ.CostProgon;
      end;

    ManufactNode:=ManufactNode.NexTTransportNode;
    end;


  MKoefGot:=MKoefGot/KolNs;
  MCost:=MCost+TimeTransport[0]*CostTransport+MaxPeopleService*CostService*ModelTime;
  st:=st+' Транспорт ='+FloatToStr(TimeTransport[0]*CostTransport);
  MCostTransport:=TimeTransport[0]*CostTransport;
  st:=st+' Персонал ='+FloatToStr(MaxPeopleService*CostService*ModelTime);
  MCostPersonal:=MaxPeopleService*CostService*ModelTime;
  FModel.MeProt.Lines.Add(st);
  end;

Procedure qSortElementArraySolution(ElementArray:TArrayElementSolution; l,r:LongInt);

var i,j:LongInt;
    w,q:TElementSolution;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := ElementArray[(l+r) div 2]
  else
    q:=ElementArray[l];
  repeat
    while (i<r) and ((ElementArray[i].NameTransportNode < q.NameTransportNode) or ((ElementArray[i].NameTransportNode = q.NameTransportNode) and (ElementArray[i].Element < q.Element))) do
      inc(i);
    while (j>l) and ((q.NameTransportNode < ElementArray[j].NameTransportNode) or ((ElementArray[j].NameTransportNode = q.NameTransportNode) and (q.Element < ElementArray[j].Element))) do
      dec(j);
    if (i <= j) then
      begin
      w:=ElementArray[i]; ElementArray[i]:=ElementArray[j]; ElementArray[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortElementArraySolution(ElementArray,l,j);
  if (i < r) then qSortElementArraySolution(ElementArray,i,r);
end;

Procedure SortElementArraySolution(ElementArray:TArrayElementSolution);
begin
If Length(ElementArray)<>0 then
qSortElementArraySolution(ElementArray,0, Length(ElementArray)-1);
end;

function AddCopySolution(NomSolution:Word):Word;
  var
    n,NElement:Word;
    NomElement:Word;
  begin
  if (Length(ArraySolution)>NomSolution) then
    begin
    n:=Length(ArraySolution);
    SetLength(ArraySolution,n+1);
    ArraySolution[n]:=TSolutionType.Create;
    ArraySolution[n].TimeEnd:=ArraySolution[NomSolution].TimeEnd;
    ArraySolution[n].TimeToModel2:=ArraySolution[NomSolution].TimeToModel2;
    NElement:=Length(ArraySolution[NomSolution].ElementArray);
    If NElement<>0 then
      begin
      SetLength(ArraySolution[n].ElementArray,NElement);
      For NomElement:=0 to NElement-1 do
        begin
        ArraySolution[n].ElementArray[NomElement].Element:= ArraySolution[NomSolution].ElementArray[NomElement].Element;
        ArraySolution[n].ElementArray[NomElement].NameTransportNode:= ArraySolution[NomSolution].ElementArray[NomElement].NameTransportNode;
        ArraySolution[n].ElementArray[NomElement].Time:= ArraySolution[NomSolution].ElementArray[NomElement].Time;
        ArraySolution[n].ElementArray[NomElement].TimeCreate:= ArraySolution[NomSolution].ElementArray[NomElement].TimeCreate;
        ArraySolution[n].ElementArray[NomElement].Value:= ArraySolution[NomSolution].ElementArray[NomElement].Value;
        end;
      end;
    result:=n;
    end;
  end;

procedure AddElementSolution(NomSolution:word; Element:string; NameTransportNode:string; TimeCreate,Time:Double; Value:Word);
  var
    n:Word;
  begin
  if (Length(ArraySolution)>NomSolution) then
    begin
    n:=Length(ArraySolution[NomSolution].ElementArray);
    SetLength(ArraySolution[NomSolution].ElementArray,n+1);
    ArraySolution[NomSolution].ElementArray[n].Element:=Element;
    ArraySolution[NomSolution].ElementArray[n].NameTransportNode:=NameTransportNode;
    ArraySolution[NomSolution].ElementArray[n].TimeCreate:=TimeCreate;
    ArraySolution[NomSolution].ElementArray[n].Time:=Time;
    ArraySolution[NomSolution].ElementArray[n].Value:=Value;        
    end;
  end;

procedure AddResultToSolution(NomSolution:Word);
  var
    CNode:TTransportNode;
    KolStat:Word;
    NomStatProduction,NomHist,n:Word;
  begin
  if (Length(ArraySolution)>NomSolution) then
    begin
    KolStat:=0;
    CNode:=FirsTTransportNode;
    While CNode<>nil do
      begin
      If Length(CNode.StatProduction)<>0 then
      for NomStatProduction:=0 to Length(CNode.StatProduction)-1 do
        begin
        SetLength(ArraySolution[NomSolution].ElementStatisticsArray,KolStat+1);
        ArraySolution[NomSolution].ElementStatisticsArray[KolStat].NameTransportNode:=CNode.Name;
        ArraySolution[NomSolution].ElementStatisticsArray[KolStat].Element:=CNode.StatProduction[NomStatProduction].Name;
        ArraySolution[NomSolution].ElementStatisticsArray[KolStat].MFailure:=CNode.StatProduction[NomStatProduction].MFailure;
        ArraySolution[NomSolution].ElementStatisticsArray[KolStat].MRecover:=CNode.StatProduction[NomStatProduction].MRecover;
        n:=Length(CNode.StatProduction[NomStatProduction].HistFailure);
        SetLength(ArraySolution[NomSolution].ElementStatisticsArray[KolStat].HistFailure,n);
        If n<>0 then
        for NomHist:=0 to n-1 do
          ArraySolution[NomSolution].ElementStatisticsArray[KolStat].HistFailure[NomHist]:=CNode.StatProduction[NomStatProduction].HistFailure[NomHist];
        n:=Length(CNode.StatProduction[NomStatProduction].HistRecov);
        SetLength(ArraySolution[NomSolution].ElementStatisticsArray[KolStat].HistRecov,n);
        If n<>0 then
        for NomHist:=0 to n-1 do
          ArraySolution[NomSolution].ElementStatisticsArray[KolStat].HistRecov[NomHist]:=CNode.StatProduction[NomStatProduction].HistRecov[NomHist];
        n:=Length(CNode.StatProduction[NomStatProduction].HistItog);
        SetLength(ArraySolution[NomSolution].ElementStatisticsArray[KolStat].HistItog,n);
        If n<>0 then
        for NomHist:=0 to n-1 do
          ArraySolution[NomSolution].ElementStatisticsArray[KolStat].HistItog[NomHist]:=CNode.StatProduction[NomStatProduction].HistItog[NomHist];

        Inc(KolStat);
        end;
      CNode:=CNode.NexTTransportNode;
      end;
    end;
  end;

procedure AddSolution(NomSolution:Word);
  var
    NomElement:Word;
    NomElementStatistics:Word;
    NomHist,NHist:Word;
    Node:TTransportNode;
  begin
  if (Length(ArraySolution)>NomSolution) and (Length(ArraySolution[NomSolution].ElementStatisticsArray)<>0) then
  for NomElement:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray)-1 do
    begin
    Node:=SearchNodeName(ArraySolution[NomSolution].ElementStatisticsArray[NomElement].NameTransportNode);
    NomElementStatistics:=Node.SearchProductionName(ArraySolution[NomSolution].ElementStatisticsArray[NomElement].Element);
    Node.StatProduction[NomElementStatistics].MFailure:=ArraySolution[NomSolution].ElementStatisticsArray[NomElement].MFailure;
    Node.StatProduction[NomElementStatistics].MRecover:=ArraySolution[NomSolution].ElementStatisticsArray[NomElement].MRecover;
    NHist:=Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElement].HistFailure);
    If NHist<>0 then
      begin
      SetLength(Node.StatProduction[NomElementStatistics].HistFailure,NHist);
      for NomHist:=0 to NHist-1 do
        Node.StatProduction[NomElementStatistics].HistFailure[NomHist]:=ArraySolution[NomSolution].ElementStatisticsArray[NomElement].HistFailure[NomHist];
      end;
    NHist:=Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElement].HistRecov);
    If NHist<>0 then
      begin
      SetLength(Node.StatProduction[NomElementStatistics].HistRecov,NHist);
      for NomHist:=0 to NHist-1 do
        Node.StatProduction[NomElementStatistics].HistRecov[NomHist]:=ArraySolution[NomSolution].ElementStatisticsArray[NomElement].HistRecov[NomHist];
      end;
    NHist:=Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElement].HistItog);
    If NHist<>0 then
      begin
      SetLength(Node.StatProduction[NomElementStatistics].HistItog,NHist);
      for NomHist:=0 to NHist-1 do
        Node.StatProduction[NomElementStatistics].HistItog[NomHist]:=ArraySolution[NomSolution].ElementStatisticsArray[NomElement].HistItog[NomHist];
      end;
    end;
  end;

Function ProcSearchSolution(SearchSolution:TArrayElementSolution):Word;
  var
    NomSolution,NomElement,NextNomElement,KolTrueElement:Word;
    SearchTrue:Boolean;
  begin
  NomSolution:=0;
  SearchTrue:=False;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Поиск решения');
  While (not SearchTrue) and (NomSolution<Length(ArraySolution)) do
    begin
    NomElement:=0;
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Выбрано решение №'+IntToStr(NomSolution));
    If Length(ArraySolution[NomSolution].ElementArray)<>0 then
      begin
      While (NomElement<Length(ArraySolution[NomSolution].ElementArray)) and
             ((ArraySolution[NomSolution].ElementArray[NomElement].Element=SearchSolution[NomElement].Element)
             and (ArraySolution[NomSolution].ElementArray[NomElement].NameTransportNode=SearchSolution[NomElement].NameTransportNode)
//             and (ArraySolution[NomSolution].ElementArray[NomElement].Time=SearchSolution[NomElement].Time)
             and (ArraySolution[NomSolution].ElementArray[NomElement].TimeCreate=SearchSolution[NomElement].TimeCreate)
             and (ArraySolution[NomSolution].ElementArray[NomElement].Value=SearchSolution[NomElement].Value)) do
         begin
         Inc (NomElement);
         If (GoProtocolEvent) and (NomElement<Length(ArraySolution[NomSolution].ElementArray)) then
         begin
         FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Элемент №'+IntToStr(NomSolution)+' Граф -'+ArraySolution[NomSolution].ElementArray[NomElement].NameTransportNode+' Имя -'+ArraySolution[NomSolution].ElementArray[NomElement].Element+' Кол-во ='+IntToStr(ArraySolution[NomSolution].ElementArray[NomElement].Value)+' Время ='+FloatToStr(ArraySolution[NomSolution].ElementArray[NomElement].Time));
         FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Основной   '+IntToStr(NomSolution)+' Граф -'+SearchSolution[NomElement].NameTransportNode+' Имя -'+SearchSolution[NomElement].Element+' Кол-во ='+IntToStr(SearchSolution[NomElement].Value)+' Время ='+FloatToStr(SearchSolution[NomElement].Time));
         end;
         end;
      If GoProtocolEvent then
      FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  NomElement= '+FloatToStr(NomElement)+' Length(ArraySolution[NomSolution].ElementArray)='+IntToStr(Length(ArraySolution[NomSolution].ElementArray)));
      SearchTrue:=NomElement=Length(ArraySolution[NomSolution].ElementArray);
      If (GoProtocolEvent) and (SearchTrue) then
      FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  SearchTrue= true');
      end;
    If not SearchTrue then
      Inc(NomSolution);
    end;
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  SearchTrue= '+BoolToStr(SearchTrue)+' NomSolution= '+IntTostr(NomSolution));
  IF SearchTrue then
    Result:=NomSolution
  else
    Result:=6400;
  end;

Procedure SaveArraySolutionAsTextFile;
  var
    F:TextFile;
    NomSolution,NomElementArray,NomHist:Word;
    st:string;
  begin
  AssignFile(F,NameGraphFile+'(Solution).txt');
  Rewrite(f);
  If Length(ArraySolution)<>0 then
  For NomSolution:=0 to Length(ArraySolution)-1 do
    begin
    Writeln(f,'@S');
    Writeln(f,FloatToStr(ArraySolution[NomSolution].TimeEnd));
    Writeln(f,FloatToStr(ArraySolution[NomSolution].TimeToModel2));
    Writeln(f,FloatToStr(ArraySolution[NomSolution].MKoefGot));
    Writeln(f,FloatToStr(ArraySolution[NomSolution].MCost));
    If Length(ArraySolution[NomSolution].ElementArray)<>0 then
    For NomElementArray:=0 to Length(ArraySolution[NomSolution].ElementArray)-1 do
      begin
      St:=FloatToStr(ArraySolution[NomSolution].ElementArray[NomElementArray].Time)+';'+ArraySolution[NomSolution].ElementArray[NomElementArray].NameTransportNode+';'+ArraySolution[NomSolution].ElementArray[NomElementArray].Element+';'+IntToStr(ArraySolution[NomSolution].ElementArray[NomElementArray].Value)+';'+FloatToStr(ArraySolution[NomSolution].ElementArray[NomElementArray].TimeCreate);
      Writeln(f,st);
      end;
    Writeln(f,'@ArrStat');
    If Length(ArraySolution[NomSolution].ElementStatisticsArray)<>0 then
    For NomElementArray:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray)-1 do
      begin
      Writeln(f,'@Element');
      Writeln(f,ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].NameTransportNode);
      Writeln(f,ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].Element);
      st:='';
      IF Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistFailure)<>0 then
      For NomHist:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistFailure)-1 do
        st:=st+FloatToStr(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistFailure[NomHist])+';';
      Writeln(f,st);
      st:='';
      IF Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistRecov)<>0 then
      For NomHist:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistRecov)-1 do
        st:=st+FloatToStr(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistRecov[NomHist])+';';
      Writeln(f,st);
      st:='';
      IF Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistItog)<>0 then
      For NomHist:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistItog)-1 do
        st:=st+FloatToStr(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistItog[NomHist])+';';
      Writeln(f,st);
      end;
    Writeln(f,'@EndSolution');
    end;
  CloseFile(f);
  end;

procedure SaveOneSolutionAsTextFile(NameFile:string; NomSolution:LongWord);
  var
    F:TextFile;
    NomElementArray,NomHist:Word;
    st:string;
  begin
  AssignFile(F,NameFile);
  Rewrite(f);
    Writeln(f,'@S');
    Writeln(f,FloatToStr(ArraySolution[NomSolution].TimeEnd));
    Writeln(f,FloatToStr(ArraySolution[NomSolution].TimeToModel2));
    Writeln(f,FloatToStr(ArraySolution[NomSolution].MKoefGot));
    Writeln(f,FloatToStr(ArraySolution[NomSolution].MCost));
    If Length(ArraySolution[NomSolution].ElementArray)<>0 then
    For NomElementArray:=0 to Length(ArraySolution[NomSolution].ElementArray)-1 do
      begin
      St:=FloatToStr(ArraySolution[NomSolution].ElementArray[NomElementArray].Time)+';'+ArraySolution[NomSolution].ElementArray[NomElementArray].NameTransportNode+';'+ArraySolution[NomSolution].ElementArray[NomElementArray].Element+';'+IntToStr(ArraySolution[NomSolution].ElementArray[NomElementArray].Value)+';'+FloatToStr(ArraySolution[NomSolution].ElementArray[NomElementArray].TimeCreate);
      Writeln(f,st);
      end;
    Writeln(f,'@ArrStat');
    If Length(ArraySolution[NomSolution].ElementStatisticsArray)<>0 then
    For NomElementArray:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray)-1 do
      begin
      Writeln(f,'@Element');
      Writeln(f,ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].NameTransportNode);
      Writeln(f,ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].Element);
      st:='';
      IF Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistFailure)<>0 then
      For NomHist:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistFailure)-1 do
        st:=st+FloatToStr(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistFailure[NomHist])+';';
      Writeln(f,st);
      st:='';
      IF Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistRecov)<>0 then
      For NomHist:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistRecov)-1 do
        st:=st+FloatToStr(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistRecov[NomHist])+';';
      Writeln(f,st);
      st:='';
      IF Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistItog)<>0 then
      For NomHist:=0 to Length(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistItog)-1 do
        st:=st+FloatToStr(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray].HistItog[NomHist])+';';
      Writeln(f,st);
    Writeln(f,'@EndSolution');
    end;
  CloseFile(f);
  end;

procedure LoadArraySolutionAsTextFile;
  var
    F:TextFile;
    St:string;
    NomSolution,NomElementArray,NomHist:Word;
  begin
  AssignFile(f,NameGraphFile+'(Solution).txt');
  Reset(f);
  NomSolution:=0;
  While not Eof(f) do
    begin
    Readln(f,st);
    if St='@S' then
      begin
      Inc(NomSolution);
      SetLength(ArraySolution,NomSolution);
      Readln(f,st);
      ArraySolution[NomSolution-1].TimeEnd:=StrToFloat(St);
      Readln(f,st);
      ArraySolution[NomSolution-1].TimeToModel2:=StrToFloat(St);
      Readln(f,st);
      ArraySolution[NomSolution-1].MKoefGot:=StrToFloat(St);
      Readln(f,st);
      ArraySolution[NomSolution-1].MCost:=StrToFloat(St);
      Readln(f,st);
      NomElementArray:=0;
      while St<>'@ArrStat' do
        begin
        inc(NomElementArray);
        SetLength(ArraySolution[NomSolution-1].ElementArray,NomElementArray);
        ArraySolution[NomSolution-1].ElementArray[NomElementArray-1].Time:=StrToFloat(Copy(St,1,pos(';',st)-1));
        Delete(St,1,pos(';',st));
        ArraySolution[NomSolution-1].ElementArray[NomElementArray-1].NameTransportNode:=Copy(St,1,pos(';',st)-1);
        Delete(St,1,pos(';',st));
        ArraySolution[NomSolution-1].ElementArray[NomElementArray-1].Element:=Copy(St,1,pos(';',st)-1);
        Delete(St,1,pos(';',st));
        ArraySolution[NomSolution-1].ElementArray[NomElementArray-1].Value:=StrToInt(Copy(St,1,pos(';',st)-1));
        Readln(f,st);
        end;
      Readln(f,st);
      NomElementArray:=0;
      while St<>'@EndSolution' do
        begin
        Readln(f,st);        
//        While St<>'@Element' do
//          begin
          inc(NomElementArray);
          SetLength(ArraySolution[NomSolution-1].ElementStatisticsArray,NomElementArray);
          ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].NameTransportNode:=st;
          Readln(f,ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].Element);
          NomHist:=0;
          Readln(f,st);
          While Pos(';',St)<>0 do
            begin
            Inc(NomHist);
            SetLength(ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].HistFailure,NomHist);
            ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].HistFailure[NomHist-1]:=StrToFloat(Copy(St,1,pos(';',st)-1));
            Delete(St,1,pos(';',st));
            end;
          NomHist:=0;
          Readln(f,st);
          While Pos(';',St)<>0 do
            begin
            Inc(NomHist);
            SetLength(ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].HistRecov,NomHist);
            ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].HistRecov[NomHist-1]:=StrToFloat(Copy(St,1,pos(';',st)-1));
            Delete(St,1,pos(';',st));
            end;
          NomHist:=0;
          Readln(f,st);
          While Pos(';',St)<>0 do
            begin
            Inc(NomHist);
            SetLength(ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].HistItog,NomHist);
            ArraySolution[NomSolution-1].ElementStatisticsArray[NomElementArray-1].HistItog[NomHist-1]:=StrToFloat(Copy(St,1,pos(';',st)-1));
            Delete(St,1,pos(';',st));
            end;
        Readln(f,st);            
//          end;
        end;
      end;
    end;
  CloseFile(f);
  end;

procedure LoadOneSolutionAsTextFile(NameFile:string; NomSolution:LongWord);
  var
    F:TextFile;
    St:string;
    NomElementArray,NomHist:Word;
  begin
  AssignFile(f,NameFile);
  Reset(f);
  While not Eof(f) do
    begin
    Readln(f,st);
    if St='@S' then
      begin
      Readln(f,st);
      ArraySolution[NomSolution].TimeEnd:=StrToFloat(St);
      Readln(f,st);
      ArraySolution[NomSolution].TimeToModel2:=StrToFloat(St);
      Readln(f,st);
      ArraySolution[NomSolution].MKoefGot:=StrToFloat(St);
      Readln(f,st);
      ArraySolution[NomSolution].MCost:=StrToFloat(St);
      Readln(f,st);
      NomElementArray:=0;
      while St<>'@ArrStat' do
        begin
        inc(NomElementArray);
        SetLength(ArraySolution[NomSolution].ElementArray,NomElementArray);
        ArraySolution[NomSolution].ElementArray[NomElementArray-1].Time:=StrToFloat(Copy(St,1,pos(';',st)-1));
        Delete(St,1,pos(';',st));
        ArraySolution[NomSolution].ElementArray[NomElementArray-1].NameTransportNode:=Copy(St,1,pos(';',st)-1);
        Delete(St,1,pos(';',st));
        ArraySolution[NomSolution].ElementArray[NomElementArray-1].Element:=Copy(St,1,pos(';',st)-1);
        Delete(St,1,pos(';',st));
        ArraySolution[NomSolution].ElementArray[NomElementArray-1].Value:=StrToInt(Copy(St,1,pos(';',st)-1));
        Readln(f,st);
        end;
      Readln(f,st);
      NomElementArray:=0;
      while St<>'@EndSolution' do
        begin
        Readln(f,st);        
//        While St<>'@Element' do
//          begin
          inc(NomElementArray);
          SetLength(ArraySolution[NomSolution].ElementStatisticsArray,NomElementArray);
          ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].NameTransportNode:=st;
          Readln(f,ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].Element);
          NomHist:=0;
          Readln(f,st);
          While Pos(';',St)<>0 do
            begin
            Inc(NomHist);
            SetLength(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].HistFailure,NomHist);
            ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].HistFailure[NomHist-1]:=StrToFloat(Copy(St,1,pos(';',st)-1));
            Delete(St,1,pos(';',st));
            end;
          NomHist:=0;
          Readln(f,st);
          While Pos(';',St)<>0 do
            begin
            Inc(NomHist);
            SetLength(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].HistRecov,NomHist);
            ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].HistRecov[NomHist-1]:=StrToFloat(Copy(St,1,pos(';',st)-1));
            Delete(St,1,pos(';',st));
            end;
          NomHist:=0;
          Readln(f,st);
          While Pos(';',St)<>0 do
            begin
            Inc(NomHist);
            SetLength(ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].HistItog,NomHist);
            ArraySolution[NomSolution].ElementStatisticsArray[NomElementArray-1].HistItog[NomHist-1]:=StrToFloat(Copy(St,1,pos(';',st)-1));
            Delete(St,1,pos(';',st));
            end;
        Readln(f,st);            
//          end;
        end;
      end;
    end;
  CloseFile(f);
  end;

constructor TSolutionType.Create;
  begin
    inherited;
  SetLength(ElementArray,0);
  SetLength(ElementStatisticsArray,0);
  TimeEnd:=0;
  TimeToModel2:=0;
  MKoefGot:=0;
  MCost:=0;
  KolAgent:=0;
  MMinKoefGot:=1;
  MMaxKoefGot:=0;
  MCostCreate:=0;MCostRecover:=0;MCostTransport:=0;MCostSklad:=0;MCostPersonal:=0;
  end;
destructor TSolutionType.Destroy;
  begin
    Finalize(ElementArray);
    Finalize(ElementStatisticsArray);
    inherited;
  end;

end.
