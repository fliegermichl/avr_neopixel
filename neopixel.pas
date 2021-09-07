unit neopixel;
interface

// The order of primary colors in the NeoPixel data stream can vary among
// device types, manufacturers and even different revisions of the same
// item.  The third parameter to the Adafruit_NeoPixel constructor encodes
// the per-pixel byte offsets of the red, green and blue primaries (plus
// white, if present) in the data stream -- the following #defines provide
// an easier-to-use named version for each permutation. e.g. NEO_GRB
// indicates a NeoPixel-compatible device expecting three bytes per pixel,
// with the first byte transmitted containing the green value, second
// containing red and third containing blue. The in-memory representation
// of a chain of NeoPixels is the same as the data-stream order; no
// re-ordering of bytes is required when issuing data to the chain.
// Most of these values won't exist in real-world devices, but it's done
// this way so we're ready for it (also, if using the WS2811 driver IC,
// one might have their pixels set up in any weird permutation).

// Bits 5,4 of this value are the offset (0-3) from the first byte of a
// pixel to the location of the red color byte.  Bits 3,2 are the green
// offset and 1,0 are the blue offset.  If it is an RGBW-type device
// (supporting a white primary in addition to R,G,B), bits 7,6 are the
// offset to the white byte...otherwise, bits 7,6 are set to the same value
// as 5,4 (red) to indicate an RGB (not RGBW) device.
// i.e. binary representation:
// 0bWWRRGGBB for RGBW devices
// 0bRRRRGGBB for RGB

// RGB NeoPixel permutations; white and red offsets are always same
// Offset:         W        R        G        B
const
NEO_RGB = ((0 shl 6) or (0 shl 4) or (1 shl 2) or (2)); ///< Transmit as R,G,B
NEO_RBG = ((0 shl 6) or (0 shl 4) or (2 shl 2) or (1)); ///< Transmit as R,B,G
NEO_GRB = ((1 shl 6) or (1 shl 4) or (0 shl 2) or (2)); ///< Transmit as G,R,B
NEO_GBR = ((2 shl 6) or (2 shl 4) or (0 shl 2) or (1)); ///< Transmit as G,B,R
NEO_BRG = ((1 shl 6) or (1 shl 4) or (2 shl 2) or (0)); ///< Transmit as B,R,G
NEO_BGR = ((2 shl 6) or (2 shl 4) or (1 shl 2) or (0)); ///< Transmit as B,G,R

// RGBW NeoPixel permutations; all 4 offsets are distinct
// Offset:         W          R          G          B
NEO_WRGB = ((0 shl 6) or (1 shl 4) or (2 shl 2) or (3)); ///< Transmit as W,R,G,B
NEO_WRBG = ((0 shl 6) or (1 shl 4) or (3 shl 2) or (2)); ///< Transmit as W,R,B,G
NEO_WGRB = ((0 shl 6) or (2 shl 4) or (1 shl 2) or (3)); ///< Transmit as W,G,R,B
NEO_WGBR = ((0 shl 6) or (3 shl 4) or (1 shl 2) or (2)); ///< Transmit as W,G,B,R
NEO_WBRG = ((0 shl 6) or (2 shl 4) or (3 shl 2) or (1)); ///< Transmit as W,B,R,G
NEO_WBGR = ((0 shl 6) or (3 shl 4) or (2 shl 2) or (1)); ///< Transmit as W,B,G,R

NEO_RWGB = ((1 shl 6) or (0 shl 4) or (2 shl 2) or (3)); ///< Transmit as R,W,G,B
NEO_RWBG = ((1 shl 6) or (0 shl 4) or (3 shl 2) or (2)); ///< Transmit as R,W,B,G
NEO_RGWB = ((2 shl 6) or (0 shl 4) or (1 shl 2) or (3)); ///< Transmit as R,G,W,B
NEO_RGBW = ((3 shl 6) or (0 shl 4) or (1 shl 2) or (2)); ///< Transmit as R,G,B,W
NEO_RBWG = ((2 shl 6) or (0 shl 4) or (3 shl 2) or (1)); ///< Transmit as R,B,W,G
NEO_RBGW = ((3 shl 6) or (0 shl 4) or (2 shl 2) or (1)); ///< Transmit as R,B,G,W

NEO_GWRB = ((1 shl 6) or (2 shl 4) or (0 shl 2) or (3)); ///< Transmit as G,W,R,B
NEO_GWBR = ((1 shl 6) or (3 shl 4) or (0 shl 2) or (2)); ///< Transmit as G,W,B,R
NEO_GRWB = ((2 shl 6) or (1 shl 4) or (0 shl 2) or (3)); ///< Transmit as G,R,W,B
NEO_GRBW = ((3 shl 6) or (1 shl 4) or (0 shl 2) or (2)); ///< Transmit as G,R,B,W
NEO_GBWR = ((2 shl 6) or (3 shl 4) or (0 shl 2) or (1)); ///< Transmit as G,B,W,R
NEO_GBRW = ((3 shl 6) or (2 shl 4) or (0 shl 2) or (1)); ///< Transmit as G,B,R,W

