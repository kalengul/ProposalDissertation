unit UTimeStructure;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFTimeStructure = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Ed0On: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Ed0Off: TEdit;
    Ed1On: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Ed1Off: TEdit;
    Ed2On: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Ed2Off: TEdit;
    Ed3On: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Ed4Off: TEdit;
    BtGo: TButton;
    procedure BtGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTimeStructure: TFTimeStructure;

implementation

uses UTransportGRAPH, UReliabilityGraph;

{$R *.dfm}

procedure TFTimeStructure.BtGoClick(Sender: TObject);
var
  TransportNode:TTransportNode;
  StructureNode:TStructureNode;
  NomStructure:LongWord;
begin
TransportNode:=FirsTTransportNode;
While TransportNode<>nil do
  begin
  IF TransportNode.Ns<>nil then
    For NomStructure:=0 to Length(TransportNode.Ns)-1 do  
    begin

    end;
  TransportNode:=TransportNode.NexTTransportNode;
  end;
end;

end.
