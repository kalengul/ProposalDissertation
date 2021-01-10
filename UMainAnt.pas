unit UMainAnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UAntGraph, UTransportGRAPH, StdCtrls, USolution, UAnt;

type
  TFMainAnt = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    MeProt: TMemo;
    Label1: TLabel;
    EdNatPher: TEdit;
    Label2: TLabel;
    EdKoefPher: TEdit;
    BtCreateAntGraph: TButton;
    PbAntGraph: TPaintBox;
    BtAddSolution: TButton;
    BtLoadSolution: TButton;
    BtGoAnt: TButton;
    EdKolAgent: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdKoefPheromon: TEdit;
    Label5: TLabel;
    EdKoefIspar: TEdit;
    procedure BtCreateAntGraphClick(Sender: TObject);
    procedure BtAddSolutionClick(Sender: TObject);
    procedure BtLoadSolutionClick(Sender: TObject);
    procedure BtGoAntClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



procedure PaintAntGraph(Canvas:TCanvas; Heigth,Weigth:Word);
procedure AddAllHistSklad;
Procedure CreateAntGraph;
procedure AddAllCostCreateProductionOnAntGraph;
Function GiveKolSolution:Double;


var
  FMainAnt: TFMainAnt;
  PheromonPar:Double;

implementation

{$R *.dfm}

uses
  UMain;




procedure PaintAntGraph(Canvas:TCanvas; Heigth,Weigth:Word);
  var
    CurrentSklad:TAntNodeSklad;
    CurrentElement:TAntNodeElement;
    CurrentValue:TAntNodeKol;
    MaxKolElement:LongWord;
    DeltElement:LongWord;
    PosSklad,PosElement,i,LText:Word;
  begin
  MaxKolElement:=0;
  CurrentSklad:=FirstNodeAntGraph;
  If CurrentSklad<>nil then
  begin
  While CurrentSklad<>nil do
    begin
    MaxKolElement:=MaxKolElement+CurrentSklad.KolElement+1;
    CurrentSklad:=CurrentSklad.NextSklad;
    end;
  DeltElement:=Trunc((Weigth-25*MaxKolElement)/MaxKolElement);
  PosSklad:=20;
  CurrentSklad:=FirstNodeAntGraph;
  While CurrentSklad<>nil do
    begin
    Canvas.Brush.Color:=ClBtnFace;
    Canvas.Pen.Style:=psDot;
    Canvas.MoveTo(PosSklad,Heigth-20);
    Canvas.LineTo(PosSklad+(25+DeltElement)*CurrentSklad.KolElement,Heigth-20);
    Canvas.LineTo(PosSklad+(25+DeltElement)*CurrentSklad.KolElement,20);
    Canvas.LineTo(PosSklad,20);
    Canvas.LineTo(PosSklad,Heigth-20);
    Canvas.Pen.Style:=psSolid;

    LText:=Canvas.TextWidth(CurrentSklad.TransportNode.Name);
    If LText<(25+DeltElement)*CurrentSklad.KolElement-10 then
      Canvas.TextOut(PosSklad+(25+DeltElement)*CurrentSklad.KolElement div 2 - LText div 2,20,CurrentSklad.TransportNode.Name);


    PosElement:=PosSklad+10;
    CurrentElement:=CurrentSklad.FirstElementSklad;
    While CurrentElement<>nil do
      begin
      Canvas.Rectangle(PosElement,50,PosElement+DeltElement,75);
      CurrentValue:=CurrentElement.Kol;
      i:=0;
      While CurrentValue<>nil do
        begin
        Canvas.MoveTo(PosElement,75+i*20);
        Canvas.LineTo(PosElement,75+(i+1)*20);
        Canvas.Pen.Color:=clBlue;
        if CurrentValue.Pheromon2/5<10 then
          Canvas.pen.Width:=Trunc(CurrentValue.Pheromon2/15)
        else
          Canvas.pen.Width:=10;
        Canvas.LineTo(PosElement+25,75+(i+1)*20);
        Canvas.Pen.Color:=clGreen;
        if CurrentValue.Pheromon1/5<10 then
          Canvas.pen.Width:=Trunc(CurrentValue.Pheromon1/15)
        else
          Canvas.pen.Width:=10;
        Canvas.MoveTo(PosElement,75+(i+1)*20-5);
        Canvas.LineTo(PosElement+25,75+(i+1)*20-5);
        Canvas.Pen.Width:=1;        
        Canvas.Pen.Color:=clBlack;
        Canvas.TextOut(PosElement+6,75+i*20,IntToStr(CurrentValue.Value));
        Inc(i);
        CurrentValue:=CurrentValue.NextKol;
        end;
      PosElement:=PosElement+DeltElement+25;
      CurrentElement:=CurrentElement.NextElement
      end;
    PosSklad:=PosSklad+(25+DeltElement)*CurrentSklad.KolElement;
    CurrentSklad:=CurrentSklad.NextSklad;
    end;
  end;
  end;