NEO_BWRG = ((1 shl 6) or (2 shl 4) or (3 shl 2) or (0)); ///< Transmit as B,W,R,G
NEO_BWGR = ((1 shl 6) or (3 shl 4) or (2 shl 2) or (0)); ///< Transmit as B,W,G,R
NEO_BRWG = ((2 shl 6) or (1 shl 4) or (3 shl 2) or (0)); ///< Transmit as B,R,W,G
NEO_BRGW = ((3 shl 6) or (1 shl 4) or (2 shl 2) or (0)); ///< Transmit as B,R,G,W
NEO_BGWR = ((2 shl 6) or (3 shl 4) or (1 shl 2) or (0)); ///< Transmit as B,G,W,R
NEO_BGRW = ((3 shl 6) or (2 shl 4) or (1 shl 2) or (0)); ///< Transmit as B,G,R,W

type
  TNeoPixelType = byte;

const
// These two tables are declared outside the Adafruit_NeoPixel class
// because some boards may require oldschool compilers that don't
// handle the C++11 constexpr keyword.

(* A PROGMEM (flash mem) table containing 8-bit unsigned sine wave (0-255).
   Copy & paste this snippet into a Python REPL to regenerate:
import math
for x in range(256):
    print("{:3},".format(int((math.sin(x/128.0*math.pi)+1.0)*127.5+0.5))),
    if x&15 == 15: print
*)
_NeoPixelSineTable : array[0..255] of byte = (
  128,131,134,137,140,143,146,149,152,155,158,162,165,167,170,173,
  176,179,182,185,188,190,193,196,198,201,203,206,208,211,213,215,
  218,220,222,224,226,228,230,232,234,235,237,238,240,241,243,244,
  245,246,248,249,250,250,251,252,253,253,254,254,254,255,255,255,
  255,255,255,255,254,254,254,253,253,252,251,250,250,249,248,246,
  245,244,243,241,240,238,237,235,234,232,230,228,226,224,222,220,
  218,215,213,211,208,206,203,201,198,196,193,190,188,185,182,179,
  176,173,170,167,165,162,158,155,152,149,146,143,140,137,134,131,
  128,124,121,118,115,112,109,106,103,100, 97, 93, 90, 88, 85, 82,
   79, 76, 73, 70, 67, 65, 62, 59, 57, 54, 52, 49, 47, 44, 42, 40,
   37, 35, 33, 31, 29, 27, 25, 23, 21, 20, 18, 17, 15, 14, 12, 11,
   10,  9,  7,  6,  5,  5,  4,  3,  2,  2,  1,  1,  1,  0,  0,  0,
    0,  0,  0,  0,  1,  1,  1,  2,  2,  3,  4,  5,  5,  6,  7,  9,
   10, 11, 12, 14, 15, 17, 18, 20, 21, 23, 25, 27, 29, 31, 33, 35,
   37, 40, 42, 44, 47, 49, 52, 54, 57, 59, 62, 65, 67, 70, 73, 76,
   79, 82, 85, 88, 90, 93, 97,100,103,106,109,112,115,118,121,124); section '.progmem';

(* Similar to above, but for an 8-bit gamma-correction table.
   Copy & paste this snippet into a Python REPL to regenerate:
import math
gamma=2.6
for x in range(256):
    print("{:3},".format(int(math.pow((x)/255.0,gamma)*255.0+0.5))),
    if x&15 == 15: print
*)
_NeoPixelGammaTable : array[0..255] of byte = (
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,
    1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  3,  3,  3,  3,
    3,  3,  4,  4,  4,  4,  5,  5,  5,  5,  5,  6,  6,  6,  6,  7,
    7,  7,  8,  8,  8,  9,  9,  9, 10, 10, 10, 11, 11, 11, 12, 12,
   13, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20,
   20, 21, 21, 22, 22, 23, 24, 24, 25, 25, 26, 27, 27, 28, 29, 29,
   30, 31, 31, 32, 33, 34, 34, 35, 36, 37, 38, 38, 39, 40, 41, 42,
   42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57,
   58, 59, 60, 61, 62, 63, 64, 65, 66, 68, 69, 70, 71, 72, 73, 75,
   76, 77, 78, 80, 81, 82, 84, 85, 86, 88, 89, 90, 92, 93, 94, 96,
   97, 99,100,102,103,105,106,108,109,111,112,114,115,117,119,120,
  122,124,125,127,129,130,132,134,136,137,139,141,143,145,146,148,
  150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,
  182,184,186,188,191,193,195,197,199,202,204,206,209,211,213,215,
  218,220,223,225,227,230,232,235,237,240,242,245,247,250,252,255); section '.progmem';

