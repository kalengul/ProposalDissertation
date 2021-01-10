unit UMainStructure;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls,
  Psapi, //Для определения объема памяти
  UTransportGRAPH,
  UVivodProtocol,
  UVivod, ExtCtrls, Grids,
  USBS,ComObj,
  UVivodStat,
  UReliabilityGraph,
  UVisualGraph,
  UVivodStatForm;

type
  TFMain = class(TForm)
    BtLoad: TButton;
    LaGraph: TLabel;
    BtFailure: TButton;
    MeProt: TMemo;
    Label6: TLabel;
    MeSBS: TMemo;
    Label7: TLabel;
    BtSwitch: TButton;
    BtGoSBS: TButton;
    Pb1: TPaintBox;
    BtLoadAction: TButton;
    Label8: TLabel;
    LaModelTime: TLabel;
    BtModelTime: TButton;
    EdModelTime: TEdit;
    BtDel: TButton;
    BtGoStat: TButton;
    EdKolRealise: TEdit;
    RgTypeProt: TRadioGroup;
    BtAddProt: TButton;
    BtOutputProtocol: TButton;
    BtSaveStatExcel: TButton;
    BtGoToFailure: TButton;
    CbElements: TComboBox;
    BtVivodStat: TButton;
    procedure BtLoadClick(Sender: TObject);
    procedure BtGraphClick(Sender: TObject);
    procedure BtFailureClick(Sender: TObject);
    procedure BtSwitchClick(Sender: TObject);
    procedure BtGoSBSClick(Sender: TObject);
    procedure BtLoadActionClick(Sender: TObject);
    procedure BtModelTimeClick(Sender: TObject);
    procedure Pb1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtGoStatClick(Sender: TObject);
    procedure BtAddProtClick(Sender: TObject);
    procedure BtOutputProtocolClick(Sender: TObject);
    procedure BtSaveStatExcelClick(Sender: TObject);
    procedure BtGoToFailureClick(Sender: TObject);
    procedure CbElementsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtVivodStatClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//procedure VivodSBS;
Procedure VivodStatistic(Stat:TStatistics; NomRecovery:Word);

Const
RAZM = 6;

var
  FMain: TFMain;
  Structure:TGraphStructure;
  ProtocolEvent:TArrayProtocolEvent;
  NomProtocol:LongWord;
//  GoStat:Boolean;
  TypeActionMouse:Byte;
  NodeKon:TStructureNode;
  CurrentStat:TStatistics;
  f:TextFile;

implementation

Uses UEventSBS, UVivodForm, UMain;

{$R *.dfm}

Procedure UPainTStructureNode;
var
i,LText:LongWord;
SText:String;
begin
With FMain do
begin

if KolNode>0 then
For i:=0 to KolNode-1 do
  begin
  Pb1.Canvas.Rectangle(Trunc(ArrayVisualNode[i].x*Pb1.Width/MaxXNode-RAZM),ArrayVisualNode[i].y-RAZM,Trunc(ArrayVisualNode[i].x*Pb1.Width/MaxXNode+RAZM),ArrayVisualNode[i].y+RAZM);
  If ArrayVisualNode[i].Node.BoolRegularly=1 then
    Pb1.Canvas.Brush.Color:=ClLime;
  If ArrayVisualNode[i].Node.BoolRegularly=0 then
    Pb1.Canvas.Brush.Color:=ClGray;
  If ArrayVisualNode[i].Node.BoolFailure=1 then
    Pb1.Canvas.Brush.Color:=ClYellow;
  If ArrayVisualNode[i].Node.BoolFailure=2 then
    Pb1.Canvas.Brush.Color:=ClRed;
  If ArrayVisualNode[i].Node.BoolAvailability=0 then
    Pb1.Canvas.Brush.Color:=ClBlue;

  Pb1.Canvas.FloodFill(Trunc(ArrayVisualNode[i].x*Pb1.Width/MaxXNode),ArrayVisualNode[i].y,ClBlack,fsBorder);
  end;

