unit UMainModel2;

interface

uses USbs,UEventSBS,UTransportGRAPH, ComObj, SysUtils;

type
  TRecover = record
       Node:TTransportNode;
       Name:string;
       Time:Double;
       TimeFailure,TimeCost:Double;
       end;
  TPlanRecover = Class
     NameSolution:string;
     PlanRecover: array of TRecover;
     TimeFailure,TimeWaiting:Double;
     TimeFailureOb,TimeWaitingOb:Double;
     ParSolution:Double;
     NodeNameArray:array of string;
     Complete:Boolean;
     function GoMaxTime(nom:LongWord; bElement:Boolean):LongWord;
     procedure GoTimeOb(nom:LongWord);
     Procedure DeleteRecover(Name:String; Node:TTransportNode);
     constructor Create;
     destructor Destroy;  override;
     end;
  TSolution = Class
    Recover:array of TPlanRecover;
    OptimumSolution:word;
    function SearchOptimumSolution:TPlanRecover;
    Procedure CopyRecover(NomRecover:LongWord);
    constructor Create;
     destructor Destroy;  override;
    end;
  Tmass=array of Double;
  Tmatrix=array of Tmass;
  ArrayZnat = array of array [0..1] of Double;
  ArrayDet = array [0..2] of double;

  TKolElement = record
                name:string;
                Kol:LongWord;
                end;
  TArrKolElement = array of TKolElement;


procedure AddRecoverEvent(Node:TTransportNode; Name:string; Time:Double; FlagEndModel:Boolean);
procedure AddAllRecoverTime(Recover:TPlanRecover; Node:TTransportNode; ElementName:string);
//Procedure GoAllRecoverTime(Ns:TNS; Element:TElementNS);
procedure GoParametrElement (Recover:TPlanRecover; Node:TTransportNode; NomNS:LongWord; NameElement:String; Par:Double; i:Word; var EndTime,TimeFailure,TimeWaiting:Double);
procedure GoKoefParabola(m:ArrayZnat;var a:ArrayDet);
function Opr(n:Word; a:tmatrix):Double;
Procedure ClearRecoverSost(EndTime:Double);
procedure ClearGraph;
procedure DoProgon(Recover:TPlanRecover; NameElement:string);
procedure SaveElementGraphTime(NameElement:string; var TF,TW:Double);
procedure SaveAllGraphTime(var TF,TW:Double);
Procedure VivodZnat(Recover:TPlanRecover; Node:TTransportNode; ElementName:string);

var
  Solution:TSolution;
  PlanRecover: TPlanRecover;
  NomExcel,NomExcel1:LongWord;
  NomModel2:LongWord;
  KolNotChangeIterMode2:LongWord;
  Koef:Double;
  ModelEndTime:Double;
  MaxKolElement:TArrKolElement;

const
  delt = 12;

implementation

uses UMain, USklad;

constructor TPlanRecover.Create;
  begin
  SetLength(PlanRecover,0);
  NameSolution:='';
  Complete:=False;
  end;

destructor TPlanRecover.Destroy;
  var
    i:LongWord;
  begin
  For i:=0 to Length(PlanRecover)-1 do
    PlanRecover[i].Node:=nil;
  SetLength(PlanRecover,0);
  inherited;
  end;

constructor TSolution.Create;
  begin
  SetLength(Recover,0);
  OptimumSolution:=0;
  end;

destructor TSolution.Destroy;
  var
    i:LongWord;
  begin
  For i:=0 to Length(Recover)-1 do
    FreeAndNil(Recover[i]);
  SetLength(Recover,0);
  OptimumSolution:=0;
  inherited;
  end;

