unit UObj;

interface

uses Graphics; //������ ��� ��������� ��������

type

  //������� ����� ��� ����������� ������
  TBaseClass = Class
    Next:TBaseClass;   //��������� ������� ������
    PressMouse:Boolean; //���� ������� �� �����
    MoveMouse:boolean;  //���� ����������� �������
    Nom:byte;
    //�����������
    constructor creat;
    //��������� ���������
    Procedure Draw(Canvas:TCanvas //����� ��� ������
                                 ); virtual; abstract;
    //��������� ������ �������
    procedure select(Canvas:TCanvas //����� ��� ������
                                 ); virtual; abstract;
    //��������� ��������� � ������ �� ������������
    function Popad(x,y:integer  //����������� ����������
                            ):boolean; virtual; abstract; //��������� �������� �� ���������
    //���������� ���������� ������� �����
    procedure MouseUp; virtual; abstract;
    //���������� ��������� ������� �����
    Procedure MouseDown(x,y:integer //���������� ������� �� �����(��������� ��� ���)
                                  ); Virtual; abstract;
    //���������� ����������� �����
    Procedure MouseMove(x,y:Integer //���������� �����������
                                  ); virtual; abstract;
    end;

  //����� ����������� ������
  TRectan = class (TBaseClass)
    x1,y1,          //���������� ������ �������� ����
    x2,y2:integer;  //���������� ������� ������� �����
    text:string;    //�������� ������� (���������� �������������)
    Izmrazmer:boolean;  //���� �������� ������� ����������� �������
    tip:byte;           //��� ����������� ������� (1-������������� 2-����)
    Par1:Real;          //���������� ������� � �������
    RectColor:TColor;
    constructor creat;
    Procedure Draw(Canvas:TCanvas); Override;
    Procedure Select(Canvas:TCanvas); Override;
    Function Popad(x,y:integer):boolean; Override;
    procedure MouseUp; Override;
    Procedure MouseDown(x,y:integer); Override;
    Procedure MouseMove(x,y:Integer); override;
    function PopadRazmer(x,y:integer):boolean;
    Procedure IzmenenieRazmera(x,y:integer);
    end;

  //����� ����������� ���
  TStrelka = class (TBaseClass)
    x1,y1,          //���������� ������ ����
    x2,y2:integer;  //���������� ����� ����
    flag:boolean;   //���� ���������� ����� ����
    //��������� �����������
    Par1,           //������ �������
    Par2:Real;      //���������� ���������
    Par3:Word;      //���������� �������
    StrelColor:TColor;  //���� �������
    Visible:Boolean;//���� ��������� �������
    constructor creat;
    Procedure Draw(Canvas:TCanvas); Override;
    Procedure Select(Canvas:TCanvas); Override;
    Function Popad(x,y:integer):boolean; Override;
    procedure MouseUp; Override;
    Procedure MouseDown(x,y:integer); Override;
    Procedure MouseMove(x,y:Integer); override;
    end;

implementation

Uses UAgent;

Const
dr = 10; //��������� ��������� ����� �������

//����������� �������� ������
constructor TBaseClass.creat;
  begin
  Next:=Nil;
  PressMouse:=false;
  end;

//����������� ����
constructor TStrelka.creat;
  begin
  x1:=0;
  x2:=0;
  y1:=0;
  y2:=0;
  Nom:=0;
  Par1:=0;
  Par2:=1;
  Par3:=0;
  flag:=true;
  StrelColor:=ClBlack;
  Visible:=true;
  end;

//����������� �������
constructor TRectan.creat;
  begin
  x1:=0;
  x2:=0;
  y1:=0;
  y2:=0;
  Par1:=0;
  Nom:=0;
  Tip:=1;
  text:='';
  RectColor:=ClBlack;
  end;