type

  { TNeoPixel }

  TNeoPixel = object
  private
    fBegun : boolean;             ///< true if _begin() previously called
    fnumBytes : word;             ///< Size of 'pixels' buffer below
    fnumLEDs : word;              ///< Number of RGB(W) LEDs in strip
    fPin : int16;                 ///< Output pin number (-1 if not yet set)
    fbrightness : byte;           ///< Strip brightness 0-255 (stored as +1)
    fEndTime : dword;             ///< Latch timing reference
    fPixels : Pbyte;              ///< Holds LED color values (3 or 4 bytes each)
    frOffset : byte;              ///< Red index within each 3- or 4-byte pixel
    fgOffset : byte;              ///< Index of green byte
    fbOffset : byte;              ///< Index of blue byte
    fwOffset : byte;              ///< Index of white (==rOffset if no white)

    fport : PByte;                ///< Output PORT register
    fpinMask : byte;              ///< Output PORT bitmask
  public
    constructor Create(n : word; p : int16 = 6; neoPixelType : TNeoPixelType = NEO_GRB);
    destructor  Destroy; virtual;
    procedure _begin;
    (*!
      @brief   Check whether a call to show() will start sending data
               immediately or will 'block' for a required interval. NeoPixels
               require a short quiet time (about 300 microseconds) after the
               last bit is received before the data 'latches' and new data can
               start being received. Usually one's sketch is implicitly using
               this time to generate a new frame of animation...but if it
               finishes very quickly, this function could be used to see if
               there's some idle time available for some low-priority
               concurrent task.
      @return  1 or true if show() will start sending immediately, 0 or false
               if show() would block (meaning some idle time is available).
    *)
    function  canShow : boolean;
    (*!
      @brief   Transmit pixel data in RAM to NeoPixels.
      @note    On most architectures, interrupts are temporarily disabled in
               order to achieve the correct NeoPixel signal timing. This means
               that the Arduino millis() and micros() functions, which require
               interrupts, will lose small intervals of time whenever this
               function is called (about 30 microseconds per RGB pixel, 40 for
               RGBW (pixels). There's no easy fix for this, but a few
               specialized alternative or companion libraries exist that use
               very device-specific peripherals to work around it.
    *)
    procedure show;
    (*!
      @brief   Set/change the NeoPixel output pin number. Previous pin,
               if any, is set to INPUT and the new pin is set to OUTPUT.
      @param   p  Arduino pin number (-1 = no pin).
    *)
    procedure setPin(p: int16);
    (*!
      @brief   Set a pixel's color using separate red, green and blue
               components. If using RGBW pixels, white will be set to 0.
      @param   n  Pixel index, starting from 0.
      @param   r  Red brightness, 0 = minimum (off), 255 = maximum.
      @param   g  Green brightness, 0 = minimum (off), 255 = maximum.
      @param   b  Blue brightness, 0 = minimum (off), 255 = maximum.
    *)
    procedure setPixelColor(n : word; r : byte; g : byte; b : byte); overload;
    (*!
      @brief   Set a pixel's color using separate red, green, blue and white
               components (for RGBW NeoPixels only).
      @param   n  Pixel index, starting from 0.
      @param   r  Red brightness, 0 = minimum (off), 255 = maximum.
      @param   g  Green brightness, 0 = minimum (off), 255 = maximum.
      @param   b  Blue brightness, 0 = minimum (off), 255 = maximum.
      @param   w  White brightness, 0 = minimum (off), 255 = maximum, ignored
                  if using RGB pixels.
    *)
    procedure setPixelColor(n : word; r, g, b, w : byte); overload;
    (*!
      @brief   Set a pixel's color using a 32-bit 'packed' RGB or RGBW value.
      @param   n  Pixel index, starting from 0.
      @param   c  32-bit color value. Most significant byte is white (for RGBW
                  pixels) or ignored (for RGB pixels), next is red, then green,
                  and least significant byte is blue.
    *)
    procedure setPixelColor(n : word; c : dword); overload;
    (*!
      @brief   Fill all or part of the NeoPixel strip with a color.
      @param   c      32-bit color value. Most significant byte is white (for
                      RGBW pixels) or ignored (for RGB pixels), next is red,
                      then green, and least significant byte is blue. If all
                      arguments are unspecified, this will be 0 (off).
      @param   first  Index of first pixel to fill, starting from 0. Must be
                      in-bounds, no clipping is performed. 0 if unspecified.
      @param   count  Number of pixels to fill, as a positive value. Passing
                      0 or leaving unspecified will fill to end of strip.
    *)
    procedure fill(c : dword =0; first : word = 0; count : word = 0);
    procedure setBrightness(b : byte);
    procedure clear;
    (*!
      @brief   Change the length of a previously-declared Adafruit_NeoPixel
               strip object. Old data is deallocated and new data is cleared.
               Pin number and pixel format are unchanged.
      @param   n  New length of strip, in pixels.
      @note    This function is deprecated, here only for old projects that
               may still be calling it. New projects should instead use the
               'new' keyword with the first constructor syntax (length, pin,
               type).
    *)
    procedure updateLength(n : word);
    (*!
      @brief   Change the pixel format of a previously-declared
               Adafruit_NeoPixel strip object. If format changes from one of
               the RGB variants to an RGBW variant (or RGBW to RGB), the old
               data will be deallocated and new data is cleared. Otherwise,
               the old data will remain in RAM and is not reordered to the
               new format, so it's advisable to follow up with clear().
      @param   t  Pixel type -- add together NEO_* constants defined in
                  Adafruit_NeoPixel.h, for example NEO_GRB+NEO_KHZ800 for
                  NeoPixels expecting an 800 KHz (vs 400 KHz) data stream
                  with color bytes expressed in green, red, blue order per
                  pixel.
      @note    This function is deprecated, here only for old projects that
               may still be calling it. New projects should instead use the
               'new' keyword with the first constructor syntax
               (length, pin, type).
    *)
    procedure updateType(t : TneoPixelType);
    function  getPixels : PByte;
    function  getBrightness: byte;
    (*!
      @brief   Convert hue, saturation and value into a packed 32-bit RGB color
               that can be passed to setPixelColor() or other RGB-compatible
               functions.
      @param   hue  An unsigned 16-bit value, 0 to 65535, representing one full
                    loop of the color wheel, which allows 16-bit hues to "roll
                    over" while still doing the expected thing (and allowing
                    more precision than the wheel() function that was common to
                    prior NeoPixel examples).
      @param   sat  Saturation, 8-bit value, 0 (min or pure grayscale) to 255
                    (max or pure hue). Default of 255 if unspecified.
      @param   val  Value (brightness), 8-bit value, 0 (min / black / off) to
                    255 (max or full brightness). Default of 255 if unspecified.
      @return  Packed 32-bit RGB with the most significant byte set to 0 -- the
               white element of WRGB pixels is NOT utilized. Result is linearly
               but not perceptually correct, so you may want to pass the result
               through the gamma32() function (or your own gamma-correction
               operation) else colors may appear washed out. This is not done
               automatically by this function because coders may desire a more
               refined gamma-correction function than the simplified
               one-size-fits-all operation of gamma32(). Diffusing the LEDs also
               really seems to help when using low-saturation colors.
    *)

    function ColorHSV(hue : word; sat : byte = 255; val : byte = 255) : dword;
    (*!
      @brief   Retrieve the pin number used for NeoPixel data output.
      @return  Arduino pin number (-1 if not set).
    *)
    function getPin : int16;
    (*!
      @brief   Return the number of pixels in an Adafruit_NeoPixel strip object.
      @return  Pixel count (0 if not set).
    *)
    function numPixels: word;
    function getPixelColor(n : word) : dword;
    (*!
      @brief   An 8-bit integer sine wave function, not directly compatible
               with standard trigonometric units like radians or degrees.
      @param   x  Input angle, 0-255; 256 would loop back to zero, completing
                  the circle (equivalent to 360 degrees or 2 pi radians).
                  One can therefore use an unsigned 8-bit variable and simply
                  add or subtract, allowing it to overflow/underflow and it
                  still does the expected contiguous thing.
      @return  Sine result, 0 to 255, or -128 to +127 if type-converted to
               a signed int8_t, but you'll most likely want unsigned as this
               output is often used for pixel brightness in animation effects.
    *)
    function sine8(x : byte) : byte; static;
    (*!
      @brief   An 8-bit gamma-correction function for basic pixel brightness
               adjustment. Makes color transitions appear more perceptially
               correct.
      @param   x  Input brightness, 0 (minimum or off/black) to 255 (maximum).
      @return  Gamma-adjusted brightness, can then be passed to one of the
               setPixelColor() functions. This uses a fixed gamma correction
               exponent of 2.6, which seems reasonably okay for average
               NeoPixels in average tasks. If you need finer control you'll
               need to provide your own gamma-correction function instead.
    *)
    function gamma8(x : byte) : byte;

    {
      return pgm_read_byte(&_NeoPixelGammaTable[x]); // 0-255 in, 0-255 out
    }
    (*!
      @brief   Convert separate red, green and blue values into a single
               "packed" 32-bit RGB color.
      @param   r  Red brightness, 0 to 255.
      @param   g  Green brightness, 0 to 255.
      @param   b  Blue brightness, 0 to 255.
      @return  32-bit packed RGB value, which can then be assigned to a
               variable for later use or passed to the setPixelColor()
               function. Packed RGB format is predictable, regardless of
               LED strand color order.
    *)
    function Color(r, g, b : byte) : dword; overload;

    (*!
      @brief   Convert separate red, green, blue and white values into a
               single "packed" 32-bit WRGB color.
      @param   r  Red brightness, 0 to 255.
      @param   g  Green brightness, 0 to 255.
      @param   b  Blue brightness, 0 to 255.
      @param   w  White brightness, 0 to 255.
      @return  32-bit packed WRGB value, which can then be assigned to a
               variable for later use or passed to the setPixelColor()
               function. Packed WRGB format is predictable, regardless of
               LED strand color order.
    *)
    function Color(r, g, b, w : byte) : dword; static; overload;

    //static uint32_t   ColorHSV(uint16_t hue, uint8_t sat=255, uint8_t val=255);
    (*!
      @brief   A gamma-correction function for 32-bit packed RGB or WRGB
               colors. Makes color transitions appear more perceptially
               correct.
      @param   x  32-bit packed RGB or WRGB color.
      @return  Gamma-adjusted packed color, can then be passed in one of the
               setPixelColor() functions. Like gamma8(), this uses a fixed
               gamma correction exponent of 2.6, which seems reasonably okay
               for average NeoPixels in average tasks. If you need finer
               control you'll need to provide your own gamma-correction
               function instead.
    *)
    function gamma32(x : dword) : dword;
    //static uint32_t   gamma32(uint32_t x);
    property Pin : int16 read GetPin;
    property Pixels : PByte read fPixels;
    property numBytes : word read fnumBytes;
    property numLEDS : word read fnumLEDs;
  end;


