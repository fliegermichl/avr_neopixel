program strandtest;

// A basic everyday NeoPixel strip test program.

// NEOPIXEL BEST PRACTICES for most reliable operation:
// - Add 1000 uF CAPACITOR between NeoPixel strip's + and - connections.
// - MINIMIZE WIRING LENGTH between microcontroller board and first pixel.
// - NeoPixel strip's DATA-IN should pass through a 300-500 OHM RESISTOR.
// - AVOID connecting NeoPixels on a LIVE CIRCUIT. If you must, ALWAYS
//   connect GROUND (-) first, then +, then data.
// - When using a 3.3V microcontroller with a 5V-powered NeoPixel strip,
//   a LOGIC-LEVEL CONVERTER on the data line is STRONGLY RECOMMENDED.
// (Skipping these may work OK on your workbench but can fail in the field)

uses HeapMgr, arduino, neopixel, timer;

// Which pin on the Arduino is connected to the NeoPixels?
// On a Trinket or Gemma we suggest changing this to 1:
const
 LED_PIN1  =  6;
 LED_PIN2  =  5;
 LED_COUNT = 12;

var
 strip1, strip2 : TNeoPixel;

 // Some functions of our own for creating animated effects -----------------

 // Fill strip pixels one after another with a color. Strip is NOT cleared
 // first; anything there will be covered pixel by pixel. Pass in color
 // (as a single 'packed' 32-bit value, which you can get by calling
 // strip.Color(red, green, blue) as shown in the loop() function above),
 // and a delay time (in milliseconds) between pixels.
 procedure colorWipe(color : dword; wait : word);
 var i : word;
 begin
   for i := 0 to strip1.numPixels - 1 do      // For each pixel in strip...
   begin
     strip1.setPixelColor(i, color);         //  Set pixel's color (in RAM)
     strip1.show();                          //  Update strip to match
     strip2.setPixelColor(i, color);         //  Set pixel's color (in RAM)
     strip2.show();                          //  Update strip to match
     delay(wait);                           //  Pause for a moment
   end;
 end;

 // Theater-marquee-style chasing lights. Pass in a color (32-bit value,
 // a la strip.Color(r,g,b) as mentioned above), and a delay time (in ms)
 // between frames.
procedure theaterChase(color: dword; wait: word);
var a, b, c : byte;
begin
   for a:=0 to 9 do  // Repeat 10 times...
   begin
     for b:=0 to 2 do //  'b' counts from 0 to 2...
     begin
       strip1.clear();         //   Set all pixels in RAM to 0 (off)
       strip2.clear();         //   Set all pixels in RAM to 0 (off)
       // 'c' counts up from 'b' to end of strip in steps of 3...
       c := b;
       while c < strip1.numPixels do
       begin
         strip1.setPixelColor(c, color); // Set pixel 'c' to value 'color'
         strip2.setPixelColor(c, color); // Set pixel 'c' to value 'color'
         c += 3;
       end;
       strip1.show(); // Update strip with new contents
       strip2.show(); // Update strip with new contents
       delay(wait);  // Pause for a moment
     end;
   end;
end;

 // Rainbow cycle along whole strip. Pass delay time (in ms) between frames.
procedure rainbow(wait: word);
var firstPixelHue : longint;
    i : word;
    pixelHue : int16;
begin
   // Hue of first pixel runs 5 complete loops through the color wheel.
   // Color wheel has a range of 65536 but it's OK if we roll over, so
   // just count from 0 to 5*65536. Adding 256 to firstPixelHue each time
   // means we'll make 5*65536/256 = 1280 passes through this outer loop:
   firstPixelHue := 0;
   while firstPixelHue < 5*65536 do
   begin
     for i := 0 to strip1.numPixels - 1 do     // For each pixel in strip...
     begin
       // Offset pixel hue by an amount to make one full revolution of the
       // color wheel (range of 65536) along the length of the strip
       // (strip.numPixels() steps):
       pixelHue := firstPixelHue + (i * longint(65536)) div strip1.numPixels;
       // strip.ColorHSV() can take 1 or 3 arguments: a hue (0 to 65535) or
       // optionally add saturation and value (brightness) (each 0 to 255).
       // Here we're using just the single-argument hue variant. The result
       // is passed through strip.gamma32() to provide 'truer' colors
       // before assigning to each pixel:
       strip1.setPixelColor(i, strip1.gamma32(strip1.ColorHSV(pixelHue)));
       strip2.setPixelColor(i, strip2.gamma32(strip2.ColorHSV(pixelHue)));
     end;
     strip1.show(); // Update strip with new contents
     strip2.show(); // Update strip with new contents
     delay(wait);  // Pause for a moment
     firstPixelHue += 256;
   end;
