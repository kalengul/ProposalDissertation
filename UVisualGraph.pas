unit UVisualGraph;

interface

uses UReliabilityGraph;

type


TVisualNode = class
             x,y:LongWord;
             Node:TStructureNode;
             end;

TVisualGraph = record
             x1,x2,y1,y2:LongWord;
             Name:String;
             end;

var
ArrayVisualNode:array of TVisualNode;
ArrayVisualGraph:array of TVisualGraph;
KolNode,NomNode:LongWord;
KolGraph,NomGraph:LongWord;
Dx,Dy:LongWord;
NodeLevel:Array of Word;
MaxX,MaxY:LongWord;
DeltX:LongWord;
MaxXNode:LongWord;

Procedure KolNodeLevel(CurrentGraph:TGraph; level:Word);
Procedure GoAllLevelNode;
procedure GoAllXYNode;
Procedure GiveNodeXY(CurrentGraph:TGraph; level:Word; Var x:LongWord);

implementation

uses UMainStructure,UTransportGRAPH;

Procedure GoAllLevelNode;
var
  level:Word;
begin
  Level:=0;
  MaxLevel:=0;
  KolNode:=0;
  SetLength(NodeLevel,1);
  KolNodeLevel(Structure.GraphLevel0,Level);
end;

Procedure KolNodeLevel(CurrentGraph:TGraph; level:Word);
  var
  CurrenTStructureNode:TStructureNode;
  VNode:TVisualNode;
  begin
  Inc(Level);
  If level>MaxLevel then
    begin
    MaxLevel:=Level;
    SetLength(NodeLevel,MaxLevel+1);
    end;
  CurrenTStructureNode:=CurrentGraph.Node;
  While CurrenTStructureNode<>nil do
    begin
    Inc(KolNode);
    Inc(NodeLevel[level]);
    If CurrenTStructureNode.SubGraph<>nil then
      KolNodeLevel(CurrenTStructureNode.SubGraph,level);
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    end;
  end;

Procedure GoAllXYNode;
var
  level:Word;
  Nom:LongWord;
  Max:LongWord;
begin
  Level:=0;
  SetLength(ArrayVisualNode,KolNode+1);
  KolNode:=0;
  MaxXNode:=0;
  Max:=0;
  For Nom:=0 to Length(NodeLevel) do
  If NodeLevel[Nom]>Max then
    Max:=NodeLevel[Nom];
  DeltX:=Trunc(MaxX/Max);
  GiveNodeXY(Structure.GraphLevel0,Level,MAxXNode);

end;

Procedure GiveNodeXY(CurrentGraph:TGraph; level:Word; Var x:LongWord);
  var
  CurrenTStructureNode:TStructureNode;
  VNode:TVisualNode;
  DGraph:LongWord;
  begin
  Inc(Level);
  Inc(KolGraph);
  DGraph:=0;
  SetLength(ArrayVisualGraph,KolGraph);
  CurrenTStructureNode:=CurrentGraph.Node;
  ArrayVisualGraph[KolGraph-1].Name:=CurrentGraph.Name;
  ArrayVisualGraph[KolGraph-1].x1:=Trunc(X);
  If Level=1 then
  ArrayVisualGraph[KolGraph-1].y1:=Trunc((Level-1)/(MaxLevel+1)*MaxY)
  else
  ArrayVisualGraph[KolGraph-1].y1:=Trunc((Level-1)/(MaxLevel+1)*MaxY-10);
  ArrayVisualGraph[KolGraph-1].y2:=Trunc((Level)/(MaxLevel+1)*MaxY+10);
  While CurrenTStructureNode<>nil do
    begin
    Inc(KolNode);
    SetLength(ArrayVisualNode,KolNode);
    VNode:=TVisualNode.Create;
    VNode.Node:=CurrenTStructureNode;
    VNode.y:=Trunc((Level)/(MaxLevel+1)*MaxY);
    VNode.x:=Trunc(X+DeltX/2+2);
    ArrayVisualNode[KolNode-1]:=VNode;
    If CurrenTStructureNode.SubGraph<>nil then
      GiveNodeXY(CurrenTStructureNode.SubGraph,level,X);
    CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
    X:=X+DeltX+4;
    end;
    DGraph:=0;
    While ArrayVisualGraph[DGraph].Name<>CurrentGraph.Name do
      inc(DGraph);
    ArrayVisualGraph[DGraph].x2:=X;
  end;

end.