implementation
uses arduino, timer;

{ TNeoPixel }

constructor TNeoPixel.Create(n: word; p: int16; neoPixelType: TNeoPixelType);
begin
  fbegun := false;
  fPixels := nil;
  fbrightness := 0;
  fEndTime := 0;
  setPin(p);
  updateType(neoPixelType);
  updateLength(n);
end;

destructor TNeoPixel.Destroy;
begin
  if (fbegun) then
  begin
    clear;
    show;
  end;
  FreeMem(fPixels, fnumBytes);
  if fPin >= 0 then pinMode(fpin, INPUT);
end;

procedure TNeoPixel._begin;
begin
  if(fpin >= 0) then
  begin
    pinMode(fpin, OUTPUT);
    digitalWrite(fpin, LOW);
  end;
  fbegun := true;
end;

function TNeoPixel.canShow: boolean;
begin
  {$ifdef alwayscanshow}
   {$warning alwayscanshow set!}
   Result := true;
  {$else}
   if fEndTime > micros then fEndTime := micros;
   Result := micros >= fEndTime + 300;
  {$endif}
end;

(*
procedure TNeoPixel.show;
var pLed      : ^Byte;
    b         : Byte;
    bitCount  : Byte;
    byteCount : Byte;
    hi, lo    : Byte;
    port      : PByte;
    i         : int16;
Begin
  pLed := fPixels;
  byteCount:=fnumBytes;
  b := digitalReadPort(fPin);
  hi := b or fPinMask;
  lo := b and not fPinMask;
  port := digitalPinToPort(fPin);
  disable_Interrupts();
  while byteCount > 0 do begin
    b:=pLed^;            // hole ein Byte aus dem Array
    inc(pLed);           // Zeiger aufs nächste Byte
    for bitCount:=0 to 7 do begin
      port^ := hi;
      if (b and $80) > 0 then begin  // High Bit
        asm
         nop
         nop
         nop
        end;
      end else begin                 // Low Bit
        asm
         nop                             // code für Low Bit
        end;
      end;
      port^ := lo;
      asm
        nop
        nop
        nop
        nop
        nop
        nop
      end;
      b:=b SHL 1;           // nächstes Bit
    end; // for bitcount;
    dec(byteCount);
  end;
  for i := 1 to 30000 do asm nop end;
  enable_Interrupts();
end;
*)

