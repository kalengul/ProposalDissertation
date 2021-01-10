unit UVivodAeroport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,UTransportGRAPH, ExtCtrls, StdCtrls, Grids;

type
  TFVivodAeroport = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    Label1: TLabel;
    SgLA: TStringGrid;
    pnl4: TPanel;
    pnl5: TPanel;
    pnl6: TPanel;
    Label2: TLabel;
    LbElements: TListBox;
    pnl7: TPanel;
    PbVivodInformation: TPaintBox;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LbElementsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVivodAeroport: TFVivodAeroport;
  VivodTransportNode:TTransportNode;

implementation

uses UMain;


{$R *.dfm}

procedure TFVivodAeroport.FormActivate(Sender: TObject);
var
  i:LongWord;
  st:string;
begin
If VivodTransportNode<>nil then
  begin
  If Length(VivodTransportNode.Ns)<>0 then
  begin
  SgLA.RowCount:=Length(VivodTransportNode.Ns)+1;
  For i:=0 to Length(VivodTransportNode.Ns)-1 do
    begin
    SgLA.Cells[0,i+1]:=VivodTransportNode.Ns[i].Name+' '+VivodTransportNode.Ns[i].Nomber;
{    Str(VivodTransportNode.Ns[i].MainNode.Stat,st)
    SgLA.Cells[1,i+1]:=st;}
    end;
  end;
  LbElements.Clear;
  if Length(VivodTransportNode.StatProduction)<>0 then
    begin
    For i:=0 to Length(VivodTransportNode.StatProduction)-1 do
      begin
      LbElements.Items.Add(VivodTransportNode.StatProduction[i].Name);
      end;
    end;
  end;
end;

procedure TFVivodAeroport.FormCreate(Sender: TObject);
begin
VivodTransportNode:=nil;
end;

procedure TFVivodAeroport.LbElementsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Point : TPoint;
  i : LongWord;
begin
  Point.X := X;
  Point.Y := Y;
  i := LbElements.ItemAtPos(Point, True);
  VivodHist(PbVivodInformation.Canvas,PbVivodInformation.Height,PbVivodInformation.Width,VivodTransportNode.StatProduction[i].HistFailure,VivodTransportNode.StatProduction[i].HistRecov,VivodTransportNode.StatProduction[i].HistItog);
end;

end.