//��������� ��������� �������
Procedure TRectan.Draw(Canvas:TCanvas);
  var
    TempMx,TempMy:double;  //��������� ��
    st:string;             //��������� ���������� ��� ������ ��������� �������
  begin
  Canvas.Pen.Width:=Trunc(Par1) div 7+1; //��������� ������� ������ �������
  If Canvas.Pen.Width>10 then Canvas.Pen.Width:=10;  //����������� ������� ������ �������
  If Par1<1 then Canvas.Pen.Style:=PsDot; //������������� ������ ������� ���������
  If CurrentGraph.VisibleTerminals then
    Begin
    TempMx:=CurrentGraph.Mx; CurrentGraph.Mx:=1;   //�������� ��������������� � ����� �������
    TempMy:=CurrentGraph.My; CurrentGraph.My:=1;
    Canvas.Pen.Color:=RectColor;
    End;
  Case tip of    //� ����������� �� ����:
    1:Canvas.Rectangle(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y1*CurrentGraph.My)-CurrentGraph.dy,
                       trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y2*CurrentGraph.My)-CurrentGraph.dy); //�������������
    2:Canvas.Ellipse(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y1*CurrentGraph.My)-CurrentGraph.dy,
                     trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y2*CurrentGraph.My)-CurrentGraph.dy);   //����
    end;
  If not CurrentGraph.VisibleTerminals then
    begin
    //����� �������� ������� �����
    Canvas.TextOut(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx+abs(trunc(x1*CurrentGraph.Mx)-trunc(x2*CurrentGraph.Mx))div 2-(length(text)*4),
                   trunc(y1*CurrentGraph.My)-CurrentGraph.dy+abs(trunc(y1*CurrentGraph.My)-trunc(y2*CurrentGraph.My))div 2-9,text);
    //����� �������� ���������
    str(Par1:5:2,St);
    Canvas.TextOut(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx+abs(trunc(x1*CurrentGraph.Mx)-trunc(x2*CurrentGraph.Mx))div 2-15,
                   trunc(y1*CurrentGraph.My)-CurrentGraph.dy+abs(trunc(y1*CurrentGraph.My)-trunc(y2*CurrentGraph.My))div 2+4,st);
    end;
  If CurrentGraph.VisibleTerminals then
    begin
    CurrentGraph.Mx:=TempMx;       //������� �������
    CurrentGraph.My:=TempMy;
    Canvas.Pen.Color:=ClBtnFace;
    end;
  Canvas.Pen.Width:=1;           //������� ����������� ���������� �����������
  Canvas.Pen.Style:=PsSolid;
  end;

//��������� ��������� ����
Procedure TStrelka.Draw(Canvas:TCanvas);
  var
  CoG,SiG, //������� � ����� ���� ������� �������� ����� �������
  CoG15,SiG15:real;  //������� � ����� 15 ���������� ���������� �� �������� ����� �������
  St:String;      //������ ��� ������ �������� �������
  begin
  With Canvas do
    If not ((Y1=Y2) and (X1=X2)) and (Visible) then   //���� ������ � ����� ������� ��������� - �� �� ���������� �������
    begin
    Pen.Color:=StrelColor;     //��������� ����� ������������ �������    
    Pen.Width:=Trunc(Par2) div 7+1; //��������� ������� �������
    If Pen.Width>7 then Pen.Width:=7;  //����������� ������� �������
    If PAr2<0.1 then Pen.Style:=PsDot; //������������� ������� ���������
    MoveTo(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx,
           trunc(y1*CurrentGraph.My)-CurrentGraph.dy);  //��������� �������� ����� �������
    LineTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy);
    CoG:=abs(y2*CurrentGraph.My-y1*CurrentGraph.My)/sqrt(sqr(y2*CurrentGraph.My-y1*CurrentGraph.My)+sqr(x2*CurrentGraph.Mx-x1*CurrentGraph.Mx));   //������� ����� ������� �������� ����� �������
    SiG:=sqrt(1-sqr(CoG));   //����� ����� ������� �������� ����� �������
    If x2<x1 then            //�������� ����� ������
      SiG:=-SiG;
    CoG15:=Cog*Cos(pi/12)+SiG*Sin(pi/12); //���������� ��������� � ������� 15 ��������� ����������
    If y2<y1 then
      CoG15:=-CoG15;
    SiG15:=Sqrt(1-Sqr(CoG15));
    If x2<x1 then
      SiG15:=-SiG15;
    LineTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx-trunc(25*SiG15),
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy-Trunc(25*CoG15));    //��������� ����������� �������
    MoveTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy);      //������� � ����� �������
    CoG15:=Cog*Cos(pi/12)-SiG*Sin(pi/12);   //���������� ��������� � ������� 15 ��������� ���������� � ������ �������
    If y2<y1 then
      CoG15:=-CoG15;
    SiG15:=Sqrt(1-Sqr(CoG15));
    If x2<x1 then
      SiG15:=-SiG15;
    If COG<0 then
      SiG15:=-SiG15;
    LineTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx-trunc(25*SiG15),
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy-Trunc(25*CoG15));   //��������� ����������� �������
    Case CurrentGraph.vivodPar of            //����� ����������� �������� �������
      1:Str(Par1:5:2,st);
      2:Str(Par2:5:2,st);
      3:Str(Par3,st);
      end;
    TextOut(Abs(trunc(x2*CurrentGraph.Mx)+trunc(x1*CurrentGraph.Mx)) div 2-CurrentGraph.Dx,
            Abs(trunc(y2*CurrentGraph.My)+trunc(y1*CurrentGraph.My)) div 2-CurrentGraph.Dy,st); //����� �������� � �������
    Pen.Width:=1;           //������� ����������� ���������� �����������
    Pen.Style:=PsSolid;
    Pen.Color:=ClBtnFace;
    end;
  end;