procedure TNeoPixel.show; assembler; nostackframe;
label wait, NextBit, NextByte, nop1, nop2, nop3;
asm
   push r29      // verwendete Register sichern
   push r28      // Y = r28/r29 fnumBytes
   push r27      // X = r26/r27 zeigt auf Pixels
   push r26      //
   push r18      // hi PinMask
   push r19      // lo PinMask
   push r20      // Bit Zähler
   push r21      // aktuell ausgegebenes Byte
   push r22      // next
   push r30      // Z = r30/r31 zeigt (vorerst) auf self
   push r31      // wird nach dem initialisieren gesichert und dann auf die Portadresse umgestellt
   push r24      // Das Ergebnis von canShow wird in r24 zurückgegeben
   push r25      // canShow verändert r24 und r25, benötigt aber den Zeiger auf self darin
wait:
   pop  r25
   pop  r24
   push r24
   push r25
   call canShow
   tst  r24
   breq wait
   pop  r25
   pop  r24
   movw  r30,r24                  // self in Z register laden
   ldd  r28,Z+TNeoPixel.fnumBytes   // fnumBytes in r28/r29 = Y Register laden
   ldd  r29,Z+TNeoPixel.fNumBytes+1
   ldd  r26,Z+TNeoPixel.fPixels  // Zeiger auf fPixels in X Register laden
   ldd  r27,Z+TNeoPixel.fPixels+1
   ldd  r22,Z+TNeoPixel.fPinMask
   ldd  r24,Z+TNeoPixel.fPin     // Arduino Pin
   ldd  r25,Z+TNeoPixel.fPin+1
   push r30                      // Z Register sichern. Wird von digitalReadPort überschrieben
   push r31
   call digitalReadPort          // Den aktuellen Zustand des Ports auslesen (wird in r24 zurückgeliefert)
   pop  r31
   pop  r30
   ldd  r18,Z+TNeoPixel.fPort    // Portadresse zwischenspeichern
   ldd  r19,Z+TNeoPixel.fPort+1
   push r30                      // Da wir nach dem senden der Sequenz 300us warten müssen,
   push r31                      // speichern wir den Inhalt des Z Registers auf dem Stack zwischen

   movw r30,r18                  // Portadresse in das Z Register laden.
                                 // ab hier kann nicht mehr auf self zugegriffen werden
   mov  r18,r24                  // Aktuellen Portzustand in r18 schreiben
   mov  r19,r18                  // und diesen auch nach lo schreiben
   or   r18,r22                  // Pin Bit setzen (hi)
   com  r22                      // Alle Bits ausser unserem setzen
   and  r19,r22                  // Pin Bit löschen, alles andere so lassen wie es ist
   com  r22                      // unser Bit wieder setzen, alles andere löschen
   ldi  r20,8                    // Bit Zähler
   ld   r21,X+                   // erstes Byte laden und X Register erhöhen
   mov  r22,r19                  // next := lo
   cli             // Interrupts sperren
NextBit:
   st   Z,r18      // PORT := hi                             (T =  0)
   sbrc r21,7      // if (Byte and 128) then                 (T =  2)
   mov  r22,r18    //   next := hi                           (T =  4)
   dec  r20        // Bit := Bit - 1                         (T =  5)
   st   Z,r22      // Port := next                           (T =  7)
   mov  r22,r19    // next := lo                             (T =  8)
   breq NextByte   // if Bit = 0 then NextByte               (from dec above)
   rol  r21        // Rotate Left on Byte                    (T = 10)
   rjmp nop1       // 3 Takte Pause                          (T = 11)