if KolGraph>0 then
For i:=0 to KolGraph-1 do
  begin
  Pb1.Canvas.Brush.Color:=ClBtnFace;
  Pb1.Canvas.Pen.Style:=psDot;
//  Pb1.Canvas.Rectangle(Trunc(ArrayVisualGraph[i].x1*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y1,Trunc(ArrayVisualGraph[i].x2*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y2);
  Pb1.Canvas.MoveTo(Trunc(ArrayVisualGraph[i].x1*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y1);
  Pb1.Canvas.LineTo(Trunc(ArrayVisualGraph[i].x2*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y1);
  Pb1.Canvas.LineTo(Trunc(ArrayVisualGraph[i].x2*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y2);
  Pb1.Canvas.LineTo(Trunc(ArrayVisualGraph[i].x1*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y2);
  Pb1.Canvas.LineTo(Trunc(ArrayVisualGraph[i].x1*Pb1.Width/MaxXNode),ArrayVisualGraph[i].y1);
  Pb1.Canvas.Pen.Style:=psSolid;
  SText:=ArrayVisualGraph[i].Name;
  While pos('>',SText)<>0 do
    Delete(SText,1,pos('>',SText));
  LText:=Pb1.Canvas.TextWidth(SText);
  If LText<(ArrayVisualGraph[i].x2-ArrayVisualGraph[i].x1)*Pb1.Width/MaxXNode-10 then
    Pb1.Canvas.TextOut(Trunc((ArrayVisualGraph[i].x2+ArrayVisualGraph[i].x1)*Pb1.Width/(MaxXNode*2)-LText/2),ArrayVisualGraph[i].y1-10,SText);
  Pb1.Canvas.Brush.Style := bsSolid;

  end;

end;
end;

Procedure GoCbElements(CurrentGraph:Tgraph);
var
CurrenTStructureNode:TStructureNode;
begin
CurrenTStructureNode:=CurrentGraph.Node;
While CurrenTStructureNode<>nil do
  begin
  FMain.CbElements.Items.Add(CurrentGraph.Name+'->'+CurrenTStructureNode.Name);
  If CurrenTStructureNode.SubGraph<>nil then
    GoCbElements(CurrenTStructureNode.SubGraph);
  CurrenTStructureNode:=currenTStructureNode.NexTStructureNode;
  end;
end;

procedure TFMain.BtLoadClick(Sender: TObject);
begin
Structure:=TGraphStructure.Create;
MaxTime:=StrToFloat(EdModelTime.Text);
Structure.LoadGraphFile('ТУ154.txt');
CurrentGraphVivod:=Structure.GraphLevel0;
Structure.GoAllEvent;
GoAllLevelNode;
GoAllXYNode;
CbElements.Clear;
GoCbElements(Structure.GraphLevel0);
//StructureVivod;
VivodSBS;
VivodModelTime;
UPainTStructureNode;
end;

procedure TFMain.BtGraphClick(Sender: TObject);
begin
GoLevelUpGraphVivod;
//StructureVivod;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
KoefFailureSwitch:=1;
{MeProt.Lines.Clear;
Structure:=TGraphStructure.Create;
Sbs:=TQueueEvent.Create;
MaxX:=Pb1.Width;
MaxY:=Pb1.Height;     }
end;

procedure TFMain.BtFailureClick(Sender: TObject);
begin
CurrenTStructureNodeVivod.GoFailure(0,0);
VivodSBS;
VivodModelTime;
UPainTStructureNode;
end;

procedure TFMain.BtSwitchClick(Sender: TObject);
begin
CurrenTStructureNodeVivod.GoSwitch(1,'Включить',1);
VivodSBS;
VivodModelTime;
UPainTStructureNode;
end;

procedure TFMain.BtGoSBSClick(Sender: TObject);
var
  EndTime:Double;
begin
ProcessingEvent(endTime);
VivodSBS;
//VivodModelTime;
UPainTStructureNode;
end;

procedure TFMain.BtLoadActionClick(Sender: TObject);
var
  ListAction:TListAction;
begin
ListAction:=TListAction.Create;
ListAction.LoadAction(Structure,'Действие.txt');
VivodSBS;
VivodModelTime;
UPainTStructureNode;
end;

procedure TFMain.BtModelTimeClick(Sender: TObject);
var
  EndTime:Double;
begin
GoStat:=False;
KolProgon:=1;
While Sbs.ModelTime<=StrToFloat(EdModelTime.Text) Do
  begin
  ProcessingEvent(EndTime);
  VivodModelTime;
  UPainTStructureNode;
  VivodModelTime;
  Sleep(10);
  end
end;

Procedure VivodStatistic(Stat:TStatistics; NomRecovery:Word);
  var
  St:String;
  k:LongWord;
  begin
{
  FStat.SgStat.Cells[0,1]:='Время работы';
  Str(Stat.TimeOsn[1,0]:7:2,st);
  FStat.SgStat.Cells[1,1]:=st;
  Str(Stat.TimeOsn[1,1]-Sqr(Stat.TimeOsn[1,0]),st);
  FStat.SgStat.Cells[2,1]:=st;

  FStat.SgStat.Cells[0,2]:='Время ожидания';
  Str(Stat.TimeOsn[0,0]:7:2,st);
  FStat.SgStat.Cells[1,2]:=st;
  Str(Stat.TimeOsn[0,1]-Sqr(Stat.TimeOsn[0,0]),st);
  FStat.SgStat.Cells[2,2]:=st;

  FStat.SgStat.Cells[0,3]:='Время ОТКАЗА';
  Str(Stat.TimeOsn[2,0]:7:2,st);
  FStat.SgStat.Cells[1,3]:=st;
  Str(Stat.TimeOsn[2,1]-Sqr(Stat.TimeOsn[2,0]),st);
  FStat.SgStat.Cells[2,3]:=st;

  FStat.SgStat.Cells[0,4]:='Время отсутствия';
  Str(Stat.TimeOsn[3,0]:7:2,st);
  FStat.SgStat.Cells[1,4]:=st;
  Str(Stat.TimeOsn[3,1]-Sqr(Stat.TimeOsn[3,0]),st);
  FStat.SgStat.Cells[2,4]:=st;

  FStat.SgStat.Cells[0,5]:='Макс. кол-во эл-ов';
  Str(Stat.MaxKolRecovery:7,st);
  FStat.SgStat.Cells[1,5]:=st;

  FStat.SgStat.Cells[0,6]:='Время ожидания';
  Str(Stat.kolRecovery[0]:7:2,st);
  FStat.SgStat.Cells[1,6]:=st;
  Str(Stat.kolRecovery[1]-Sqr(Stat.kolRecovery[0]),st);
  FStat.SgStat.Cells[2,6]:=st;

  IF NomRecovery<=Stat.MaxKolRecovery then
    begin
    FStat.SgFailure.Cells[0,1]:='Время работы';
    Str(Stat.Time[NomRecovery][1,0]:7:2,st);
    FStat.SgFailure.Cells[1,1]:=st;
    Str(Stat.Time[NomRecovery][1,1]-Sqr(Stat.Time[NomRecovery][1,0]),st);
    FStat.SgFailure.Cells[2,1]:=st;

    FStat.SgFailure.Cells[0,2]:='Время ожидания';
    Str(Stat.Time[NomRecovery][0,0]:7:2,st);
    FStat.SgFailure.Cells[1,2]:=st;
    Str(Stat.Time[NomRecovery][0,1]-Sqr(Stat.Time[NomRecovery][0,0]),st);
    FStat.SgFailure.Cells[2,2]:=st;

    FStat.SgFailure.Cells[0,3]:='Время ОТКАЗА';
    Str(Stat.Time[NomRecovery][2,0]:7:2,st);
    FStat.SgFailure.Cells[1,3]:=st;
    Str(Stat.Time[NomRecovery][2,1]-Sqr(Stat.Time[NomRecovery][2,0]),st);
    FStat.SgFailure.Cells[2,3]:=st;

    FStat.SgFailure.Cells[0,4]:='Время отсутствия';
    Str(Stat.Time[NomRecovery][3,0]:7:2,st);
    FStat.SgFailure.Cells[1,4]:=st;
    Str(Stat.Time[NomRecovery][3,1]-Sqr(Stat.Time[NomRecovery][3,0]),st);
    FStat.SgFailure.Cells[2,4]:=st;

    FStat.SgFailure.Cells[0,5]:='Количество отказов';
    Str(Stat.KolFailure[NomRecovery][0]:7:2,st);
    FStat.SgFailure.Cells[1,5]:=st;
    Str(Stat.KolFailure[NomRecovery][1]-Sqr(Stat.KolFailure[NomRecovery][0]),st);
    FStat.SgFailure.Cells[2,5]:=st;
{    if Length(Stat.ArrayFailure[NomRecovery])<>1 then
    for k:=1 to Length(Stat.ArrayFailure[NomRecovery])-1 do
      begin
      FStat.SgFailure.RowCount:=5+Length(Stat.ArrayFailure[NomRecovery])*3-2;
      FStat.SgFailure.Cells[0,6+(k-1)*3]:='Время отказ №'+IntToStr(k);
      Str(Stat.ArrayFailure[NomRecovery][k].Time[0]:7:2,st);
      FStat.SgFailure.Cells[1,6+(k-1)*3]:=st;
      Str(Stat.ArrayFailure[NomRecovery][k].Time[1]-Sqr(Stat.ArrayFailure[NomRecovery][k].Time[0]),st);
      FStat.SgFailure.Cells[2,6+(k-1)*3]:=st;

      FStat.SgFailure.Cells[0,7+(k-1)*3]:='Вкл дубл отказ №'+IntToStr(k);
      Str(Stat.ArrayFailure[NomRecovery][k].DoubleElement[0]:7:2,st);
      FStat.SgFailure.Cells[1,7+(k-1)*3]:=st;
      Str(Stat.ArrayFailure[NomRecovery][k].DoubleElement[1]-Sqr(Stat.ArrayFailure[NomRecovery][k].DoubleElement[0]),st);
      FStat.SgFailure.Cells[2,7+(k-1)*3]:=st;

      FStat.SgFailure.Cells[0,8+(k-1)*3]:='Отказ надуровня отказ №'+IntToStr(k);
      Str(Stat.ArrayFailure[NomRecovery][k].LevelOtkaz[0]:7:2,st);
      FStat.SgFailure.Cells[1,8+(k-1)*3]:=st;
      Str(Stat.ArrayFailure[NomRecovery][k].LevelOtkaz[1]-Sqr(Stat.ArrayFailure[NomRecovery][k].LevelOtkaz[0]),st);
      FStat.SgFailure.Cells[2,8+(k-1)*3]:=st;
      end;   }
 {   end;
{  FStat.SgFailure.RowCount:=1;
  For k:=0 to Length(Stat.MTimeFailure)-1 do
    begin
    FStat.SgFailure.RowCount:=K+2;
    FStat.SgFailure.Cells[0,k+1]:=IntToStr(K+1);
    Str(Stat.MTimeFailure[k]:7:2,st);
    FStat.SgFailure.Cells[1,k+1]:=st;
    Str(Stat.DTimeFailure[k]:7:2,st);
    FStat.SgFailure.Cells[2,k+1]:=st;
    end;}
  end;

procedure TFMain.Pb1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i:LongWord;
  CurrenTStructureNodeV:TStructureNode;
  st:string;
  Stat:TStatistics;
begin
//Поиск вершины
i:=0;
While (i<Length(ArrayVisualNode)) and not(
      (x<=ArrayVisualNode[i].x*Pb1.Width/MaxXNode+RAZM) and
      (X>=ArrayVisualNode[i].x*Pb1.Width/MaxXNode-RAZM) and
      (y<=ArrayVisualNode[i].y+RAZM) and
      (y>=ArrayVisualNode[i].y-RAZM)) do
  inc(i);
If i<Length(ArrayVisualNode) then
begin
If TypeActionMouse=0 then
  begin
  //Вывод информации
  CurrenTStructureNodeV:=ArrayVisualNode[i].Node;
  CurrenTStructureNodeVivod:=CurrenTStructureNodeV;
  CurrentGraphVivod:=CurrenTStructureNodeV.Graph;
  IF not GoStat then
    begin
    FVivod.LaName.Caption:=CurrenTStructureNodeV.Name;
    Str(CurrenTStructureNodeV.Time[1]:7:2,st);
    FVivod.LaTimeGo.Caption:=st;
    Str(CurrenTStructureNodeV.Time[0]:7:2,st);
    FVivod.LaTimeStop.Caption:=st;
    Str(CurrenTStructureNodeV.Time[2]:7:2,st);
    FVivod.LaTimeFailure.Caption:=st;
    Str(CurrenTStructureNodeV.Time[3]:7:2,st);
    FVivod.LaTimeAva.Caption:=st;
    //Визуализация
    FVivod.Top:=ArrayVisualNode[i].y+RAZM+2+Pb1.Top+FMain.Top;
    FVivod.Left:=Trunc(ArrayVisualNode[i].x*Pb1.Width/MaxXNode+RAZM+2)+Pb1.Left+FMain.Left;
    FVivod.Visible:=true;
    end
  else
    begin
    FStat.LaName.Caption:=CurrenTStructureNodeV.Name;
    Stat:=CurrenTStructureNodeV.Stat;
    CurrentStat:=Stat;
    VivodStatistic(Stat,0);
    //Визуализация
    FStat.Top:=ArrayVisualNode[i].y+RAZM+2+Pb1.Top+FMain.Top;
    FStat.Left:=Trunc(ArrayVisualNode[i].x*Pb1.Width/MaxXNode+RAZM+2)+Pb1.Left+FMain.Left;
    FStat.Visible:=true;
    end;
  end;
If TypeActionMouse=1 then
  begin
  ArrayVisualNode[i].Node.StatProtocol:=Structure.AddNewProtocol(RgTypeProt.ItemIndex,ArrayVisualNode[i].Node);
  TypeActionMouse:=0;
  end;
end;
end;

procedure TFMain.BtDelClick(Sender: TObject);
begin
FreeAndNil(Structure.GraphLevel0);
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
UPainTStructureNode;
end;

function GoMemory:LongWord;
begin
  Result:=(AllocMemSize);
end;

procedure TFMain.BtGoStatClick(Sender: TObject);
var
  i:LongWord;
  j:LONGWord;
  NomExcel:LongWord;
  StructureNameFile:string;
  EndTime:Double;
  ListAction:TListAction;
begin
AssignFile(f,'Отказы протокол.txt');
Rewrite(f);
//  MsExcel := CreateOleObject('Excel.Application');
//  MsExcel.Workbooks.Open['E:\Диссертация\ПРОГРАММА\Пример2.xls'];
GoStat:=true;
NomExcel:=1;
KolProgon:=0;
//  MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[1,1]:=GoMemory;
//Inc(NomExcel);
StructureNameFile:='ТУ154.txt';
Structure.Name:=StructureNameFile;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Запуск');
For i:=1 to StrToInt(EdKolRealise.Text) do
  begin
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка структуры');
  Inc(KolProgon);
  Structure.LoadGraphFile(StructureNameFile);
  Structure.NewProgonStat;
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   СОздание событий отказа');
  CurrentGraphVivod:=Structure.GraphLevel0;
  Structure.GoAllEvent;
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
  ListAction:=TListAction.Create;
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Загрузка действий');
  ListAction.LoadAction(Structure,'Действие.txt');
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Старт прогона №'+IntToStr(i));
  SetLength(ProtocolEvent,0);
  While Sbs.ModelTime<=StrToFloat(EdModelTime.Text) Do
    ProcessingEvent(EndTime);
//      MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Конец прогона №'+IntToStr(i));
//      MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//      Inc(NomExcel);
  structure.GraphLevel0.SaveTime;
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Выключение системы');
  structure.GraphLevel0.SwitchOFF;
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Сохранение статистики прогона №'+IntToStr(i));
  Structure.SaveStat;
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
{
MeSbs.Clear;
For j:=0 to NomProtocol-1 do
  begin
//  Writeln(f,IntToStr(j));
  Case ProtocolEvent[j].TypeEvent of
    0: MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[j+2,3]:=ProtocolEvent[j].Time;
    3: MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[j+2,5]:=ProtocolEvent[j].Time;
    2: MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[j+2,4]:=ProtocolEvent[j].Time;
    1: MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[j+2,6]:=ProtocolEvent[j].Time;
    4: MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[j+2,7]:=ProtocolEvent[j].Time;
    end;
  MsExcel.Workbooks[1].WorkSheets['Лист1'].Cells[j+2,1]:=ProtocolEvent[j].EvenTStructureNodeName;
  end;
//  MsExcel.ActiveWorkbook.Close;
//  MsExcel.Application.Quit;}
//  Structure.SaveStatExcel;

//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление структуры');
  FreeAndNil(Structure.GraphLevel0);
  FreeAndNil(SBS);
 //   MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление СБС');
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
  SetLength(ProtocolEvent,0);
  NomProtocol:=0;
//    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Удаление действий');
  FreeAndNil(ListAction);
//    MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//    Inc(NomExcel);
  KoefFailureSwitch:=1;
  Sbs:=TQueueEvent.Create;
  Writeln(f);
  end;



{For i:=0 to Length(Structure.StatistiksNode)-1 do
  Structure.StatistiksNode[i].StatCounting;}
//MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'   Конец сбора статистики');
{Structure.LoadGraphFile('марсохода Curiosity.txt');
CurrentGraphVivod:=Structure.GraphLevel0;
GoAllLevelNode;
GoAllXYNode;
UPainTStructureNode;}
CloseFile(f);
Structure.SaveFailureFile;
Structure.SaveHistFailureTextFile('Гистограмма отказов.txt');
Structure.SaveStatFailureTextFile('ОТКАЗЫ.txt');
Structure.SaveStatRecoveryTextFile('ВОССТАНОВЛЕНИЕ.txt');
//Сортировка времен отказов
For i:=0 to Length(Structure.StatistiksNode)-1 do
  Structure.StatistiksNode[i].SortTimeFailure;
//  MsExcel.Workbooks[1].WorkSheets['Лист2'].Cells[NomExcel,1]:=GoMemory;
//  Inc(NomExcel);
//  MsExcel.ActiveWorkbook.Close;
//  MsExcel.Application.Quit;
end;

procedure TFMain.BtAddProtClick(Sender: TObject);
begin
TypeActionMouse:=1;
end;

procedure TFMain.BtOutputProtocolClick(Sender: TObject);
begin
FVivodProtocol.ShowModal;
end;

procedure TFMain.BtSaveStatExcelClick(Sender: TObject);
begin
Structure.SaveStatExcel;
end;

procedure TFMain.BtGoToFailureClick(Sender: TObject);
var
  EndTime:Double;
begin
GoStat:=False;
KolProgon:=1;
While NodeKon.BoolFailure<>2 Do
  begin

  ProcessingEvent(EndTime);
  UPainTStructureNode;
//  Sleep(20);
  end

end;

Procedure SearchNodeGraph(CurrentGraph:TGraph; var searchNode:TStructureNode);
var
CurrenTStructureNode:TStructureNode;
begin
CurrenTStructureNode:=CurrentGraph.Node;
While CurrenTStructureNode<>nil do
  begin
  If CurrenTStructureNode.Graph.Name+'->'+CurrenTStructureNode.Name=FMain.CbElements.Text then
    SearchNode:=CurrenTStructureNode;
  If CurrenTStructureNode.SubGraph<>nil then
    SearchNodeGraph(CurrenTStructureNode.SubGraph,SearchNode);
  CurrenTStructureNode:=CurrenTStructureNode.NexTStructureNode;
  end;
end;

procedure TFMain.CbElementsChange(Sender: TObject);
begin
SearchNodeGraph(Structure.GraphLevel0,NodeKon);
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FreeAndNil(Structure);
end;

procedure TFMain.BtVivodStatClick(Sender: TObject);
begin
FVivodStat.ShowModal;
end;

end.
