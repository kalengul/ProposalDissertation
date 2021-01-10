unit UVivodStat;

interface

uses
  Classes, Controls, Forms,
  StdCtrls, Grids, Spin;

type
  TFStat = class(TForm)
    Label6: TLabel;
    LaName: TLabel;
    SgStat: TStringGrid;
    SgFailure: TStringGrid;
    Label1: TLabel;
    seNom: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure seNomChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FStat: TFStat;

implementation

{$R *.dfm}

Uses UMainStructure;

procedure TFStat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UMainStructure.FMain.Enabled:=true;
end;

procedure TFStat.FormCreate(Sender: TObject);
begin
SgStat.ColWidths[0]:=200;
SgStat.Cells[0,0]:='Параметр';
SgStat.Cells[1,0]:='Mx';
SgStat.Cells[2,0]:='Dx';
SgFailure.ColWidths[0]:=200;
SgFailure.Cells[0,0]:='№';
SgFailure.Cells[1,0]:='Mx';
SgFailure.Cells[2,0]:='Dx';
end;

procedure TFStat.seNomChange(Sender: TObject);
begin
VivodStatistic(CurrentStat,seNom.Value);
end;

end.
