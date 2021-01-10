unit UObj;

interface

uses Graphics; //Модуль для отрисовки объектов

type

  //Базовый класс для организации списка
  TBaseClass = Class
    Next:TBaseClass;   //Следующий элемент списка
    PressMouse:Boolean; //Флаг нажатия на мышку
    MoveMouse:boolean;  //Флаг перемещения объекта
    Nom:byte;
    //Конструктор
    constructor creat;
    //Процедура отрисовки
    Procedure Draw(Canvas:TCanvas //Канва для вывода
                                 ); virtual; abstract;
    //Процедура выбора объекта
    procedure select(Canvas:TCanvas //Канва для вывода
                                 ); virtual; abstract;
    //Процедура попадания в объект по координатаам
    function Popad(x,y:integer  //Проверяемые координаты
                            ):boolean; virtual; abstract; //Результат проверки на попадание
    //Обработчик поднимания клавиши мышки
    procedure MouseUp; virtual; abstract;
    //Обработчик опускания клавиши мышки
    Procedure MouseDown(x,y:integer //Координаты нажатия на мышку(требуются для дуг)
                                  ); Virtual; abstract;
    //Обработчик перемещения мышки
    Procedure MouseMove(x,y:Integer //Координаты перемещения
                                  ); virtual; abstract;
    end;

  //Класс отображения вершин
  TRectan = class (TBaseClass)
    x1,y1,          //Координаты левого верхнего угла
    x2,y2:integer;  //Координаты правого нижнего угрла
    text:string;    //Название вершины (уникальный идентификатор)
    Izmrazmer:boolean;  //Флаг изменеия размера отображения вершины
    tip:byte;           //Тип отображения вершины (1-Прямоугольник 2-Круг)
    Par1:Real;          //Количество ресурса в вершине
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

  //Класс отображения дуг
  TStrelka = class (TBaseClass)
    x1,y1,          //Координаты начала дуги
    x2,y2:integer;  //Координаты конца дуги
    flag:boolean;   //Флаг выбранного конца дуги
    //Параметры отображения
    Par1,           //Длинна стрелки
    Par2:Real;      //Количество феромонов
    Par3:Word;      //Количество агентов
    StrelColor:TColor;  //Цвет стрелки
    Visible:Boolean;//Поле отрисовки стрелки
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
dr = 10; //Растояние попадания около стрелки

//Конструктор базового класса
constructor TBaseClass.creat;
  begin
  Next:=Nil;
  PressMouse:=false;
  end;

//Конструктор дуги
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

//Конструктор вершины
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

//Процедура отрисовки вершины
Procedure TRectan.Draw(Canvas:TCanvas);
  var
    TempMx,TempMy:double;  //Временные МО
    st:string;             //Временная переменная для вывода параметра вершины
  begin
  Canvas.Pen.Width:=Trunc(Par1) div 7+1; //Установка толщины границ ыершины
  If Canvas.Pen.Width>10 then Canvas.Pen.Width:=10;  //Ограничение толщины границ ыершины
  If Par1<1 then Canvas.Pen.Style:=PsDot; //Отрисовывание границ ыершины пунктиром
  If CurrentGraph.VisibleTerminals then
    Begin
    TempMx:=CurrentGraph.Mx; CurrentGraph.Mx:=1;   //Выводить прямоугольнички в одном маштабе
    TempMy:=CurrentGraph.My; CurrentGraph.My:=1;
    Canvas.Pen.Color:=RectColor;
    End;
  Case tip of    //В зависимости от типа:
    1:Canvas.Rectangle(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y1*CurrentGraph.My)-CurrentGraph.dy,
                       trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y2*CurrentGraph.My)-CurrentGraph.dy); //Прямоугольник
    2:Canvas.Ellipse(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y1*CurrentGraph.My)-CurrentGraph.dy,
                     trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,trunc(y2*CurrentGraph.My)-CurrentGraph.dy);   //Круг
    end;
  If not CurrentGraph.VisibleTerminals then
    begin
    //Вывод названия вершины графа
    Canvas.TextOut(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx+abs(trunc(x1*CurrentGraph.Mx)-trunc(x2*CurrentGraph.Mx))div 2-(length(text)*4),
                   trunc(y1*CurrentGraph.My)-CurrentGraph.dy+abs(trunc(y1*CurrentGraph.My)-trunc(y2*CurrentGraph.My))div 2-9,text);
    //Вывод значения параметра
    str(Par1:5:2,St);
    Canvas.TextOut(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx+abs(trunc(x1*CurrentGraph.Mx)-trunc(x2*CurrentGraph.Mx))div 2-15,
                   trunc(y1*CurrentGraph.My)-CurrentGraph.dy+abs(trunc(y1*CurrentGraph.My)-trunc(y2*CurrentGraph.My))div 2+4,st);
    end;
  If CurrentGraph.VisibleTerminals then
    begin
    CurrentGraph.Mx:=TempMx;       //Возврат маштаба
    CurrentGraph.My:=TempMy;
    Canvas.Pen.Color:=ClBtnFace;
    end;
  Canvas.Pen.Width:=1;           //Возврат стандартных параметров отображения
  Canvas.Pen.Style:=PsSolid;
  end;