Procedure TSolution.CopyRecover(NomRecover:LongWord);
  var
    n,k,i,sk,nsk:LongWord;
    NewPlan:TPlanRecover;
  begin
  n:=Length(Recover);
  SetLength(Recover,n+1);
  NewPlan:=TPlanRecover.Create;
  NewPlan.NameSolution:='Ðåøåíèå ¹'+IntToStr(n);
  Recover[n]:=NewPlan;
  k:=Length(Recover[NomRecover].PlanRecover);
  SetLength(NewPlan.PlanRecover,k);
  sk:=0;
  SetLength(NewPlan.NodeNameArray,0);
  For i:=0 to k-1 do
    begin
 {   nsk:=0;
    IF sk<>0 then
      begin
      While (nsk<sk) and (Recover[NomRecover].PlanRecover[i].Name+'->'+Recover[NomRecover].PlanRecover[i].Node.Name<>NewPlan.NodeNameArray[nsk]) do
        Inc(nsk);
      end;
    If (sk=0) or (nsk=sk) then
      begin
      Inc(sk);
      SetLength(NewPlan.NodeNameArray,sk);
      NewPlan.NodeNameArray[sk-1]:=Recover[NomRecover].PlanRecover[i].Name+'->'+Recover[NomRecover].PlanRecover[i].Node.Name;
      end;    }
    NewPlan.PlanRecover[i].Node:=Recover[NomRecover].PlanRecover[i].Node;
    NewPlan.PlanRecover[i].Name:=Recover[NomRecover].PlanRecover[i].Name;
    NewPlan.PlanRecover[i].Time:=Recover[NomRecover].PlanRecover[i].Time;
    NewPlan.PlanRecover[i].TimeFailure:=Recover[NomRecover].PlanRecover[i].TimeFailure;
    NewPlan.PlanRecover[i].TimeCost:=Recover[NomRecover].PlanRecover[i].TimeCost;                
    end;
  end;

function TSolution.SearchOptimumSolution:TPlanRecover;
  var
    i:LongWord;
    Min:double;
    NomMin:LongWord;
  begin
  Writeln(f);
  min:=100000000000000000;
  NomMin:=0;
  For i:=0 to Length(Recover)-1 do
    begin
    Writeln(f,Recover[i].NameSolution+': '+FloatToStr(Recover[i].TimeFailureOb*koef+Recover[i].TimeWaiting*(1-koef)));
    Recover[i].ParSolution:=Recover[i].TimeFailureOb*koef+Recover[i].TimeWaiting*(1-koef);
    if (not Recover[i].Complete) and (Recover[i].TimeFailureOb*koef+Recover[i].TimeWaiting*(1-koef)<min) then
      begin
      min:=Recover[i].TimeFailureOb*koef+Recover[i].TimeWaiting*(1-koef);

      NomMin:=i;
      end;
    end;
  Self.OptimumSolution:=NomMin;
  result:=Recover[nomMin];
  end;

Procedure TPlanRecover.DeleteRecover(Name:String; Node:TTransportNode);
  var
    i,j,n:LongInt;

  begin
  n:=Length(PlanRecover);
  i:=0;
  while i<n do
    begin
    if (PlanRecover[i].Name=Name) and (PlanRecover[i].Node=Node) then
      begin
      Dec(n);
      If i<>n then
        begin
        for j:=i to n-1 do
          PlanRecover[j]:=PlanRecover[j+1];
        end;
      SetLength(PlanRecover,n);
      dec(i);
      end;
    inc(i);
    end;
 { i:=0;
  n:=Length(NodeNameArray);
  while (i<n) and (NodeNameArray[i]<>Name+'->'+Node.name) do
    Inc(i);
  If i<>n then
    begin
    If i<>n-1 then
      begin
      j:=i;
      While j<n-1 do
        begin
        NodeNameArray[j]:=NodeNameArray[j+1];
        inc(j);
        end;
      end;
    SetLength(NodeNameArray,n-1);
    end;
             }
  end;

procedure TPlanRecover.GoTimeOb(nom:LongWord);
  var
    CNode:TTransportNode;
    NomNs:LongWord;
  begin
  CNode:=FirsTTransportNode;

  While CNode<>nil do
    begin
    If Length(CNode.Ns)<>0 then
    For NomNs:=0 to Length(CNode.Ns)-1 do
      begin
      if NomExcel=1 then
        begin
//        TimeFailureOb:=TimeFailureOb+CNode.Ns[NomNs].TimeFailure;
//        TimeWaitingOb:=TimeWaitingOb+CNode.Ns[NomNs].TimeWaiting;
        end
      else
        begin
//        TimeFailureOb:=(TimeFailureOb*(nom-1)+CNode.Ns[NomNs].TimeFailure)/nom;
//        TimeWaitingOb:=(TimeWaitingOb*(nom-1)+CNode.Ns[NomNs].TimeWaiting)/nom;
        end;
      end;
    CNode:=CNode.NexTTransportNode;
    end;
  end;

