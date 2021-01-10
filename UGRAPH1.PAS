unit UGRAPH;

interface

Uses USklad, SysUtils;

type
  TTransportNode = class;
  TNS = class;
  TElementNS = class;

TArc = class
  Node:TTransportNode;
  NextArc:TArc;
  TypeArc:Byte;
  LengthArc:Double;
  constructor Create;
  end;

TTransportNode = class
  Name:string;
  Sklad:TSklad;
  Ns:array of TNs;
  TypeNode:Byte;
  NexTTransportNode:TTransportNode;
  Arc:TArc;
  NodeFinish:Byte;
  Par:Double;
  x,y:LongWord;
  constructor Create;
  function SearchElementMax:TElementNs;
  function AddArc(TypeArc:Byte; LengthArc:Double):TArc;
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


function AddNode (Name:string; TypeNode:Byte):TTransportNode;
function SearchMinTime(NodeNat,NodeKon:TTransportNode):Double;
function SearchNodeName(Name:String):TTransportNode;
procedure LoadGraph(NameFile:string);
function SearchElementGraph(Node:TTransportNode; ElementName:String; var MinTime:Double):TTransportNode;
function GoSearch(TimeSearch:Double; Node:TTransportNode; ElementName:string; ElementEndModel:Boolean):Boolean;
function SearchNodeMaxNS:TTransportNode;
function SearchSkladMinLength(NodeNat:TTransportNode; VolumeElement:Double):TSklad;

var
  FirsTTransportNode:TTransportNode;
  GoTransfer:Byte;


implementation

uses UEventSBS,USBS,UVolna,UMain;

constructor TTransportNode.Create;
  begin
    Name:='';
    TypeNode:=0;
    NexTTransportNode:=nil;
    Arc:=nil;
    Ns:=nil;
    NodeFinish:=0;
  end;

constructor TArc.Create;
  begin
    NextArc:=nil;
    Node:=nil;
    TypeArc:=0;
    LengthArc:=0;
  end;

function TTransportNode.AddArc(TypeArc:Byte; LengthArc:Double):TArc;
  var
    NewArc:TArc;
    CurrentArc:TArc;
  begin
    NewArc:=TArc.Create;
    NewArc.TypeArc:=TypeArc;
    NewArc.LengthArc:=LengthArc;
  If Arc=nil then
    Arc:=NewArc
  else
    begin
    CurrentArc:=Arc;
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
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
  CElement:=NS[NomNS].FirstElement;
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

function GoSearch(TimeSearch:Double; Node:TTransportNode; ElementName:string; ElementEndModel:Boolean):Boolean;
  var
    Time:Double;
    SearchNode:TTransportNode;
    NewEvent:TEventAddElement;
  begin
  SearchNode:=SearchElementGraph(Node,ElementName,Time);
  If SearchNode<>nil then
    begin
    NewEvent:=TEventAddElement.Create;
    NewEvent.Name:=ElementName;
    NewEvent.Node:=SearchNode;
    NewEvent.EventTime:=TimeSearch+Time;
    NewEvent.FlagEndModel:=ElementEndModel;
    SBS.AddEvent(NewEvent);
    if VivodProcessing then
    Writeln(f,FloatToStr(TimeSearch)+'   '+Node.Name+'   ВОССТАНОВЛЕНИЕ Эл-та '+ElementName+'  ВОССТАНОВЛЕН Эл-т ЧАСТИ '+SearchNode.Name+'     Время ожидания элемента '+FloatToStr(Time));
    Result:=True;
    end
  else
    Result:=False;
  end;

function SearchElementGraph(Node:TTransportNode; ElementName:String; var MinTime:Double):TTransportNode;
  var
    CurrenTTransportNode,SearchNode:TTransportNode;
    CurrentElement:TElementNS;
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
      CurrentElement:=CurrenTTransportNode.Ns[NomNS].SearchElementName(ElementName);
      if (CurrentElement<>nil) and (CurrentElement.Failure=1) then
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
  if SearchNode<>nil then
    begin
    ElementSklad.TimeWaiting:=ElementSklad.TimeWaiting+MinTime;
    end;

  Result:=SearchNode;
  end;

procedure LoadGraph(NameFile:string);
  var
    f:TextFile;
    st:string;
    Name:string;
    TypeArc:Byte;
    LengthArc:Double;
    Node:TTransportNode;
    Arc:TArc;
    Sklad:TSklad;
    Ns:TNs;
    NodeN,NodeK:TTransportNode;
    NomNS:LongWord;
  begin
  AssignFile(f,NameFile);
  Reset(f);
  while not Eof(f) do
    begin
    Readln(f,st);
    If st[1]='n' then
      begin
      Delete(St,1,2);
      Name:=Copy(St,1,pos('@',st)-1);
      Delete(St,1,pos('@',st));
      Node:=AddNode(Name,StrToInt(Copy(St,1,pos('@',st)-1)));
      Delete(St,1,pos('@',st));
      Node.x:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      Node.y:=StrToInt(Copy(St,1,pos('@',st)-1));
      Delete(St,1,pos('@',st));
      NomNS:=0;
      If st[1]='1' then
        begin
        Sklad:=TSklad.Create;
        Node.Sklad:=Sklad;
        Delete(St,1,pos('@',st));
        if st[1]='1' then
          begin
          Delete(St,1,pos('@',st));
          While pos('@',st)<>0 do
            begin
            Ns:=TNs.Create;
            Ns.Name:=Copy(St,1,pos('@',st)-1);
            Delete(St,1,pos('@',st));
            Ns.LoadElementFile(Copy(St,1,pos('@',st)-1));
            Delete(St,1,pos('@',st));
            Ns.Node:=Node;
            Inc(NomNS);
            SetLength(Node.Ns,NomNS);
            Node.Ns[NomNs-1]:=Ns;

            end;
          end;
        end;
      Delete(St,1,pos('@',st));
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
    CElement:=FirstElement;
    While CElement<>nil do
      begin
      DelElement:=CElement;
      CElement:=CElement.NextElement;
      DelElement.Destroy;
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
    Event.Element:=CurrentElement;
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
    Event.Element:=CurrentElement;
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
      Event.Element:=Self;
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
      DelElement.Destroy;
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

function SearchSkladMinLength(NodeNat:TTransportNode; VolumeElement:Double):TSklad;
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
  if (CNode.Sklad<>nil) and (CNode.Sklad.MaxVolumeSklad-CNode.Sklad.VolumeSklad>VolumeElement) and (Leng<Min) then
    begin
    Min:=Leng;
    MinNode:=CNode;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
Result:=MinNode.Sklad;
end;

end.