//Процедура отрисовки дуги
Procedure TStrelka.Draw(Canvas:TCanvas);
  var
  CoG,SiG, //Косинус и синус угла наклона основной линии стрелки
  CoG15,SiG15:real;  //Косинус и синус 15 градусного отклонения от основной линии стрелки
  St:String;      //Строка для вывода значения стрелки
  begin
  With Canvas do
    If not ((Y1=Y2) and (X1=X2)) and (Visible) then   //Если начало и конец стрелки совпадают - то не отображать стрелку
    begin
    Pen.Color:=StrelColor;     //Изменение цвета отрисованной стрелки    
    Pen.Width:=Trunc(Par2) div 7+1; //Установка толщины стрелки
    If Pen.Width>7 then Pen.Width:=7;  //Ограничение толщины стрелки
    If PAr2<0.1 then Pen.Style:=PsDot; //Отрисовывание стрелки пунктиром
    MoveTo(trunc(x1*CurrentGraph.Mx)-CurrentGraph.dx,
           trunc(y1*CurrentGraph.My)-CurrentGraph.dy);  //Отрисовка основной линии стрелки
    LineTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy);
    CoG:=abs(y2*CurrentGraph.My-y1*CurrentGraph.My)/sqrt(sqr(y2*CurrentGraph.My-y1*CurrentGraph.My)+sqr(x2*CurrentGraph.Mx-x1*CurrentGraph.Mx));   //Косинус угола наклона основной линии стрелки
    SiG:=sqrt(1-sqr(CoG));   //Синус угола наклона основной линии стрелки
    If x2<x1 then            //Проверка знака синуса
      SiG:=-SiG;
    CoG15:=Cog*Cos(pi/12)+SiG*Sin(pi/12); //Вычисление косинусов и синусов 15 градусных отклонений
    If y2<y1 then
      CoG15:=-CoG15;
    SiG15:=Sqrt(1-Sqr(CoG15));
    If x2<x1 then
      SiG15:=-SiG15;
    LineTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx-trunc(25*SiG15),
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy-Trunc(25*CoG15));    //Рисование направления стрелки
    MoveTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx,
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy);      //Возврат в конец стрелки
    CoG15:=Cog*Cos(pi/12)-SiG*Sin(pi/12);   //Вычисление косинусов и синусов 15 градусных отклонений в другую сторону
    If y2<y1 then
      CoG15:=-CoG15;
    SiG15:=Sqrt(1-Sqr(CoG15));
    If x2<x1 then
      SiG15:=-SiG15;
    If COG<0 then
      SiG15:=-SiG15;
    LineTo(trunc(x2*CurrentGraph.Mx)-CurrentGraph.dx-trunc(25*SiG15),
           trunc(y2*CurrentGraph.My)-CurrentGraph.dy-Trunc(25*CoG15));   //Рисование направления стрелки
    Case CurrentGraph.vivodPar of            //Выбор отображения значения стрелки
      1:Str(Par1:5:2,st);
      2:Str(Par2:5:2,st);
      3:Str(Par3,st);
      end;
    TextOut(Abs(trunc(x2*CurrentGraph.Mx)+trunc(x1*CurrentGraph.Mx)) div 2-CurrentGraph.Dx,
            Abs(trunc(y2*CurrentGraph.My)+trunc(y1*CurrentGraph.My)) div 2-CurrentGraph.Dy,st); //Вывод значения у стрелки
    Pen.Width:=1;           //Возврат стандартных параметров отображения
    Pen.Style:=PsSolid;
    Pen.Color:=ClBtnFace;
    end;
  end;

