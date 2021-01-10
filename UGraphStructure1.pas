unit UGraphStructure;

interface

Uses UReliabilityGraph,
     UReliability,
     UAction,
     ComObj,
     SysUtils;     //StrToFloat


type

TArrayStatProtocol = array of TStatProtocol;

TGraphStructure = class
  Name:String;
  GraphLevel0:TGraph;
  StatistiksNode:Array of TStatistics;
  StatProtocol:TArrayStatProtocol;
  ListAction:TListAction;
  Constructor Create;
  Destructor Destroy;    override;
  Procedure LoadGraphFile (NameFile:String);
  Procedure SaveGraphFile (NameFile:String);
  Procedure ClearSostStructure;
  procedure GoStructureEvent;
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

TSaveFailure = record
               Name:string[20];
               KolFailure:array [0..1] of Double;
               ArrayHistKolFailure: array [0..20] of Double;
               end;

var MsExcel: Variant;
MaxLevel:Word;
MaxTime:double;

implementation



Constructor TGraphStructure.Create;
  begin
  GraphLevel0:=nil;
  SetLength(StatProtocol,0);
  SetLength(StatistiksNode,0)
  end;
Destructor TGraphStructure.Destroy;
  var
    i:word;
  begin
{  if GraphLevel0<>nil then
    GraphLevel0.Destroy;}
  If Length(StatProtocol)<>0 then
  for i:=0 to Length(StatProtocol)-1 do
    StatProtocol[i].Destroy;
  Finalize(StatProtocol);
  If Length(StatistiksNode)<>0 then
  for i:=0 to Length(StatistiksNode)-1 do
    StatistiksNode[i].Destroy;
  Finalize(StatistiksNode);
  end;

Procedure TGraphStructure.ClearSostStructure;
  begin
  GraphLevel0.SaveTime;
  GraphLevel0.SwitchOFF;
  SaveStat;
  GraphLevel0.Destroy;
  ListAction.Destroy;
  end;

procedure TGraphStructure.GoStructureEvent;
  begin
  LoadGraphFile(Name+'.txt');
  NewProgonStat;
  GoAllEvent;
  ListAction:=TListAction.Create;
  ListAction.LoadAction('Действие.txt');
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
    While (CurrentFailure<>nil) and not((CurrentFailure.TypeRegulary=CurrenTStructureNode.BoolRegularly) and (CurrentFailure.TypeFailure=CurrenTStructureNode.BoolFailure)) do
      CurrentFailure:=CurrentFailure.NextFailure;
    If CurrentFailure<>nil then
      CurrentFailure.GoFailure;
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
  AssignFile (f,NameFile);
  reset(f);
  GraphLevel0:=TGraph.Create;
  GraphLevel0.Name:='Level0';
  While Not EOF(f) do
    begin
    CurrentGraph:=GraphLevel0;
    Readln(f,st);
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
             CurrenTStructureNode.Time[TypeR]:=Random*(NormReliability.Mx/10);
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

Procedure TGraphStructure.SaveGraphFile (NameFile:String);
  begin
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



end.
