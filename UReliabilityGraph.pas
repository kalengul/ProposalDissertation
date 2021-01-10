unit UReliabilityGraph;

interface

Uses 
     UReliability,
     USBS,
     SysUtils;

type

TGraph = class;
TDoubleArc = class;
TRelationArc = class;
TSensorArc = class;
TListFailure = class;
TStructureNode= class;
TStatistics = class;
TStatProtocol = class;
TActionList = class;
TElementActionList = class;
TArrayOFNode = Array of TStructureNode;
THistArr = array of Double;


TStructureNode = class
   Name:String;          //Название элемента
   Graph:TGraph;         //Указатель на граф, в котоором находится элемент
   Failure:TListFailure;   //Список различных типов отказов
   NexTStructureNode:TStructureNode;               //Список элементов в графе
   SubGraph:TGraph;              //Подграф

   BoolRegularly,                //0-Выключено 1- Включено
   BoolFailure,                  //0-работает 1- неисправность 2- отказ
   BoolAvailability,             //0-Снят 1-На месте
   BoolSearchFailure:Byte;       //0-Отказ не обнаружен 1 - Обнаружен отказ 2 - Выполняются операции по устранению отказа
   BoolReplacement:Byte;         //Флаг процедуры замены
   KolElementToFailure:byte;     //Количество элементов, вызывающих отказ

   //Начальное состояние
   BoolSostRegularly,                //0-Выключено 1- Включено
   BoolSostFailure,                  //0-работает 1- неисправность 2- отказ
   BoolSostAvailability:Byte;     //0-Снят 1-На месте

   KoefFailureSwitchOn:Double;
   SostTime:Array [0..3] of Double; //Наработка до запуска системы
   Time:Array [0..3] of Double;  //Время нахождения элемента в различных состояниях 0-выключенный 1-включен 2-отказ
   ArrayKG: array of Double;     //Массив КГ 
   LastTime:Double;              //Последнее время
   FailureBySwitchOn:Byte;       //Если отказ произошел во включенном состоянии

   DoubleNode:TDoubleArc;        //Список дуг с дублирующими вершинами
   KolParallelNode:byte;         //Количество одновременно работающих дублирующих элементов 0-работет по одному
   DoubleRelationUp,DoubleRelationDown:TDoubleArc;  //спсок зависимых

   RelationNode:TRelationArc;    //Список зависимых надежностей
   SensorNode:TSensorArc;        //Список дуг с Датчиками
   ActionLisTStructureNode:TActionList;   //Список ДЕЙСТВИЙ

   Stat:TStatistics;             //Указатель на элемент статистики по данной вершины
   StatProtocol:TStatProtocol;   //Указатель на протокол статистики, связанный с элементом


{   TimeToSwitch:Double;          //Время на включение
   TimeToDismantling:Double;     //Время на демонтаж
   TimeToInstallation:Double;    //Время на монтаж
   TimeToSetting:Double;         //Время на настройку
}
   ImpactLevel:Byte;             //Влияние на уровеньвыше 0-не влияет на отказ
   AutoRenovation:TParametersFailure;        //Автовостановление nil-нет иначе время на востановление

   procedure SaveTime;
   //Процедуры включения/выключения
   Procedure GoSwitch(KoefAction:Double; NameAction:String; TypeAction:Byte);
   Procedure SwitchON(TimeSwitch:Double; KoefAction:Double);
   Procedure SwitchOFF;
   Procedure Clear;
   //Процедуры обработки отказов
   Procedure GoFailure(TimeFailure:Double; GoDouble:Byte);
   Procedure AddFailure(TypeR,TypeFe:Byte; Par:TParametersFailure);
   Procedure DelFailure (TypeR,TypeFe:Byte);
   Procedure DelAllFailure;
   //Процедуры востановления
   Procedure GoRecovery (TimeRecovery:Double);
   procedure GoAvailability;
   //Процедуры работы с дугами
   Function AddDoubleArc(NodeKon:TStructureNode):TDoubleArc;
   Function AddDoubleRelationUp(NodeKon:TStructureNode):TDoubleArc;
   Function AddRelationArc(NodeKon:TStructureNode):TRelationArc;
   Function AddSensorArc(NodeKon:TStructureNode):TSensorArc;
   Function AddActionArc(NameAction:string):TActionList;
   Function SearchActionName(NameAction:string):TActionList;
   Procedure DelDoubleArc(NodeKon:TStructureNode);
   Procedure DelDoubleRelationUp(NodeKon:TStructureNode);
   Procedure DelRelationArc(NodeKon:TStructureNode);
   Procedure DelSensorArc(NodeKon:TStructureNode);
   Procedure DelAllDoubleArc;
   Procedure DelAllRelationArc;
   Procedure DelAllSensorArc;
   Procedure DelAllActionArc;
   Procedure CopyAllArc(OldNode:TStructureNode);
   Constructor Create;
   Destructor Destroy; override;
   end;

TGraph = class
   Name:String;
   Node:TStructureNode;
   FatherNodeGraph:TStructureNode;
   //Процедуры включения/выключения
//   Procedure SwitchOn;
   Procedure SwitchOFF;
   procedure Clear;
   //Процедуры работы с элементами (вершинами)
   Function SearchNodeName(Name:String):TStructureNode;
   function SearchNodeNameAllStructure(NameNode:String):TStructureNode;
   Function AddNode(Search:Boolean; Name:String):TStructureNode;
   Procedure DeleteNode (Name:String);
   function SearchFailureNodeGraphName(Name:String):TStructureNode;
   //Процедуры получения выхода
   Function CreateListCuTStructureNode:TStructureNode;
   //Процедура сохранения статистики
   Procedure SaveStatGraph;
   procedure SaveTime;
   //Процедуры загрузки и сохранения графа
   Constructor Create;
   Destructor Destroy; override;
   end;

//Спсок типов отказов
TListFailure = class
   Node:TStructureNode;               //Указатель на элемент
   NextFailure:TListFailure; //Следующий элемент
   TypeRegulary:Byte;        //Тип Включения 0-выключен 1-включен
   TypeFailure:Byte;         //Тип отказа
   TypeCollection:Byte;      //Последействие
   Parameters:TParametersFailure; //Указатель на набор параметров
   Event:TEvent;  //Указатель на событие отказа в СБС
   Procedure Clear;
   Constructor Create;
   Destructor Destroy;  override;
   Procedure DelFailure;  //Удаление события по данному отказу
   Procedure GoFailure;   //Создание события по данному отказу
   end;


TDoubleArc = class
   NextArc:TDoubleArc;
   Node:TStructureNode;
   Constructor Create;
   Destructor Destroy;  override;
   end;

TRelationArc = class
   NextArc:TRelationArc;
   Node:TStructureNode;
   TypeRegulary:Byte;        //Тип Включения 0-выключен 1-включен
   TypeFailure:Byte;         //Тип отказа
   ChangeReliability:TChangeReliability;
   Constructor Create;
   Destructor Destroy;  override;
   Procedure Go;
   end;

TSensorArc = class
   NextArc:TSensorArc;
   Node:TStructureNode;
   Constructor Create;
   Destructor Destroy;  override;
   end;

TElementAction = class
   Node:TStructureNode;
   NameAction:String;
   TypeAction:Byte;
   KoefAction:Double;
   TimeAction:Double;
   Constructor Create;
   Destructor Destroy;  override;
   end;

TSearchFailure = class
   Node:TStructureNode;
   reliability:Double;
   NextSearch:TSearchFailure;
   Function Go:Boolean;
   Constructor Create;
   Destructor Destroy;  override;
   end;

TArrayAction = array of TElementAction;

TElementActionList = class
  Node:TArrayOFNode;
  TypeAction:Byte;
  NameAction:String;
  StartToFinish:Byte;
  NextElement:TElementActionList;
  Constructor Create;
  Destructor Destroy;   override;
  end;

TActionList = class
  NameAction:String;
  TypeAction:Byte;
  TimeAction:Double;
  KoefAction:Double;
  ListSearchFailure:TSearchFailure;    //Вероятность обнаружить отказ этого или другово устройства
  FirstAction:TElementActionList;
  NextList:TActionList;
  Function AddActionListArc(NameAction:string; TypeAction:Byte; NodeKon:TStructureNode):TElementActionList;
  Function AddSearchFailure(NodeKon:TStructureNode; Reliability:Double):TSearchFailure;
//  Procedure DelAllAction;
  Constructor Create;
  Destructor Destroy;   override;
  end;


TStatFailure = record
  Time:array [0..1] of Double;            //Время отказа
  DoubleElement:array [0..1] of Double;     //Включение дублирующего элемента
  LevelOtkaz:array [0..1] of Double;        //Отказ элемента верхнего уровня
  end;

TArrayFailure = Array of TStatFailure;     //По каждому отказу
TStatisticTime = Array [0..3,0..1] of Double;     //Массив статистики времени

TDoubleTime = record
              NomProgon:LongWord;
              TimeFailure:Double;
              TimeRecover:Double;
              end;
TArrayProcessDouble = array of  TDoubleTime;

TStatistics = class
  //Вершина
  NameNode:String;
  Node:TStructureNode;
  //Общее по прогонам
//  KolProgon:LongWord;        //Количество реализаций модели (номер текущей реализации)
  TimeOsn:TStatisticTime;    //Времена  (ПО ЗАВЕРШЕНИЮ ПРОГОНА)
//  TimeOsnBufer:array [0..3] of Double;  //Буферное время для подсчета общего
  //По каждому элементу из востановления