function TPlanRecover.GoMaxTime(nom:LongWord; bElement:Boolean):LongWord;
  var
    i,j,s,sk,k,n,NomMax:LongWord;
    max:Double;
    ArrName:array of string;
    ArrNode:array of TTransportNode;
    bEnter:Boolean;
    bNodeName:Boolean;
    KolNodeName:LongWord;
    bSearch:Boolean;
  begin
  SetLength(ArrName,0);
  SetLength(ArrNode,0);
  n:=Length(PlanRecover);
{  IF bElement then
    begin
    TimeFailure:=0;
    TimeWaiting:=0;
    end;  }
  max:=0;
  NomMax:=0;
  bSearch:=False;
  sk:=Length(NodeNameArray);
  for i:=n-1 downto 1 do
    begin
    benter:=False;
    If Length(ArrName)<>0 then
    for j:=0 to Length(ArrName)-1 do
      if (ArrName[j]=PlanRecover[i].Name) and (ArrNode[j]=PlanRecover[i].Node) then
        begin
        bEnter:=True;
        Break;
        end;
    If not bEnter then
      begin
      k:=Length(ArrName);
      Inc(k);
      SetLength(ArrName,k);
      SetLength(ArrNode,k);
      ArrName[k-1]:=PlanRecover[i].Name;
      ArrNode[k-1]:=PlanRecover[i].Node;
      if not bElement then
      If nom=1 then
        begin
        TimeFailure:=TimeFailure+PlanRecover[i].TimeFailure;
        TimeWaiting:=TimeWaiting+PlanRecover[i].TimeCost;
        end
      else
        begin
        TimeFailure:=(TimeFailure*(nom-1)+PlanRecover[i].TimeFailure)/nom;
        TimeWaiting:=(TimeWaiting*(nom-1)+PlanRecover[i].TimeCost)/nom;
        end;
      If (bElement) and (PlanRecover[i].TimeFailure*koef+PlanRecover[i].TimeCost*(1-koef)>max) then
        begin
        bNodeName:=False;
        KolNodeName:=0;
        if Length(NodeNameArray)<>0 then
        for s:=0 to sk-1 do
          If NodeNameArray[s]='n '+PlanRecover[i].Name then
            begin
            bNodeName:=True;
            Inc(KolNodeName);
            end;
        if not bNodeName then
          begin
          max:=PlanRecover[i].TimeFailure*koef+PlanRecover[i].TimeCost*(1-koef);
          NomMax:=i;
          bSearch:=True;
          end;
        end;
      end;
    end;
  If (bElement) and (max=0) then
    begin
    Complete:=True;
    Writeln(f,'Ðåøåíèå çàâåðøåíî');
    end;
{  If (bSearch) AND (bElement)  then
    begin
    Inc(sk);
    SetLength(NodeNameArray,sk);
    self.NodeNameArray[sk-1]:=PlanRecover[NomMax].Node.Name+'->'+PlanRecover[NomMax].Name
    end;      }
  result:=NomMax;
  end;

procedure ClearGraph;
var
  CNode:TTransportNode;
  NomNs:LongWord;
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  If Length(CNode.Ns)<>0 then
  For NomNs:=0 to Length(CNode.Ns)-1 do
    begin
    CNode.NS[NomNs].ClearSostStructure;
    SBS.clear;
    CNode.NS[NomNs].GoStructureEvent;
    end;
  if CNode.Sklad<>nil then
    begin
    CNode.Sklad.ClearElementSklad;
    end;
  CNode:=CNode.nexTTransportNode;
  end;
end;

procedure SaveAllGraphTime(var TF,TW:Double);
var
  CNode:TTransportNode;
  Element:TElementNS;
  ElementSklad:TElementSklad;
  NomNs:LongWord;
begin
TF:=0;
TW:=0;
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  If Length(CNode.Ns)<>0 then
  For NomNs:=0 to Length(CNode.Ns)-1 do
    begin
