unit UVivod;

interface

Uses UReliabilityGraph,
     UReliability,
     Dialogs,
     USbs,
     
     SysUtils;     //StrToFloat

Procedure GoSubGraphVivod(NameNode:String);
Procedure GoLevelUpGraphVivod;
Procedure ParametersVivod(NameNode:String);
Procedure StructureVivod;
Procedure VivodSBS;
Procedure VivodModelTime;


Var
CurrentGraphVivod:TGraph;
CurrenTStructureNodeVivod:TStructureNode;


implementation

Uses UMainStructure,
     
     UFormVivodParameters,
     UEventSBS;

procedure VivodSBS;
  var
  Event,PEvent:TEvent;
  st:string;
  i:word;
  begin
  UMainStructure.FMain.MeSBS.Clear;
  If Sbs=nil then
  UMainStructure.FMain.MeSBS.Lines.Add('СБС Пуста')
  else
    begin
    Event:=Sbs.FirstEvent;
    While Event<>nil do
      begin
      St:=FloatToStr(Event.EventTime);
      If (Event is TEventFailure) then
        St:=St+'|    Отказ '+(Event as TEventFailure).Node.Name;
      If (Event is TEventSwitch) then
        St:=St+'|   Включение '+(Event as TEventSwitch).Node.Name;
      If (Event is TEventSwitchList) then
        begin
        St:=St+'|  Последовательность';
        For i:=0 to (Event as TEventSwitchList).KolNode-1 do
          St:=St+(Event as TEventSwitchList).Node[i].Node.Name+'->';
        end;
      If (Event is TEventAction) then
        St:=St+(Event as TEventAction).Action.Name+'('+(Event as TEventAction).Action.Node.Name+')';

      UMainStructure.FMain.MeSBS.Lines.Add(St);
      PEvent:=Event;
      Event:=Event.NextEvent;
      end;
    end;
   end;

Procedure VivodModelTime;
begin
UMainStructure.FMain.LaModelTime.Caption:=FloatToStr(Sbs.ModelTime);
end;

Procedure GoSubGraphVivod(NameNode:String);
  var
  CurrenTStructureNode:TStructureNode;
  begin
  CurrenTStructureNode:=CurrentGraphVivod.SearchNodeName(NameNode);
  If CurrenTStructureNode=nil then
    ShowMessage('Вершина не найдена')
  else
    If CurrenTStructureNode.SubGraph=nil then
      ShowMessage('У данной вершины нет подграфа')
    else
      CurrentGraphVivod:=CurrenTStructureNode.SubGraph;
  end;

Procedure GoLevelUpGraphVivod;
  begin
  CurrentGraphVivod:=CurrentGraphVivod.FatherNodeGraph.Graph;
  CurrenTStructureNodeVivod:=CurrentGraphVivod.FatherNodeGraph;
  end;

Procedure ParametersVivod(NameNode:String);
  var
  CurrenTStructureNode:TStructureNode;
  CurrentFailure:TListFailure;
  CurrentDouble:TDoubleArc;
  CurrentSensor:TSensorArc;
  CurrentRelation:TRelationarc;
  i:Byte;
  begin
  CurrenTStructureNode:=CurrentGraphVivod.SearchNodeName(NameNode);
  CurrenTStructureNodeVivod:=CurrenTStructureNode;
//  FVivodParameters.LeTimeGo.Text:=FloatToStr(CurrenTStructureNode.TimeToSwitch);
  CurrentFailure:=CurrenTStructureNode.Failure;
  i:=1;
  While CurrentFailure<>nil do
    begin
        FVivodParameters.SgFailure.RowCount:=i+1;
    Case CurrentFailure.TypeRegulary of
       0:FVivodParameters.SgFailure.Cells[0,i]:='Выключен';
       1:FVivodParameters.SgFailure.Cells[0,i]:='Включен';
       End;
    FVivodParameters.SgFailure.Cells[1,i]:=IntToStr(CurrentFailure.TypeFailure);
    if (CurrentFailure.Parameters is TExpFailure) then
      begin
      FVivodParameters.SgFailure.Cells[2,i]:='Эксп.';
      FVivodParameters.SgFailure.Cells[3,i]:=FloatToStr((CurrentFailure.Parameters as TExpFailure).La);
      end;
    if (CurrentFailure.Parameters is TNormalFailure) then
      begin
      FVivodParameters.SgFailure.Cells[2,i]:='Норм.';
      FVivodParameters.SgFailure.Cells[3,i]:=FloatToStr((CurrentFailure.Parameters as TNormalFailure).Mx);
      FVivodParameters.SgFailure.Cells[4,i]:=FloatToStr((CurrentFailure.Parameters as TNormalFailure).Dx);
      end;
    CurrentFailure:=CurrentFailure.NextFailure;
    Inc(i);
    end;
  FVivodParameters.MeDouble.Clear;
  CurrentDouble:=CurrenTStructureNode.DoubleNode;
  While CurrentDouble<>nil do
    begin
    FVivodParameters.MeDouble.Lines.Add(CurrentDouble.Node.Name);
    CurrentDouble:=CurrentDouble.NextArc
    end;
  FVivodParameters.MeSensor.Clear;
  CurrentSensor:=CurrenTStructureNode.SensorNode;
  While CurrentSensor<>nil do
    begin
    FVivodParameters.MeSensor.Lines.Add(CurrentSensor.Node.Name);
    CurrentSensor:=CurrentSensor.NextArc
    end;
  CurrentRelation:=CurrenTStructureNode.RelationNode;
  i:=1;
  While CurrentRelation<>nil do
    begin
    FVivodParameters.SgRelation.RowCount:=i+1;
    FVivodParameters.SgRelation.Cells[0,i]:=CurrentRelation.Node.Name;
    Case CurrentRelation.TypeRegulary of
       0:FVivodParameters.SgRelation.Cells[1,i]:='Выключен';
       1:FVivodParameters.SgRelation.Cells[1,i]:='Включен';
       End;
    FVivodParameters.SgRelation.Cells[2,i]:=IntToStr(CurrentRelation.TypeFailure);
    Case CurrentRelation.ChangeReliability.TypeChange of
       0:FVivodParameters.SgRelation.Cells[3,i]:='Изменить В';
       1:FVivodParameters.SgRelation.Cells[3,i]:='Изменить На';
       2:FVivodParameters.SgRelation.Cells[3,i]:='Установить';
       End;
    FVivodParameters.SgRelation.Cells[4,i]:=FloatToStr(CurrentRelation.ChangeReliability.ParChangeMx);
    CurrentRelation:=CurrentRelation.NextArc;
    Inc(i);
    end;
  end;

Procedure StructureVivod;
  var
  CurrenTStructureNode:TStructureNode;
  begin
  FVivodParameters.LbStructure.Clear;
  CurrenTStructureNode:=CurrentGraphVivod.Node;
  While CurrenTStructureNode<>nil do
    begin
    FVivodParameters.LbStructure.Items.Add(CurrenTStructureNode.Name);
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

end.
