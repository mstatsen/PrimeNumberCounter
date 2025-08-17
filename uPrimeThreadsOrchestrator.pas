unit uPrimeThreadsOrchestrator;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs,
  System.Generics.Collections, System.Math,
  Vcl.Forms,
  uPrimeThreadsOrchestratorState;

type
  TPrimeThreadsOrhestrator = class;

  TOnUpdateStatus = procedure(AOrchestrator: TPrimeThreadsOrhestrator) of object;

  TPrimeThreadsOrhestrator = class
  strict private
    FLockObject: TObject;
    FCurrentPrime: Integer;
    FList: TObjectList<TThread>;
    FMaxNumber: Integer;
    FResultFile: TextFile;
    FResultFileName: string;
    FState: TPrimeThreadsOrchestratorState;
    FOnUpdateStatus: TOnUpdateStatus;
    procedure EnterCriticalSection;
    procedure ExitCriticalSection;
    procedure DeleteResultFile;
    procedure DeleteThreadsFiles;
    procedure DoUpdateStatus;
    procedure InitThreads(AThreadsCount: integer);
    procedure SetMaxNumber(AMaxNumber: Integer);
    function CheckFinished: Boolean;
  public
    const MAX_THREAD_COUNT = 9;
    const INITIAL_MAX_NUMBER = 1000000;
  public
    constructor Create(AResultFileName: string);
    destructor Destroy; override;
    procedure AddNumberToResult(ANumber: Integer);
    procedure AddThread;
    procedure TerminateAll;
    procedure Start(AThreadsCount: Integer; AMaxNumber: Integer = -1);
    function CurrentPrimeIsMax: Boolean;
    function NextCurrentPrime: Integer;
    function ThreadsCount: Integer;
    property CurrentPrime: Integer read FCurrentPrime;
    property List: TObjectList<TThread> read FList;
    property ResultFileName: string read FResultFileName;
    property State: TPrimeThreadsOrchestratorState read FState;
    property OnUpdateStatus: TOnUpdateStatus read FOnUpdateStatus write FOnUpdateStatus;
  end;

implementation

uses
  uPrimeThread;

{ TPrimeThreadsOrhestrator }

procedure TPrimeThreadsOrhestrator.AddNumberToResult(ANumber: Integer);
begin
  EnterCriticalSection;

  try
    AssignFile(FResultFile, FResultFileName);

    if FileExists(FResultFileName) then
      Append(FResultFile)
    else
      Rewrite(FResultFile);

    try
      Write(FResultFile, ANumber, ' ');
    finally
      CloseFile(FResultFile);
    end;
  finally
    ExitCriticalSection;
  end;
end;

procedure TPrimeThreadsOrhestrator.AddThread;
var
  thread: TPrimeThread;
begin
  if FList.Count = MAX_THREAD_COUNT then
    Exit;

  if FState <> ptosProcessed then
    Exit;

  thread := TPrimeThread.Create(Self, FList.Count + 1);
  FList.Add(thread);
  thread.Start;
end;

function TPrimeThreadsOrhestrator.CheckFinished: Boolean;
var
  thread: TThread;
begin
  for thread in FList do
    if not thread.Finished then
      Exit(False);

  Result := True;
end;

constructor TPrimeThreadsOrhestrator.Create(AResultFileName: string);
begin
  inherited Create;
  FMaxNumber := INITIAL_MAX_NUMBER;
  FLockObject := TObject.Create;
  FList := TObjectList<TThread>.Create;
  FState :=  ptosReady;
  FResultFileName := AResultFileName;
end;


function TPrimeThreadsOrhestrator.CurrentPrimeIsMax: Boolean;
begin
  EnterCriticalSection;

  try
    Exit(
      FCurrentPrime + 1 > FMaxNumber
    );
  finally
    ExitCriticalSection;
  end;
end;

procedure TPrimeThreadsOrhestrator.DeleteResultFile;
begin
  if FileExists(FResultFileName) then
    DeleteFile(FResultFileName);
end;

procedure TPrimeThreadsOrhestrator.DeleteThreadsFiles;
var
  i: Integer;
  threadFileName: string;
begin
  for i := 1 to MAX_THREAD_COUNT do
  begin
    threadFileName := TPrimeThread.ThreadFileName(i);

    if FileExists(threadFileName) then
       DeleteFile(ThreadFileName);
  end;
end;

destructor TPrimeThreadsOrhestrator.Destroy;
begin
  FreeAndNil(FLockObject);
  FreeAndNil(FList);
  inherited;
end;

procedure TPrimeThreadsOrhestrator.InitThreads(AThreadsCount: integer);
var
  i: integer;
begin
  FList.Clear;
  DeleteThreadsFiles;

  for i := 0 to AThreadsCount - 1 do
    AddThread;
end;

function TPrimeThreadsOrhestrator.NextCurrentPrime: Integer;
begin
  EnterCriticalSection;

  try
    Inc(FCurrentPrime);
    Result := FCurrentPrime;
  finally
    ExitCriticalSection;
  end;
end;

procedure TPrimeThreadsOrhestrator.SetMaxNumber(AMaxNumber: Integer);
begin
  if AMaxNumber = -1 then
    FMaxNumber := INITIAL_MAX_NUMBER
  else FMaxNumber := AMaxNumber;
end;

procedure TPrimeThreadsOrhestrator.Start(AThreadsCount: Integer;
  AMaxNumber: Integer = -1);
begin
  if FState = ptosProcessed then
    Exit;

  DeleteResultFile;
  SetMaxNumber(AMaxNumber);
  FCurrentPrime := 1;
  FState := ptosProcessed;
  InitThreads(AThreadsCount);

   while not CheckFinished do
   begin
     Sleep(100);
     Application.ProcessMessages;
     DoUpdateStatus;
   end;

   FState := ptosFinished;
   DoUpdateStatus;
end;

procedure TPrimeThreadsOrhestrator.TerminateAll;
var
  thread: TThread;
begin
  FList.OwnsObjects := False;

  try
    for thread in FList do
    begin
      thread.Terminate;
      thread.WaitFor;
      thread.Free;
    end;
  finally
    FList.Clear;
    FList.OwnsObjects := True;
  end;
end;

function TPrimeThreadsOrhestrator.ThreadsCount: Integer;
begin
  Result := FList.Count;
end;

procedure TPrimeThreadsOrhestrator.DoUpdateStatus;
begin
  if Assigned(FOnUpdateStatus) then
    FOnUpdateStatus(Self);
end;

procedure TPrimeThreadsOrhestrator.EnterCriticalSection;
begin
  System.TMonitor.Enter(FLockObject);
end;

procedure TPrimeThreadsOrhestrator.ExitCriticalSection;
begin
  System.TMonitor.Exit(FLockObject);
end;

end.
