unit UTestModel1;

interface

Uses UGRAPH,USklad,SysUtils;

type

TNS = class;

TElementNS = class
  Name:String;
  LastTime:Double;
  TimeFailure:double;
  TimeWaiting:double;
  Failure:Byte;
  Zakon:Byte;
  Parametr1,Parametr2:Double;
  NextElement:TElementNS;
  NS:TNS;
  constructor Create;
  function GoTimeFailure (ThisTime:Double):Double;
  procedure GoFailure (Time:Double);
  end;

TNS = class
      FirstElement:TElementNS;
      Node:TNode;
      Failure:Byte;
      LastTime:Double;
      TimeFailure:double;
      TimeWaiting:double;
      function SearchElementName(Name:String):TElementNs;
      procedure ClearSost;
      function AddElementNS (Name:string; Zakon:Byte; Par1,PAr2:Double):TElementNs;
      function RecoverElement (Name:string; Time:Double):Boolean;
      procedure GoAllFailure;
      procedure LoadElementFile(NameFile:string);
      constructor Create;
      end;


implementation

uses UEventSBS,USBS;


constructor TNS.Create;
  begin
    FirstElement:=nil;
    NOde:=nil;
    LastTime:=0;
    TimeWaiting:=0;
    TimeFailure:=0;
  end;

constructor TElementNS.Create;
  begin
  Zakon:=255;
  NextElement:=Nil;
  NS:=nil;
  Name:='';
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
    CurrentElement.TimeWaiting:=0;
    CurrentElement.Failure:=0;
    CurrentElement:=CurrentElement.NextElement;
    end;
  TimeWaiting:=0;
  TimeFailure:=0;
  Failure:=0;
  end;

function TNS.RecoverElement (Name:string; Time:Double):Boolean;
  var
    CurrentElement,CElement:TElementNS;
    Event:TEventFailure;
  begin
  CurrentElement:=SearchElementName(Name);
  IF CurrentElement<>nil then
    begin
    if CurrentElement.Failure<>1 then
      Result:=false
    else
      begin
      CurrentElement.Failure:=0;
      CurrentElement.TimeFailure:=CurrentElement.TimeFailure+Time-LastTime;
      CElement:=FirstElement;
      While (CElement<>nil) and (CElement.Failure<>1) do
        CElement:=CElement.NextElement;
      if CElement=nil then
        begin
        Failure:=0;
        TimeFailure:=TimeFailure+Time-LastTime;
        end;
      Event:=TEventFailure.Create;
      Event.Element:=CurrentElement;
      Event.EventTime:=CurrentElement.GoTimeFailure(Time);
      SBS.AddEvent(Event);
      Result:=True;
      end;
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
       For i:=1 to 12 do
         s:=s+Random;
       result:=ThisTime+(s-6)*sqrt(Parametr2)+Parametr1;
       end;
    3: result:=ThisTime-ln(Random+0.000000000001)/(1-Parametr1);
    end;
  end;

procedure TElementNs.GoFailure (Time:Double);
  var
    ElementSklad:TElementSklad;
    i,j,Nom:Word;
    MinTime:Double;
    Event:TEventFailure;
  begin
  IF (NS.Node<>nil) and (NS.Node.Sklad<>nil) then
    begin
    ElementSklad:=NS.Node.Sklad.SearchElement(Name);
    if (ElementSklad<>nil) and (ElementSklad.kolvo<>0) then
      begin
      MinTime:=10000000000000000;
      For i:=0 to Length(ElementSklad.TimeEnabled)-1 do
        if ElementSklad.TimeEnabled[i]<MinTime then
          begin
          MinTime:=ElementSklad.TimeEnabled[i];
          nom:=i;
          end;
      TimeWaiting:=TimeWaiting+(Time-MinTime);
      NS.TimeWaiting:=NS.TimeWaiting+(Time-MinTime);
      Dec(ElementSklad.kolvo);
      if Nom<>Length(ElementSklad.TimeEnabled)-1 then
        for j:=Nom to Length(ElementSklad.TimeEnabled)-2 do
          ElementSklad.TimeEnabled[j]:=ElementSklad.TimeEnabled[j+1];
      Event:=TEventFailure.Create;
      Event.Element:=Self;
      Event.EventTime:=GoTimeFailure(Time);
      SBS.AddEvent(Event);

      end
    else
      begin
      If NS.Failure<>1 then
        begin
        NS.LastTime:=Time;
        NS.Failure:=1;
        end;
      LastTime:=Time;
      Failure:=1;
      end;
    end;

  end;

procedure TNS.LoadElementFile(NameFile:string);
  var
    f:TextFile;
    St:string;
    Name:string;
    Zakon:Byte;
    par1,par2:double;
  begin
  AssignFile(f,NameFile);
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
  end;


end.
