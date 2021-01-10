unit UVivodStatForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin;

type
  TFVivodStat = class(TForm)
    LbVibor: TListBox;
    PbVisual: TPaintBox;
    LeMin: TLabeledEdit;
    LeMax: TLabeledEdit;
    lbl1: TLabel;
    SeShag: TSpinEdit;
    procedure FormActivate(Sender: TObject);
    procedure LbViborClick(Sender: TObject);
    procedure SeShagChange(Sender: TObject);
    procedure LeMinChange(Sender: TObject);
    procedure LeMaxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVivodStat: TFVivodStat;
  Hist:array of Word;
  nHist:LongWord;
  NomElement:LongWord;
  TimeMin,TimeMax:Double;

implementation

uses UMainStructure,UTransportGRAPH;

{$R *.dfm}

procedure TFVivodStat.FormActivate(Sender: TObject);
var
  i:LongWord;
begin
LeMax.Text:=FMain.EdModelTime.Text;
LbVibor.Clear;
For i:=0 to Length(Structure.StatistiksNode)-1 do
  begin
  LbVibor.Items.Add(Structure.StatistiksNode[i].NameNode);
  end;

end;

function DoubleSearch(Par:Double):LongWord;
var
  a,b,x:LongWord;
  fa,fb,fx:Double;
begin
a:=0;
b:=Length(Structure.StatistiksNode[NomElement].TimeFailure)-1;
While b-a>1 do
  begin
  x:=(a+b) div 2;
  fx:=Structure.StatistiksNode[NomElement].TimeFailure[x].TimeFailure;
  if fx=Par then
    begin
    a:=x;
    b:=x;
    end
  else
  If fx-par>0 then
    b:=x
  else
    a:=x;
  end;
Result:=(a+b) div 2
end;

procedure GoHist(Mnosh:word; var kol:LongWord);
var
  i:LongWord;
  nmax,nmin:LongWord;
  shag:Double;
begin
nHist:=Trunc((FVivodStat.PbVisual.Width-20)/Mnosh)+1;
SetLength(Hist,nHist+1);
For i:=0 to nHist do
  Hist[i]:=0;
TimeMin:=StrToFloat(FVivodStat.LeMin.Text);
nmin:=DoubleSearch(TimeMin);
TimeMax:=StrToFloat(FVivodStat.LeMax.Text);
nmax:=DoubleSearch(TimeMax);
Kol:=nmax-nmin;
Shag:=nhist/(TimeMax-TimeMin);
For i:=nmin to nmax do
  begin
  Inc(Hist[Trunc((Structure.StatistiksNode[NomElement].TimeFailure[i].TimeFailure-TimeMin)*shag)]);
  end;
end;

procedure Draw;
var
  i:LongWord;
  max:LongWord;
  nShag:Word;
  kol,z:LongWord;
  st:string;
begin
with FVivodStat do
  begin
  nShag:=SeShag.Value;
  NomElement:=LbVibor.ItemIndex;
  PbVisual.Canvas.Rectangle(0,0,PbVisual.Width,PbVisual.Height);
  if Length(Structure.StatistiksNode[NomElement].TimeFailure)<>0 then
    begin
    GoHist(nShag,kol);
    max:=0;
    for i:=0 to nHist do
      if max<Hist[i] then
        max:=Hist[i];


    PbVisual.Canvas.Pen.Color:=clRed;
    For i:=0 to nHist do
      PbVisual.Canvas.Rectangle(10+i*nShag,PbVisual.Height-20,10+(i+1)*nShag,PbVisual.Height-20-trunc((PbVisual.Height-40)/max*Hist[i]));
    PbVisual.Canvas.Pen.Color:=clBlack;
    PbVisual.Canvas.MoveTo(5,PbVisual.Height-20);
    PbVisual.Canvas.LineTo(PbVisual.Width-10,PbVisual.Height-20);
    PbVisual.Canvas.MoveTo(10,20);
    PbVisual.Canvas.LineTo(10,PbVisual.Height-20);
    i:=0;
    While i<=max do
      begin
      z:=Trunc(PbVisual.Height-20-(PbVisual.Height-40)*i/max);
      PbVisual.Canvas.MoveTo(5,z);
      PbVisual.Canvas.LineTo(15,z);
      Str(i/StrToFloat(FMain.EdKolRealise.Text):5:4,st);
      PbVisual.Canvas.TextOut(12,z+2,st);
      If Max>300 then
        i:=i+100
      else
      if max>100 then
        i:=i+50
      else
      If max>10 then
        i:=i+10
      else
        i:=i+1;
      end;
    For i:=0 to 20 do
      begin
      z:=Trunc(10+(PbVisual.Width-20)*i/20);
      PbVisual.Canvas.MoveTo(z,PbVisual.Height-15);
      PbVisual.Canvas.LineTo(z,PbVisual.Height-25);
      Str(Trunc(i/20*(TimeMax-TimeMin)+TimeMin),st);
      PbVisual.Canvas.TextOut(z,PbVisual.Height-15,st);
      end;
    end;
  end;
end;

procedure TFVivodStat.LbViborClick(Sender: TObject);
begin
//  NomElement:=4;
Draw;
end;

procedure TFVivodStat.SeShagChange(Sender: TObject);
begin
Draw;
end;

procedure TFVivodStat.LeMinChange(Sender: TObject);
begin
Draw;
end;

procedure TFVivodStat.LeMaxChange(Sender: TObject);
begin
//Draw;
end;

end.