//Процедура выбора вершины
Procedure TRectan.Select(Canvas:TCanvas);
  begin
  Canvas.Brush.Color:=ClYellow; //Изменение цвета закраски на желтый
  Draw(Canvas);                 //Отрисовка вершины
  Canvas.Brush.Color:=ClBtnFace;
  end;

//Процедура выбора дуги
Procedure TStrelka.Select(Canvas:TCanvas);
  begin
  Canvas.Pen.Color:=clYellow;  //Изменение цвета стрелки
  Canvas.Pen.Width:=3;         //Увеличение толщины стрелки
  Draw(Canvas);                //Отрисовка дуги
  Canvas.Pen.Width:=1;         //Возврат значений
  Canvas.Pen.Color:=clBlack;
  end;

//Функция попадания в область вершины
Function TRectan.Popad(x,y:integer):boolean;
  begin
  Case tip of       //Попадание в зависимости от типа отобажения вершины
    1: Popad:=(x<=x2) and (x>=x1) and (y<=y2) and (y>=y1);
    2: Popad:=(x<=x2) and (x>=x1) and (y<=(y2+y1)/2 + Sqrt(Sqr((y2-y1)/2)-Sqr(x-(x1+x2)/2))) and (y>=(y2+y1)/2 - Sqrt(Sqr((y2-y1)/2)-Sqr(x-(x1+x2)/2)));
    end;
  end;

//Функция попадания в область стрелки
Function TStrelka.Popad(x,y:integer):boolean;
  var
  k,b:real; //Коэффициенты уравнения основной линии стрелки (y=Kx+B)
  Dx,Dy:real; //Граничные смещения от стрелки
  CosAlf,SinAlf:real; //Косинус и синус угла наклона прямой
  begin
  If not ((X1=X2) and (Y1=Y2)) then begin  //Проверка на видимость стрелки
  //Косинус и синус угла наклона прямой
  CosAlf:=Abs(X2-X1)/Sqrt(Sqr(X2-X1)+Sqr(Y2-Y1));
  SinAlf:=Sqrt(1-Sqr(CosAlf));
  //Коэффициент K
  If X1<>X2 then
    k:=(y1-y2)/(x1-x2)
  else
    k:=0;
  b:=y1-k*x1;  //Коэффициент B
  Dx:=Dr*SinAlf;  //Вычисление смещений
  Dy:=Dr*CosAlf;
  If k<>0 then                                                                   //Попадание в направление стрелки
    popad:=(y>=k*x+b-Dy) and (y<=k*x+b+Dy) or (x>=(y-b)/k-Dx) and (x<=(y-b)/k+Dx)
  else
    popad:=(y>=b-Dy) and (y<=b+Dy);
  If ((X1>X2) and ((X>x1) or (X<x2))) or   //Отсечение границ стрелки вдоль направления стрелки
     ((X1<X2) and ((X<x1) or (X>x2))) or
     ((X1=X2) and (X<>x1)) or
     ((Y1>Y2) and ((Y>Y1) or (Y<Y2))) or
     ((Y1<Y2) and ((Y<Y1) or (Y>Y2))) or
     ((Y1=Y2) and (Y<>Y1)) then
    Popad:=false;
  end
  else
    Popad:=true;  //Попадание в "невидимую" стрелку
  end;

