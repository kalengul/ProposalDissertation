unit UDistributions;

interface

function RandomExponent(ex: Extended): Extended;

implementation

function RandomExponent(ex: Extended): Extended;
{ ���������������� ������������� }
begin
  Result := -ex * Ln(Random)
end;

end.
 