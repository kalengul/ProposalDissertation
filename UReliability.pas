unit UReliability;

interface



type
TChangeReliability = class
  TypeChange:Byte;
  ParChangeMx:Double;
  Constructor Create;
  Destructor Destroy; override;
  end;

TParametersFailure = class
  Constructor Create;
  Destructor Destroy; override;
  Function GetTime (Time:Double):Double;  virtual; abstract;
  end;

TExpFailure = Class (TParametersFailure)
  La:Double;
  Constructor Create;
  Destructor Destroy;  override;
  Function GetTime (Time:Double):Double; override;
  end;

TNormalFailure = Class (TParametersFailure)
  Mx,Dx:Double;
  Constructor Create;
  Destructor Destroy; override;
  Function GetTime (Time:Double):Double; override;
  end;

implementation

Constructor TChangeReliability.Create;
  begin
    inherited;
  end;
Destructor TChangeReliability.Destroy;
  begin
    inherited;
  end;

Constructor TParametersFailure.Create;
  begin
  inherited;
  end;
Destructor TParametersFailure.Destroy;
  begin
  inherited;
  end;

Constructor TExpFailure.Create;
  begin
    inherited;
  La:=0;
  end;
Destructor TExpFailure.Destroy;
  begin
  La:=0;
  inherited;
  end;
Function TExpFailure.GetTime (Time:Double):Double;
  begin
  Randomize;
  Result:=-Ln(Random+0.00001)/(1-La);
  end;

Constructor TNormalFailure.Create;
  begin
    inherited;
  Mx:=0;
  Dx:=0
  end;
Destructor TNormalFailure.Destroy;
  begin
  Mx:=0;
  Dx:=0;
  inherited;
  end;
Function TNormalFailure.GetTime (Time:Double):Double;
  var
  X:Double;
  i:byte;
  res:double;
  begin
  x:=0;
  Randomize;
  For i:=1 to 50 do
    x:=x+random;
  Res:=Sqrt(Dx)*(X-25)+Mx-time;
  if Res<0 then
    result:=0
  else
    result:=res;
  end;

end.
