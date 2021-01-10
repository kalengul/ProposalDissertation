unit UAntGraph;

interface

Uses
      SysUtils, //FreeAndNill
      UTransportGRAPH;

type
  TAntNodeElement = class;
  TAntNodeKol = class;
  TAntArcKol = class;

  TAntNodeSklad = class
             TransportNode:TTransportNode;
             FirstElementSklad:TAntNodeElement;
             NextSklad,LastSklad:TAntNodeSklad;
             KolElement:LongWord;
             function SearchElementSklad(NameElement:String):TAntNodeElement;
             Function AddElementSklad(NameElement:String):TAntNodeElement;
             constructor Create;
             destructor Destroy; override;
             end;

  TAntNodeElement = class
                    Name:String;
                    Sklad:TAntNodeSklad;
                    Kol:TAntNodeKol;
                    CostProduction:Double;
                    NextElement,LastElement:TAntNodeElement;
                    function SearchValueElement (Value:Word):TAntNodeKol;
                    function AddValueElement (Value:Word):TAntNodeKol;
                    constructor Create;
                    destructor Destroy; override;
                    end;

  TAntNodeKol = class
                Element:TAntNodeElement;
                Value:Word;
                Pheromon1,Pheromon2:Double;
                NPheromon1,NPheromon2:Double;
                Arc:tAntArcKol;
                NextKol:TAntNodeKol;
                procedure AddAntArc(NodeKolKon:TAntNodeKol);
                function SearchAntArc(NodeKolKon:TAntNodeKol):tAntArcKol;
                constructor Create;
                destructor Destroy; override;
                end;
  TArrayAntNodeKol = array of TAntNodeKol;

  TAntArcKol = class
               NextArc:TAntArcKol;
               Node:TAntNodeKol;
               Pheromon1,Pheromon2:Double;
               NPheromon1,NPheromon2:Double;
               constructor Create;
               destructor Destroy; override;
               end;

function SearchNodeSklad(Node:TTransportNode):TAntNodeSklad;
function AddNodeSklad(Node:TTransportNode):TAntNodeSklad;
procedure AddNodeAnt(TransportNode:TTransportNode; NameElement:string; Value:Word; Pheromon1,Pheromon2:Double);
procedure AddAllAntArc;
procedure DelAllAntArc;
procedure ClearAllAntGraph;
procedure DecreasePheromonAllGraph(ParArc1,PArArc2,ParNode1,ParNode2:Double);
procedure SaveAntGraphFromTextFile(NameFile:String);
procedure LoadAntGraphFromTextFile(NameFile:string);

var
  FirstNodeAntGraph:TAntNodeSklad;
  NatKolPheromon1,NatKolPheromon2:Double;

implementation

procedure SaveAntGraphFromTextFile(NameFile:String);
var
  f:TextFile;
  CurrentSklad:TAntNodeSklad;
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
begin
AssignFile(f,NameFile);
Rewrite(f);
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      Writeln(F,CurrentSklad.TransportNode.Name+'@'+CurrentElement.Name+'@'+IntToStr(CurrentValue.Value)+'@'+FloatToStr(CurrentValue.Pheromon1)+'@'+FloatToStr(CurrentValue.Pheromon2)+'@');
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
CloseFile(f);
end;

procedure LoadAntGraphFromTextFile(NameFile:string);
var
  f:TextFile;
  st:string;
  TransportNode:TTransportNode;
  NameTransportNode,NameElement:string;
  NomValue:LongWord;
  KolPheromon1,KolPheromon2:Double;
begin
AssignFile(f,NameFile);
Reset(f);
While not (Eof (f)) do
  begin
  Readln(f,st);
  NameTransportNode:=Copy(St,1,pos('@',st)-1);
  Delete(St,1,pos('@',st));
  NameElement:=Copy(St,1,pos('@',st)-1);
  Delete(St,1,pos('@',st));
  NomValue:=StrToInt(Copy(St,1,pos('@',st)-1));
  Delete(St,1,pos('@',st));
  KolPheromon1:=StrToFloat(Copy(St,1,pos('@',st)-1));
  Delete(St,1,pos('@',st));
  KolPheromon2:=StrToFloat(Copy(St,1,pos('@',st)-1));
  Delete(St,1,pos('@',st));
  TransportNode:=SearchNodeName(NameTransportNode);
  AddNodeAnt(TransportNode,NameElement,NomValue,KolPheromon1,KolPheromon2);
  end;
CloseFile(f);
end;

procedure DecreasePheromonAllGraph(ParArc1,PArArc2,ParNode1,ParNode2:Double);
var
  CurrentSklad:TAntNodeSklad;
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  CurrentArc:TAntArcKol;
begin
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      CurrentArc:=CurrentValue.Arc;
      While CurrentArc<>nil do
        begin
        CurrentArc.Pheromon1:=CurrentArc.Pheromon1*ParArc1;
        CurrentArc.Pheromon2:=CurrentArc.Pheromon2*ParArc2;
        CurrentArc:=CurrentArc.NextArc;
        end;
      CurrentValue.Pheromon1:=CurrentValue.Pheromon1*ParNode1;
      CurrentValue.Pheromon2:=CurrentValue.Pheromon2*ParNode2;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
