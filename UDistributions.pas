unit UDistributions;

interface

function RandomExponent(ex: Extended): Extended;

implementation

function RandomExponent(ex: Extended): Extended;
{ экспоненциальное распределение }
begin
  Result := -ex * Ln(Random)
end;

end.
 