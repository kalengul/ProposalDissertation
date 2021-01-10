unit UNewTransportGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTransportGRAPH, USklad, StdCtrls, ExtCtrls;

type
  TFNewTransportGraph = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    PbGraph: TPaintBox;
    BtNewNode: TButton;
    BtNewArc: TButton;
    EdNewNode: TEdit;
    LaSost: TLabel;
    BtAddSkald: TButton;
    EdVolumeSklad: TEdit;
    BtAddNS: TButton;
    BtAddManufacture: TButton;
    BtAddRecover: TButton;
    EdRecoverCoeff: TEdit;
    EdManufactureNAme: TEdit;
    EdCostSklad: TEdit;
    procedure BtNewNodeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PbGraphMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtNewArcClick(Sender: TObject);
    procedure BtAddSkaldClick(Sender: TObject);
    procedure BtAddNSClick(Sender: TObject);
    procedure BtAddManufactureClick(Sender: TObject);
    procedure BtAddRecoverClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNewTransportGraph: TFNewTransportGraph;

implementation

{$R *.dfm}

uses UAddNS;

var
  TypeGo:Byte;
  Node,NodeK:TTransportNode;
  Arc:TTransportArc;
  Sklad:TSklad;
  Manufact:TManufact;
  Bitmap : TBitmap;

procedure TFNewTransportGraph.PbGraphMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Case TypeGo of
  0:begin
    end;
  1:begin
    TypeGo:=0;
    Node.x:=x;
    Node.y:=y;
    LaSost.Caption:='';
    end;
  3:begin
    NodeK:=SearchNodeXY(x,y);
    if NodeK<>nil then
      begin
      Arc:=Node.AddArc(1,Sqrt(Sqr(Node.x-NodeK.x)+Sqr(Node.y-NodeK.y)));
      Arc.Node:=NodeK;
      end
    else
      begin
      LaSost.Caption:='';
      TypeGo:=0;
      end;
    end;
  2:begin
    Node:=SearchNodeXY(x,y);
    if Node<>nil then
      begin
      LaSost.Caption:='Выберите конечную вершину';
      TypeGo:=3;
      end
    else
      begin
      LaSost.Caption:='';
      TypeGo:=0;
      end;
    end;    
  4:begin
    Node:=SearchNodeXY(x,y);
    If Node<>nil then
      begin
      Sklad:=TSklad.Create;
      Node.Sklad:=Sklad;
      Sklad.MaxVolumeSklad:=StrToFloat(EdVolumeSklad.Text);
      Sklad.CostSklad:=StrToFloat(EdCostSklad.Text);
      If Node.TypeNode=0 then
        Node.TypeNode:=1;
      end;
    TypeGo:=0;
    LaSost.Caption:='';
    end;
  5:begin
    Node:=SearchNodeXY(x,y);
    If Node<>nil then
      begin
      NodeAddNs:=Node;
      FAddNs.ShowModal;
      end;
    TypeGo:=0;
    LaSost.Caption:='';
    end;
  6:begin
    Node:=SearchNodeXY(x,y);
    If Node<>nil then
      begin
      Manufact:=TManufact.Create;
      Node.Manufact:=Manufact;
      Manufact.Name:=EdManufactureNAme.Text;
      end;
    TypeGo:=0;
    LaSost.Caption:='';
    end;
  7:begin
    Node:=SearchNodeXY(x,y);
    If Node<>nil then
      begin
      Manufact:=TManufact.Create;
      Node.ARZ:=Manufact;
      Manufact.Name:=EdManufactureNAme.Text;
      end;
    TypeGo:=0;
    LaSost.Caption:='';
    end;
  end;

Bitmap:=TBitmap.Create;
Bitmap.Width := PbGraph.Width;
Bitmap.Height := PbGraph.Height;
Bitmap.LoadFromFile('RUS.bmp');
PbGraph.Canvas.Draw(0,0,Bitmap);
PaintNode(PbGraph.Canvas);
end;

procedure TFNewTransportGraph.FormActivate(Sender: TObject);
begin
TypeGo:=0;
Node:=nil;
end;

procedure TFNewTransportGraph.BtNewNodeClick(Sender: TObject);
begin
Node:=AddNode(EdNewNode.Text,0);
TypeGo:=1;
LaSost.Caption:='Выберите точку, где расположена вершина';
end;

procedure TFNewTransportGraph.BtNewArcClick(Sender: TObject);
begin
TypeGo:=2;
LaSost.Caption:='Выберите начальную вершину';
end;

procedure TFNewTransportGraph.BtAddSkaldClick(Sender: TObject);
begin
TypeGo:=4;
LaSost.Caption:='Выберите вершину';
end;

procedure TFNewTransportGraph.BtAddNSClick(Sender: TObject);
begin
TypeGo:=5;
LaSost.Caption:='Выберите вершину';
end;

procedure TFNewTransportGraph.BtAddManufactureClick(Sender: TObject);
begin
TypeGo:=6;
LaSost.Caption:='Выберите вершину';
end;

procedure TFNewTransportGraph.BtAddRecoverClick(Sender: TObject);
begin
TypeGo:=7;
LaSost.Caption:='Выберите вершину';
end;

end.
