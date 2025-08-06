unit uPrimeThread;

interface

uses
  System.Classes, System.SysUtils,
  uPrimeNumberHelper,
  uPrimeThreadsOrchestrator;

type
  TPrimeThread = class(TThread)
  strict private
    FOrchestrator: TPrimeThreadsOrhestrator;
    FThreadIndex: Integer;
    function ThreadFileName: string; overload;
  protected
    procedure Execute; override;
  public
    constructor Create(AOrchestrator: TPrimeThreadsOrhestrator;
      AThreadIndex: Integer);
    class function ThreadFileName(AThreadIndex: Integer): string; overload;
    property ThreadIndex: Integer read FThreadIndex;
  end;

implementation

constructor TPrimeThread.Create(AOrchestrator: TPrimeThreadsOrhestrator;
  AThreadIndex: Integer);
begin
  inherited Create(True);
  FOrchestrator := AOrchestrator;
  FThreadIndex := AThreadIndex;
  FreeOnTerminate := False;
end;

procedure TPrimeThread.Execute;
var
  number: Integer;
  numberList: TStringList;
begin
  numberList := TStringList.Create;

  try
    while True do
    begin
      if FOrchestrator.CurrentPrimeIsMax then
        Break;

      number := FOrchestrator.NextCurrentPrime;

      if not TPrimeNumberHelper.IsPrime(number) then
        Continue;

      FOrchestrator.AddNumberToResult(number);
      numberList.Add(IntToStr(number));
    end;

    numberList.Text := StringReplace(numberList.Text, sLineBreak, ' ', [rfReplaceAll]);
    numberList.SaveToFile(ThreadFileName);
  finally
    numberList.Free;
  end;
end;

class function TPrimeThread.ThreadFileName(AThreadIndex: Integer): string;
begin
  Result := Format('Thread%d.txt', [AThreadIndex]);
end;

function TPrimeThread.ThreadFileName: string;
begin
  Result := ThreadFileName(FThreadIndex);
end;

end.