end;

 // Rainbow-enhanced theater marquee. Pass delay time (in ms) between frames.
procedure theaterChaseRainbow(wait : word);
var firstPixelHue : longint;
    a, b, c : byte;
    hue : word;
    color : dword;
begin
   firstPixelHue := 0;     // First pixel starts at red (hue 0)
   for a := 0 to 29 do        // Repeat 30 times...
   begin
     for b := 0 to 2 do         //  'b' counts from 0 to 2...
     begin
       strip1.clear();         //   Set all pixels in RAM to 0 (off)
       strip2.clear();         //   Set all pixels in RAM to 0 (off)
       // 'c' counts up from 'b' to end of strip in increments of 3...
       c := b;
       while c < strip1.numPixels do
       begin
         // hue of pixel 'c' is offset by an amount to make one full
         // revolution of the color wheel (range 65536) along the length
         // of the strip (strip.numPixels() steps):
         hue := firstPixelHue + longint(c) * Longint(65536) div strip1.numPixels;
         color := strip1.gamma32(strip1.ColorHSV(hue)); // hue -> RGB
         strip1.setPixelColor(c, color); // Set pixel 'c' to value 'color'
         strip2.setPixelColor(c, color); // Set pixel 'c' to value 'color'
         c += 3;
       end;
       strip1.show();                  // Update strip with new contents
       strip2.show();                  // Update strip with new contents
       delay(wait);                   // Pause for a moment
       firstPixelHue += 65536 div 90; // One cycle of color wheel over 90 frames
     end;
   end;
end;

procedure Blink(time : dword = 500);
begin
   digitalWrite(BUILDIN_LED, HIGH);
   delay(time);
   digitalWrite(BUILDIN_LED, LOW);
   delay(time);
end;

var HEAP : array[0..1024] of byte;
    i : integer;
    mic : dword;
begin // Program strandtest
  RegisterHeapBlock(@HEAP, 1024);
  pinMode(BUILDIN_LED, OUTPUT);

  // Argument 1 = Number of pixels in NeoPixel strip
  // Argument 2 = Arduino pin number (most are valid)
  // Argument 3 = Pixel type flags, add together as needed:
  //   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
  //   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
  //   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
  //   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
  //   NEO_RGBW    Pixels are wired for RGBW bitstream (NeoPixel RGBW products)
  strip1.create(LED_COUNT, LED_PIN1, NEO_GRB);
  strip1._begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip1.show();            // Turn OFF all pixels ASAP
  strip1.setBrightness(50);
  strip2.create(LED_COUNT, LED_PIN2, NEO_GRB);
  strip2._begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip2.show();            // Turn OFF all pixels ASAP
  strip2.setBrightness(50);
  while true do
  begin
      // Fill along the length of the strip in various colors...
    colorWipe(strip1.Color(255,   0,   0), 50); // Red
    colorWipe(strip1.Color(  0, 255,   0), 50); // Green
    colorWipe(strip1.Color(  0,   0, 255), 50); // Blue

    // Do a theater marquee effect in various colors...
    theaterChase(strip1.Color(127, 127, 127), 50); // White, half brightness
    theaterChase(strip1.Color(127,   0,   0), 50); // Red, half brightness
    theaterChase(strip1.Color(  0,   0, 127), 50); // Blue, half brightness

    rainbow(10);             // Flowing rainbow cycle along the whole strip
    theaterChaseRainbow(50); // Rainbow-enhanced theaterChase variant
  end;
end.


