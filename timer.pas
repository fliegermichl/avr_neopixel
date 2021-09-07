unit timer;

(* Implements an pascal version of the Arduino micros() and millis() functions.
   At the time of writing this, only ATMega328P with 16MHz supported!
   fliegermichl (www.lazarusforum.de) 2021
*)

interface
type
  TArduino_TimerFlag = (tfMicrosTimerRunning, tfMillisTimerRunning);
  TArduino_TimerFlags = set of TArduino_TimerFlag;

function micros : dword;  // At 16MHz this value overruns nearly every 70 seconds
function millis : dword;
procedure start_micros_timer;
procedure stop_micros_timer;

const
  Arduino_TimerFlags : TArduino_TimerFlags = [];

implementation
uses intrinsics;
const lastmicros : dword = 0;
      lastMillis : dword = 0;
      lastmillisRest : smallint = 0;  // wird alle 1024 Mikrosekunden um 24 hochgezählt

function micros: dword;
begin
  if (not (tfMicrosTimerRunning in Arduino_TimerFlags)) then
  begin
    start_micros_timer();
  end;
  Result := lastmicros + TCNT0 * 4;
end;

function millis: dword;
begin
  if (not (tfMillisTimerRunning in Arduino_TimerFlags)) then
  begin
    Include(Arduino_TimerFlags, tfMillisTimerRunning);
    if (not (tfMicrosTimerRunning in Arduino_TimerFlags)) then
      start_micros_timer();
  end;
  Result := lastMillis;
end;

procedure start_micros_timer;
begin
  asm cli end; // Disable Interrupts
  Include(Arduino_TimerFlags, tfMicrosTimerRunning);
  TCCR0A := 0; // normaler Timermodus
  TCNT0  := 0; // Timer auf 0 setzen
  TIMSK0 := 1; // TIMSK := (1 shl TOIE0); Interrupt, wenn Timer0 überläuft
  TCCR0B := 3; // Bits CS01 und CS00 setzen TCCR0B := (1 shl CS01) or (1 shl CS00); = Timer wird alle 64 Takte erhöht = 4 us
               // Dies startet den Timer auch
  asm sei end; // Enable Interrupts
end;

procedure stop_micros_timer;
begin
  TCCR0B := 0; // Kein Prescaler, kein Timer
end;

procedure Timer0Interrupt; public Name 'TIMER0_OVF_ISR'; Interrupt;
var SREG : Byte;
begin
  SREG := avr_save();
  lastmicros += 1024; // 256 * 4
  if (tfMillisTimerRunning in Arduino_TimerFlags) then
  begin
    inc(lastMillis);
    inc(lastMillisRest, 24);
    if (lastMillisRest > 1000) then
    begin
      inc(LastMillis);
      LastMillisRest := LastMillisRest - 1000;
    end;
  end;
  avr_restore(SREG);
end;

end.