//    Element:=CNode.NS[NomNs].FirstElement;
    While Element<>nil do
      begin
      TF:=TF+Element.TimeFailure;
      Element:=Element.NextElement;
      end;
    end;
  if CNode.Sklad<>nil then
    begin
    ElementSklad:=CNode.Sklad.FirstElement;
    while ElementSklad<>nil do
      begin
      Tw:=Tw+ElementSklad.TimeWaiting;
      ElementSklad:=ElementSklad.NextElement;
      end;

    end;
  CNode:=CNode.nexTTransportNode;
  end;
end;

procedure SaveElementGraphTime(NameElement:string; var TF,TW:Double);
var
  CNode:TTransportNode;
  Element:TElementNS;
  ElementSklad:TElementSklad;
  NomNS:LongWord;
begin
TF:=0;
TW:=0;
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  If Length(CNode.Ns)<>0 then
  For NomNs:=0 to Length(CNode.Ns)-1 do
    begin
//    Element:=CNode.NS[NomNs].SearchElementName(NameElement);
    If Element<>nil then
      begin
      TF:=TF+Element.TimeFailure;
      end;
    end;
  if CNode.Sklad<>nil then
    begin
    ElementSklad:=CNode.Sklad.SearchElement(NameElement);
    If ElementSklad<>nil then
      Tw:=Tw+ElementSklad.TimeWaiting;
    end;
  CNode:=CNode.nexTTransportNode;
  end;
end;


procedure DoProgon(Recover:TPlanRecover; NameElement:string);
var
  Recov,j:LongWord;
  EndModel:boolean;
  EndTime:Double;
begin
Sbs:=TQueueEvent.Create;
ClearGraph;
if Length(Recover.PlanRecover)<>0 then
  For Recov:=0 to Length(Recover.PlanRecover)-1 do
    AddRecoverEvent(Recover.PlanRecover[Recov].Node,Recover.PlanRecover[Recov].Name,Recover.PlanRecover[Recov].Time,False);
//j:=0;
while (SBS.FirstEvent<>nil) and (SBS.ModelTime<ModelEndTime) do
  begin
{  IF (SBS.FirstEvent is TEventFailure) and ((SBS.FirstEvent as TEventFailure).Element.name=NameElement) then
    Inc(j);                   }
  ProcessingEvent(EndTime);
  end;
//VivodSostGraph;
ClearRecoverSost(EndTime);
//SBS.clear;
FreeAndNil(SBS);
end;

procedure GoParametrElement (Recover:TPlanRecover; Node:TTransportNode; NomNS:LongWord; NameElement:String; Par:Double; i:Word; var EndTime,TimeFailure,TimeWaiting:Double);
  var
    j,Kol,Recov:Word;
    Element:TElementNS;
    ElementSklad:TElementSklad;
    Ns:TGraphStructure;
    CNode:TTransportNode;
    TF,TW:Double;
    EndModel:Boolean;
//    Sbs:TQueueEvent;
  begin
    TimeFailure:=0;
    TimeWaiting:=0;
    IF Length(Node.Ns)=0 then
      NS:=nil
    else
      Ns:=Node.Ns[NomNS];
    for kol:=1 to NomModel2 do
      begin
      Sbs:=TQueueEvent.Create;
      If Ns<>nil then
        begin


//        Ns.Node.Sklad.ClearElementSklad;
        end
      else
        ClearGraph;

      if Length(Recover.PlanRecover)<>0 then
        For Recov:=0 to Length(Recover.PlanRecover)-1 do
          if ((Node.Ns=nil) or (Node.Ns<>nil) and (Recover.PlanRecover[Recov].Node=Node)) and (Recover.PlanRecover[Recov].Name=NameElement) then
            AddRecoverEvent(Recover.PlanRecover[Recov].Node,Recover.PlanRecover[Recov].Name,Recover.PlanRecover[Recov].Time,False);
      AddRecoverEvent(Node,NameElement,Par,True);
      j:=0;
      EndModel:=False;
      while (not EndModel) and (SBS.FirstEvent<>nil) and (SBS.ModelTime<ModelEndTime) do
        begin
{        IF (Node.Ns<>nil) and (SBS.FirstEvent is TEventFailure) and ((SBS.FirstEvent as TEventFailure).Element.name=NameElement) and ((SBS.FirstEvent as TEventFailure).Element.NS=Node.Ns) then
          Inc(j);}
        ProcessingEvent(EndTime);
{        If j=i+1 then
          begin
          EndTime:=SBS.ModelTime;
//          Break;
          end;    }
        end;

      ClearRecoverSost(EndTime);

      If Ns<>nil then
        begin
