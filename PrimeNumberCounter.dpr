program PrimeNumberCounter;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {FormMain},
  uPrimeThread in 'uPrimeThread.pas',
  uPrimeNumberHelper in 'uPrimeNumberHelper.pas',
  uPrimeThreadsOrchestrator in 'uPrimeThreadsOrchestrator.pas',
  uPrimeThreadsOrchestratorState in 'uPrimeThreadsOrchestratorState.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
