unit arduino;
{$PACKENUM 1}
interface
type
  TPinMode = (INPUT, OUTPUT); // input = 0, output = 1
  TPinState = (LOW, HIGH);    // low = 0, high = 1
const
  NOT_A_PIN = -1;
  BUILDIN_LED = 13;

procedure pinMode(pin : byte; Mode : TPinMode);
procedure digitalWrite(pin: byte; value : TPinState);
function  digitalRead(pin : byte) : TPinState;
function  digitalReadPort(pin : byte) : Byte;
function  digitalPinToPort(pin : int16) : Pbyte;
function  digitalPinToInput(pin : byte) : PByte;
function  digitalPinToBitmask(pin : byte) : byte;
function  digitalPinToDDR(pin : byte) : Pbyte;
function  pgm_read_byte(addr : PByte) : byte;
function  pgm_read_word(addr : PByte) : word;
procedure pgm_copy_string(addr, buffer : PChar);
procedure delay_us(us : dword);
procedure delay(ms : dword);
//procedure disable_Interrupts;
//procedure enable_Interrupts;

//function  portOutputRegister(digitalPinToPort(p));

const
  INTERN_LED = 13;
{$IFNDEF F_CPU}
 {$ERROR F_CPU not defined}
{$ENDIF}
  _millis = F_CPU div 1000;
implementation
uses timer;

procedure pinMode(pin : byte; Mode : TPinMode);
var ddr : byte;
begin
 ddr := digitalPinToBitMask(pin);
 if Mode = INPUT then
   digitalPinToddr(pin)^ := digitalPinToddr(pin)^ and not ddr
 else
   digitalPinToddr(pin)^ := digitalPinToddr(pin)^ or ddr;
end;

procedure digitalWrite(pin: byte; value: TPinState);
var Port: PByte;
    PinMask : byte;
begin
 Port := digitalPinToPort(pin);
 PinMask := digitalPinToBitMask(pin);
 if value = LOW then
   port^ := port^ and not PinMask
 else
   port^ := port^ or PinMask;
end;

function digitalRead(pin: byte): TPinState;
var PinMask : Byte;
begin
 PinMask := digitalPinToBitMask(pin);
 if (digitalReadPort(pin) and PinMask) > 0 then
   Result := HIGH
 else
   Result := LOW;
end;

function digitalReadPort(pin: byte): Byte;
begin
 Result := digitalPinToInput(pin)^;
end;

// Here i only have defined for Arduino Uno with ATMega328P
function digitalPinToPort(pin : int16) : Pbyte;
begin
 case pin of
  0..7  : Result := @PORTD;
  8..13 : Result := @PORTB;
  14..19: Result := @PORTC;
 else
  Result := nil;
 end;
end;

function digitalPinToInput(pin: byte): PByte;
begin
 case pin of
  0..7  : Result := @PIND;
  8..13 : Result := @PINB;
  14..19: Result := @PINC;
 else
  Result := nil;
 end;
end;

function digitalPinToBitmask(pin: byte): byte;
begin
  Result := 0;
  case pin of
   0..7   : Result := 1 shl pin;
   8..13  : Result := 1 shl (pin - 8);
   14..19 : Result := 1 shl (pin - 14);
  end;
end;

function digitalPinToDDR(pin: byte): Pbyte;
begin
  Result := NIL;
  case pin of
   0..7 : Result := @DDRD;
   8..13 : Result := @DDRB;
   14..19 : Result := @DDRC;
  end;
end;

function pgm_read_byte(addr: PByte): uint8; assembler; nostackframe;
// Rein: r24, r25 Pointer
// Raus: r24
asm
  push r30
  push r31
  mov r30, r24
  mov r31, r25
  lpm r24, Z
  pop r31
  pop r30
end[];


function pgm_read_word(addr: PByte): word; assembler; nostackframe;
// Rein: r24, r25 Pointer
// Raus: r24, r25 Daten
asm
  push r31
  push r30

  mov r30, r24
  mov r31, r25
  lpm r24, Z+
  lpm r25, Z

  pop r30
  pop r31
end[];

procedure pgm_copy_string(addr, buffer: PChar); assembler; nostackframe;
// Rein: r22, r23, r24, r25 Pointer
label
  loop;
asm
  push r31
  push r30
  push r27
  push r26
  push r16
  push r0

  mov r26, r22
  mov r27, r23
  mov r30, r24
  mov r31, r25
  lpm r0, Z+
  st X+, r0
  mov r16, r0
  loop:
  lpm r0, Z+
  st X+, r0
  dec r16
  brne loop

  pop r0
  pop r16
  pop r26
  pop r27
  pop r30
  pop r31
end[];

procedure delay_us(us: dword);
var wait : dword;
    mcs : dword;
begin
  mcs := micros;
  wait := mcs + us;
  if wait < mcs then while micros > wait do asm nop end;
  while (micros < wait) do asm nop end;
end;

procedure delay(ms: dword);
var wait : dword;
    mls : dword;
begin
  mls := millis;
  wait := mls + ms;
  // Wenn der wait durch die Addition übergelaufen ist, müssen wir warten,
  // bis auch der Timer übergelaufen ist
  if wait < mls then while millis > wait do asm nop end;
  while (millis < wait) do asm nop end;
end;

procedure disable_Interrupts; assembler; nostackframe;
asm
  cli
end;

procedure enable_Interrupts; assembler; nostackframe;
asm
  sei
end;



end.

