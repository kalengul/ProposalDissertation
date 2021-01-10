unit UEventSBS;

interface

Uses USBS,
     UTransportGRAPH,
     UReliabilityGraph,
     UAction,
     StdCtrls; //MemoEdit

type
{  TEventFailure = class (TEvent)
    Element:TElementNS;
    Constructor Create; override;
    Destructor Destroy; override;
    end; }

  TEventAddElement = class (TEvent)
    Name:String;
    Node,NodeTransport:TTransportNode;
    FlagEndModel:Boolean;
    Constructor Create;
    Destructor Destroy; override;
    end;

  TEventCreate = class (TEvent)
    NameProduction:string;
    TimeProduction,CostProduction:Double;
    NodeCreate,NodeTransport:TTransportNode;
    CreateOrRecover:Boolean;
    Constructor Create;
    Destructor Destroy; override;
    end;

  TEventTransportElement = class (TEvent)
    Name:String;
    NodeNat,NodeKOn:TTransportNode;
    Constructor Create;
    Destructor Destroy; override;
    end;


TEventFailure = class (TEvent)
   Node:TStructureNode;
   Structure:TGraphStructure;
   Constructor Create;
   Destructor Destroy; override;

   end;

TEventSwitch = class (TEvent)
   Node:TStructureNode;
   KoefAction:Double;
   Structure:TGraphStructure;
   Constructor Create;
   Destructor Destroy; override;
   end;

TEventSwitchList = class (TEvent)
   Node:TArrayAction;
   Structure:TGraphStructure;
   NomNode:Word;
   KolNode:Word;
   Constructor Create;
   Destructor Destroy; override;
   end;

TEventAction = class (TEvent)
   Action:TAction;
   Structure:TGraphStructure;
   Constructor Create;
   Destructor Destroy; override;
   end;

TEventRenovation = class (TEvent)
   Node:TStructureNode;
   Structure:TGraphStructure;
   Constructor Create; 
   Destructor Destroy; override;
   end;

Procedure ProcessingEvent(var EndTime:Double);
procedure VivodSBSToMemoEdit(Me:TMemo);

implementation

uses UMain, SysUtils, UVivod, UMainStructure,USklad; //Протокол


Procedure ProcessingEvent(var EndTime:Double);
  var
  Event:TEvent;
  st:string;
  NomNs:LongWord;
  BRecover:Boolean;
  CNodeBFailyre:TStructureNode;
  BFailure:Boolean;
  GoEvent:Boolean;
  TransportTime:Double;
  CurrentList:TSearchFailure;
  CurrentFailure:TListFailure;
  ElementSklad:TElementSklad;
  Node:TTransportNode;
  CurrentVivodGraph:TGraph;
  NewEventAddElement:TEventAddElement;
  NewEventCreate:TEventCreate;
  n,i:LongWord;
  NomProduction:LongWord;
  NameProduction:string;
  TimeProduction,CostProduction:Double;
  begin
  Event:=Sbs.GetFirstEvent;
  IF Event<>nil then
  begin
  EndTime:=Event.EventTime;
  If (Event is TEventFailure) and ((Event as TEventFailure).Node.BoolFailure<>2) then
    begin
    UMainStructure.Structure:=(Event as TEventFailure).Structure;
    If GoProtocolEvent then
      begin
      Str(Sbs.ModelTime:12:2,st);
      FModel.MeProt.Lines.Add(st+' ЛА - '+(Event as TEventFailure).Structure.Name+' - '+(Event as TEventFailure).Structure.Nomber+' ОТКАЗ Элемента -> '+(Event as TEventFailure).Node.Graph.Name+'->'+(Event as TEventFailure).Node.Name);
      end;

    Str(Sbs.ModelTime:12:2,st);
    IF ((Event as TEventFailure).Node.Name= FModel.EdElementName.Text) and (BoolGoProtocolElement) then
    FModel.MeProt.Lines.Add(st+' ЛА - '+(Event as TEventFailure).Structure.Name+' - '+(Event as TEventFailure).Structure.Nomber+' ОТКАЗ Элемента -> '+(Event as TEventFailure).Node.Graph.Name+'->'+(Event as TEventFailure).Node.Name);

    If (Event as TEventFailure).Node.StatProtocol<>nil then
      (Event as TEventFailure).Node.StatProtocol.AddStat(Sbs.ModelTime);
    (Event as TEventFailure).Node.GoFailure(Event.EventTime,0);