//��������� ������ �������
Procedure TRectan.Select(Canvas:TCanvas);
  begin
  Canvas.Brush.Color:=ClYellow; //��������� ����� �������� �� ������
  Draw(Canvas);                 //��������� �������
  Canvas.Brush.Color:=ClBtnFace;
  end;

//��������� ������ ����
Procedure TStrelka.Select(Canvas:TCanvas);
  begin
  Canvas.Pen.Color:=clYellow;  //��������� ����� �������
  Canvas.Pen.Width:=3;         //���������� ������� �������
  Draw(Canvas);                //��������� ����
  Canvas.Pen.Width:=1;         //������� ��������
  Canvas.Pen.Color:=clBlack;
  end;

//������� ��������� � ������� �������
Function TRectan.Popad(x,y:integer):boolean;
  begin
  Case tip of       //��������� � ����������� �� ���� ���������� �������
    1: Popad:=(x<=x2) and (x>=x1) and (y<=y2) and (y>=y1);
    2: Popad:=(x<=x2) and (x>=x1) and (y<=(y2+y1)/2 + Sqrt(Sqr((y2-y1)/2)-Sqr(x-(x1+x2)/2))) and (y>=(y2+y1)/2 - Sqrt(Sqr((y2-y1)/2)-Sqr(x-(x1+x2)/2)));
    end;
  end;

//������� ��������� � ������� �������
Function TStrelka.Popad(x,y:integer):boolean;
  var
  k,b:real; //������������ ��������� �������� ����� ������� (y=Kx+B)
  Dx,Dy:real; //��������� �������� �� �������
  CosAlf,SinAlf:real; //������� � ����� ���� ������� ������
  begin
  If not ((X1=X2) and (Y1=Y2)) then begin  //�������� �� ��������� �������
  //������� � ����� ���� ������� ������
  CosAlf:=Abs(X2-X1)/Sqrt(Sqr(X2-X1)+Sqr(Y2-Y1));
  SinAlf:=Sqrt(1-Sqr(CosAlf));
  //����������� K
  If X1<>X2 then
    k:=(y1-y2)/(x1-x2)
  else
    k:=0;
  b:=y1-k*x1;  //����������� B
  Dx:=Dr*SinAlf;  //���������� ��������
  Dy:=Dr*CosAlf;
  If k<>0 then                                                                   //��������� � ����������� �������
    popad:=(y>=k*x+b-Dy) and (y<=k*x+b+Dy) or (x>=(y-b)/k-Dx) and (x<=(y-b)/k+Dx)
  else
    popad:=(y>=b-Dy) and (y<=b+Dy);
  If ((X1>X2) and ((X>x1) or (X<x2))) or   //��������� ������ ������� ����� ����������� �������
     ((X1<X2) and ((X<x1) or (X>x2))) or
     ((X1=X2) and (X<>x1)) or
     ((Y1>Y2) and ((Y>Y1) or (Y<Y2))) or
     ((Y1<Y2) and ((Y<Y1) or (Y>Y2))) or
     ((Y1=Y2) and (Y<>Y1)) then
    Popad:=false;
  end
  else
    Popad:=true;  //��������� � "���������" �������
  end;

