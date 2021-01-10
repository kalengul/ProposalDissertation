unit UAddNS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,UTransportGRAPH,UNewTransportGraph, Grids, StdCtrls, ExtCtrls;

type
  TFAddNs = class(TForm)
    Panel1: TPanel;
    pnl1: TPanel;
    LaName: TLabel;
    BtAddNs: TButton;
    EdNameFile: TEdit;
    Label1: TLabel;
    SgNS: TStringGrid;
    procedure BtAddNsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAddNs: TFAddNs;
  NodeAddNs:TTransportNode;

implementation

{$R *.dfm}

procedure TFAddNs.BtAddNsClick(Sender: TObject);
var
  n:LongWord;
  NewNs:TGraphStructure;
begin
If NodeAddNs<>nil then
  begin
  n:=Length(NodeAddNs.Ns);
  LaName.Caption:=NodeAddNs.Name;
  NewNs:=TGraphStructure.Create;
  NewNs.Name:=EdNameFile.Text;
//  NewNs.LoadGraphFile(EdNameFile.Text+'.txt');
  SetLength(NodeAddNs.Ns,n+1);
  NodeAddNs.Ns[n]:=NewNs;
  end;
{}
end;

end.
