unit UFormVivodParameters;

interface

uses
  Classes, Controls, Forms,
  StdCtrls, ExtCtrls, Grids;

type
  TFVivodParameters = class(TForm)
    Label1: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LbStructure: TListBox;
    SgFailure: TStringGrid;
    LeTimeGo: TLabeledEdit;
    SgRelation: TStringGrid;
    MeDouble: TMemo;
    MeSensor: TMemo;
    procedure LbStructureClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVivodParameters: TFVivodParameters;

implementation

{$R *.dfm}

Uses UVivod;

procedure TFVivodParameters.LbStructureClick(Sender: TObject);
begin
ParametersVivod(LbStructure.Items[LbStructure.ItemIndex]);
GoSubGraphVivod(LbStructure.Items[LbStructure.ItemIndex]);
StructureVivod;
end;

procedure TFVivodParameters.FormActivate(Sender: TObject);
begin
ParametersVivod(CurrenTStructureNodeVivod.Name);
GoSubGraphVivod(CurrenTStructureNodeVivod.Name);
StructureVivod;
end;

end.