//  KolRecovery: array [0..1] of Double;      //Среднее количество восстановлений (ПО ЗАВЕРШЕНИЮ ПРОГОНА)
//  MaxKolRecovery:Word;                      //Это для счетчиков

//  Time:Array of TStatisticTime;             //Статистика времени по каждому элементу (до восстановления)
//  KolFailure: array of array [0..1] of Double;       //Количество отказов до восстановления
  //По каждому отказу
  GoSaveTime:Boolean;                               //TRue, если необходимо сохранять время отказа
  TimeFailure:TArrayProcessDouble;
  KolFailure:array [0..1] of Double;
  ArrayHistKolFailure:THistArr;
  ArrayHistKolRecovery:THistArr;
  KolRecovery:array [0..1] of Double;
  NomFailure:Word;                          //Номер текущего отказа
  MaxKolFailure:Word;
  ArrayFailure: Array of TStatFailure;     //Статистика отказов по каждому элементу (до восстановления)
  NomRecovery:Word;                   //Номер текущего восстановления
  MaxKolRecovery:Word;
  ArrayRecovery: array of array[0..1] of Double;  //Статистика по восстановлению
//  Procedure StatCounting;
  Constructor Create;
  Destructor Destroy;  override;
  procedure SortTimeFailure;
  procedure qSort(l,r:LongWord);
  Procedure SaveStatisticRecovery(Time:Double);
  Procedure SaveStatisticFailure(Time:Double; SwitchDouble,ImpactLevel:Byte);
  procedure SaveStatisticProgon;
  end;

TProtocolEvent = record
  Time:Double;
  EvenTStructureNodeName:String;
  TypeEvent:byte;
  End;

TArrayProtocolEvent = Array of TProtocolEvent;

TStatProtocol = class
  Protocol:TArrayProtocolEvent;
  NameNode:String;
  TypeProtocol:Byte;
  Parameters:Double;
  Constructor Create(TypeP:byte; NodeP:TStructureNode);
  Destructor Destroy;       override;
  Procedure AddStat(Par:Double);
  end;

Var
KoefFailureSwitch:Double;
KolProgon:Word;


implementation

Uses   UEventSbs,
       UTransportGRAPH,
       UMainStructure,             //Для протокола
       UMain;

function TSearchFailure.Go:boolean;
  begin
  If Node.BoolFailure<>2 then
    Result:=false
  else
    begin
    Result:=reliability>Random;
    end;
  end;

Procedure TStatProtocol.AddStat(Par:Double);

  Procedure CopyProtocol;
    var
    n,i:LongWord;
    begin
{    n:=Length(ProtocolEvent);
    SetLength(Protocol,n);
    For i:=0 to n-1 do
      begin
      Protocol[i].Time:=ProtocolEvent[i].Time;
      Protocol[i].EvenTStructureNodeName:=ProtocolEvent[i].EvenTStructureNodeName;
      Protocol[i].TypeEvent:=ProtocolEvent[i].TypeEvent;
      end;      }
    end;

  begin
  Case TypeProtocol of
        0:If Parameters>Par then
            begin
            Parameters:=Par;
            CopyProtocol;
            end;
        1:If Parameters<Par then
            begin
            Parameters:=Par;
            CopyProtocol;
            end;
        end;
  end;

 
Procedure TGraph.SaveStatGraph;
  var
  CurrenTStructureNode:TStructureNode;
  begin
  CurrenTStructureNode:=Node;
  While CurrenTStructureNode<>nil do
    begin
//    CurrenTStructureNode.Stat.SaveStatisticRecovery;
    CurrenTStructureNode.Stat.SaveStatisticProgon;
    If CurrenTStructureNode.SubGraph<>nil then
      CurrenTStructureNode.SubGraph.SaveStatGraph;
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

procedure  TGraph.SaveTime;
  var
  CurrenTStructureNode:TStructureNode;
  begin
  CurrenTStructureNode:=Node;
  While CurrenTStructureNode<>nil do
    begin
    CurrenTStructureNode.SaveTime;
    If CurrenTStructureNode.SubGraph<>nil then
      CurrenTStructureNode.SubGraph.SaveTime;
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

Procedure TStatistics.SaveStatisticRecovery(Time:Double);
  var
    i:Byte;
    n:LongWord;
  begin
  IF SettingModel=1 then
  begin
  n:=Length(TimeFailure)-1;
  If (GoSaveTime){ and (n<>0)} then
    begin
    While (n>0) and (TimeFailure[n-1].TimeFailure<TimeFailure[n].TimeFailure) and (TimeFailure[n-1].TimeRecover=0) do
      Dec(n);
    TimeFailure[n].TimeRecover:=Time;
//    FModel.MeProt.Lines.Add(FloatToStr(TimeFailure[n-1].TimeFailure)+' '+FloatToStr(TimeFailure[n-1].TimeRecover))
    end;

  IF GoSaveArrayFailyreAndRecoveryBool then
  begin
  If NomRecovery>=Length(ArrayRecovery) then
    begin
    SetLength(ArrayRecovery,NomRecovery+1);
    ArrayRecovery[NomRecovery][0]:=0;
    ArrayRecovery[NomRecovery][1]:=0;
    end;
  ArrayRecovery[NomRecovery][0]:=(ArrayRecovery[NomRecovery][0]*(KolProgon-1)+Time)/KolProgon;
  ArrayRecovery[NomRecovery][1]:=(ArrayRecovery[NomRecovery][1]*(KolProgon-1)+Sqr(Time))/KolProgon;
  end;
  Inc(NomRecovery);
  end;
  {For i:=0 to 3 do
    begin
    TimeOsnBufer[i]:=TimeOsnBufer[i]+Node.Time[i];
    Time[NomRecovery][i][0]:=(Time[NomRecovery][i][0]*(KolProgon-1)+Node.Time[i])/KolProgon;
    Time[NomRecovery][i][1]:=(Time[NomRecovery][i][1]*(KolProgon-1)+Sqr(Node.Time[i]))/KolProgon;
    end;

  KolFailure[0]:=(KolFailure[0]*(KolProgon-1)+NomFailure)/KolProgon;
  KolFailure[1]:=(KolFailure[1]*(KolProgon-1)+Sqr(NomFailure))/KolProgon;
//  NomFailure:=0;

  Inc(NomRecovery);
  SetLength(Time,NomRecovery+1);
  If NomRecovery>MaxKolRecovery then
    begin
    MaxKolRecovery:=NomRecovery;
    SetLength(Time,NomRecovery+1);
    For i:=0 to 3 do
      begin
      Time[NomRecovery][i][0]:=0;
      Time[NomRecovery][i][1]:=0;
      end;

//    SetLength(ArrayFailure,NomRecovery+1);
    end; }

  end;

procedure TStatistics.qSort(l,r:LongWord);
var i,j:LongInt;
    w,q:Double;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := TimeFailure[(l+r) div 2].TimeFailure
  else
    q:=l;
  repeat
    while (i<r) and (TimeFailure[i].TimeFailure < q) do
      inc(i);
    while (j>l) and (q < TimeFailure[j].TimeFailure) do
      dec(j);
    if (i <= j) then
      begin
      w:=TimeFailure[i].TimeFailure; TimeFailure[i].TimeFailure:=TimeFailure[j].TimeFailure; TimeFailure[j].TimeFailure:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSort(l,j);
  if (i < r) then qSort(i,r);
end;

Procedure TStatistics.SortTimeFailure;
var
n:LongWord;
begin
n:=Length(TimeFailure);
if n>1 then
  qSort(0,n-1);
end;

procedure TStatistics.SaveStatisticFailure(Time:Double; SwitchDouble,ImpactLevel:Byte);
  var
    n:LongWord;
  begin
  if GoSaveTime then
    begin
    n:=Length(TimeFailure);
    SetLength(TimeFailure,n+1);
    TimeFailure[n].TimeFailure:=Time;
    TimeFailure[n].TimeRecover:=0;
    TimeFailure[n].NomProgon:=NomProgon;
    end;
  IF GoSaveArrayFailyreAndRecoveryBool then
  begin
  If NomFailure>=Length(ArrayFailure) then
    begin
    SetLength(ArrayFailure,NomFailure+1);
    ArrayFailure[NomFailure].Time[0]:=0;
    ArrayFailure[NomFailure].Time[1]:=0;
    ArrayFailure[NomFailure].DoubleElement[0]:=0;
    ArrayFailure[NomFailure].DoubleElement[1]:=0;
    ArrayFailure[NomFailure].LevelOtkaz[0]:=0;
    ArrayFailure[NomFailure].LevelOtkaz[1]:=0;
    end;
  ArrayFailure[NomFailure].Time[0]:=(ArrayFailure[NomFailure].Time[0]*(KolProgon-1)+Time)/KolProgon;
  ArrayFailure[NomFailure].Time[1]:=(ArrayFailure[NomFailure].Time[1]*(KolProgon-1)+Sqr(Time))/KolProgon;

  ArrayFailure[NomFailure].DoubleElement[0]:=(ArrayFailure[NomFailure].DoubleElement[0]*(KolProgon-1)+SwitchDouble)/KolProgon;
  ArrayFailure[NomFailure].DoubleElement[1]:=(ArrayFailure[NomFailure].DoubleElement[1]*(KolProgon-1)+Sqr(SwitchDouble))/KolProgon;

  ArrayFailure[NomFailure].LevelOtkaz[0]:=(ArrayFailure[NomFailure].LevelOtkaz[0]*(KolProgon-1)+ImpactLevel)/KolProgon;
  ArrayFailure[NomFailure].LevelOtkaz[1]:=(ArrayFailure[NomFailure].LevelOtkaz[1]*(KolProgon-1)+Sqr(ImpactLevel))/KolProgon;
  end;
  Inc(NomFailure);
  end;

