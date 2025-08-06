unit uPrimeNumberHelper;

interface

type
  TPrimeNumberHelper = class
  public
    class function IsPrime(ANumber: Integer): Boolean;
  end;

implementation

{ TPrimeNumberHelper }

class function TPrimeNumberHelper.IsPrime(ANumber: Integer): Boolean;
var
  i: Integer;
begin
  if ANumber < 2 then
    Exit(False);

  if ANumber = 2 then
    Exit(True);

  if ANumber mod 2 = 0 then
    Exit(False);

  for i := 3 to Trunc(Sqrt(ANumber)) do
    if ANumber mod i = 0 then
      Exit(False);

  Result := True;
end;

end.