nop1:
   nop             //                                        (T = 13)
   st   Z,r19      // Port := lo                             (T = 15)
   rjmp nop2       // 3 Takte Pause machen
nop2:
   nop             //
   rjmp NextBit    // Nächstes Bit ausgeben
NextByte:
   ldi  r20,8      // Bit := 8
   ld   r21,X+     // Nächstes Byte von fPixels laden
   st   Z,r19      // Port := lo
   rjmp nop3       // 1 Takt warten
nop3:
   sbiw r28,1      // Bytezähler decrementieren
   brne NextBit    // Nicht Null? nächstes Byte ausgeben
   pop  r31        // die Adresse von self wieder zurück
   pop  r30        // holen
   sei             // Interrupts wieder zulassen
   call micros     // Aktuellen Microsekundenzählerstand in fEndTime speichern
   std  Z+TNeoPixel.fEndTime,r22
   std  Z+TNeoPixel.fEndTime+1,r23
   std  Z+TNeoPixel.fEndTime+2,r24
   std  Z+TNeoPixel.fEndTime+3,r25
   pop  r31        // gesicherte Register wieder herstellen.
   pop  r30
   pop  r22
   pop  r21
   pop  r20
   pop  r19
   pop  r18
   pop  r26
   pop  r27
   pop  r28
   pop  r29
end;

procedure TNeoPixel.setPin(p: int16);
begin
  if(fbegun and (fpin >= 0)) then pinMode(fpin, INPUT);
  fpin := p;
  if(fbegun) then
  begin
    pinMode(p, OUTPUT);
    digitalWrite(p, LOW);
  end;
  fport    := digitalPinToPort(p);
  fpinMask := digitalPinToBitMask(p);
end;

procedure TNeoPixel.setPixelColor(n: word; r: byte; g: byte; b: byte);
var p : PByte;
begin
  if(n < fnumLEDs) then
  begin
    if (fbrightness > 0) then
    begin // See notes in setBrightness()
      r := (word(r) * word(fbrightness)) shr 8;
      g := (word(g) * word(fbrightness)) shr 8;
      b := (word(b) * word(fbrightness)) shr 8;
    end;
    if(fwOffset = frOffset) then
    begin // Is an RGB-type strip
      p := @fpixels[n * 3];    // 3 bytes per pixel
    end else
    begin                 // Is a WRGB-type strip
      p := @fpixels[n * 4];    // 4 bytes per pixel
      p[fwOffset] := 0;        // But only R,G,B passed -- set W to 0
    end;
    p[frOffset] := r;          // R,G,B always stored
    p[fgOffset] := g;
    p[fbOffset] := b;
  end;
end;

procedure TNeoPixel.setPixelColor(n: word; r, g, b, w: byte);
var p : PByte;
begin
    if(n < fnumLEDs) then
    begin
      if(fbrightness > 0) then // See notes in setBrightness()
      begin
        r := (word(r) * word(fbrightness)) shr 8;
        g := (word(g) * word(fbrightness)) shr 8;
        b := (word(b) * word(fbrightness)) shr 8;
        w := (word(w) * word(fbrightness)) shr 8;
      end;
    end;
    if(fwOffset = frOffset) then
    begin // Is an RGB-type strip
      p := @fpixels[n * 3];    // 3 bytes per pixel (ignore W)
    end else
    begin                 // Is a WRGB-type strip
      p := @fpixels[n * 4];    // 4 bytes per pixel
      p[fwOffset] := w;        // Store W
    end;
    p[frOffset] := r;          // Store R,G,B
    p[fgOffset] := g;
    p[fbOffset] := b;
end;

procedure TNeoPixel.setPixelColor(n: word; c: dword);
var p : PByte;
    r, g, b, w : byte;
begin
  if(n < fnumLEDs) then
  begin
    r := c shr 16;
    g := c shr 8;
    b := byte(c);
    if(fbrightness > 0) then
    begin // See notes in setBrightness()
      r := (word(r) * word(fbrightness)) shr 8;
      g := (word(g) * word(fbrightness)) shr 8;
      b := (word(b) * word(fbrightness)) shr 8;
    end;
    if(fwOffset = frOffset) then
    begin
      p := @fpixels[n * 3];
    end else
    begin
      p := @fpixels[n * 4];
      w := c shr 24;
      if fbrightness > 0 then
        p[fwoffset] := (w * fbrightness) shr 8
      else
        p[fwoffset] := w;
    end;
    p[frOffset] := r;
    p[fgOffset] := g;
    p[fbOffset] := b;
  end;
end;

procedure TNeoPixel.fill(c: dword; first: word; count: word);
var i, _end : word;
begin
  if(first >= fnumLEDs) then exit; // If first LED is past end of strip, nothing to do

  // Calculate the index ONE AFTER the last pixel to fill
  if(count = 0) then
  begin
    // Fill to end of strip
    _end := fnumLEDs-1;
  end else
  begin
    // Ensure that the loop won't go past the last pixel
    _end := first + count;
    if(_end >= fnumLEDs) then _end := fnumLEDs-1;
  end;
  for i := first to _end do setPixelColor(i, c);
end;

procedure TNeoPixel.setBrightness(b: byte);
var newBrightness, oldBrightNess : byte;
    ptr : PByte;
    scale : word;
    c : byte;
    w : word;
    i : word;
