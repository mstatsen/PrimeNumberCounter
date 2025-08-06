unit uPrimeThreadsOrchestratorState;

interface

type
  TPrimeThreadsOrchestratorState = (
    ptosReady,
    ptosProcessed,
    ptosFinished
  );

  TPrimeThreadsOrchestratorStateHelper = class
  strict private
    const NAMES: array[TPrimeThreadsOrchestratorState] of string =
      ('Ready to start', 'Process started', 'Process finished');
  public
    class function Name(AState: TPrimeThreadsOrchestratorState): string;
  end;

implementation

{ TPrimeThreadsOrchestratorStateHelper }

class function TPrimeThreadsOrchestratorStateHelper.Name(
  AState: TPrimeThreadsOrchestratorState): string;
begin
  Exit(
    NAMES[AState]
  );
end;

end.