//        Element:=NS.SearchElementName(NameElement);
        TF:=Element.TimeFailure;
//        ElementSklad:=Ns.Node.Sklad.SearchElement(NAmeElement);
        If ElementSklad=nil then
          TW:=0
        else
        TW:=ElementSklad.TimeWaiting;
        end
      else
        begin
        SaveElementGraphTime(NameElement,TF,TW);
        end;
      If Kol=1 then
        begin
        TimeFailure:=TF;
        TimeWaiting:=TW;
        end
      else
        begin
        TimeFailure:=(TimeFailure*(Kol-1)+TF)/kol;
        TimeWaiting:=(TimeWaiting*(Kol-1)+TW)/kol;
        end;

    //  SBS.clear;
      FreeAndNil(SBS);
      end;
  end;

function GoMemory:LongWord;
begin
  Result:=(AllocMemSize);
end;

Procedure VivodToExcel (Name:string; Par, Nom,TimeFailure,TimeWaiting,EndTime:Double);
begin
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,1]:=GoMemory;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,2]:=Name;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,3]:=Nom;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,4]:=Par;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,5]:=TimeFailure;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,6]:=TimeWaiting;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,7]:=EndTime;
    inc(NomExcel);
end;

procedure VivodKoefExcel(koef:ArrayDet);
begin
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,11]:=koef[0];
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,12]:=koef[1];
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,13]:=koef[2];
end;
{
Procedure GoAllRecoverTime(Ns:TNS; Element:TElementNS);
  var
    a,b:Double;
    M1,M2:Double;
    m:ArrayZnat;
    koef:ArrayDet;
    n:LongWord;
  begin
  MsExcel := CreateOleObject('Excel.Application');
  MsExcel.Workbooks.Open['E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð2.xls'];
  MsExcel.DisplayAlerts := false;
  a:=800;
  b:=1800;
  SetLength(m,0);
  n:=0;
  While a<=1500 do
    begin
    inc(NomExcel);
    GoParametrElement (NS.Node,Element.name,a,1,b,M1,M2);
    Inc(n);
    SetLength(m,n);
    m[n-1][0]:=a;
    m[n-1][1]:=M1;
    if n >5 then
      begin
      GoKoefParabola(m,koef);
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,10]:=koef[0];
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,11]:=koef[1];
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,12]:=koef[2];
      end;
    FModel.MeProt.Lines.Add('  a='+FloatToStr(a));
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,1]:=GoMemory;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,2]:=Element.Name;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,3]:=a;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,4]:=M1;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,5]:=M2;
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,6]:=b;

    MsExcel.Workbooks[1].saveAS('E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð3.xls');
    a:=a+15;
    end;
    GoKoefParabola(m,koef);
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[1,10]:=koef[0];
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[1,11]:=koef[1];
    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[1,12]:=koef[2];
 MsExcel.Workbooks[1].saveAS('E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð3.xls');
    MsExcel.ActiveWorkbook.Close;
  MsExcel.Application.Quit;
  end;
    }
Procedure VivodZnat(Recover:TPlanRecover; Node:TTransportNode; ElementName:string);
var
  j,n:LongWord;
  z:Double;
  m:ArrayZnat;
  koefApr:ArrayDet;
  MOshA:Double;
  MNerA:Double;
begin
    MsExcel := CreateOleObject('Excel.Application');
  MsExcel.Workbooks.Open['E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð2.xls'];
  MsExcel.DisplayAlerts := false;
    n:=0;
    For j:=0 to 200 do
      begin
//      FModel.MeProt.Lines.Add(Node.Name+' '+ElementName+' '+'  2000*0.005*j='+FloatToStr(2000*0.005*j));
      GoParametrElement (Recover,Node,0,ElementName,2000*0.005*j,1,z,MNerA,MOshA);
      VivodToExcel (ElementName,2000*0.05*j,1,MNerA,MOshA,0);
      Inc(n);
      SetLength(m,n);
      m[n-1][0]:=2000*0.005*j;
      m[n-1][1]:=MNerA*koef+MOshA*(1-koef);
      end;
    GoKoefParabola(m,koefApr);
    VivodKoefExcel(koefApr);
    MsExcel.Workbooks[1].saveAS('E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð3.xls');
    MsExcel.ActiveWorkbook.Close;
    MsExcel.Application.Quit;