end;

procedure ClearAllAntGraph;
var
  CurrentSklad:TAntNodeSklad;
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  CurrentArc:TAntArcKol;
begin
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      CurrentArc:=CurrentValue.Arc;
      While CurrentArc<>nil do
        begin
        CurrentArc.Pheromon1:=CurrentArc.NPheromon1;
        CurrentArc.Pheromon2:=CurrentArc.NPheromon2;
        CurrentArc:=CurrentArc.NextArc;
        end;
      CurrentValue.Pheromon1:=CurrentValue.NPheromon1;
      CurrentValue.Pheromon2:=CurrentValue.NPheromon2;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
end;

procedure AddAllAntArc;
var
  CurrentSklad,NextSklad:TAntNodeSklad;
  CurrentElement,NextElement:TAntNodeElement;
  CurrentValue,NextValue:TAntNodeKol;
begin
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  NextSklad:=CurrentSklad.NextSklad;
  If NextSklad=nil then
    NextSklad:=FirstNodeAntGraph;
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    NextElement:=CurrentElement.NextElement;
    If NextElement=nil then
      NextElement:=NextSklad.FirstElementSklad;
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      NextValue:=NextElement.Kol;
      While NextValue<>nil do
        begin
        CurrentValue.AddAntArc(NextValue);
        NextValue:=NextValue.NextKol;
        end;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
end;

procedure DelAllAntArc;
var
  CurrentSklad:TAntNodeSklad;
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  CurrentArc,DelArc:TAntArcKol;
begin
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      CurrentArc:=CurrentValue.Arc;
      while CurrentArc<>nil do
        begin
        DelArc:=CurrentArc;
        CurrentArc:=CurrentArc.NextArc;
        FreeAndNil(DelArc);
        end;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
end;

procedure AddNodeAnt(TransportNode:TTransportNode; NameElement:string; Value:Word; Pheromon1,Pheromon2:Double);
var
  CurrentSklad:TAntNodeSklad;
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
begin
CurrentSklad:=SearchNodeSklad(TransportNode);
IF CurrentSklad=nil then
  CurrentSklad:=AddNodeSklad(TransportNode);
CurrentElement:=CurrentSklad.SearchElementSklad(NameElement);
If CurrentElement=nil then
  CurrentElement:=CurrentSklad.AddElementSklad(NameElement);
CurrentValue:=CurrentElement.AddValueElement(Value);
CurrentValue.Pheromon1:=Pheromon1;
CurrentValue.Pheromon2:=Pheromon2;
CurrentValue.NPheromon1:=Pheromon1;
CurrentValue.NPheromon2:=Pheromon2;
end;

function AddNodeSklad(Node:TTransportNode):TAntNodeSklad;
  var
    NewSklad,CurrentSklad:TAntNodeSklad;
  begin
  NewSklad:=TAntNodeSklad.Create;
  NewSklad.TransportNode:=Node;
  CurrentSklad:=FirstNodeAntGraph;
  IF CurrentSklad=nil then
    FirstNodeAntGraph:=NewSklad
  else
    begin
    While CurrentSklad.NextSklad<>nil do
      CurrentSklad:=CurrentSklad.NextSklad;
    CurrentSklad.NextSklad:=NewSklad;
    NewSklad.LastSklad:=CurrentSklad;
    end;
  Result:=NewSklad;
  end;

Function TAntNodeSklad.AddElementSklad(NameElement:String):TAntNodeElement;
  var
    NewElement,CurrentElement:TAntNodeElement;
  begin
  Inc(KolElement);
  NewElement:=TAntNodeElement.Create;
  NewElement.Sklad:=self;
  NewElement.Name:=NameElement;
  CurrentElement:=FirstElementSklad;
  IF CurrentElement=nil then
    FirstElementSklad:=NewElement
  else
    begin
    While (CurrentElement.NextElement<>nil) and (CurrentElement.Name<NameElement) do
      CurrentElement:=CurrentElement.NextElement;
    If CurrentElement.Name<NameElement then
      begin
      CurrentElement.NextElement:=NewElement;
      NewElement.LastElement:=CurrentElement;
      end
    else
      begin
      NewElement.NextElement:=CurrentElement;
      NewElement.LastElement:=CurrentElement.LastElement;
      If CurrentElement.LastElement<>nil then
        CurrentElement.LastElement.NextElement:=NewElement
      else
        FirstElementSklad:=NewElement;
      CurrentElement.LastElement:=NewElement;
      end;
    end;
  Result:=NewElement;
  end;

