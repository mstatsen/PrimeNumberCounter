unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uPrimeThreadsOrchestrator,
  uPrimeThreadsOrchestratorState, Vcl.NumberBox;

type
  TFormMain = class(TForm)
    mStatus: TMemo;
    pnlButtons: TPanel;
    btnStart: TButton;
    btnAddThread: TButton;
    edNumber: TNumberBox;
    lNumber: TLabel;
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddThreadClick(Sender: TObject);
  strict private
    const RESULT_FILE_NAME = 'Result.txt';
    const INITIAL_THREADS_COUNT = 2;
  strict private
    FThreadsOrchestrator: TPrimeThreadsOrhestrator;
    FCurrentPrimeLineIndex: Integer;
    procedure OnUpdateOrchestratorStatusHandler(AOrchestrotor: TPrimeThreadsOrhestrator);
    procedure Start;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.btnStartClick(Sender: TObject);
begin
  Start;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FThreadsOrchestrator := TPrimeThreadsOrhestrator.Create(RESULT_FILE_NAME);
  FThreadsOrchestrator.OnUpdateStatus := OnUpdateOrchestratorStatusHandler;
  edNumber.ValueInt := TPrimeThreadsOrhestrator.INITIAL_MAX_NUMBER;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FThreadsOrchestrator.TerminateAll;
  FreeAndNil(FThreadsOrchestrator);
end;

procedure TFormMain.OnUpdateOrchestratorStatusHandler(
  AOrchestrotor: TPrimeThreadsOrhestrator);
const
  STR_STARTED = 'Process started with %d threads';
  STR_NUMBERS_PROCESSED = '%d numbers processed';
begin
  if mStatus.Lines.Count = 0 then
    mStatus.Lines.Add(
      Format(STR_STARTED, [AOrchestrotor.ThreadsCount])
    );

  case AOrchestrotor.State of
    ptosProcessed:
    begin
      if FCurrentPrimeLineIndex = -1 then
        FCurrentPrimeLineIndex := mStatus.Lines.Add(string.Empty);

      mStatus.Lines[FCurrentPrimeLineIndex] := Format(
        STR_NUMBERS_PROCESSED,
        [AOrchestrotor.CurrentPrime - 1]
      );
    end;
    ptosFinished:
    begin
      mStatus.Lines.Add(
        TPrimeThreadsOrchestratorStateHelper.Name(AOrchestrotor.State)
      );

      edNumber.ReadOnly := False;
      btnStart.Enabled := True;
      btnAddThread.Enabled := False;
    end;
  end;
end;

procedure TFormMain.btnAddThreadClick(Sender: TObject);
const
  STR_THREAD_ADDED = 'Thread %d added';
begin
  if FThreadsOrchestrator.State <> ptosProcessed then
    Exit;

  FThreadsOrchestrator.AddThread;
  mStatus.Lines.Add(
    Format(
      STR_THREAD_ADDED,
      [FThreadsOrchestrator.ThreadsCount]
    )
  );

  if FThreadsOrchestrator.ThreadsCount = TPrimeThreadsOrhestrator.MAX_THREAD_COUNT then
    btnAddThread.Enabled := False;
end;

procedure TFormMain.Start;
begin
  edNumber.ReadOnly := True;
  btnStart.Enabled := False;
  btnAddThread.Enabled := True;
  mStatus.Clear;
  FCurrentPrimeLineIndex := -1;
  FThreadsOrchestrator.Start(INITIAL_THREADS_COUNT, edNumber.ValueInt);
end;

end.