end;

procedure AddAllRecoverTime(Recover:TPlanRecover; Node:TTransportNode; ElementName:string);
  var
    i,j,n,kolarr,kz:LongWord;
    Kol:Word;
    a,b,z,x1,x2,k,a1,b1:Double;
    Mx1,mx2:Double;
    MOshA,MOshB,MOshX1,MOshX2:Double;
    MNerA,MNerB,MNerX1,MNerX2:Double;
    m:ArrayZnat;
    koefApr:ArrayDet;
    TF,TW:Double;
    NomElement:LongWord;
  begin
//  MsExcel := CreateOleObject('Excel.Application');
//  MsExcel.Workbooks.Open['E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð2.xls'];
//  MsExcel.DisplayAlerts := false;
  n:=Length(Recover.NodeNameArray);
  SetLength(Recover.NodeNameArray,n+1);
  Recover.NodeNameArray[n]:=ElementName+'->'+Node.Name;
  NomElement:=0;
  while (NomElement<Length(MaxKolElement)) and (MaxKolElement[NomElement].Name<>ElementName) do
    Inc(NomElement);

  x1:=0;
  x2:=0;
  a:=0;
  b:=0;
  i:=0;
  While i<MaxKolElement[NomElement].Kol do
    begin
    Inc(i);
    SetLength(m,0);
    n:=0;
    GoParametrElement (Recover,Node,0,ElementName,a,i,b,MNerA,MOshA);
    b:=ModelEndTime;
//    VivodToExcel (Element.Name,a,i,MNerA,MOshA,b);
    Inc(n);
    SetLength(m,n);
    m[n-1][0]:=a;
    m[n-1][1]:=MNerA*koef+MOshA*(1-koef);
    FModel.MeProt.Lines.Add(Node.Name+' '+ElementName+' '+intToStr(i)+'  a='+FloatToStr(a)+'  b='+FloatTOStr(b));
    For j:=1 to 20 do
      begin
      GoParametrElement (Recover,Node,0,ElementName,a+(b-a)*0.05*j,i,z,MNerA,MOshA);
      FModel.MeProt.Lines.Add(Node.Name+' '+ElementName+' '+intToStr(i)+'  a+(b-a)*0.05*j='+FloatToStr(a+(b-a)*0.05*j)+' MNerA='+FloatToStr(MNerA)+' MOshA='+FloatToStr(MOshA));
//      VivodToExcel (Element.Name,a+(b-a)*0.05*j,i,MNerA,MOshA,b);
      Inc(n);
      SetLength(m,n);
      m[n-1][0]:=a+(b-a)*0.05*j;
      m[n-1][1]:=MNerA*koef+MOshA*(1-koef);
      end;
    GoKoefParabola(m,koefApr);
//    VivodKoefExcel(koefApr);
    While abs(b-a)>delt do
      begin
      x1:=abs(b+a)/2-delt/3;
      GoParametrElement (Recover,Node,0,ElementName,x1,i,z,MNerX1,MOshX1);
//      VivodToExcel (Element.Name,x1,i,MNerX1,MOshX1,z);
      Inc(n);
      SetLength(m,n);
      m[n-1][0]:=x1;
      m[n-1][1]:=MNerX1*koef+MOshX1*(1-koef);
      GoKoefParabola(m,koefApr);
//      VivodKoefExcel(koefApr);
      Mx1:=koefApr[0]*Sqr(x1)+koefApr[1]*x1+koefApr[2];
//      MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,8]:=Mx1;

      x2:=abs(b+a)/2+delt/3;
      GoParametrElement (Recover,Node,0,ElementName,x2,i,z,MNerX2,MOshX2);
//      VivodToExcel (Element.Name,x2,i,MNerX2,MOshX2,z);
      m[n-1][0]:=x2;
      m[n-1][1]:=MNerX2*koef+MOshX2*(1-koef);
      GoKoefParabola(m,koefApr);
//      VivodKoefExcel(koefApr);
      Mx2:=koefApr[0]*Sqr(x2)+koefApr[1]*x2+koefApr[2];
