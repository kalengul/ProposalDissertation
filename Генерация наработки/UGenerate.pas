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
Writeln(f,'�����������������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �1@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �1@->@�������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �1@->@���� ������ ������� 5377�@:'+IntToStr(random(61320))+'@'+IntToStr(Random(8760))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �1@->@������ 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �2@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �2@->@�������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �2@->@���� ������ ������� 5377�@:'+IntToStr(random(61320))+'@'+IntToStr(Random(8760))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �2@->@������ 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@�������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���� ������ ������� 5377�@:'+IntToStr(random(61320))+'@'+IntToStr(Random(8760))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@������ �1 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@������ �2 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���@->@������� ���������� ���@:'+IntToStr(Random(52560))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���@->@�������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���@->@������ ��� ����������� ��������� ������������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���@->@������ ��� ����������� ��������� ������������@->@������ 4672@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@�������� �������@->@��������� �3@->@���@->@������ 5102@:'+IntToStr(Random(8760))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@��������������� ���� ����������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@��������������� ���� ����������@->@��������� ��� 4487�@:'+IntToStr(Random(39420))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@��������������� ���� ����������@->@�������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@��������������� ���� ����������@->@�������@->@�������� ��� ���������� ��������� 5670@:'+IntToStr(Random(21900))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@��������������� ���� ����������@->@�������@->@��������� 4463��-41@:'+IntToStr(Random(17520))+'@'+IntToStr(Random(1500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �1@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �1@->@���� ������� 4602@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �1@->@��������� ����������� �������� 4561@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �1@->@��������� ������ ���� 5701�-01@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �1@->@����������� �������� 5701�-02@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �1@->@������ 4672@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �2@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �2@->@���� ������� 4602@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �2@->@��������� ����������� �������� 4561@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �2@->@��������� ������ ���� 5701�-01@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �2@->@����������� �������� 5701�-02@:'+IntToStr(Random(35040))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@���� �2@->@������ 4672@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@��������� ����������� �������� ��� 5606�-1@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(4500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@��������� � ������ �����������@:'+IntToStr(Random(27520))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@������ 4477@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(3700))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@�������� �1 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@�������� �2 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@��������� ��� 4458@:'+IntToStr(Random(39420))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@���������������@:'+IntToStr(Random(87600))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@����������������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@����������������@->@����������@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@����������������@->@��������� �������@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@���������������@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@����� ���� ����������@->@���-56-1@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(4600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@��������� ����������� �������� ��� 5606�-1@:'+IntToStr(Random(43800))+'@'+IntToStr(Random(4500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@��������� � ������ �����������@:'+IntToStr(Random(27520))+'@'+IntToStr(Random(2500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@������ 4477@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(3700))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@�������� �1 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@�������� �2 5670@:'+IntToStr(Random(26280))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@��������� ��� 4458@:'+IntToStr(Random(39420))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@���������������@:'+IntToStr(Random(87600))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@����������������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@����������������@->@����������@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@����������������@->@��������� �������@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(4000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@���������������@:'+IntToStr(Random(87600))+'@'+IntToStr(Random(3500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@������ ���� ����������@->@���-56-1@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(4600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@����������@->@�����@:'+IntToStr(Random(14400))+'@'+IntToStr(Random(6000))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@��������� ����@:'+IntToStr(Random(87600))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� ������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� ������@->@���������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� ������@->@��������������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� ������@->@���-56-2@:'+IntToStr(Random(30660))+'@'+IntToStr(Random(5600))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �1@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �1@->@���������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �1@->@��������������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �1@->@���-56-2@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@:'+IntToStr(r1)+'@'+IntToStr(r2)+'@'+IntToStr(r3)+'@'+IntToStr(r4)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���-56-2@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���������� �1@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���������� �1@->@���������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���������� �1@->@��������������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���������� �2@:'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+IntToStr(500)+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���������� �2@->@���������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(5500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ���������� �������@->@����� �2@->@���������� �2@->@��������������@:'+IntToStr(Random(52560))+'@'+IntToStr(Random(6500))+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
Writeln(f,'�����������������@->@������� ����������@:'+IntToStr(Random(30660))+'@'+IntToStr(0)+'@'+IntToStr(Random(500))+'@'+IntToStr(Random(500))+'@'+'0@0@1@');
  CloseFile(f);
  end;
end;

end.