begin
  // Stored brightness value is different than what's passed.
  // This simplifies the actual scaling math later, allowing a fast
  // 8x8-bit multiply and taking the MSB. 'brightness' is a uint8_t,
  // adding 1 here may (intentionally) roll over...so 0 = max brightness
  // (color values are interpreted literally; no scaling), 1 = min
  // brightness (off), 255 = just below max brightness.
  newBrightness := b + 1;
  if(newBrightness <> fbrightness) then
  begin
    // Compare against prior value
    // Brightness has changed -- re-scale existing data in RAM,
    // This process is potentially "lossy," especially when increasing
    // brightness. The tight timing in the WS2811/WS2812 code means there
    // aren't enough free cycles to perform this scaling on the fly as data
    // is issued. So we make a pass through the existing color data in RAM
    // and scale it (subsequent graphics commands also work at this
    // brightness level). If there's a significant step up in brightness,
    // the limited number of steps (quantization) in the old data will be
    // quite visible in the re-scaled version. For a non-destructive
    // change, you'll need to re-render the full strip data. C'est la vie.
    oldBrightness := fbrightness - 1;
    if(oldBrightness = 0) then scale := 0 // Avoid /0
    else if(b = 255) then scale := 65535 div oldBrightness
    else scale := (((word(newBrightness) shl 8) - 1)) div oldBrightness;
    ptr := fPixels;
    for i := 0 to fnumBytes - 1 do
    begin
      c      := ptr^;
      w := (c * scale) shr 8;
      ptr^ := Byte(w);
      ptr += 1;
    end;
    fbrightness := newBrightness;
  end;
end;

procedure TNeoPixel.clear;
begin
  FillChar(fPixels^, fNumBytes, 0);
end;

procedure TNeoPixel.updateLength(n: word);
begin
 if fPixels <> nil then freememory(fpixels, fnumBytes); // Free existing data (if any)

 // Allocate new data -- note: ALL PIXELS ARE CLEARED
 if fwOffset = frOffset then
   fnumBytes := n * 3
 else
   fnumBytes := n * 4;
  getMemory(fPixels, fNumBytes);
 if (fPixels <> nil) then
 begin
   fnumLEDs := n;
   clear;
 end else
 begin
    fnumLEDs := 0;
    fnumBytes := 0;
 end;
end;

procedure TNeoPixel.updateType(t: TneoPixelType);
var newThreeBytesPerPixel, oldThreeBytesPerPixel : boolean;
begin
 oldThreeBytesPerPixel := (fwOffset = frOffset); // false if RGBW
 fwOffset := (t shr 6) and %11; // See notes in header file
 frOffset := (t shr 4) and %11; // regarding R/G/B/W offsets
 fgOffset := (t shr 2) and %11;
 fbOffset :=  t        and %11;

 // If bytes-per-pixel has changed (and pixel data was previously
 // allocated), re-allocate to new size. Will clear any data.
 if (fpixels <> nil) then
 begin
   newThreeBytesPerPixel := (fwOffset = frOffset);
   if(newThreeBytesPerPixel <> oldThreeBytesPerPixel) then updateLength(fnumLEDs);
 end;
end;

(*!
  @brief   Get a pointer directly to the NeoPixel data buffer in RAM.
           Pixel data is stored in a device-native format (a la the NEO_*
           constants) and is not translated here. Applications that access
           this buffer will need to be aware of the specific data format
           and handle colors appropriately.
  @return  Pointer to NeoPixel buffer (uint8_t* array).
  @note    This is for high-performance applications where calling
           setPixelColor() on every single pixel would be too slow (e.g.
           POV or light-painting projects). There is no bounds checking
           on the array, creating tremendous potential for mayhem if one
           writes past the ends of the buffer. Great power, great
           responsibility and all that.
*)
function TNeoPixel.getPixels: PByte;
begin
 Result := fPixels;
end;

function TNeoPixel.getBrightness: byte;
begin
  Result := fBrightness - 1;
end;

function TNeoPixel.ColorHSV(hue: word; sat: byte; val: byte): dword;
var r, g, b : byte;
    v1 : dword;
    s1 : word;
    s2 : byte;
