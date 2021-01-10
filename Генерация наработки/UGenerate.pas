unit UGenerate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    BtStart: TButton;
    OdLoad: TOpenDialog;
    procedure BtStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BtStartClick(Sender: TObject);
var
  f:TextFile;
  r1,r2,r3,r4:LongWord;
begin
If OdLoad.Execute then
  begin
  AssignFile(f,OdLoad.FileName);
  Rewrite(f);
  Randomize;
  R1:=Random(175200)+17520;
  R2:=Random(26280)+8760;
  R3:=Random(26280);
  R4:=Random(4350);
Writeln(f,'Кондиционирование@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №1@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №1@->@Агрегат@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №1@->@Кран отбора воздуха 5377Т@:'+IntToStr(random(61320))+'@'+IntToStr(Random(8760))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №1@->@Клапан 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №2@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №2@->@Агрегат@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №2@->@Кран отбора воздуха 5377Т@:'+IntToStr(random(61320))+'@'+IntToStr(Random(8760))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №2@->@Клапан 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@Агрегат@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@Кран отбора воздуха 5377Т@:'+IntToStr(random(61320))+'@'+IntToStr(Random(8760))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@Клапан №1 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@Клапан №2 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@ВСУ@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@ВСУ@->@Система охлаждения ВСУ@:'+IntToStr(Random(52560))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@ВСУ@->@Агрегат@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@ВСУ@->@Штуцер для подключения наземного кондиционера@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@ВСУ@->@Штуцер для подключения наземного кондиционера@->@Клапан 4672@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Источник воздуха@->@Двигатель №3@->@ВСУ@->@Клапан 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Предварительный узел охлаждения@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Предварительный узел охлаждения@->@Первичный ВВР 4487Т@:'+IntToStr(Random(39420))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Предварительный узел охлаждения@->@Эжектор@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Предварительный узел охлаждения@->@Эжектор@->@Заслонка для управления эжектором 5670@:'+IntToStr(Random(21900))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Предварительный узел охлаждения@->@Эжектор@->@Термореле 4463АТ-41@:'+IntToStr(Random(17520))+'@'+IntToStr(Random(1500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №1@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №1@->@Кран наддува 4602@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №1@->@Регулятор избыточного давления 4561@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №1@->@Командный прибор ПСВП 5701Т-01@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №1@->@Дроссельная заслонка 5701Т-02@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №1@->@Клапан 4672@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №2@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №2@->@Кран наддува 4602@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №2@->@Регулятор избыточного давления 4561@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №2@->@Командный прибор ПСВП 5701Т-01@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №2@->@Дроссельная заслонка 5701Т-02@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Магистрали@->@ПСВП №2@->@Клапан 4672@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Регулятор избыточного давления РИД 5606Т-1@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(4500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Термореле и датчик температуры@:'+IntToStr(Random(27520))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Клапан 4477@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(3700))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Заслонка №1 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Заслонка №2 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Вторичный ВВР 4458@:'+IntToStr(Random(39420))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Воздухозаборник@:'+IntToStr(Random(87600))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Турбохолодильник@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Турбохолодильник@->@Компрессор@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Турбохолодильник@->@Маслянная система@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@Влагоотделитель@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Левый узел охлаждения@->@АРТ-56-1@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(4600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Регулятор избыточного давления РИД 5606Т-1@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(4500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Термореле и датчик температуры@:'+IntToStr(Random(27520))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Клапан 4477@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(3700))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Заслонка №1 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Заслонка №2 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Вторичный ВВР 4458@:'+IntToStr(Random(39420))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Воздухозаборник@:'+IntToStr(Random(87600))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Турбохолодильник@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Турбохолодильник@->@Компрессор@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Турбохолодильник@->@Маслянная система@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@Влагоотделитель@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Правый узел охлаждения@->@АРТ-56-1@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(4600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Охладитель@->@Масло@:'+IntToStr(Random(14400))+'@'+IntToStr(Random(6000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Глушитель шума@:'+IntToStr(Random(87600))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции кабины@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции кабины@->@Смеситель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции кабины@->@Распределитель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции кабины@->@АРТ-56-2@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №1@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №1@->@Смеситель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №1@->@Распределитель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №1@->@АРТ-56-2@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@АРТ-56-2@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@Магистраль №1@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@Магистраль №1@->@Смеситель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@Магистраль №1@->@Распределитель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@Магистраль №2@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@Магистраль №2@->@Смеситель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система вентиляции салонов@->@Салон №2@->@Магистраль №2@->@Распределитель@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'Кондиционирование@->@Система управления@:'+IntToStr(Random(30660))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
  CloseFile(f);
  end;
end;

end.