procedure AddAllHistSklad;
  var
    CNode,SkladNode:TTransportNode;
    Nom,NomHist:LongWord;
  begin
  CNode:=FirsTTransportNode;
  While CNode<>nil do
    begin
    if Length(CNode.Ns)<>0 then
      begin
//      FMainAnt.MeProt.Lines.Add('Найдена вершина с аэродромом '+CNode.Name);
      Nom:=0;
      While Nom<>64000 do
        begin
//        FMainAnt.MeProt.Lines.Add('Поиск элемента');
        Nom:=CNode.SearchStatProductionMax;
//        FMainAnt.MeProt.Lines.Add('Элемент найден №'+IntToStr(NOM));
        If Nom<>64000 then
          begin
//          FMainAnt.MeProt.Lines.Add(IntToStr(NOM)+' Элемент '+CNode.StatProduction[Nom].Name+' требуется раз '+FloatToStr(CNode.StatProduction[Nom].MFailure-CNode.StatProduction[Nom].MRecover));
          SkladNode:=SearchSkladMinLength(CNode,Length(CNode.StatProduction[Nom].HistItog));
          IF SkladNode<>nil then
            begin
            SkladNode.AddProductionNameAndHist(CNode.StatProduction[Nom].Name,CNode.StatProduction[Nom].HistItog);
//            FMainAnt.MeProt.Lines.Add('Выбран склад '+SkladNode.Name);
{            For NomHist:=0 to Length(CNode.StatProduction[Nom].HistItog)-1 do
              begin
              AddNodeAnt(SkladNode,CNode.StatProduction[Nom].Name,NomHist,PheromonPar*CNode.StatProduction[Nom].HistItog[NomHist],PheromonPar*CNode.StatProduction[Nom].HistItog[NomHist]);
//              FMainAnt.MeProt.Lines.Add('Создана верина муравьев '+SkladNode.Name+' -> '+CNode.StatProduction[Nom].Name+' -> '+IntToStr(NomHist)+' - > '+FloatToStr(PheromonPar*CNode.StatProduction[Nom].HistItog[NomHist]));
              end; }
//            FMainAnt.MeProt.Lines.Add('Элемент занесен');
            CNode.StatProduction[Nom].Save:=True;
            end;
          end;
//        FMainAnt.MeProt.Lines.Add('Следующий элемент');
        end;
      end;
    CNode:=CNode.NexTTransportNode;
    end;
  end;

Procedure CreateAntGraph;
var
  CNode:TTransportNode;
  Nom,NomHist:LongWord;
