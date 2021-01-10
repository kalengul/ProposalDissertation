unit UVivodProtocol;

interface

uses
  Classes, Controls, Forms,
  StdCtrls;

type
  TFVivodProtocol = class(TForm)
    CbProtocol: TComboBox;
    MeProtocol: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure CbProtocolChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVivodProtocol: TFVivodProtocol;

implementation

Uses UMainStructure;

{$R *.dfm}

procedure TFVivodProtocol.FormActivate(Sender: TObject);
var
i:Word;
begin
For i:=0 to Length(Structure.StatProtocol)-1 do
  CbProtocol.Items.Add(Structure.StatProtocol[i].NameNode);
end;

procedure TFVivodProtocol.CbProtocolChange(Sender: TObject);
var
i,j:LongWord;
st:string;
begin
i:=0;
While (i<Length(Structure.StatProtocol)) and (Structure.StatProtocol[i].NameNode<>CbProtocol.Text) do
  inc(i);
If i<Length(Structure.StatProtocol) then
  begin
  MeProtocol.Clear;
  If Length(Structure.StatProtocol[i].Protocol)<>0 then
  For j:=0 to Length(Structure.StatProtocol[i].Protocol) do
    begin
    str(Structure.StatProtocol[i].Protocol[j].Time:12:2,st);
    Case Structure.StatProtocol[i].Protocol[j].TypeEvent of
      0: MeProtocol.Lines.Add(st+'->  (Œ“ ¿«)      '+Structure.StatProtocol[i].Protocol[j].EvenTStructureNodeName);
      1: MeProtocol.Lines.Add(st+'->  (¬ Àﬁ◊≈Õ»≈)  '+Structure.StatProtocol[i].Protocol[j].EvenTStructureNodeName);
      2: MeProtocol.Lines.Add(st+'->  (¬€ Àﬁ◊≈Õ»≈) '+Structure.StatProtocol[i].Protocol[j].EvenTStructureNodeName);
      end;
    end;
  end;
end;

end.