Procedure TStatistics.SaveStatisticProgon;
  var
    i:Byte;
  begin
  KolFailure[1]:=(KolFailure[1]*(KolProgon-1)+sqr(NomFailure))/KolProgon;
  KolFailure[0]:=(KolFailure[0]*(KolProgon-1)+NomFailure)/KolProgon;
  KolRecovery[0]:=(KolRecovery[0]*(KolProgon-1)+NomRecovery)/KolProgon;
  KolRecovery[1]:=(KolRecovery[1]*(KolProgon-1)+sqr(NomRecovery))/KolProgon;
  if GoSaveHistBool then
  begin
  if NomFailure>MaxKolFailure then
    MaxKolFailure:=NomFailure;
  SetLength(ArrayHistKolFailure,MaxKolFailure+1);
  ArrayHistKolFailure[NomFailure]:=ArrayHistKolFailure[NomFailure]+1;
  if NomRecovery>MaxKolRecovery then
    MaxKolRecovery:=NomRecovery;
  SetLength(ArrayHistKolRecovery,MaxKolRecovery+1);
  ArrayHistKolRecovery[NomRecovery]:=ArrayHistKolRecovery[NomRecovery]+1;
  end;
//  Inc(NomRecovery);
{  If NomFailure<20 then
    ArrayHistKolFailure[NomFailure]:=ArrayHistKolFailure[NomFailure]+1
  else
    ArrayHistKolFailure[20]:=ArrayHistKolFailure[20]+1;}

   for i:=0 to 3 do
    begin
    TimeOsn[i][0]:=(TimeOsn[i][0]*(KolProgon-1)+Node.Time[i]-Node.SostTime[i])/KolProgon;
    TimeOsn[i][1]:=(TimeOsn[i][1]*(KolProgon-1)+Sqr(Node.Time[i]-Node.SostTime[i]))/KolProgon;
    end;