function TAntNodeElement.AddValueElement (Value:Word):TAntNodeKol;
  var
    NewKol,CurrentKol:TAntNodeKol;
  begin
  NewKol:=TAntNodeKol.Create;
  NewKol.Value:=Value;
  NewKol.Element:=Self;
  CurrentKol:=Kol;
  IF CurrentKol=nil then
    Kol:=NewKol
  else
    begin
    While CurrentKol.NextKol<>nil do
      CurrentKol:=CurrentKol.NextKol;
    CurrentKol.NextKol:=NewKol;
    end;
  Result:=NewKol;
  end;

function TAntNodeKol.SearchAntArc(NodeKolKon:TAntNodeKol):tAntArcKol;
  var
    CurrentArc:TAntArcKol;
  begin
  CurrentArc:=Arc;
  While (CurrentArc<>nil) and (CurrentArc.Node<>NodeKolKon) do
    CurrentArc:=CurrentArc.NextArc;
  Result:=CurrentArc;
  end;

procedure TAntNodeKol.AddAntArc(NodeKolKon:TAntNodeKol);
  var
    NewArc,CurrentArc:TAntArcKol;
  begin
  NewArc:=TAntArcKol.Create;
  NewArc.Node:=NodeKolKon;
  CurrentArc:=Arc;
  IF CurrentArc=nil then
    Arc:=NewArc
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
    end;
  end;

function SearchNodeSklad(Node:TTransportNode):TAntNodeSklad;
  var
    CurrentNodeSklad:TAntNodeSklad;
  begin
  CurrentNodeSklad:=FirstNodeAntGraph;
  While (CurrentNodeSklad<>nil) and (CurrentNodeSklad.TransportNode<>Node) do
    CurrentNodeSklad:=CurrentNodeSklad.NextSklad;
  Result:=CurrentNodeSklad;
  end;

function TAntNodeSklad.SearchElementSklad(NameElement:String):TAntNodeElement;
  var
    CurrentNodeElement:TAntNodeElement;
  begin
  CurrentNodeElement:=FirstElementSklad;
  While (CurrentNodeElement<>nil) and (CurrentNodeElement.Name<>NameElement) do
    CurrentNodeElement:=CurrentNodeElement.NextElement;
  Result:=CurrentNodeElement;
  end;

function TAntNodeElement.SearchValueElement (Value:Word):TAntNodeKol;
  var
    CurrentNodeKol:TAntNodeKol;
  begin
  CurrentNodeKol:=Kol;
  While (CurrentNodeKol<>nil) and (CurrentNodeKol.Value<>Value) do
    CurrentNodeKol:=CurrentNodeKol.NextKol;
  Result:=CurrentNodeKol;
  end;

constructor TAntNodeSklad.Create;
begin
inherited;
TransportNode:=nil;
FirstElementSklad:=nil;
NextSklad:=nil;
LastSklad:=nil;
KolElement:=0;
end;
destructor TAntNodeSklad.Destroy;
var
  CurrentElement,DelElement:TAntNodeElement;
begin
CurrentElement:=FirstElementSklad;
while CurrentElement<>nil do
  begin
  DelElement:=CurrentElement;
  CurrentElement:=CurrentElement.NextElement;
  FreeAndNil(DelElement);
  end;
TransportNode:=nil;
FirstElementSklad:=nil;
NextSklad:=nil;
LastSklad:=nil;
inherited;
end;

constructor TAntNodeElement.Create;
begin
inherited;
Name:='';
Sklad:=nil;
Kol:=nil;
NextElement:=nil;
LastElement:=nil;
 CostProduction:=0;
end;
destructor TAntNodeElement.Destroy;
var
  CurrentKol,DelKol:TAntNodeKol;
begin
Dec(Sklad.KolElement);
CurrentKol:=Kol;
while CurrentKol<>nil do
  begin
  DelKol:=CurrentKol;
  CurrentKol:=CurrentKol.NextKol;
  FreeAndNil(DelKol);
  end;
Name:='';
Sklad:=nil;
Kol:=nil;
NextElement:=nil;
LastElement:=nil;
inherited;
end;

constructor TAntNodeKol.Create;
begin
inherited;
Element:=nil;
Arc:=nil;
NextKol:=nil;
Pheromon1:=NatKolPheromon1;
Pheromon2:=NatKolPheromon2;
NPheromon1:=NatKolPheromon1;
NPheromon2:=NatKolPheromon2;
end;
destructor TAntNodeKol.Destroy;
var
  CurrentArc,DelArc:TAntArcKol;
begin
CurrentArc:=Arc;
while CurrentArc<>nil do
  begin
  DelArc:=CurrentArc;
  CurrentArc:=CurrentArc.NextArc;
  FreeAndNil(DelArc);
  end;
Element:=nil;
Arc:=nil;
NextKol:=nil;
inherited;
end;

constructor TAntArcKol.Create;
begin
inherited;
NextArc:=nil;
Node:=nil;
Pheromon1:=NatKolPheromon1;
Pheromon2:=NatKolPheromon2;
NPheromon1:=NatKolPheromon1;
NPheromon2:=NatKolPheromon2;
end;
destructor TAntArcKol.Destroy;
begin
NextArc:=nil;
Node:=nil;
inherited;
end;


end.
