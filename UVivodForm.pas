unit UVivodForm;

interface

uses
  Classes, Controls, Forms,
  StdCtrls, UFormVivodParameters;

type
  TFVivod = class(TForm)
    Label6: TLabel;
    LaName: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    LaTimeGo: TLabel;
    LaTimeStop: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    LaTimeFailure: TLabel;
    LaTimeAva: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVivod: TFVivod;

implementation

{$R *.dfm}

Uses UMainStructure;

procedure TFVivod.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UMainStructure.FMain.Enabled:=true;
end;

procedure TFVivod.Button1Click(Sender: TObject);
begin
FVivodParameters.ShowModal;
end;

end.