//      MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel,8]:=Mx2;

      FModel.MeProt.Lines.Add(Node.Name+' '+ElementName+' '+intToStr(i)+'  a='+FloatToStr(a)+'  b='+FloatTOStr(b)+'  x1='+FloatToStr(x1)+'  x2='+FloatTOStr(x2));

      IF MX2<=MX1 then
        begin
        A:=x1;
        MNerA:=MNerX1;
        MOshA:=MOshX1;
        end
      else
        begin
        B:=x2;
        MNerB:=MNerX2;
        MOshB:=MOshX2;
        end;
      end;
    n:=length(Recover.PlanRecover);
    inc(n);
    SetLength(Recover.PlanRecover,n);
    Recover.PlanRecover[n-1].Node:=Node;
    Recover.PlanRecover[n-1].Name:=ElementName;
    Recover.PlanRecover[n-1].Time:=abs(b+a)/2;
    Recover.PlanRecover[n-1].TimeFailure:=MNerX2;
    Recover.PlanRecover[n-1].TimeCost:=MOshX2;
   { For kz:=1 to KolNotChangeIterMode2 do
    begin
    DoProgon(Recover,ElementName);

    SaveAllGraphTime(TF,TW);
    if kz=1 then
      begin
      Recover.PlanRecover[n-1].TimeFailure:=TF;
      Recover.PlanRecover[n-1].TimeCost:=TW;
      end
    else
      begin
      Recover.PlanRecover[n-1].TimeFailure:=(Recover.PlanRecover[n-1].TimeFailure*(kz-1)+TF)/kz;
      Recover.PlanRecover[n-1].TimeCost:=(Recover.PlanRecover[n-1].TimeCost*(kz-1)+TW)/kz;
      end;
//    Recover.GoMaxTime(k,False);    //Âû÷èñëåíèå ñóìàðíîãî âðåìåíè
    end;           }
//    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel1,20]:=Element.Name;
//    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel1,21]:=i;
//    MsExcel.Workbooks[1].WorkSheets['Ëèñò1'].Cells[NomExcel1,22]:=abs(b+a)/2;
    Inc(NomExcel1);
//    MsExcel.Workbooks[1].saveAS('E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð3.xls');
    end;
//    MsExcel.Workbooks[1].saveAS('E:\ÊÀÔÅÄÐÀ\ÄÈÑÑÅÐÒÀÖÈß\ÏÐÎÃÐÀÌÌÀ ÌÎÄÅËÜ ¹2\Ïðèìåð3.xls');
//  MsExcel.ActiveWorkbook.Close;
//  MsExcel.Application.Quit;
  end;

Procedure ClearRecoverSost(EndTime:Double);
var
  CurrenTTransportNode:TTransportNode;
  CurrentElement:TElementNS;
  NomNS:LongWord;
begin
CurrenTTransportNode:=firsTTransportNode;
While CurrenTTransportNode<>nil do
  begin
  If Length(CurrenTTransportNode.Ns)<>0 then
  For NomNS:=0 to Length(CurrenTTransportNode.Ns)-1 do
    begin
{    If CurrenTTransportNode.Ns[NomNS].Failure=1 then
      CurrenTTransportNode.Ns[NomNS].TimeFailure:=CurrenTTransportNode.Ns[NomNS].TimeFailure+EndTime-CurrenTTransportNode.Ns[NomNS].LastTime;
    CurrenTTransportNode.Ns[NomNS].Failure:=0;
    CurrentElement:=CurrenTTransportNode.Ns[NomNS].FirstElement;
    while CurrentElement<>nil do
      begin
      If CurrentElement.Failure=1 then
        CurrentElement.TimeFailure:=CurrentElement.TimeFailure+EndTime-CurrentElement.LastTime;
      CurrentElement.Failure:=0;
      CurrentElement:=CurrentElement.NextElement;
      end;}
    end;
{  If CurrenTTransportNode.Sklad<>nil then
    begin

    end;}
  CurrenTTransportNode:=CurrenTTransportNode.NexTTransportNode;
  end;
end;

procedure AddRecoverEvent(Node:TTransportNode; Name:string; Time:Double; FlagEndModel:Boolean);
  var
    Event:TEventAddElement;
  begin
  Event:=TEventAddElement.Create;
  Event.Name:=Name;
  Event.Node:=Node;
  Event.FlagEndModel:=FlagEndModel;
  Event.EventTime:=Time;
  Sbs.AddEvent(Event);
  end;

