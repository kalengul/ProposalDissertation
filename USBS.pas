unit USBS;

interface

uses
SysUtils;

type
TEvent = Class;

TQueueEvent = class
   ModelTime:Double;
   FirstEvent:TEvent;
   Function GetFirstEvent:TEvent;
   Procedure AddEvent (NewEvent:TEvent);
   Procedure clear;
   Constructor Create;
   Destructor Destroy;  override;
   end;

TEvent = class
   NextEvent,PreEvent:TEvent;  //Указатель на следующий и предыдущий элемент очереди
   EventTime:Double;       //Время события
   Constructor Create;
   Destructor Destroy; override;
   end;

var

SBS:TQueueEvent;

implementation


Constructor TQueueEvent.Create;
  begin
    inherited;
  ModelTime:=0;
  FirstEvent:=nil;
  end;

Destructor TQueueEvent.Destroy;
  begin
  Clear;
  inherited;
  end;

Function TQueueEvent.GetFirstEvent:TEvent;
  begin
  Result:=FirstEvent;
  if FirstEvent<>nil then
    begin
      ModelTime:=FirstEvent.EventTime; //Меняем текущее время
      FirstEvent:=FirstEvent.NextEvent;  //Сдвигаем первый указатель вперед
      IF FirstEvent<>nil then
        begin
        FirstEvent.PreEvent.NextEvent:=nil;
        FirstEvent.PreEvent:=nil;
        end;
    end;
  end;

Procedure TQueueEvent.AddEvent (NewEvent:TEvent);
var
  CurEvent,PrevEvent:TEvent;
begin
  CurEvent:=FirstEvent; PrevEvent:=nil;
  //Ищем место вставки нового события в очередь
  while (CurEvent<>nil) and (CurEvent.EventTime<NewEvent.EventTime) do
    begin
      PrevEvent:=CurEvent;
      CurEvent:=CurEvent.NextEvent;
    end;
  //Вставляем новое событие в очередь
  NewEvent.NextEvent:=CurEvent;
  NewEvent.PreEvent:=PrevEvent;
  //Учитываем, что новое событие может стать первым
  if PrevEvent=nil then
    begin
    If FirstEvent<>nil then
      FirstEvent.PreEvent:=NewEvent;
    FirstEvent:=NewEvent;
    NewEvent.PreEvent:=nil;

    end
  else
    begin
    PrevEvent.NextEvent:=NewEvent;
    if CurEvent<>nil then
      CurEvent.PreEvent:=NewEvent;
    end;
  end;

Procedure TQueueEvent.Clear;
  var
  DelEvent,NextDelEvent:TEvent;
  begin
  NextDelEvent:=FirstEvent;
  While NextDelEvent<>nil do
    begin
    DelEvent:=NextDelEvent;
    NextDelEvent:=NextDelEvent.NextEvent;
    FreeAndNil(DelEvent)
    end;
  ModelTime:=0;
  FirstEvent:=nil;
  end;

Constructor TEvent.Create;
  begin
  inherited;
  end;
Destructor TEvent.Destroy;
  begin
    If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
    PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
  inherited;
  end;


end.
