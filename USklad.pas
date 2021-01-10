unit USklad;

interface

uses
  SysUtils,
  UReliabilityGraph;

type

  TElementSklad = class
    Name:String;
    kolvo:Word;
    TimeEnabled:array of double;
    NextElement:TElementSklad;
    TimeWaiting:double;
    FlagEndModel:Boolean;
    TimeEndModel:Double;
    Procedure ClearElement;
    procedure DecreaseElement(TimeDecrease:Double);
    constructor Create;
    destructor destroy;  override;
  end;

  TSklad = class
    FirstElement:TElementSklad;
    CostSklad:Double;
    VolumeSklad,MaxVolumeSklad:Double;
    AllTimeProcess:TArrayProcessDouble;
    NameElementProcess:string;
    procedure ClearSklad;
    procedure ClearElementSklad;
    function SearchElement (Name:string):TElementSklad;
    function AddElement (Name:String; Time:Double; ElementEndModel:Boolean):TElementSklad;
    constructor Create;
    destructor destroy;  override;
  end;

implementation

constructor TElementSklad.Create;
  begin
  Name:='';
  KOlvo:=0;
  TimeWaiting:=0;
  FlagEndModel:=False;
  TimeEndModel:=0;
  SetLength(TimeEnabled,0);
  NextElement:=nil;
  end;

destructor TElementSklad.destroy;
  begin
  Name:='';
  KOlvo:=0;
  TimeWaiting:=0;
  FlagEndModel:=false;
  SetLength(TimeEnabled,0);
  NextElement:=nil;
  inherited;
  end;

constructor TSklad.Create;
  begin
  FirstElement:=nil;
  CostSklad:=0;
  VolumeSklad:=0;
  MaxVolumeSklad:=0;
  NameElementProcess:='';
  end;

destructor TSklad.destroy;
  begin
  ClearSklad;
  inherited;
  end;

procedure TSklad.ClearSklad;
  var
    DelElement,CElement:TElementSklad;
  begin
  CElement:=FirstElement;
  While CElement<>nil do
    begin
    DelElement:=CElement;
    CElement:=CElement.NextElement;
    FreeAndNil(DelElement);
    end;
  FirstElement:=nil;
  end;

procedure TSklad.ClearElementSklad;
  var
    DelElement,CElement:TElementSklad;
  begin
  CElement:=FirstElement;
  While CElement<>nil do
    begin
    CElement.ClearElement;
    CElement:=CElement.NextElement;
    end;
//  FirstElement:=nil;
  end;

procedure TElementSklad.ClearElement;
  begin
//  Name:='';
  Kolvo:=0;
  TimeWaiting:=0;
  SetLength(TimeEnabled,0);
  end;

procedure TElementSklad.DecreaseElement(TimeDecrease:Double);
  var
    MinTime:Double;
    NomMin,n,i:LongWord;
  begin
  If kolvo<>0 then
    begin
    Dec(kolvo);
    n:=Length(TimeEnabled);
    NomMin:=0;
    MinTime:=TimeEnabled[NomMin];
    If n>1 then
      For i:=1 to n-1 do
        if TimeEnabled[i]<MinTime then
          begin
          MinTime:=TimeEnabled[i];
          NomMin:=i;
          end;
    TimeWaiting:=TimeWaiting+TimeDecrease-TimeEnabled[NomMin];
    If NomMin<>n-1 then
      for i:=NomMin to n-2 do
        TimeEnabled[i]:=TimeEnabled[i+1];
    SetLength(TimeEnabled,n-1);
    end;
  end;

function TSklad.SearchElement (Name:string):TElementSklad;
  var
    CurrentElement:TElementSklad;
  begin
  CurrentElement:=FirstElement;
  While (CurrentElement<>nil) and (CurrentElement.Name<>Name) do
    CurrentElement:=CurrentElement.NextElement;
  Result:=CurrentElement;
  end;

function TSklad.AddElement (Name:String; Time:Double; ElementEndModel:Boolean):TElementSklad;
  var
    NewElement:TElementSklad;
    CurrentElement,PElement:TElementSklad;
    n:Word;
  begin
  NewElement:=SearchElement(Name);
  If NewElement=nil then
    begin
    NewElement:=TElementSklad.Create;
    NewElement.Name:=Name;
    If FirstElement=nil then
      FirstElement:=NewElement
    else
      begin
      PElement:=nil;
      CurrentElement:=FirstElement;
      While (CurrentElement.NextElement<>nil) and (CurrentElement.Name<Name) do
        begin
        PElement:=CurrentElement;
        CurrentElement:=CurrentElement.NextElement;
        end;
      If CurrentElement.Name>Name then
        begin
        If PElement<>nil then
          PElement.NextElement:=NewElement
        else
          FirstElement:=NewElement;
        NewElement.NextElement:=CurrentElement;
        end
      else
        CurrentElement.NextElement:=NewElement;
      end;
    end;
  Inc(NewElement.kolvo);
  NewElement.FlagEndModel:=ElementEndModel;
  if ElementEndModel then
    NewElement.TimeEndModel:=Time;

  n:=Length(NewElement.TimeEnabled);
  SetLength(NewElement.TimeEnabled,n+1);
  NewElement.TimeEnabled[n]:=Time;

  if NameElementProcess=Name then
    begin
    n:=Length(AllTimeProcess);
    SetLength(AllTimeProcess,n+1);
    AllTimeProcess[n].TimeFailure:=Time;
    end;

  end;
end.
