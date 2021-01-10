unit UVolna;

interface

uses UTransportGRAPH,USBS,SysUtils;

type
  TEventVolna = class (TEvent)
    Node:TTransportNode;
    ArrayNode: array of TTransportNode;
    Constructor Create;
    Destructor Destroy; override;
    end;

function MinTimeGraphVolna(NodeN,NodeK:TTransportNode):Double;

var
  SbsVolna:TQueueEvent;

implementation

function MinTimeGraphVolna(NodeN,NodeK:TTransportNode):Double;
  var
    NewEvent: TEventVolna;
    Event:TEvent;
    CArc:TTransportArc;
    n,i:LongWord;
    BGo:Boolean;
  begin
  Event:=nil;
  SbsVolna:=TQueueEvent.Create;
  NewEvent:=TEventVolna.Create;
  NewEvent.Node:=NodeN;
  SbsVolna.AddEvent(NewEvent);
    repeat
    FreeAndNil(Event);
    Event:=SbsVolna.GetFirstEvent;
    CArc:=(Event as TEventVolna).Node.Arc;
    While CArc<>nil do
      begin
      BGo:=True;
      n:=Length((Event as TEventVolna).ArrayNode);
      IF N<>0 then
      For i:=0 to n-1 do
        if (Event as TEventVolna).ArrayNode[i]=CArc.Node then
          BGo:=False;
      If BGo then
        begin
        NewEvent:=TEventVolna.Create;
        NewEvent.Node:=CArc.Node;
        NewEvent.EventTime:=Event.EventTime+CArc.LengthArc;
        SetLength(NewEvent.ArrayNode,n+1);
        IF N<>0 then
        For i:=0 to n-1 do
          NewEvent.ArrayNode[i]:=(Event as TEventVolna).ArrayNode[i];
        NewEvent.ArrayNode[n]:=CArc.Node;
        SbsVolna.AddEvent(NewEvent);
        end;
      CArc:=CArc.NexTTransportArc;
      end;
    until (Event=nil) or ((Event as TEventVolna).Node=NodeK);
  Result:=Event.EventTime;
  FreeAndNil(Event);
  FreeAndNil(SbsVolna);
  end;

Constructor TEventVolna.Create;
  begin
  NextEvent:=nil;
  PreEvent:=nil;
  ArrayNode:=nil;
  EventTime:=0;
  Node:=nil;
  end;

Destructor TEventVolna.Destroy;
  begin
  If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
  PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
  Node:=nil;
  inherited;
  end;

end.