begin
    // Remap 0-65535 to 0-1529. Pure red is CENTERED on the 64K rollover;
    // 0 is not the start of pure red, but the midpoint...a few values above
    // zero and a few below 65536 all yield pure red (similarly, 32768 is the
    // midpoint, not start, of pure cyan). The 8-bit RGB hexcone (256 values
    // each for red, green, blue) really only allows for 1530 distinct hues
    // (not 1536, more on that below), but the full unsigned 16-bit type was
    // chosen for hue so that one's code can easily handle a contiguous color
    // wheel by allowing hue to roll over in either direction.
    hue := (hue * 1530 + 32768) div 65536;
    // Because red is centered on the rollover point (the +32768 above,
    // essentially a fixed-point +0.5), the above actually yields 0 to 1530,
    // where 0 and 1530 would yield the same thing. Rather than apply a
    // costly modulo operator, 1530 is handled as a special case below.

    // So you'd think that the color "hexcone" (the thing that ramps from
    // pure red, to pure yellow, to pure green and so forth back to red,
    // yielding six slices), and with each color component having 256
    // possible values (0-255), might have 1536 possible items (6*256),
    // but in reality there's 1530. This is because the last element in
    // each 256-element slice is equal to the first element of the next
    // slice, and keeping those in there this would create small
    // discontinuities in the color wheel. So the last element of each
    // slice is dropped...we regard only elements 0-254, with item 255
    // being picked up as element 0 of the next slice. Like this:
    // Red to not-quite-pure-yellow is:        255,   0, 0 to 255, 254,   0
    // Pure yellow to not-quite-pure-green is: 255, 255, 0 to   1, 255,   0
    // Pure green to not-quite-pure-cyan is:     0, 255, 0 to   0, 255, 254
    // and so forth. Hence, 1530 distinct hues (0 to 1529), and hence why
    // the constants below are not the multiples of 256 you might expect.

    // Convert hue to R,G,B (nested ifs faster than divide+mod+switch):
    if(hue < 510) then
    begin         // Red to Green-1
      b := 0;
      if(hue < 255) then
      begin              //   Red to Yellow-1
        r := 255;
        g := hue;        //     g = 0 to 254
      end else
      begin              //   Yellow to Green-1
        r := 510 - hue;  //     r = 255 to 1
        g := 255;
      end;
    end else if(hue < 1020) then
    begin // Green to Blue-1
      r := 0;
      if(hue <  765) then
      begin              //   Green to Cyan-1
        g := 255;
        b := hue - 510;  //     b = 0 to 254
      end else
      begin              //   Cyan to Blue-1
        g := 1020 - hue; //     g = 255 to 1
        b := 255;
      end;
    end else if(hue < 1530) then
    begin // Blue to Red-1
      g := 0;
      if(hue < 1275) then
      begin              //   Blue to Magenta-1
        r := hue - 1020; //     r = 0 to 254
        b := 255;
      end else
      begin              //   Magenta to Red-1
        r := 255;
        b := 1530 - hue; //     b = 255 to 1
      end;
    end else
    begin                // Last 0.5 Red (quicker than % operator)
      r := 255;
      g := 0;
      b := 0;
    end;

    // Apply saturation and value to R,G,B, pack into 32-bit result:
    v1 :=   longword(1) + longword(val); // 1 to 256; allows >>8 instead of /255
    s1 :=   longword(1) + longword(sat); // 1 to 256; same reason
    s2 := 255 - sat; // 255 to 0
    Result := ((((((longword(r) * longword(s1)) shr 8) + s2) * v1) and $ff00) shl 8) or
              (((((longword(g) * longword(s1)) shr 8) + s2) * v1) and $ff00)       or
              ( ((((longword(b) * longword(s1)) shr 8) + s2) * v1)           shr 8);
end;

function TNeoPixel.getPin: int16;
begin
  Result := fPin;
end;

function TNeoPixel.numPixels: word;
begin
  Result := fnumLEDs;
end;

function TNeoPixel.getPixelColor(n: word): dword;
var p : PByte;
begin
  Result := 0;
  if(n >= fnumLEDs) then exit; // Out of bounds, return no color.

  if(fwOffset = frOffset) then
  begin // Is RGB-type device
    p := @fpixels[n * 3];
    if (fbrightness > 0) then
    begin
      // Stored color was decimated by setBrightness(). Returned value
      // attempts to scale back to an approximation of the original 24-bit
      // value used when setting the pixel color, but there will always be
      // some error -- those bits are simply gone. Issue is most
      // pronounced at low brightness levels.
      Result := ((dword(p[frOffset] shl 8) div fbrightness) shl 16) or
                ((dword(p[fgOffset] shl 8) div fbrightness) shl  8) or
                (dword(p[fbOffset] shl 8) div fbrightness       );
    end else
    begin
      // No brightness adjustment has been made -- return 'raw' color
      Result := dword(p[frOffset] shl 16) or
                dword(p[fgOffset] shl  8) or
                dword(p[fbOffset]);
    end;
  end else
  begin                 // Is RGBW-type device
    p := @fpixels[n * 4];
    if(fbrightness > 0) then
    begin// Return scaled color
      Result := ((dword(p[fwOffset] shl 8) div fbrightness) shl 24) or
                ((dword(p[frOffset] shl 8) div fbrightness) shl 16) or
                ((dword(p[fgOffset] shl 8) div fbrightness) shl  8) or
                (dword(p[fbOffset] shl 8) div fbrightness       );
    end else
    begin // Return raw color
      Result := dword(p[fwOffset] shl 24) or
                dword(p[frOffset] shl 16) or
                dword(p[fgOffset] shl  8) or
                dword(p[fbOffset]);
    end;
  end;
end;

function TNeoPixel.sine8(x: byte): byte;
begin
 Result := pgm_read_byte(@_NeoPixelSineTable[x]); // 0-255 in, 0-255 out
end;

function TNeoPixel.gamma8(x: byte): byte;
begin
  Result := pgm_read_byte(@_NeoPixelGammaTable[x]);
end;

function TNeoPixel.Color(r, g, b: byte): dword;
begin
  Result := (dword(r) shl 16) or (dword(g) shl 8) or b;
end;

function TNeoPixel.Color(r, g, b, w: byte): dword;
begin
  Result := dword(w shl 24) or dword(r shl 16) or dword(g shl 8) or b;
end;

function TNeoPixel.gamma32(x: dword): dword;
var y : array[0..3] of byte absolute x;
    i : integer;
begin
 for i := 0 to 3 do
  y[i] := gamma8(y[i]);
 Result := x;
end;

end.