//���������� ������ ���������� ������� ���� �� �������
Procedure TRectan.MouseUp;
  begin
  PressMouse:=false; //��������� ������
  MoveMouse:=False;
{  Nom:=0;   }
  end;

  //���������� ������ ���������� ������� ���� �� ����
Procedure Tstrelka.MouseUp;
  begin
  PressMouse:=false; //��������� ������
  MoveMouse:=False;
  end;

//���������� ������ ��������� ������� ���� �� �������
Procedure TRectan.MouseDown(x,y:integer);
  begin
  PressMouse:=true;  //��������� ������
  MoveMouse:=False;
  end;

//���������� ������ ��������� ������� ���� �� ����
Procedure TStrelka.MouseDown(x,y:integer);
  var
    rast1,rast2:real; //��������� �� ��������� �� ������ �������
  begin
  PressMouse:=true;  //��������� ������
  rast1:=sqrt(sqr(x-x2)+sqr(y-y2));
  rast2:=sqrt(sqr(x1-x)+sqr(y1-y));
  flag:=rast1<rast2; //����� ������������� ����� �������
  MoveMouse:=False;
  end;

//���������� ������ ����������� �������
Procedure TRectan.MouseMove(x,y:integer);
  var
    nx2,nx1,ny2,ny1:integer; //����� ���������� �������
  begin
  MoveMouse:=True;    //��������� ������
  NX2:=x+(X2-X1) div 2;  //����������� ����� ��������� �������
  NY2:=Y+(Y2-Y1) div 2;
  NX1:=x-(X2-X1) div 2;
  NY1:=Y-(Y2-Y1) div 2;
  x2:=NX2;               //��������� ����� ��������� �������
  x1:=nx1;
  y2:=ny2;
  y1:=ny1;
  end;

//���������� ������ ����������� ����
Procedure Tstrelka.MouseMove(x,y:integer);
  begin
  MoveMouse:=True;  //��������� ������
  if flag then      //� ����������� �� �����
    begin
    X2:=x;          //���������� ����� �������
    Y2:=Y;
    end
  else
    begin
    X1:=x;          //���������� ������ �������
    Y1:=y;
    end;
  end;

//������� ��������� � ������� ����������� �������
function TRectan.PopadRazmer(x,y:integer) //����������
                                :boolean; //���������
  begin
  Result:=(abs(x-x1)<Dr) or (abs(x-x2)<Dr) or (abs(y-y1)<Dr) or (abs(y-y2)<Dr);
  end;

//������� ��������� ������� ����������� �������
Procedure TRectan.IzmenenieRazmera(x,y:integer); //����������
  begin
  If (abs(x-x1)<Dr/2) then    //�������� ���������� X ������ �������� ����
    begin
    x1:=x;
    If tip=2 then
      Y2:=Y1+X2-X1;           //�������� ������ ���������� �����
    end;
  If (abs(x-x2)<Dr/2) then    //�������� ���������� Y ������ �������� ����
    begin
    x2:=x;
    If tip=2 then
      Y2:=Y1+X2-X1;           //�������� ������ ���������� �����
    end;
  If (abs(y-y1)<Dr/2) then    //�������� ���������� X ������� ������� ����
    begin
    y1:=y;
    If tip=2 then
      X2:=X1+Y2-Y1;           //�������� ������ ���������� �����
    end;
  If (abs(y-y2)<Dr/2) then    //�������� ���������� Y ������� ������� ����
    begin
    y2:=y;
    If tip=2 then
      X2:=X1+Y2-Y1;           //�������� ������ ���������� �����
    end;
  If X2-X1<Dr then X2:=x1+Dr*2;  //��������� ������������ ������� �����������
  If y2-y1<Dr then y2:=y1+Dr*2;
  end;

end.