//    Event.Destroy;
    end
  else
  If (Event is TEventSwitch) and ((Event as TEventSwitch).Node.BoolRegularly=0) then
    Begin
    UMainStructure.Structure:=(Event as TEventSwitch).Structure;
    (Event as TEventSwitch).Node.SwitchON(Event.EventTime,(Event as TEventSwitch).KoefAction);
    FreeAndNil(Event);
//    (Event as TEventSwitch).Destroy;
    end
  else
  If (Event is TEventSwitchList) and ((Event as TEventSwitchList).NomNode<(Event as TEventSwitchList).KolNode)then
    begin
    UMainStructure.Structure:=(Event as TEventSwitchList).Structure;
{
    If GoProtocolEvent then
      FModel.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' ЛА - '+(Event as TEventSwitchList).Structure.Name+' - '+(Event as TEventSwitchList).Structure.Nomber+' Действие '+IntToStr((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].TypeAction));
}
    GoEvent:=true;
     Case ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].TypeAction) of
      0:begin
        //Отключение
        If ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolRegularly<>0) and ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolFailure<>2) and ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolAvailability=1) then
          begin
          (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SwitchOFF;
          If (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SubGraph<>nil then
            (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SubGraph.SwitchOFF;
          end
        else
          GoEvent:=false;
        end;
      1:begin
        //Включение
        BFailure:=False;
        CNodeBFailyre:=(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node;
        While CNodeBFailyre<>nil do
          begin
          If CNodeBFailyre.BoolFailure=2 then
            BFailure:=true;
          CNodeBFailyre:=CNodeBFailyre.Graph.FatherNodeGraph;
          end;
        If ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolRegularly=0) and ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolFailure<>2) and ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolAvailability=1) and (not BFailure)then
          (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SwitchON(Event.EventTime,(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].KoefAction)
        else
          GoEvent:=false;
        end;
      2:begin
        //Демонтаж

        If ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolAvailability=1) then
          begin
         { Inc(NomProtocol);
          SetLength(ProtocolEvent,NomProtocol);
          ProtocolEvent[NomProtocol-1].Time:=Sbs.ModelTime;
          ProtocolEvent[NomProtocol-1].EvenTStructureNodeName:=(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.Graph.Name+'->'+(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.Name;
          ProtocolEvent[NomProtocol-1].TypeEvent:=3;
           }
          //Определение, задействована ли ремонтная бригада
          If not (Event as TEventSwitchList).Structure.GoPeopleService then
            begin
            (Event as TEventSwitchList).Structure.GoPeopleService:=True;
            PeopleService:=PeopleService+1;
            If PeopleService>MaxPeopleService then
              MaxPeopleService:=PeopleService;
            end;
          (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SaveTime;
          CurrentFailure:=(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.Failure;
          While (CurrentFailure<>nil) do
            begin
            if CurrentFailure.Event<>nil then
              begin
              FreeAndNil(CurrentFailure.Event);
              end;
            CurrentFailure:=CurrentFailure.NextFailure;
            end;
          (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolAvailability:=0;
          end
        else
          GoEvent:=false;
        end;
      3:begin
        //Монтаж
        If ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolAvailability=0) then
          begin
          //Определение, задействована ли ремонтная бригада
          If (Event as TEventSwitchList).Structure.GoPeopleService then
            begin
            (Event as TEventSwitchList).Structure.GoPeopleService:=False;
            PeopleService:=PeopleService-1;
            end;
          (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.GoAvailability;
          end
        else
          GoEvent:=false;
        end;
      4:begin
        //Настройка
        If ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolAvailability=1)
//         and ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.BoolFailure=2)
           then
          begin
   {       Str(Sbs.ModelTime:12:2,st);
          IF (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.Name= 'Распределитель' then
          FModel.MeProt.Lines.Add(st+' ЛА - '+(Event as TEventSwitchList).Structure.Name+' - '+(Event as TEventSwitchList).Structure.Nomber+' Восстановление Элемента -> '+(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.Name);}
          (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.GoRecovery(Event.EventTime);
          end
        else
          GoEvent:=false;
        end;

      end;
    //Обнаружение отказа
     If (Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SearchActionName((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].NameAction)<>nil then
      CurrentList:=(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.SearchActionName((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].NameAction).ListSearchFailure
     else
      CurrentList:=nil;
     while CurrentList<>nil do
      begin

      If (CurrentList.Node.BoolFailure=2) and (CurrentList.Node.BoolSearchFailure=0) and (CurrentList.Go) then
        begin
        If GoProtocolEvent then
          begin
          FModel.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' ЛА - '+(Event as TEventSwitchList).Structure.Name+' - '+(Event as TEventSwitchList).Structure.Nomber+' ОБНАРУЖЕН ОТКАЗ '+CurrentList.Node.Name);
        //  VivodElementSkald((Event as TEventSwitchList).Structure.TransportNode.Sklad);
          end;

        If (CurrentList.Node.Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
           FModel.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' ЛА - '+(Event as TEventSwitchList).Structure.Name+' - '+(Event as TEventSwitchList).Structure.Nomber+' ОБНАРУЖЕН ОТКАЗ '+CurrentList.Node.Name+' '+IntToStr(CurrentList.Node.BoolSearchFailure)+' '+IntToStr(CurrentList.Node.BoolFailure));

        //Отправка части на АРЗ
        IF (CurrentList.Node.BoolSearchFailure=0) and (CurrentList.Node.BoolFailure=2) then
          begin
          If (CurrentList.Node.Name=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
            FModel.MeProt.Lines.Add('На АРЗ');
          GoToARZ((Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node,(Event as TEventSwitchList).Structure,(Event as TEventSwitchList).EventTime);
          end;

        //Обнаружен отказ устройства NODE
        CurrentList.Node.BoolSearchFailure:=1;

        //Поиск элемента на складе
//        If not SettingModel=2 then
          ElementSklad:=(Event as TEventSwitchList).Structure.TransportNode.Sklad.SearchElement(CurrentList.Node.Name);
        If (SettingModel=2) or ((SettingModel=1) and (ElementSklad<>nil) and (ElementSklad.kolvo<>0)) then
          begin
          If GoProtocolEvent then
            begin
            Str(Sbs.ModelTime:12:2,st);
            FModel.MeProt.Lines.Add(st+' SettingModel='+IntToStr(SettingModel)+' ЛА - '+(Event as TEventSwitchList).Structure.Name+' - '+(Event as TEventSwitchList).Structure.Nomber+' ЗАМЕНА -> '+CurrentList.Node.Name);
            If ElementSklad<>nil then
              FModel.MeProt.Lines.Add('ElementSklad<>nil Element='+ElementSklad.Name);
            end;
          //Есть на складе элемент для замены
          CurrentList.Node.BoolSearchFailure:=2;
          CurrentList.Node.BoolReplacement:=1;
          CurrentList.Node.GoSwitch(1,'Замена',255);
          If ElementSklad<>nil then
            begin
            if ((Event as TEventSwitchList).Structure.TransportNode.Sklad.NameElementProcess=ElementSklad.Name) and (Length((Event as TEventSwitchList).Structure.TransportNode.Sklad.AllTimeProcess)<>0) then
              begin
              n:=Length((Event as TEventSwitchList).Structure.TransportNode.Sklad.AllTimeProcess)-1;
              While (n>1) and ((Event as TEventSwitchList).Structure.TransportNode.Sklad.AllTimeProcess[n-1].TimeRecover=0) do
                Dec(n);
              (Event as TEventSwitchList).Structure.TransportNode.Sklad.AllTimeProcess[n].TimeRecover:=Event.EventTime;
              end;
            ElementSklad.DecreaseElement(EndTime);
            end;
          end
        else
        If (SettingModel=1) then
        //Поиск элемента на других складах
          begin
          GoSearchRecover(Event.EventTime,(Event as TEventSwitchList).Structure.TransportNode,CurrentList.Node.Name);
          end;
        end;
      CurrentList:=CurrentList.NextSearch;
      end;     

    //Вывод
    If (not GoStat) and (GoEvent)  then
      UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Элемент ->'+(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].Node.Name+' Действие ->'+(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].NameAction);
    //Переход к следующему действию
    inc((Event as TEventSwitchList).NomNode);
    IF ((Event as TEventSwitchList).NomNode<(Event as TEventSwitchList).KolNode) then
      begin
      If GoEvent then
      //Изменение времени
        (Event as TEventSwitchList).EventTime:=(Event as TEventSwitchList).EventTime+(Event as TEventSwitchList).Node[(Event as TEventSwitchList).NomNode].TimeAction;
      //Добавление времени
      SBS.AddEvent(Event);
      end
    else
      FreeAndNil(Event);
    end
  else
  If (Event is TEventAction) then
    begin
//    If GoProtocolEvent then
//      begin
//      FModel.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' ЛА - '+(Event as TEventAction).Structure.Name+' - '+(Event as TEventAction).Structure.Nomber+' Смена режима ');
//      end;

    UMainStructure.Structure:=(Event as TEventAction).Structure;
    (Event as TEventAction).Action.Go;
//    (Event as TEventAction).Action.Destroy;
      FreeAndNil(Event);
    end
  else
  If (Event is TEventRenovation) and ((Event as TEventRenovation).Node.BoolFailure=2) then
    begin
    UMainStructure.Structure:=(Event as TEventRenovation).Structure;
    Inc(NomProtocol);
    SetLength(ProtocolEvent,NomProtocol);
    ProtocolEvent[NomProtocol-1].Time:=Sbs.ModelTime;
    ProtocolEvent[NomProtocol-1].EvenTStructureNodeName:=(Event as TEventRenovation).Node.Graph.Name+'->'+(Event as TEventRenovation).Node.Name;
    ProtocolEvent[NomProtocol-1].TypeEvent:=0;

    (Event as TEventRenovation).Node.BoolFailure:=0;    //Элемент работоспособен
    (Event as TEventRenovation).Node.SwitchOFF;         //Создание событий отказа
      FreeAndNil(Event);

    end
  else
  If (Event is TEventAddElement) then
    begin
    If GoProtocolEvent then
      begin
      Str(Sbs.ModelTime:12:2,st);
      FModel.MeProt.Lines.Add(st+' Элемент - '+(Event as TEventAddElement).Name+' Склад '+(Event as TEventAddElement).Node.Name);
      end;
//        Str(Event.EventTime:10:2,st);
    BRecover:=false;
    IF ((Event as TEventAddElement).Node.NS<>nil) then
      begin
      NomNS:=0;
      while (NomNs<Length((Event as TEventAddElement).Node.NS)) and (not (Event as TEventAddElement).Node.NS[NomNs].RecoverElement((Event as TEventAddElement).Name, Event.EventTime)) do
        Inc(NomNs);
      BRecover:=NomNs<Length((Event as TEventAddElement).Node.NS);
      end;
    If not BRecover then
      begin
      If ((Event as TEventAddElement).Node.NS<>nil) then
         begin
         //Если доставили на аэродром - то на склад
         if (VivodProcessing)  then
         Writeln(f,FloatToStr(Event.EventTime)+'   '+(Event as TEventAddElement).Node.Name+'   ДОБАВЛЕНИЕ Эл-та '+(Event as TEventAddElement).Name+'  на СКЛАД');
         if (GoProtocolEvent)  then
         FModel.MeProt.Lines.Add(FloatToStr(Event.EventTime)+'   '+(Event as TEventAddElement).Node.Name+'   ДОБАВЛЕНИЕ Эл-та '+(Event as TEventAddElement).Name+'  на СКЛАД');

         (Event as TEventAddElement).Node.Sklad.AddElement((Event as TEventAddElement).Name, Event.EventTime,(Event as TEventAddElement).FlagEndModel)
         end
      else
        //Ищем отказавший элемент ЛА на аэродромах
        if (not GoSearchFailure(Event.EventTime,(Event as TEventAddElement).Node,(Event as TEventAddElement).Name,(Event as TEventAddElement).FlagEndModel))  then
          begin
          //Нужна ли дальнейшая транспортировка?
          If (Event as TEventAddElement).NodeTransport=nil then
            begin
            if (VivodProcessing) then
              Writeln(f,FloatToStr(Event.EventTime)+'   '+(Event as TEventAddElement).Node.Name+'   ДОБАВЛЕНИЕ Эл-та '+(Event as TEventAddElement).Name+'  на СКЛАД');
            if (GoProtocolEvent) then
              FModel.MeProt.Lines.Add(FloatToStr(Event.EventTime)+'   '+(Event as TEventAddElement).Node.Name+'   ДОБАВЛЕНИЕ Эл-та '+(Event as TEventAddElement).Name+'  на СКЛАД');

            //Добавляем элемент на склад
            (Event as TEventAddElement).Node.Sklad.AddElement((Event as TEventAddElement).Name, Event.EventTime,(Event as TEventAddElement).FlagEndModel);
            end
          else
            begin
            if (VivodProcessing) then
              Writeln(f,FloatToStr(Event.EventTime)+'   '+(Event as TEventAddElement).Node.Name+'   ТРАНСПОРТИРОВКА Эл-та '+(Event as TEventAddElement).Name+'  на СКЛАД '+(Event as TEventAddElement).NodeTransport.Name);
            if (GoProtocolEvent) then
              FModel.MeProt.Lines.Add(FloatToStr(Event.EventTime)+'   '+(Event as TEventAddElement).Node.Name+'   ТРАНСПОРТИРОВКА Эл-та '+(Event as TEventAddElement).Name+'  на СКЛАД '+(Event as TEventAddElement).NodeTransport.Name);

            //Новове событие транспортировки
            NewEventAddElement:=TEventAddElement.Create;
            NewEventAddElement.Name:=(Event as TEventAddElement).Name;
            NewEventAddElement.Node:=(Event as TEventAddElement).NodeTransport;
            NewEventAddElement.NodeTransport:=nil;
            TransportTime:=SearchMinTime((Event as TEventAddElement).Node,(Event as TEventAddElement).NodeTransport);
            NewEventAddElement.EventTime:=(Event as TEventAddElement).EventTime+TransportTime;
            TimeTransportProgon:=TimeTransportProgon+TransportTime;
            SBS.AddEvent(NewEventAddElement);
            end;
          end;
//        FModel.MeProt.Lines.Add(St+' ->'+(Event as TEventAddElement).Name+' ХРАНЕНИЕ')
      end
      else
        begin

//        GoToARZ((Event as TEventAddElement).Node,(Event as TEventAddElement).Node.NS[NomNs],(Event as TEventAddElement).EventTime);
        end;

//    else
//        FModel.MeProt.Lines.Add(St+' ->'+(Event as TEventAddElement).Name+' ВОССТАНОВЛЕНИЕ')
      FreeAndNil(Event);

    end
  else
  If (Event is TEventCreate) then
    begin
    //Создали событие перемещения на склад предприятия/АРЗ
    NewEventAddElement:=TEventAddElement.Create;
    NewEventAddElement.Name:=(Event as TEventCreate).NameProduction;
    NewEventAddElement.Node:=(Event as TEventCreate).NodeCreate;
    NewEventAddElement.NodeTransport:=(Event as TEventCreate).NodeTransport;
    NewEventAddElement.EventTime:=(Event as TEventCreate).EventTime;
    SBS.AddEvent(NewEventAddElement);
    IF (Event as TEventCreate).CreateOrRecover then
      begin
      if (Event as TEventCreate).NodeCreate.Manufact<>nil then
      begin
      //Увеличили производственную мощность предприятия
      (Event as TEventCreate).NodeCreate.Manufact.Power:=(Event as TEventCreate).NodeCreate.Manufact.Power-(Event as TEventCreate).CostProduction/(Event as TEventCreate).TimeProduction;
      //Удалили ЗЧ из очереди предприятия
      (Event as TEventCreate).NodeCreate.Manufact.CostProgon:=(Event as TEventCreate).NodeCreate.Manufact.CostProgon+(Event as TEventCreate).CostProduction;
      (Event as TEventCreate).NodeCreate.Manufact.ManufactQuery.DelProduction((Event as TEventCreate).NameProduction);
      If GoProtocolEvent then
        begin
        Str(Sbs.ModelTime:12:2,st);
        FModel.MeProt.Lines.Add(st+' Производство - '+(Event as TEventCreate).NodeCreate.Manufact.Name+' Мощность - '+FloatToStr((Event as TEventCreate).NodeCreate.Manufact.Power)+' Новая ЗЧ - "'+(Event as TEventCreate).NameProduction+'" Склад назначения - '+(Event as TEventCreate).NodeTransport.Name);
        end;
      //Нашли новое изделие, подходящее по мощности предприятия
      If (Event as TEventCreate).NodeCreate.Manufact.GiveFirstProductionOnPower((Event as TEventCreate).EventTime,Node,NameProduction,TimeProduction,CostProduction) then
        begin
        //Запускаем новое производство на предприятии
        NewEventCreate:=TEventCreate.Create;
        NewEventCreate.NameProduction:=NameProduction;
        NewEventCreate.TimeProduction:=TimeProduction;
        NewEventCreate.CostProduction:=CostProduction;
        NewEventCreate.NodeCreate:=(Event as TEventCreate).NodeCreate;
        NewEventCreate.CreateOrRecover:=True;
        NewEventCreate.NodeTransport:=Node;
        NewEventCreate.EventTime:=(Event as TEventCreate).EventTime+TimeProduction;
        SBS.AddEvent(NewEventCreate);
        If GoProtocolEvent then
          begin
          FModel.MeProt.Lines.Add(st+' В производство добавлена новая часть: '+NameProduction+' Мощность предприятия - '+FloatToStr((Event as TEventCreate).NodeCreate.Manufact.Power));
          end;
        end;
      end;
      end
    else
      if (Event as TEventCreate).NodeCreate.ARZ<>nil then
      begin
      If ((Event as TEventCreate).NameProduction=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
              begin
        Str(Sbs.ModelTime:12:2,st);
        FModel.MeProt.Lines.Add(st+' АРЗ - '+(Event as TEventCreate).NodeCreate.ARZ.Name+' Новая ЗЧ - '+(Event as TEventCreate).NameProduction+' Склад назначения - '+(Event as TEventCreate).NodeTransport.Name);
        end;

      //Увеличили производственную мощность АРЗ
      (Event as TEventCreate).NodeCreate.ARZ.Power:=(Event as TEventCreate).NodeCreate.ARZ.Power-(Event as TEventCreate).CostProduction/(Event as TEventCreate).TimeProduction;
      //Удалили ЗЧ из очереди АРЗ
      (Event as TEventCreate).NodeCreate.ARZ.CostProgon:=(Event as TEventCreate).NodeCreate.ARZ.CostProgon+(Event as TEventCreate).CostProduction;
      (Event as TEventCreate).NodeCreate.ARZ.ManufactQuery.DelProduction((Event as TEventCreate).NameProduction);
      If ((Event as TEventCreate).NameProduction=FModel.EdElementName.Text) and (BoolGoProtocolElement) then
        for NomProduction:=0 to Length((Event as TEventCreate).NodeCreate.ARZ.SetProduction)-1 do
          FModel.MeProt.Lines.Add(IntToStr(NomProduction)+' '+(Event as TEventCreate).NodeCreate.ARZ.SetProduction[NomProduction].NameProduction);
      //Нашли новое изделие, подходящее по мощности АРЗ
      If GoProtocolEvent then
        begin
        Str(Sbs.ModelTime:12:2,st);
        FModel.MeProt.Lines.Add(st+' АРЗ - '+(Event as TEventCreate).NodeCreate.ARZ.Name+' Мощность - '+FloatToStr((Event as TEventCreate).NodeCreate.ARZ.Power)+' Новая ЗЧ - '+(Event as TEventCreate).NameProduction+' Склад назначения - '+(Event as TEventCreate).NodeTransport.Name);
        end;

      If (Event as TEventCreate).NodeCreate.ARZ.GiveFirstProductionOnPower((Event as TEventCreate).EventTime,Node,NameProduction,TimeProduction,CostProduction) then
        begin
        //Запускаем новое восстановление на АРЗ
        NewEventCreate:=TEventCreate.Create;
        NewEventCreate.NameProduction:=NameProduction;
        NewEventCreate.TimeProduction:=TimeProduction;
        NewEventCreate.CostProduction:=CostProduction;
        NewEventCreate.NodeCreate:=(Event as TEventCreate).NodeCreate;
        NewEventCreate.CreateOrRecover:=False;
        NewEventCreate.NodeTransport:=Node;
        NewEventCreate.EventTime:=(Event as TEventCreate).EventTime+TimeProduction;
        SBS.AddEvent(NewEventCreate);
        If GoProtocolEvent then
          begin
          FModel.MeProt.Lines.Add(st+' В ремонт добавлена новая часть: '+NameProduction+' Мощность предприятия - '+FloatToStr((Event as TEventCreate).NodeCreate.ARZ.Power));
          end;

        end;
      end;
    FreeAndNil(Event);
    end;
  end
  else
    EndTime:=1000000000000000;
  end;

Constructor TEventFailure.Create;
  begin
    inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  EventTime:=0;
  Node:=nil;
  Structure:=nil;
  end;

Destructor TEventFailure.Destroy;
  var
    Failure:TListFailure;
  begin
  If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
    PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
{      If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   СБС Удаление ОТКАЗА');
 }
{  Failure:=Node.Failure;
  While (Failure<>nil) and (Failure.Event<>self) do
    Failure:=Failure.NextFailure;
  IF Failure<>nil then
    Failure.Event:=nil;
  else
  If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   ОШИБКА');}
  Node:=nil;
  Structure:=nil;
    inherited;
  end;

Constructor TEventSwitch.Create;
  begin
    inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  EventTime:=0;
  Node:=nil;
  Structure:=nil;
  end;

Destructor TEventSwitch.Destroy;
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
  Structure:=nil;
    inherited;
  end;

Constructor TEventSwitchList.Create;
  begin
  inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  Structure:=nil;
  EventTime:=0;
  SetLength(Node,0);
  NomNode:=0;
  end;

Destructor TEventSwitchList.Destroy;
  var
    i:LongWord;
  begin
  If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
  PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
  Structure:=nil;
{    If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   СБС Удаление списка действий');    }
  For i:=0 to Length(Node)-1 do
    begin
    FreeAndNil(Node[i]);
    end;

//  Finalize(Node);
  inherited;
  end;

Constructor TEventAction.Create;
  begin
  inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  Structure:=nil;
  EventTime:=0;
  end;

Destructor TEventAction.Destroy;
  begin
  If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
  PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
  Structure:=nil;
{    If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   СБС Удаление Action');     }

  inherited;
  end;

Constructor TEventRenovation.Create;
  begin
  inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  Structure:=nil;
  EventTime:=0;
  Node:=nil;
  end;

Destructor TEventRenovation.Destroy;
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
  Structure:=nil;
  inherited;
  end;

Constructor TEventAddElement.Create;
  begin
  inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  EventTime:=0;
  FlagEndModel:=False;
  Node:=nil;
  NodeTransport:=nil;
  end;

Destructor TEventAddElement.Destroy;
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
  NodeTransport:=nil;
  inherited;
  end;

Constructor TEventCreate.Create;
  begin
  inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  EventTime:=0;
  NodeCreate:=nil;
  NodeTransport:=nil;
  end;

Destructor TEventCreate.Destroy;
  begin
  If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
  PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
  NodeCreate:=nil;
  NodeTransport:=nil;
  inherited;
  end;

Constructor TEventTransportElement.Create;
  begin
  inherited;
  NextEvent:=nil;
  PreEvent:=nil;
  EventTime:=0;
  NodeNat:=nil;
  NodeKon:=nil;
  end;

Destructor TEventTransportElement.Destroy;
  begin
  If SBS.FirstEvent=self then
    Sbs.FirstEvent:=NextEvent;
  If NextEvent<>nil then
  NextEvent.PreEvent:=PreEvent;
  If PreEvent<>nil then
  PreEvent.NextEvent:=NextEvent;
  NextEvent:=nil;
  PreEvent:=nil;
  NodeNat:=nil;
  NodeKon:=nil;
  inherited;
  end;

procedure VivodSBSToMemoEdit(Me:TMemo);
var
  CurrentEvent:TEvent;
  st:string;
begin
  Me.Lines.Clear;
  CurrentEvent:=SBS.FirstEvent;
  While CurrentEvent<>nil do
    begin
    St:=FloatToStr(CurrentEvent.EventTime)+' -> ';
    IF CurrentEvent is TEventFailure then
      St:=st+'ОТКАЗ '+(CurrentEvent as TEventFailure).Structure.Name+' '+(CurrentEvent as TEventFailure).Structure.Nomber+' -> '+(CurrentEvent as TEventFailure).Node.Name;
    IF CurrentEvent is TEventAction then
      St:=st+'Действие из списка '+(CurrentEvent as TEventAction).Structure.Name+' '+(CurrentEvent as TEventAction).Structure.Nomber+' -> '+(CurrentEvent as TEventAction).Action.Name;
    If CurrentEvent is TEventSwitchList then
      St:=st+'Последовательность действий'+(CurrentEvent as TEventSwitchList).Structure.Name+' '+(CurrentEvent as TEventSwitchList).Structure.Nomber;
    Me.Lines.Add(st);
    CurrentEvent:=CurrentEvent.NextEvent;
    end;
end;


end.