procedure GoKoefParabola(m:ArrayZnat; var a:ArrayDet);
var
  i,j,s,n:LongInt;
  y,x,x2,x3,x4,yx,yx2,det:double;
  Matr1,MatrOpred:Tmatrix;
  b:ArrayDet;
begin
n:=Length(m);
y:=0;
x:=0;
x2:=0;
x3:=0;
x4:=0;
yx:=0;
yx2:=0;
for i:=0 to n-1 do
  begin
  y:=y+m[i][1];
  x:=x+m[i][0];
  x2:=x2+sqr(m[i][0]);
  x3:=x3+sqr(m[i][0])*m[i][0];
  x4:=x4++sqr(m[i][0])*sqr(m[i][0]);
  yx:=yx+m[i][0]*m[i][1];
  yx2:=yx2+Sqr(m[i][0])*m[i][1];
  end;
SetLength(Matr1,3,3);
SetLength(MatrOpred,3,3);
Matr1[0][0]:=x4; Matr1[0][1]:=x3; Matr1[0][2]:=x2;  b[0]:=yx2;
Matr1[1][0]:=x3; Matr1[1][1]:=x2; Matr1[1][2]:=x;   b[1]:=yx;
Matr1[2][0]:=x2; Matr1[2][1]:=x; Matr1[2][2]:=n;    b[2]:=y;
det:=x4*x2*n+2*x3*x*x2-x2*x2*x2-x3*x3*n-x*x*x4;
for s:=0 to 2 do
  begin
for i:=0 to 2 do
  for j:=0 to 2 do
    if j=s then
      MatrOpred[i,j]:=b[i]
    else
      MatrOpred[i,j]:=Matr1[i,j];
  If det<>0 then
  a[s]:=(MatrOpred[0,0]*MatrOpred[1,1]*MatrOpred[2,2]+MatrOpred[1,0]*MatrOpred[2,1]*MatrOpred[0,2]+MatrOpred[2,0]*MatrOpred[0,1]*MatrOpred[1,2]-
         MatrOpred[2,0]*MatrOpred[1,1]*MatrOpred[0,2]-MatrOpred[1,0]*MatrOpred[0,1]*MatrOpred[2,2]-MatrOpred[0,0]*MatrOpred[2,1]*MatrOpred[1,2] )/det;
  end;
end;

procedure Per(k,n:Word;var a:Tmatrix; var p:Word);
//ïåðåñòàíîâêà ñòðîê, åñëè ãëàâíûé ýëåìåíò=0
var z:Double;j,i:Word;
begin
z:=abs(a[k,k]);i:=k;p:=0;
for j:=k+1 to n-1 do
   begin
     if abs(a[j,k])>z then
        begin
          z:=abs(a[j,k]);
          i:=j;
        end;
   end;
if i>k then
 begin
  p:=p+1;//ñ÷åò÷èê ïåðåñòàíîâîê
  for j:=k to n-1 do
   begin
     z:=a[i,j];
     a[i,j]:=a[k,j];
     a[k,j]:=z;
   end;
 end;  
end;

function Znak(p:Word):ShortInt;
//ïðè ïåðåñòàíîâêå ìåíÿåòñÿ çíàê îïðåäåëèòåëÿ, íàäî åãî îòñëåäèòü
begin
if p mod 2=0 then
  result:=1
  else
  result:=-1;
end;

function Opr(n:Word; a:tmatrix):Double;
var k,i,j,p:Word;
    r,det:Double;
begin
det:=1.0;
for k:=0 to n-1 do
  begin
    if a[k,k]=0 then Per(k,n,a,p);//ïåðåñòàíîâêà ñòðîê
    det:=znak(p)*det*a[k,k];//âû÷èñëåíèå îïðåäåëèòåëÿ
    for j:=k+1 to n-1 do //ïåðåñ÷åò êîýôôèöèåíòîâ
       begin
         if a[k,k]=0 then a[k,k]:=0.0001;
         r:=a[j,k]/a[k,k];
         for i:=k to n-1 do
         a[j,i]:=a[j,i]-r*a[k,i];
       end;
  end;
Result:=det;
end;

end.