//Обработчик событя отпускания клавиши мыши на вершине
Procedure TRectan.MouseUp;
  begin
  PressMouse:=false; //Установка флагов
  MoveMouse:=False;
{  Nom:=0;   }
  end;

  //Обработчик событя отпускания клавиши мыши на дуге
Procedure Tstrelka.MouseUp;
  begin
  PressMouse:=false; //Установка флагов
  MoveMouse:=False;
  end;

//Обработчик событя нажимания клавиши мыши на вершине
Procedure TRectan.MouseDown(x,y:integer);
  begin
  PressMouse:=true;  //Установка флагов
  MoveMouse:=False;
  end;

//Обработчик событя нажимания клавиши мыши на дуге
Procedure TStrelka.MouseDown(x,y:integer);
  var
    rast1,rast2:real; //Растояния от указателя до концов стрелок
  begin
  PressMouse:=true;  //Установка флагов
  rast1:=sqrt(sqr(x-x2)+sqr(y-y2));
  rast2:=sqrt(sqr(x1-x)+sqr(y1-y));
  flag:=rast1<rast2; //Выбор перемещаемого конца стрелки
  MoveMouse:=False;
  end;

//Обработчик событя перемещения вершины
Procedure TRectan.MouseMove(x,y:integer);
  var
    nx2,nx1,ny2,ny1:integer; //Новые координаты вершины
  begin
  MoveMouse:=True;    //Установка флагов
  NX2:=x+(X2-X1) div 2;  //Определение новых координат вершины
  NY2:=Y+(Y2-Y1) div 2;
  NX1:=x-(X2-X1) div 2;
  NY1:=Y-(Y2-Y1) div 2;
  x2:=NX2;               //Установка новых координат вершины
  x1:=nx1;
  y2:=ny2;
  y1:=ny1;
  end;

//Обработчик событя перемещения дуги
Procedure Tstrelka.MouseMove(x,y:integer);
  begin
  MoveMouse:=True;  //Установка флагов
  if flag then      //В зависимости от флага
    begin
    X2:=x;          //Перемещаем конец стрелки
    Y2:=Y;
    end
  else
    begin
    X1:=x;          //Перемещаем начало стрелки
    Y1:=y;
    end;
  end;

//Функция попадания в границу отображения вершины
function TRectan.PopadRazmer(x,y:integer) //Координаты
                                :boolean; //Результат
  begin
  Result:=(abs(x-x1)<Dr) or (abs(x-x2)<Dr) or (abs(y-y1)<Dr) or (abs(y-y2)<Dr);
  end;

//Функция изменения размера отображения вершины
Procedure TRectan.IzmenenieRazmera(x,y:integer); //Координаты
  begin
  If (abs(x-x1)<Dr/2) then    //Изменеие координаты X Левого Верхнего угла
    begin
    x1:=x;
    If tip=2 then
      Y2:=Y1+X2-X1;           //Пересчет второй координаты круга
    end;
  If (abs(x-x2)<Dr/2) then    //Изменеие координаты Y Левого Верхнего угла
    begin
    x2:=x;
    If tip=2 then
      Y2:=Y1+X2-X1;           //Пересчет второй координаты круга
    end;
  If (abs(y-y1)<Dr/2) then    //Изменеие координаты X Правого Нижнего угла
    begin
    y1:=y;
    If tip=2 then
      X2:=X1+Y2-Y1;           //Пересчет второй координаты круга
    end;
  If (abs(y-y2)<Dr/2) then    //Изменеие координаты Y Правого Нижнего угла
    begin
    y2:=y;
    If tip=2 then
      X2:=X1+Y2-Y1;           //Пересчет второй координаты круга
    end;
  If X2-X1<Dr then X2:=x1+Dr*2;  //Установка минимального размера отображения
  If y2-y1<Dr then y2:=y1+Dr*2;
  end;

end.