begin
CNode:=FirsTTransportNode;
While CNode<>nil do
  begin
  If {(CNode.Ns=nil) and} (Length(CNode.StatProduction)<>0) then
  For Nom:=0 to Length(CNode.StatProduction)-1 do
    begin
    If (not CNode.StatProduction[Nom].Save) and (Length(CNode.StatProduction[Nom].HistItog)<>0) then
    begin
    For NomHist:=0 to Length(CNode.StatProduction[Nom].HistItog)-1 do
      AddNodeAnt(CNode,CNode.StatProduction[Nom].Name,NomHist,PheromonPar*CNode.StatProduction[Nom].HistItog[NomHist],PheromonPar*CNode.StatProduction[Nom].HistItog[NomHist]);
    CNode.StatProduction[Nom].Save:=True;
    end;
    end;
  CNode:=CNode.NexTTransportNode;
  end;
end;

Function GiveKolSolution:Double;
var
    CurrentSklad:TAntNodeSklad;
    CurrentElement:TAntNodeElement;
    CurrentValue:TAntNodeKol;
    KolValue,NValue:Double;
begin
KolValue:=1;
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    NValue:=0;
    While CurrentValue<>nil do
      begin
      NValue:=NValue+1;
      CurrentValue:=CurrentValue.NextKol;
      end;
    KolValue:=KolValue*NValue;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
result:=KolValue;
end;

procedure AddAllCostCreateProductionOnAntGraph;
var
  CNode:TTransportNode;
  CurrentSklad:TAntNodeSklad;
  CurrentElement:TAntNodeElement;
begin
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  CurrentElement:=CurrentSklad.FirstElementSklad;
  While CurrentElement<>nil do
    begin
    CNode:=FirsTTransportNode;
    While (CNode<>nil) and not ((CNode.Manufact<>nil) and (CNode.Manufact.SearchManufact(CurrentElement.Name)<>65000)) do
      CNode:=CNode.NexTTransportNode;
    If CNode<>nil then
      CurrentElement.CostProduction:=CNode.Manufact.SearchManufactP(CurrentElement.Name).CostProduction;
    CurrentElement:=CurrentElement.NextElement;
    end;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
end;

procedure TFMainAnt.BtCreateAntGraphClick(Sender: TObject);
begin
NatKolPheromon1:=StrToFloat(EdNatPher.Text);
PheromonPar:=StrToFloat(EdKoefPher.Text);
CreateAntGraph;
AddAllAntArc;
PaintAntGraph(PbAntGraph.Canvas,PbAntGraph.Height,PbAntGraph.Width);
end;

procedure TFMainAnt.BtAddSolutionClick(Sender: TObject);
begin

SetLength(ArraySolution,1);
ArraySolution[0]:=TSolutionType.Create;
AddResultToSolution(0);
SaveArraySolutionAsTextFile;
end;

procedure TFMainAnt.BtLoadSolutionClick(Sender: TObject);
begin
SetLength(ArraySolution,1);
ArraySolution[0]:=TSolutionType.Create;
LoadArraySolutionAsTextFile;
NameGraphFile:='Test';
end;

procedure TFMainAnt.BtGoAntClick(Sender: TObject);
var
  KolElement:Word;
  CurrentSklad:TAntNodeSklad;
begin
NameGraphFile:='Test';
SetLength(ArraySolution,1);
ArraySolution[0]:=TSolutionType.Create;
//MeProt.Lines.Add('Создается решение');
AddResultToSolution(0);
CreateAntNode;
CreateAnt(StrToInt(EdKolAgent.Text));
AntGoGraph;
KolElement:=0;
CurrentSklad:=FirstNodeAntGraph;
While CurrentSklad<>nil do
  begin
  KolElement:=KolElement+CurrentSklad.KolElement;
  CurrentSklad:=CurrentSklad.NextSklad;
  end;
//MeProt.Lines.Add('Количество элементов '+IntToStr(KolElement));
While Length(Ant[0].Way)<KolElement do
  Ant[0].GoNextNode(FModel.RgKrit.ItemIndex);
AddCopySolution(0);
Ant[0].AddSolutionFromWay(0,ArraySolution[1].ElementArray);
SaveArraySolutionAsTextFile;
end;

end.