{
  TimeOsn[0][0]:=(TimeOsn[0][0]*(KolProgon-1)+Node.Time[0])/KolProgon;
  TimeOsn[1][0]:=(TimeOsn[1][0]*(KolProgon-1)+Node.Time[1])/KolProgon;
  TimeOsn[2][0]:=(TimeOsn[2][0]*(KolProgon-1)+Node.Time[2])/KolProgon;
  TimeOsn[3][0]:=(TimeOsn[3][0]*(KolProgon-1)+Node.Time[3])/KolProgon;
}
{
  If Self.NameNode='Level0->Кондиционирование ТУ154' then
    FModel.MeProt.Lines.Add(' Node.Time[0]='+FloatToStr(Node.Time[0])+' Node.Time[1]='+FloatToStr(Node.Time[1])+' Node.Time[2]='+FloatToStr(Node.Time[2])+' Node.Time[3]='+FloatToStr(Node.Time[3]));
{
  for i:=0 to 3 do
    begin
    TimeOsn[i][0]:=(TimeOsn[i][0]*(KolProgon-1)+Node.Time[i])/KolProgon;
    TimeOsn[i][1]:=(TimeOsn[i][1]*(KolProgon-1)+Sqr(Node.Time[i]))/KolProgon;
//    TimeOsnBufer[i]:=0;
    end;
{  KolRecovery[0]:=(KolRecovery[0]*(KolProgon-1)+NomRecovery)/KolProgon;
  KolRecovery[1]:=(KolRecovery[1]*(KolProgon-1)+Sqr(NomRecovery))/KolProgon;
//  Inc(KolProgon);
  NomRecovery:=0;}
  end;

Procedure TRelationArc.Go;
var
CurrentFailure:TListFailure;
begin
CurrentFailure:=Node.Failure;
While (CurrentFailure<>nil) and not ((CurrentFailure.TypeRegulary=TypeRegulary) and (CurrentFailure.TypeFailure=TypeFailure)) do
  CurrentFailure:=CurrentFailure.NextFailure;
If CurrentFailure<>nil then
  begin
  Case ChangeReliability.TypeChange of
    0: (CurrentFailure.Parameters as TNormalFailure).Mx:=(CurrentFailure.Parameters as TNormalFailure).Mx*ChangeReliability.ParChangeMx;
    1: (CurrentFailure.Parameters as TNormalFailure).Mx:=(CurrentFailure.Parameters as TNormalFailure).Mx+ChangeReliability.ParChangeMx;
    2: (CurrentFailure.Parameters as TNormalFailure).Mx:=ChangeReliability.ParChangeMx;
    end;
  end;
end;

Procedure TStructureNode.AddFailure(TypeR,TypeFe:Byte; Par:TParametersFailure);
  var
  CurrentFailure,NewFailure:TListFailure;
  begin
  NewFailure:=TListFailure.Create;
  NewFailure.Node:=Self;
  NewFailure.TypeRegulary:=TypeR;
  NewFailure.TypeFailure:=TypeFe;
  NewFailure.Parameters:=Par;
  CurrentFailure:=Failure;
  If CurrentFailure=nil then
    Failure:=NewFailure
  else
    begin
    While CurrentFailure.NextFailure<>nil do
      CurrentFailure:=CurrentFailure.NextFailure;
    CurrentFailure.NextFailure:=NewFailure;
    end;
  end;

Procedure TStructureNode.DelFailure (TypeR,TypeFe:Byte);
  var
  CurrentFailure,DelFailure:TListFailure;
  begin
{  If not GoStat then
  UMainStructure.FMain.MeProt.Lines.Add('Удаление события отказа '+Self.Name);}
  CurrentFailure:=Failure;
  While (CurrentFailure<>nil) and (CurrentFailure.NextFailure.TypeRegulary<>TypeR) and (CurrentFailure.NextFailure.TypeFailure<>TypeFe) do
    CurrentFailure:=CurrentFailure.NextFailure;
  FreeAndNil(CurrentFailure);
  end;

Procedure TStructureNode.DelAllFailure;
 var
  CurrentFailure,DelFailure:TListFailure;
  begin
  CurrentFailure:=Failure;
  While (CurrentFailure<>nil) do
    begin
    DelFailure:=CurrentFailure;
    CurrentFailure:=CurrentFailure.NextFailure;
    FreeAndNil(DelFailure);
    end;
  end;
{
Procedure TGraph.SwitchOn;
  var
    CurrenTStructureNode:TStructureNode;
    NewEvent:tEventSwitch;
  begin
  If not GoStat then
  UMain.FMain.MeProt.Lines.Add('Включение графа '+Self.Name);
  CurrenTStructureNode:=Node;
  While CurrenTStructureNode<>nil do
    begin
    NewEvent:=TEventSwitch.Create;
    NewEvent.Node:=CurrenTStructureNode;
    NewEvent.EventTime:=Sbs.ModelTime+CurrenTStructureNode.TimeToSwitch;
    Sbs.AddEvent(NewEvent);
    If CurrenTStructureNode.SubGraph<>nil then
      CurrenTStructureNode.SubGraph.SwitchOn;
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;
}
Procedure TGraph.SwitchOFF;
  var
    CurrenTStructureNode:TStructureNode;
  begin
{  If not GoStat then
  UMainStructure.FMain.MeProt.Lines.Add('Отключение графа '+Self.Name); }
  CurrenTStructureNode:=Node;
  While CurrenTStructureNode<>nil do
    begin
    If  (CurrenTStructureNode.BoolFailure<>2) then
      CurrenTStructureNode.SwitchOFF;
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

Procedure TStructureNode.GoSwitch(KoefAction:Double; NameAction:String; TypeAction:Byte);
  var
  NomNode,NomFinish,i:Word;
  NodeList,FinishList:TArrayAction;
  NewEvent:tEventSwitchList;
  CurrentList:TActionList;

  Procedure GoActionList(CurrenTStructureNode:TStructureNode; CurrentAction:TActionList; StartToFinish:Byte);
    var
    CurrentList:TActionList;
    CurrentElement:TElementActionList;
    i:word;
    begin
    If CurrentAction<>nil then
    begin
    CurrentElement:=CurrentAction.FirstAction;
      While CurrentElement<>nil do
        begin
        //Поиск Совершивших действие или элемента, который добавить
        i:=0;
        If CurrentElement.TypeAction=1 then
          begin
            i:=0;
            While (i<Length(CurrentElement.Node)) and not ((CurrentElement.Node[i].BoolRegularly=1) and (CurrentElement.Node[i].BoolFailure<>2) and (CurrentElement.Node[i].BoolAvailability=1)) do
              inc(i);
            If i>=Length(CurrentElement.Node) then
              begin
              i:=0;
              While (i<Length(CurrentElement.Node)) and not ((CurrentElement.Node[i].BoolRegularly=0) and (CurrentElement.Node[i].BoolFailure<>2) and (CurrentElement.Node[i].BoolAvailability=1)) do
                inc(i);
              end;
            end;
        If (Length(CurrentElement.Node)<>0) and (i<Length(CurrentElement.Node)) then
          begin
          //Ищем действие по названию
          CurrentList:=CurrentElement.Node[i].SearchActionName(CurrentElement.NameAction);
          If CurrentList<>nil then
            GoActionList(CurrentElement.Node[i],CurrentList,CurrentElement.StartToFinish);  //Для включения устройства нужно еще что-то сделать
          end;
        CurrentElement:=CurrentElement.NextElement;
      end;
      //Сохранение действия, которое попало в процедуру
    If StartToFinish=0 then
      begin
      Inc(NomNode);
      SetLength(NodeList,NomNode);
      NodeList[NomNode-1]:=TElementAction.Create;
      NodeList[NomNode-1].Node:=CurrenTStructureNode;
      NodeList[NomNode-1].TypeAction:=CurrentAction.TypeAction;
      NodeList[NomNode-1].NameAction:=CurrentAction.NameAction;
      NodeList[NomNode-1].KoefAction:=CurrentAction.KoefAction;
      NodeList[NomNode-1].TimeAction:=CurrentAction.TimeAction;
      end
    else
      begin
      Inc(NomFinish);
      SetLength(FinishList,NomFinish);
      FinishList[NomFinish-1]:=TElementAction.Create;
      FinishList[NomFinish-1].Node:=CurrenTStructureNode;
      FinishList[NomFinish-1].TypeAction:=CurrentAction.TypeAction;
      FinishList[NomFinish-1].NameAction:=CurrentAction.NameAction;
      FinishList[NomFinish-1].KoefAction:=CurrentAction.KoefAction;
      FinishList[NomFinish-1].TimeAction:=CurrentAction.TimeAction;
      end

  end;
  end;

  begin
  NomNode:=0;
  NomFinish:=0;
  SetLength(NodeList,0);
  SetLength(FinishList,0);
  If ActionLisTStructureNode<>nil then
    GoActionList(Self,SearchActionName(NameAction),0);
  If Length(NodeList)<>0 then
  begin
  If NomFinish<>0 then
  For i:=Length(FinishList)-1 downto 0  do
    begin
    inc(NomNode);
    SetLength(NodeList,NomNode);
    NodeList[NomNode-1]:=TElementAction.Create;
    NodeList[NomNode-1].Node:=FinishList[i].Node;
    NodeList[NomNode-1].TypeAction:=FinishList[i].TypeAction;
    NodeList[NomNode-1].NameAction:=FinishList[i].NameAction;
    NodeList[NomNode-1].KoefAction:=FinishList[i].KoefAction;
    NodeList[NomNode-1].TimeAction:=FinishList[i].TimeAction;
    end;
  If Length(FinishList)<>0 then
  For i:=0 to Length(FinishList)-1 do
    begin
    FreeAndNil(FinishList[i]);
    end;
//  If not GoStat then
//     UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Создается последовательность действий '+Self.Name);
//  If GoProtocolEvent then
//    UMain.FModel.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Создается последовательность действий борта '+UMainStructure.Structure.Name+' '+UMainStructure.Structure.Nomber+' - '+NameAction);
  NewEvent:=TEventSwitchList.Create;
  NewEvent.Structure:=UMainStructure.Structure;
  NewEvent.Node:=NodeList;
  NewEvent.NomNode:=0;
  NewEvent.KolNode:=NomNode;
  NewEvent.EventTime:=Sbs.ModelTime+NewEvent.Node[NewEvent.NomNode].TimeAction;
  Sbs.AddEvent(NewEvent);
  end;
  end;

Procedure TStructureNode.SwitchON(TimeSwitch:Double; KoefAction:Double);
  var
  CurrentFailure:TListFailure;
  CurrentDouble:TDoubleArc;
  CurrenTStructureNode:TStructureNode;
  begin
{  If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Включение элемента '+Self.Name);
 }
//  If not GoStat then
//  UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Включение элемента '+Self.Name);
  //Удаление всех событий отказа в выключенном состоянии
  CurrentFailure:=Failure;
  While (CurrentFailure<>nil) do
    begin
    If (CurrentFailure.TypeRegulary=BoolRegularly) then
      CurrentFailure.DelFailure;
    CurrentFailure:=CurrentFailure.NextFailure;
    end;
  SaveTime;
  KoefFailureSwitchOn:=KoefAction;
  BoolRegularly:=1;                    //Изменение состояния
  //Создание событий отказа включенного устройства
  CurrentFailure:=Failure;
  While (CurrentFailure<>nil) do
    begin
    If (CurrentFailure.TypeRegulary=BoolRegularly) then
      begin
//      CurrentFailure.DelFailure;
      CurrentFailure.GoFailure;
      end;
    CurrentFailure:=CurrentFailure.NextFailure;
    end;
  //Включение надуровня
{  If (ImpactLevel=1) and (Graph.FatherNodeGraph.BoolFailure=0) and (Graph.FatherNodeGraph.BoolRegularly=0) then
    begin
//    Graph.FatherNodeGraph.GoSwitch(1,'Включение',1);
    end;}
  //Включение нужных
{  CurrentDouble:=Self.DoubleRelationUp;
  While CurrentDouble<>nil do
    begin
    If (CurrentDouble.Node.BoolFailure=2) then
      begin
      Dec(CurrentDouble.Node.KolElementToFailure);
      if (CurrentDouble.Node.KolElementToFailure=0) then
        begin
        CurrentDouble.Node.GoRecovery(TimeSwitch);                 //Востановление отказавшего элемента из-за отказа всех дублирующих
        CurrentDouble.Node.SwitchON(TimeSwitch,1);
        end;
      end;
    CurrentDouble:=CurrentDouble.NextArc;
    end;                 }
  //Поиск и удаление тех, кто дублировал
{  CurrentDouble:=self.DoubleNode;
  While (CurrentDouble<>nil) do
    begin
    CurrentDouble.Node.DelDoubleRelationUp(Self.Graph.FatherNodeGraph);
    CurrentDouble:=CurrentDouble.NextArc;
    end;
  //Включение всего подграфа
{  If SubGraph<>nil then
    SubGraph.SwitchON;}
  end;

procedure TStructureNode.SaveTime;

  begin
  If BoolAvailability=0 then
    Time[3]:=Time[3]+(Sbs.ModelTime-Self.LastTime)
  else
  IF BoolFailure=2 then
    Time[2]:=Time[2]+(Sbs.ModelTime-Self.LastTime)
  else
  IF BoolRegularly=0 then
    Time[0]:=Time[0]+(Sbs.ModelTime-Self.LastTime)*KoefFailureSwitch
  else
    Time[1]:=Time[1]+(Sbs.ModelTime-Self.LastTime)*KoefFailureSwitchOn;
  Self.LastTime:=Sbs.ModelTime;
  end;

Procedure TStructureNode.SwitchOFF;
  var
  CurrentFailure:TListFailure;
  begin
  if Self.DoubleRelationUp=nil then
  begin
//  If not GoStat then
//  UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Выключение элемента '+Self.Name);
    //Удаление всех событий отказа во включенном состоянии
  CurrentFailure:=Failure;
  While (CurrentFailure<>nil) do
    begin
    If (CurrentFailure.TypeRegulary=BoolRegularly) then
      CurrentFailure.DelFailure;
    CurrentFailure:=CurrentFailure.NextFailure;
    end;
  SaveTime;
  BoolRegularly:=0;                    //Изменение состояния
  //Создание событий отказа выключенного устройства
  CurrentFailure:=Failure;
  While (CurrentFailure<>nil) do
    begin
    If (CurrentFailure.TypeRegulary=BoolRegularly) then
      begin
//      CurrentFailure.DelFailure;
      CurrentFailure.GoFailure;
      end;
    CurrentFailure:=CurrentFailure.NextFailure;
    end;
  //Включение всего подграфа
  If SubGraph<>nil then
    SubGraph.SwitchOFF;
  end;
  end;

procedure TStructureNode.GoAvailability;
  var
    i:Byte;
  begin
  {  Inc(NomProtocol);
    SetLength(ProtocolEvent,NomProtocol);
    ProtocolEvent[NomProtocol-1].Time:=Sbs.ModelTime;
    ProtocolEvent[NomProtocol-1].EvenTStructureNodeName:=Graph.Name+'->'+Name;
    ProtocolEvent[NomProtocol-1].TypeEvent:=2;
   }
  //Сохранение времен
  SaveTime;
  //Сохранение статистики по элементу
//  Stat.SaveStatisticRecovery;
  //Обнуление параметров
  For i:=0 to 3 do
    Time[i]:=0;
  BoolAvailability:=1;
  BoolReplacement:=0;
  end;

Procedure TListFailure.DelFailure;
  begin
  FreeAndNil(Event);  
  //Удаление событие через деструктор
//  If not GoStat then
//  UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Удаление отказа');
  If Event<>nil then
    begin

    end
  else
//  If not GoStat then
//    UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' В СБС нет отказа');
  end;

Procedure TListFailure.GoFailure;
  var
  NewEvent:TEventFailure;
  TimeFailure:Double;
  begin
  If Node<>nil then
  begin
//  If not GoStat then
//  UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Создание события отказа');
  NewEvent:=TEventFailure.Create;
  NewEvent.Structure:=UMainStructure.Structure;
  NewEvent.Node:=Node;
  Self.Event:=NewEvent;
  If TypeRegulary=0 then
    begin
    TimeFailure:=Parameters.GetTime(0)/KoefFailureSwitch+Node.Time[0];
    If TimeFailure>Sbs.ModelTime then
      NewEvent.EventTime:=TimeFailure
    else
       NewEvent.EventTime:=Sbs.ModelTime;
    end
  else
    begin
    TimeFailure:=Parameters.GetTime(0)/KoefFailureSwitch+Node.Time[1];
    If TimeFailure>Sbs.ModelTime then
      NewEvent.EventTime:=TimeFailure
    else
       NewEvent.EventTime:=Sbs.ModelTime;
    end;
//  IF TypeCollection=1 then
//    NewEvent.EventTime:=NewEvent.EventTime-Node.Time[TypeRegulary];
  SBS.AddEvent(NewEvent);

  end;
  end;

Procedure TStructureNode.GoFailure(TimeFailure:Double; GoDouble:Byte);
var
CurrentRelation:TRelationArc;
CurrentDouble:TDoubleArc;
CurrentSensor:TSensorArc;
KolDooble:Byte;
BDooble:Boolean;
NewEvent:TEventSwitch;
CurFailure:TListFailure;
NewEventRenovation:TEventRenovation;
ImpLevel,DblEl:Byte;
begin
{
    Inc(NomProtocol);
    SetLength(ProtocolEvent,NomProtocol);
    ProtocolEvent[NomProtocol-1].Time:=Sbs.ModelTime;
    ProtocolEvent[NomProtocol-1].EvenTStructureNodeName:=Graph.Name+'->'+Name;
    ProtocolEvent[NomProtocol-1].TypeEvent:=0;
                                   }
//If not GoStat then
//   UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' '+Self.Name+' переведен в состояние "ОТКАЗ"');


SaveTime;
If GoProtocolEvent then
   begin
   FModel.MeProt.Lines.Add(FloatToStr(TimeFailure)+' '+Self.Name+' переведен в состояние "ОТКАЗ" Время: Time[0]='+FloatToStr(Time[0])+' Time[1]='+FloatToStr(Time[1])+' Time[2]='+FloatToStr(Time[2])+' Time[3]='+FloatToStr(Time[3]));
   end;

BoolFailure:=2;  //0-работает 1- неисправность 2- отказ
BoolSearchFailure:=0;
Self.FailureBySwitchOn:=BoolRegularly; //Запоминаем что отказ произошел в состоянии
BoolRegularly:=0;  //Выключить
//Удаление событий отказов
CurFailure:=failure;
While CurFailure<>nil do
  begin
  if CurFailure.Event<>nil then
    begin
    FreeAndNil(CurFailure.Event);
    end;
  CurFailure:=CurFailure.NextFailure;
  end;
//Отключение подграфа
If SubGraph<>nil then
  begin
  SubGraph.SwitchOFF;
  end;
//Учет зависимостей
CurrentRelation:=RelationNode;
While CurrentRelation<>nil do
  begin
//  If not GoStat then
//  UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Учитывается влияние отказа на '+CurrentRelation.Node.Name);
  CurrentRelation.Go;
  CurrentRelation:=CurrentRelation.NextArc;
  end;
//Дублирование
BDooble:=false;
KolDooble:=0;
CurrentDouble:=DoubleNode;
While CurrentDouble<>nil do
  begin
  If (CurrentDouble.Node.BoolFailure<>2) and (CurrentDouble.Node.BoolRegularly=1) then //Что делать если =1
    begin
    BDooble:=true;
    Inc(KolDooble);
    end;
  CurrentDouble:=CurrentDouble.NextArc;
  end;
CurrentDouble:=DoubleNode;
IF GoDouble=0 then     //Если в последовательности выключений еще не включался дублирующий элемент
While (CurrentDouble<>nil) and (KolDooble<KolParallelNode) do
  begin
  If (CurrentDouble.Node.BoolFailure<>2) and (CurrentDouble.Node.BoolRegularly=0) then  //0-выключен 1-включен
    begin
    Inc(KolDooble);
//    If not GoStat then
//      UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Включается дублирующий элемент '+CurrentDouble.Node.Name);
    CurrentDouble.Node.GoSwitch(KoefFailureSwitchOn,'Включение',1);        //Включение
    GoDouble:=1;
    If (self.ImpactLevel=1) and (CurrentDouble.Node.Graph<>Self.Graph) then
      CurrentDouble.Node.AddDoubleRelationUp(Self.Graph.FatherNodeGraph);                //Создание зависимости
//    BDooble:=true;   //Дублирующий включается???
    end;
  CurrentDouble:=CurrentDouble.NextArc;
  end;
//Включение датчиков
CurrentSensor:=SensorNode;
While CurrentSensor<>nil do
  begin
  CurrentSensor.Node.GoSwitch(KoefFailureSwitchOn,'Включение',1);
//  If not GoStat then
//  UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Включается датчик '+CurrentSensor.Node.Name);
  CurrentSensor:=CurrentSensor.NextArc;
  end;
//Автовастоновление
If AutoRenovation<>nil then
  begin
  NewEventRenovation:=TEventRenovation.Create;
  NewEventRenovation.Node:=Self;
  NewEventRenovation.EventTime:=Sbs.ModelTime+Self.AutoRenovation.GetTime(Self.Time[1]);
  Sbs.AddEvent(NewEventRenovation);
  end;
//Отключение все что по поводу дублирования
{CurrentDouble:=Self.DoubleRelationUp;
If (not BDooble) and (ImpactLevel=1) then
While CurrentDouble<>nil do
  begin
  If CurrentDouble.Node.BoolFailure<>2 then
    begin
    CurrentDouble.Node.GoFailure(TimeFailure,GoDouble);
    end;
  CurrentDouble:=CurrentDouble.NextArc;
  end;     }
//Учет последовательности неисправностей
ImpLevel:=0;
If (Graph.FatherNodeGraph<>nil) then
  begin
  If (not BDooble) and (ImpactLevel=1) and (Graph.FatherNodeGraph.BoolFailure<>2) then
    begin
//    If not GoStat then
//    UMainStructure.FMain.MeProt.Lines.Add(FloatToStr(Sbs.ModelTime)+' Отказ элемента верхнего уровня');
    Graph.FatherNodeGraph.GoFailure(TimeFailure,GoDouble);  //Отказ элемента верхнего уровня
    ImpLevel:=1;
    end
  else
    If (Graph.FatherNodeGraph.BoolFailure<>2) then
      Graph.FatherNodeGraph.BoolFailure:=1; //0-работает 1- неисправность 2- отказ
  Inc(Graph.FatherNodeGraph.KolElementToFailure);
  end;
Stat.SaveStatisticFailure(TimeFailure,ImpLevel,GoDouble);

//Запланировать востановление элемента
{IF FailureBySwitchOn=1 then
  Self.GoSwitch(1,'Замена',255);}
end;

Procedure TStructureNode.GoRecovery (TimeRecovery:Double);
var
CurrentDouble,CurrentRelation:TDoubleArc;
CurrenTStructureNode:TStructureNode;
DoubleSwitch,CurrentSwitch:byte;
i:Byte;
begin
{    Inc(NomProtocol);
    SetLength(ProtocolEvent,NomProtocol);
    ProtocolEvent[NomProtocol-1].Time:=Sbs.ModelTime;
    ProtocolEvent[NomProtocol-1].EvenTStructureNodeName:=Graph.Name+'->'+Name;
    ProtocolEvent[NomProtocol-1].TypeEvent:=1;
 }
If GoProtocolEvent then
   begin
   FModel.MeProt.Lines.Add(FloatToStr(TimeRecovery)+' '+Self.Name+' Восстановление');
   end;
SaveTime;
BoolFailure:=0;  //Установка рабочего состояния
BoolSearchFailure:=0;
BoolReplacement:=0;
{If Self.FailureBySwitchOn=1 then
  Self.GoSwitch(1,'Включение',1)
else                }
SwitchOFF;
DoubleSwitch:=0;
Stat.SaveStatisticRecovery(TimeRecovery);
If (Self.ImpactLevel=1) and (Graph.FatherNodeGraph.BoolFailure=2) then
  begin
  CurrenTStructureNode:=Self.Graph.Node;
  While CurrenTStructureNode<>nil do
    begin
    If (CurrenTStructureNode.BoolFailure=2) and (CurrenTStructureNode.ImpactLevel=1) then
      begin
      CurrentSwitch:=0;
      CurrentDouble:=CurrenTStructureNode.DoubleNode;
      While CurrentDouble<>nil do
        begin
        if CurrentDouble.Node.BoolFailure<>2 then
          Inc(CurrentSwitch);
        CurrentDouble:=CurrentDouble.NextArc;
        end;
      if CurrentSwitch=0 then
        Inc(DoubleSwitch);
      end;
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  if DoubleSwitch=0 then
    Graph.FatherNodeGraph.GoRecovery(TimeRecovery);        //Востановление элемента надуровня
  end;
end;

{  If{ (Graph.FatherNodeGraph<>nil) and }{(Graph.FatherNodeGraph.BoolFailure<>2) then
{  begin
    CurrentDouble:=Self.DoubleNode;
    CurrentSwitch:=0;
  While (CurrentDouble<>nil) do
    begin
    If CurrentDouble.Node.BoolRegularly=1 then
      begin
    Inc(DoubleSwitch);
      If CurrentSwitch=0 then
        begin
        CurrentRelation:=Self.Graph.FatherNodeGraph.DoubleRelationDown;
        While (CurrentRelation<>nil) and (CurrentRelation.Node<>CurrentDouble.Node) do
          CurrentRelation:=CurrentRelation.NextArc;
        If CurrentRelation<>nil then
          begin
         //Если верхний уровень работает на дубле
          Self.GoSwitch(1,'Включение',1);
          CurrentSwitch:=1;
          end;
        end;
      end;
    CurrentDouble:=CurrentDouble.NextArc;
    end;
  end;  
  If DoubleSwitch=0 then
    begin
    //Все дублирующие элементы были в состоянии ОТКАЗ
    //Проверить есть ли еще что-то мешающее востановлению
    Dec(Graph.FatherNodeGraph.KolElementToFailure);
    If Graph.FatherNodeGraph.KolElementToFailure=0 then
      Graph.FatherNodeGraph.GoRecovery;        //Востановление элемента надуровня
    CurrentDouble:=Self.DoubleNode;
    While CurrentDouble<>nil do
      begin
      If (CurrentDouble.Node.Graph.FatherNodeGraph.BoolFailure=2) then
        Dec(CurrentDouble.Node.Graph.FatherNodeGraph.KolElementToFailure);
      If (CurrentDouble.Node.Graph.FatherNodeGraph.BoolFailure=2) and (CurrentDouble.Node.Graph.FatherNodeGraph.KolElementToFailure=0) then
      begin
      Self.AddDoubleRelationUp(CurrentDouble.Node.Graph.FatherNodeGraph);  //Создание зависимости
      CurrentDouble.Node.Graph.FatherNodeGraph.GoRecovery;                 //Востановление отказавшего элемента из-за отказа всех дублирующих
      end;
      CurrentDouble:=CurrentDouble.NextArc;
      end;
    end;
  end;
end;         }

Function TStructureNode.SearchActionName(NameAction:string):TActionList;
  var
  CurrentAction:TActionList;
  begin
  CurrentAction:=Self.ActionLisTStructureNode;
  While (CurrentAction<>nil) and (CurrentAction.NameAction<>NameAction) do
    CurrentAction:=CurrentAction.NextList;
  Result:=CurrentAction;
  end;

Procedure TStructureNode.CopyAllArc(OldNode:TStructureNode);
var
CurrentDoubleArc, NewDoubleArc: TDoubleArc;
CurrentRelationArc, NewRelationArc: TRelationArc;
CurrentSensorArc, NewSensorArc: TSensorArc;
begin
CurrentDoubleArc:=OldNode.DoubleNode;
While CurrentDoubleArc<>nil do
  begin
  NewDoubleArc:=AddDoubleArc(CurrentDoubleArc.Node);
  CurrentDoubleArc:=CurrentDoubleArc.NextArc;
  end;
CurrentRelationArc:=OldNode.RelationNode;
While CurrentRelationArc<>nil do
  begin
  NewRelationArc:=AddRelationArc(CurrentRelationArc.Node);
  CurrentRelationArc:=CurrentRelationArc.NextArc;
  end;
CurrentSensorArc:=OldNode.SensorNode;
While CurrentSensorArc<>nil do
  begin
  NewSensorArc:=AddSensorArc(CurrentSensorArc.Node);
  CurrentSensorArc:=CurrentSensorArc.NextArc;
  end;
end;

Function TGraph.CreateListCuTStructureNode:TStructureNode;
  var
  FirsTStructureNodeList,LasTStructureNodeList:TStructureNode;
  CurrenTStructureNode,NexTStructureNode,PreNode:TStructureNode;
  begin
  PreNode:=nil;
  CurrenTStructureNode:=Node;
  FirsTStructureNodeList:=nil;
  While CurrenTStructureNode<>nil do
    begin
    NexTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    If CurrenTStructureNode.BoolAvailability=0 then
      begin
      {Выдернули из графа}
      If PreNode=nil then
        Node:=CurrenTStructureNode.NexTStructureNode
      else
        PreNode.NexTStructureNode:=CurrenTStructureNode.NexTStructureNode;
      {Удалили зависимые дуги}
      CurrenTStructureNode.DelAllDoubleArc;
      CurrenTStructureNode.DelAllRelationArc;
      CurrenTStructureNode.DelAllSensorArc;
      CurrenTStructureNode.NexTStructureNode:=nil;
      CurrenTStructureNode.Graph:=nil;
      CurrenTStructureNode.Failure:=nil; //!!!!!!!!!!!!!!!!!!!!!!!!!!!11
      {Добавили в список элементов}
      If FirsTStructureNodeList=nil then
        FirsTStructureNodeList:=CurrenTStructureNode
      else
        LasTStructureNodeList.NexTStructureNode:=CurrenTStructureNode;
      LasTStructureNodeList:=CurrenTStructureNode;
      end;
    CurrenTStructureNode:=NexTStructureNode;
    end;
  Result:=FirsTStructureNodeList;
  end;

Function TGraph.SearchNodeName(Name:String):TStructureNode;
  var
  SearchNode:TStructureNode;
  begin
  SearchNode:=Node;
  While (SearchNode<>nil) and (SearchNode.Name<>Name) do
    SearchNode:=SearchNode.NexTStructureNode;
  Result:=SearchNode;
  end;

function TGraph.SearchNodeNameAllStructure(NameNode:String):TStructureNode;
  var
    CNode,SearchNode:TStructureNode;
  begin
  SearchNode:=nil;
  CNode:=Node;
  While (CNode<>nil) and (SearchNode=nil) do
    begin
    If (Pos(':',CNode.Name)=0) and (NameNode=CNode.Name)
    or (Pos(':',CNode.Name)<>0) and (NameNode=Copy(CNode.Name,1,Pos(':',CNode.Name)-1)) then
      SearchNode:=CNode;
    if (SearchNode=nil) and (CNode.SubGraph<>nil) then
      SearchNode:=CNode.SubGraph.SearchNodeNameAllStructure(NameNode);
    CNode:=CNode.NexTStructureNode;
    end;
  Result:=SearchNode;
  end;

Function TGraph.AddNode(Search:Boolean; Name:String):TStructureNode;
  var
  NewNode,LasTStructureNode:TStructureNode;
  NewAction:TActionList;
  begin
  NewNode:=nil;
  If Search then
    NewNode:=SearchNodeName(Name);
  If NewNode=nil then
    begin
    NewNode:=TStructureNode.Create;
    NewNode.Name:=Name;
    NewNode.Graph:=Self;
    NewNode.Time[0]:=0;
    NewNode.Time[1]:=0;
    NewNode.Time[2]:=0;
    NewNode.Time[3]:=0;
    NewNode.LastTime:=0;            
    NewAction:=TActionList.Create;
    NewAction.NameAction:='Выключение';
    NewAction.TypeAction:=0;
    NewAction.TimeAction:=0;
    NewAction.KoefAction:=1;
    NewAction.FirstAction:=nil;
    NewNode.ActionLisTStructureNode:=NewAction;
    LasTStructureNode:=Node;
    If LasTStructureNode=nil then
      Node:=NewNode
    else
      begin
      While LasTStructureNode.NexTStructureNode<>nil do
        LasTStructureNode:=LasTStructureNode.NexTStructureNode;
      LasTStructureNode.NexTStructureNode:=NewNode;
      end;
    end;
  Result:=NewNode;
  end;

Procedure TGraph.DeleteNode (Name:String);
  var
  NexTStructureNode,DelNode:TStructureNode;
  begin
  DelNode:=Node;
  While DelNode<>nil do
    begin
    NexTStructureNode:=DelNode.NexTStructureNode;
    FreeAndNil(DelNode);
    DelNode:=NexTStructureNode;
    end;
  end;

function TGraph.SearchFailureNodeGraphName(Name:String):TStructureNode;
  var
    CurrentNode,SearchNode:TStructureNode;
  begin
  CurrentNode:=Node;
  SearchNode:=nil;
  While (CurrentNode<>nil) and (SearchNode=nil) do
    begin
    If (CurrentNode.Name=Name) and (CurrentNode.BoolFailure=2){ and (CurrentNode.BoolSearchFailure=1)} then
      SearchNode:=CurrentNode;
    IF (SearchNode=nil) and (CurrentNode.SubGraph<>nil) then
      SearchNode:=CurrentNode.SubGraph.SearchFailureNodeGraphName(Name);
    CurrentNode:=CurrentNode.NexTStructureNode;
    end;
  Result:=SearchNode;
  end;

Function TActionList.AddActionListArc(NameAction:string; TypeAction:Byte; NodeKon:TStructureNode):TElementActionList;
  var
  CurrentElementAction,NewElementAction:TElementActionList;
  begin
  NewElementAction:=TElementActionList.Create;
  SetLength(NewElementAction.Node,1);
  NewElementAction.Node[0]:=NodeKon;
  NewElementAction.NameAction:=NameAction;
  NewElementAction.TypeAction:=TypeAction;
  CurrentElementAction:=Self.FirstAction;
  If CurrentElementAction=nil then
    Self.FirstAction:=NewElementAction
  else
    begin
    While CurrentElementAction.NextElement<>nil do
      CurrentElementAction:=CurrentElementAction.NextElement;
    CurrentElementAction.NextElement:=NewElementAction;
    end;
  Result:=NewElementAction;
  end;

Function TActionList.AddSearchFailure(NodeKon:TStructureNode; Reliability:Double):TSearchFailure;
  var
  NewSearch,CurrentSearch:TSearchFailure;
  begin
  CurrentSearch:=ListSearchFailure;
  If CurrentSearch=nil then
    begin
    NewSearch:=TSearchFailure.Create;
    NewSearch.NextSearch:=nil;
    NewSearch.Node:=NodeKon;
    NewSearch.reliability:=Reliability;
    ListSearchFailure:=NewSearch;
    end
  else
    begin
    While (CurrentSearch.NextSearch<>nil) and (CurrentSearch.Node<>NodeKon) do
      CurrentSearch:=CurrentSearch.NextSearch;
    If CurrentSearch.NextSearch<>nil then
      result:=CurrentSearch
    else
      begin
      NewSearch:=TSearchFailure.Create;
      NewSearch.NextSearch:=nil;
      NewSearch.Node:=NodeKon;
      NewSearch.reliability:=Reliability;
      CurrentSearch.NextSearch:=NewSearch;
      end;
    end;
  end;

Function TStructureNode.AddDoubleArc(NodeKon:TStructureNode):TDoubleArc;
  var
  NewArc,NewArcD,CurrentArc:TDoubleArc;
  begin
  //Добавление дублирующей дуги
  NewArc:=TDoubleArc.Create;
  NewArc.Node:=NodeKon;
  CurrentArc:=DoubleNode;
  If CurrentArc=nil then
    DoubleNode:=NewArc
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
    end;
  //Добавление дублирующей дуги в противоположном направлении
  NewArcD:=TDoubleArc.Create;
  NewArcD.Node:=Self;
  CurrentArc:=NodeKon.DoubleNode;
  If CurrentArc=nil then
    NodeKon.DoubleNode:=NewArcD
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArcD;
    end;
  Result:=NewArc;
  end;

Function TStructureNode.AddDoubleRelationUp(NodeKon:TStructureNode):TDoubleArc;
  var
  NewArc,NewArcD,CurrentArc:TDoubleArc;
  begin
  //Добавление дублирующей дуги
  NewArc:=TDoubleArc.Create;
  NewArc.Node:=NodeKon;
  CurrentArc:=DoubleRelationUp;
  If CurrentArc=nil then
    DoubleRelationUp:=NewArc
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
    end;
  //Добавление дублирующей дуги в противоположном направлении
  NewArcD:=TDoubleArc.Create;
  NewArcD.Node:=Self;
  CurrentArc:=NodeKon.DoubleRelationDown;
  If CurrentArc=nil then
    NodeKon.DoubleRelationDown:=NewArcD
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArcD;
    end;
  Result:=NewArc;
  end;

Function TStructureNode.AddRelationArc(NodeKon:TStructureNode):TRelationArc;
  var
  NewArc,CurrentArc:TRelationArc;
  begin
  NewArc:=TRelationArc.Create;
  NewArc.Node:=NodeKon;
  CurrentArc:=RelationNode;
  If CurrentArc=nil then
    RelationNode:=NewArc
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
    end;
  Result:=NewArc;
  end;

Function TStructureNode.AddSensorArc(NodeKon:TStructureNode):TSensorArc;
  var
  NewArc,CurrentArc:TSensorArc;
  begin
  NewArc:=TSensorArc.Create;
  NewArc.Node:=NodeKon;
  CurrentArc:=SensorNode;
  If CurrentArc=nil then
    SensorNode:=NewArc
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
    end;
  Result:=NewArc;
  end;

Function TStructureNode.AddActionArc(NameAction:string):TActionList;
  var
  CurrentAction,NewAction:TActionList;
  begin
  CurrentAction:=SearchActionName(NameAction);
  If CurrentAction=nil then
    begin
    NewAction:=TActionList.Create;
    NewAction.NameAction:=NameAction;
    CurrentAction:=ActionLisTStructureNode;
    If CurrentAction=nil then
      ActionLisTStructureNode:=NewAction
    else
      begin
      While CurrentAction.NextList<>nil do
        CurrentAction:=CurrentAction.NextList;
      CurrentAction.NextList:=NewAction;
      end;
    Result:=NewAction;
    end
  else
    Result:=CurrentAction;
  end;


Procedure TStructureNode.DelDoubleArc(NodeKon:TStructureNode);
  var
  DelArc,PreArc:TDoubleArc;
  begin
  PreArc:=nil;
  DelArc:=DoubleNode;
  While (DelArc<>nil) and (DelArc.Node<>NodeKon) do
    begin
    PreArc:=DelArc;
    DelArc:=DelArc.NextArc;
    end;
  If DelArc<>nil then
  begin
  If PreArc=nil then
    DoubleNode:=DelArc.NextArc
  else
    PreArc.NextArc:=DelArc.NextArc;
  FreeAndNil(DelArc);
  end;
  end;

Procedure TStructureNode.DelDoubleRelationUp(NodeKon:TStructureNode);
  var
  DelArc,PreArc:TDoubleArc;
  CurrenTStructureNode:TStructureNode;
  begin
  PreArc:=nil;
  DelArc:=DoubleRelationDown;
  While (DelArc<>nil) and (DelArc.Node<>NodeKon) do
    begin
    PreArc:=DelArc;
    DelArc:=DelArc.NextArc;
    end;
  If DelArc<>nil then
  begin
  If PreArc=nil then
    DoubleRelationDown:=DelArc.NextArc
  else
    PreArc.NextArc:=DelArc.NextArc;
  CurrenTStructureNode:=DelArc.Node;
  FreeAndNil(DelArc);

  PreArc:=nil;
  DelArc:=CurrenTStructureNode.DoubleRelationUp;
  While (DelArc<>nil) and (DelArc.Node<>NodeKon) do
    begin
    PreArc:=DelArc;
    DelArc:=DelArc.NextArc;
    end;
  If PreArc=nil then
    CurrenTStructureNode.DoubleRelationUp:=DelArc.NextArc
  else
    PreArc.NextArc:=DelArc.NextArc;
  FreeAndNil(DelArc);
  end;
  end;

Procedure TStructureNode.DelRelationArc(NodeKon:TStructureNode);
  var
  DelArc,PreArc:TRelationArc;
  begin
  PreArc:=nil;
  DelArc:=RelationNode;
  While (DelArc<>nil) and (DelArc.Node<>NodeKon) do
    begin
    PreArc:=DelArc;
    DelArc:=DelArc.NextArc;
    end;
  If PreArc=nil then
    RelationNode:=DelArc.NextArc
  else
    PreArc.NextArc:=DelArc.NextArc;
  FreeAndNil(DelArc);
  end;

Procedure TStructureNode.DelSensorArc(NodeKon:TStructureNode);
  var
  DelArc,PreArc:TSensorArc;
  begin
  PreArc:=nil;
  DelArc:=SensorNode;
  While (DelArc<>nil) and (DelArc.Node<>NodeKon) do
    begin
    PreArc:=DelArc;
    DelArc:=DelArc.NextArc;
    end;
  If PreArc=nil then
    SensorNode:=DelArc.NextArc
  else
    PreArc.NextArc:=DelArc.NextArc;
  FreeAndNil(DelArc);
  end;

Procedure TStructureNode.DelAllDoubleArc;
  var
  DelArc,NextArc:TDoubleArc;
  begin
  DelArc:=DoubleNode;
  If DelArc<>nil then
    begin
    NextArc:=DelArc.NextArc;
    While (DelArc<>nil) do
      begin
      FreeAndNil(DelArc);
      DelArc:=NextArc;
      If DelArc<>nil then
      NextArc:=DelArc.NextArc;
      end;
    DoubleNode:=nil;
    end;

  DelArc:=DoubleRelationDown;
  If DelArc<>nil then
    begin
    NextArc:=DelArc.NextArc;
    While (DelArc<>nil) do
      begin
      FreeAndNil(DelArc);
      DelArc:=NextArc;
      If DelArc<>nil then
      NextArc:=DelArc.NextArc;
      end;
    DoubleNode:=nil;
    end;

  DelArc:=DoubleRelationUp;
  If DelArc<>nil then
    begin
    NextArc:=DelArc.NextArc;
    While (DelArc<>nil) do
      begin
      FreeAndNil(DelArc);
      DelArc:=NextArc;
      If DelArc<>nil then
      NextArc:=DelArc.NextArc;
      end;
    DoubleNode:=nil;
    end;
  end;

Procedure TStructureNode.DelAllRelationArc;
  var
  DelArc,NextArc:TRelationArc;
  begin
  DelArc:=RelationNode;
  If DelArc<>nil then
    begin
    NextArc:=DelArc.NextArc;
    While (DelArc<>nil) do
      begin
      FreeAndNil(DelArc);
      DelArc:=NextArc;
      If DelArc<>nil then
      NextArc:=DelArc.NextArc;
      end;
    RelationNode:=nil;
    end;
  end;

Procedure TStructureNode.DelAllSensorArc;
  var
  DelArc,NextArc:TSensorArc;
  begin
  DelArc:=SensorNode;
  If DelArc<>nil then
    begin
    NextArc:=DelArc.NextArc;
    While (DelArc<>nil) do
      begin
      FreeAndNil(DelArc);
      DelArc:=NextArc;
      If DelArc<>nil then
      NextArc:=DelArc.NextArc;
      end;
    SensorNode:=nil;
    end;
  end;

Procedure TStructureNode.DelAllActionArc;
  var
  DelArc,NextArc:TActionList;
  begin
  DelArc:=ActionLisTStructureNode;
  If DelArc<>nil then
    begin
    NextArc:=DelArc.NextList;
    While (DelArc<>nil) do
      begin
      FreeAndNil(DelArc);
      DelArc:=NextArc;
      If NextArc<>nil then
      NextArc:=NextArc.NextList;
      end;
    ActionLisTStructureNode:=nil;
    end;
  end;

Constructor TGraph.Create;
  begin
  inherited;
  Name:='';
  Node:=nil;
  FatherNodeGraph:=nil;
  end;

Destructor TGraph.Destroy;
  var
  CurrenTStructureNode,NexTStructureNode:TStructureNode;
  begin
      If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление графа');
  CurrenTStructureNode:=Node;
  While CurrenTStructureNode<>nil do
    begin
{    If CurrenTStructureNode.SubGraph<>nil then
      CurrenTStructureNode.SubGraph.Destroy;   }
    NexTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    FreeAndNil(CurrenTStructureNode);
    CurrenTStructureNode:=NexTStructureNode;
    end;
  inherited;
  end;

Constructor TStructureNode.Create;
  begin
  inherited;
  Name:='';
  Graph:=nil;
  Failure:=nil;
  NexTStructureNode:=nil;
  DoubleNode:=Nil;
  RelationNode:=nil;
  SensorNode:=Nil;
  Stat:=nil;
  StatProtocol:=nil;
  SubGraph:=Nil;
  ActionLisTStructureNode:=nil;
  ImpactLevel:=0;
  BoolSostRegularly:=0; BoolSostFailure:=0; BoolSostAvailability:=1;
  BoolRegularly:=0; BoolFailure:=0; BoolAvailability:=1; BoolReplacement:=0;
  BoolSearchFailure:=0;
  KolElementToFailure:=0;
  SostTime[0]:=0; SostTime[1]:=0; SostTime[2]:=0; SostTime[3]:=0;
  Time[0]:=0; Time[1]:=0; Time[2]:=0; Time[3]:=0;
  LastTime:=0;
  KoefFailureSwitchOn:=1;
  AutoRenovation:=nil;
  DoubleRelationUp:=nil;
  DoubleRelationDown:=nil;
  end;

Destructor TStructureNode.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление УЗЛА');

  DelAllDoubleArc;
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   DBL');
  DelAllRelationArc;
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   REL');
  DelAllSensorArc;
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   SEN');
  DelAllActionArc;
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   ACT');
  DelAllFailure;
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   FAIL');
  NexTStructureNode:=nil;
  Graph:=Nil;
  IF Stat<>nil then
    Stat.Node:=nil;
  Stat:=nil;
  Failure:=Nil;
  FreeAndNil(StatProtocol);
  FreeAndNil(SubGraph);
  FreeAndNil(AutoRenovation);
  inherited;
  end;

Constructor TDoubleArc.Create;
  begin
  inherited;
  NextArc:=nil;
  Node:=Nil;
  end;
Destructor TDoubleArc.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление дублирующей дуги');

  NextArc:=nil;
  Node:=Nil;
  inherited;
  end;

Constructor TRelationArc.Create;
  begin
  inherited;
  NextArc:=nil;
  Node:=Nil;
  ChangeReliability:=nil;
  end;
Destructor TRelationArc.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление зависимой дуги');

  NextArc:=nil;
  Node:=Nil;
  FreeAndNil(ChangeReliability);
  inherited;
  end;

Constructor TSensorArc.Create;
  begin
  inherited;
  NextArc:=nil;
  Node:=Nil;
  end;
Destructor TSensorArc.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление дуги - датчика');

  NextArc:=nil;
  Node:=Nil;
  inherited;
  end;

Constructor TActionList.Create;
  begin
  inherited;
  ListSearchFailure:=nil;
  Self.NameAction:='';
  Self.TypeAction:=255;
  Self.TimeAction:=0;
  Self.KoefAction:=1;
  Self.FirstAction:=nil;
  Self.NextList:=nil;
  end;
Destructor TActionList.Destroy;
  var
  CElementAction,DElementAction:TElementActionList;
    CurrentSearch,NextSearch:TSearchFailure;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление TActionList');

  CElementAction:=Self.FirstAction;
  DElementAction:=CElementAction;
  While DElementAction<>nil do
    begin
    CElementAction:=CElementAction.NextElement;
    FreeAndNil(DElementAction);
    DElementAction:=CElementAction;
    end;
  CurrentSearch:=Self.ListSearchFailure;
  NextSearch:=CurrentSearch;
  While NextSearch<>nil do
    begin
    NextSearch:=CurrentSearch.NextSearch;
    FreeAndNil(CurrentSearch);
    CurrentSearch:=NextSearch;
    end;
  Self.FirstAction:=nil;
  Self.NextList:=nil;
  inherited;
  end;

Constructor TListFailure.Create;
  begin
  inherited;
   NextFailure:=nil;
   TypeFailure:=0;
   Parameters:=nil;
   Event:=nil;
   Node:=nil;
  end;

Destructor TListFailure.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add('Удаление Отказа элемента');
  FreeAndNil(Parameters);
  FreeAndNil(Event);
  NextFailure:=nil;
  Node:=nil;
  inherited;
  end;

Constructor TSearchFailure.Create;
  begin
  inherited;
  Node:=nil;
  NextSearch:=nil;
  reliability:=1;
  end;

Destructor TSearchFailure.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление Поиска отказа');
  Node:=nil;
  NextSearch:=nil;
  inherited;
  end;

Constructor TStatistics.Create;
  var
    i:byte;
  begin
  inherited;
  NameNode:='';
  Node:=nil;
//  SetLength(Time,1);
//  SetLength(KolFailure,1);
  GoSaveTime:=False;
  SetLength(TimeFailure,0);
  SetLength(ArrayRecovery,0);
  SetLength(ArrayFailure,0);
  SetLength(ArrayHistKolFailure,0);
  SetLength(ArrayHistKolRecovery,0);
  KolFailure[0]:=0;
  KolFailure[1]:=0;
  KolRecovery[0]:=0;
  KolRecovery[1]:=0;
  MaxKolFailure:=0;
  MaxKolRecovery:=0;
{  For i:=0 to 20 do
    ArrayHistKolFailure[i]:=0;
{  For i:=0 to 3 do
    begin
    TimeOsnBufer[i]:=0;
    Time[0][i][0]:=0;
    Time[0][i][1]:=0;
    end;
}
//  KolFailure[0][0]:=0;
//  KolFailure[0][1]:=0;
//  KolRecovery[0]:=0;
//  KolRecovery[1]:=0;

  NomRecovery:=0;
  NomFailure:=0;
//  KolProgon:=1;                                                           KolProgon
  end;
Destructor TStatistics.Destroy;
  var
    i,j:Word;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление статистики');

  Node:=nil;
//  Finalize(TimeOsn);
//  Finalize(TimeOsnBufer);
//  Finalize(KolRecovery);
{  If Length(Time)<>0 then
  for i:=0 to Length(Time)-1 do
    Finalize(Time[i]);
  Finalize(Time);
  Finalize(KolFailure);  }

  If Length(ArrayFailure)<>0 then
    for i:=0 to Length(ArrayFailure)-1 do
    Finalize(ArrayFailure[i]);
  inherited;
  end;

Constructor TStatProtocol.Create(TypeP:byte; NodeP:TStructureNode);
  begin
  TypeProtocol:=TypeP;
  NameNode:=NodeP.Graph.Name+'->'+NodeP.Name;
  Case TypeP of
    0:Parameters:=1000000000000;
    1:Parameters:=0;
    end;
  end;

Destructor TStatProtocol.Destroy;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление протокола');

  Finalize(Protocol);
  inherited;
  end;


Constructor TElementActionList.Create;
  begin
  inherited;
  Self.TypeAction:=255;
  Self.NameAction:='';
  SetLength(Node,0);
  NextElement:=nil;
  end;
Destructor TElementActionList.Destroy;
  var
    i:LongWord;
  begin
    If GoProtocolEvent then
    FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление TElementActionList');

  NextElement:=nil;
  If Length(Node)<>0 then
    begin
    for i:=0 to Length(Node)-1 do
      Node[i]:=nil;
    Finalize(Node);
    end;
  inherited;
  end;

Procedure TGraph.Clear;
var
  CNode:TStructureNode;
begin
  CNode:=Self.Node;
  While CNode<>nil do
    begin
    CNode.Clear;
    If CNode.SubGraph<>nil then
      CNode.SubGraph.Clear;
    CNode:=CNode.NexTStructureNode;
    end;
end;

procedure TStructureNode.Clear;
var
  CurrentFailure:TListFailure;
  i:Byte;
begin
  CurrentFailure:=Self.Failure;
  While CurrentFailure<>nil do
    begin
    CurrentFailure.DelFailure;
    CurrentFailure:=CurrentFailure.NextFailure;
    end;
  Self.BoolRegularly:=Self.BoolSostRegularly;
  Self.BoolFailure:=Self.BoolSostFailure;
  Self.BoolAvailability:=Self.BoolSostAvailability;
  Self.BoolSearchFailure:=0;
  Self.KolElementToFailure:=0;
  For i:=0 to 3 do
    Self.Time[i]:=Self.SostTime[i];
  Self.LastTime:=0;
end;

procedure TListFailure.Clear;
begin
DelFailure;
FreeAndNil(Event);
end;

constructor TElementAction.Create;
  begin
  Node:=nil;
  NameAction:='';
  TypeAction:=0;
  KoefAction:=0;
  TimeAction:=0;
  end;

destructor TElementAction.Destroy;
  begin
{    If GoProtocolEvent then
  FModel.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление TElementAction');
 }
  Node:=nil;
  NameAction:='';
  TypeAction:=0;
  KoefAction:=0;
  TimeAction:=0;
  end;

end.
