import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.net.*; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class nightlights_plasma extends PApplet {

OPC opcc,opcu,opcs,opct,opca;
int SCREENWIDTH  = 200;
int SCREENHEIGHT = 300;
 
int GRADIENTLEN = 1500;
// use this factor to make things faster, esp. for high resolutions
int SPEEDUP = 1;
 
// swing/wave function parameters
int SWINGLEN = GRADIENTLEN*3;
int SWINGMAX = GRADIENTLEN / 2 - 1;
 
// gradient & swing curve arrays
private int[] colorGrad;
private int[] swingCurve;

public void setup()
{

    makeGradient(GRADIENTLEN);
    makeSwingCurve(SWINGLEN, SWINGMAX);


  // Connect to the local instance of fcserver
  opcc = new OPC(this, "cloud.local", 7890);
  opcu = new OPC(this, "unicorn.local", 7890);
  opcs = new OPC(this, "strawberry.local", 7890);
  opct = new OPC(this, "toast.local", 7890);
  opca = new OPC(this, "apple.local", 7890);


  if (opcc != null){
    println("Initializing Cloud");
    opcc.ledStrip(0, 16, width/2, height/2, width / 70.0f, 0, false);
    opcc.ledStrip(1000, 16, width/2, height/2-15, width / 70.0f, 0, false);
    opcc.ledStrip(2000, 16, width/2, height/2-30, width / 70.0f, 0, false);
    opcc.ledStrip(3000, 48, width/2, height/2+15, width / 70.0f, 0, false);
    opcc.ledStrip(4000, 32, width/2, height/2+30, width / 70.0f, 0, false);
    opcc.ledStrip(5000, 32, width/2, height/2+45, width / 70.0f, 0, false);
    
    opcc.startConnect();
  }
 
  if (opcu != null){
    println("Initializing Unicorn");
    opcu.ledStrip(0, 32, width/2, height/2-10, width / 70.0f, 0, false);
    opcu.ledStrip(1000, 64, width/2, height/2-25, width / 70.0f, 0, false);
    opcu.ledStrip(2000, 32, width/2, height/2-35, width / 70.0f, 0, false);
    
    opcu.startConnect();
  }
  
  if (opcs != null){
    println("Initializing Strawberry");
    opcs.ledStrip(0, 24, width/2, height/2-45, width / 70.0f, 0, false);
    opcs.ledStrip(1000, 16, width/2, height/2+20, width / 70.0f, 0, false);
    
    opcs.startConnect();
  }
  
  if (opct != null){
    println("Initializing Toast");
    opct.ledStrip(0, 32, width/2+10, height/2-5, width / 70.0f, 0, false);
    
    opct.startConnect();
  }
  
  if (opca != null){
    println("Initializing Apple");
    opca.ledStrip(0, 16, width/2, height/2+5, width / 70.0f, 0, false);
    opca.ledStrip(1000, 16, width/2, height/2-50, width / 70.0f, 0, false);
    opca.ledStrip(2000, 48, width/2, height/2-40, width / 70.0f, 0, false);
    opca.ledStrip(3000, 16, width/2, height/2+50, width / 70.0f, 0, false);

    opca.startConnect();    
  }
}

public void draw() {
  loadPixels();
    int i = 0;
    int t = frameCount*SPEEDUP;
    int swingT = swing(t); // swingT/-Y/-YT variables are used for a little tuning ...
 
    for (int y = 0; y < SCREENHEIGHT; y++) {
        int swingY  = swing(y);
        int swingYT = swing(y + t);
        for (int x = 0; x < SCREENWIDTH; x++) {
            // this is where the magic happens: map x, y, t around
            // the swing curves and lookup a color from the gradient
            // the "formula" was found by a lot of experimentation
            pixels[i++] = gradient(
                    swing(swing(x + swingT) + swingYT) +
                    swing(swing(x + t     ) + swingY ));
        }
    }
    updatePixels();
}
 
// create a new random gradient when mouse is pressed
public void mousePressed() {
    if (mouseButton == LEFT)
        makeGradient(GRADIENTLEN);
    else if (mouseButton == RIGHT)
        makeSwingCurve(SWINGLEN, SWINGMAX);
}
   
// fill the given array with a nice swingin' curve
// three cos waves are layered together for that
// the wave "wraps" smoothly around, uh, if you know what i mean ;-)
public void makeSwingCurve(int arrlen, int maxval) {
    // default values will be used upon first call
    int factor1=2;
    int factor2=3;
    int factor3=6;
 
    if (swingCurve == null) {
        swingCurve = new int[SWINGLEN];
    } else {
        factor1=(int) random(1, 7);
        factor2=(int) random(1, 7);
        factor3=(int) random(1, 7);
    }
 
    int halfmax = maxval/factor1;
 
    for( int i=0; i<arrlen; i++ ) {
        float ni = i*TWO_PI/arrlen; // ni goes [0..TWO_PI] -> one complete cos wave
        swingCurve[i]=(int)(
            cos( ni*factor1 ) *
            cos( ni*factor2 ) *
            cos( ni*factor3 ) *
            halfmax + halfmax );
    }
}
 
// create a smooth, colorful gradient by cosinus curves in the RGB channels
private void makeGradient(int arrlen) {
    // default values will be used upon first call
    int rf = 4;
    int gf = 2;
    int bf = 1;
    int rd = arrlen;
    int gd = arrlen / gf;
    int bd = arrlen / bf / 2;
 
    if (colorGrad == null) {
        // first call
        colorGrad = new int[GRADIENTLEN];
    } else {
        // we are called again: random gradient
        rf = (int) random(1, 5);
        gf = (int) random(1, 5);
        bf = (int) random(1, 5);
        rd = (int) random(0, arrlen);
        gd = (int) random(0, arrlen);
        bd = (int) random(0, arrlen);
        System.out.println("Gradient factors("+rf+","+gf+","+bf+"), displacement("+rd+","+gd+","+bd+")");
    }
 
    // fill gradient array
    for (int i = 0; i < arrlen; i++) {
        int r = cos256(arrlen / rf, i + rd);
        int g = cos256(arrlen / gf, i + gd);
        int b = cos256(arrlen / bf, i + bd);
        colorGrad[i] = color(r, g, b);
    }
}
 
// helper: get cosinus sample normalized to 0..255
private int cos256(final int amplitude, final int x) {
    return (int) (cos(x * TWO_PI / amplitude) * 127 + 127);
}
 
// helper: get a swing curve sample
private int swing(final int i) {
    return swingCurve[i % SWINGLEN];
}
 
// helper: get a gradient sample
private int gradient(final int i) {
    return colorGrad[i % GRADIENTLEN];
}
/*
 * Simple Open Pixel Control client for Processing,
 * designed to sample each LED's color from some point on the canvas.
 *
 * Micah Elizabeth Scott, 2013
 * This file is released into the public domain.
 */




public class Connector implements Runnable {
   public Socket socket;
   public OutputStream output;
   
   Thread t;
   String host;
   int port;
 
   public Connector(String host, int port) {
       this.host = host;
       this.port = port;
   }
 
   public boolean isConnected() {
       return (this.output != null);
   }
   
   public void startConnect() {       
       this.t = new Thread(this);
       this.t.start();
       println("Starting connection to OPC server " + this.host);
   }
   
   public void dispose() {
       this.socket = null;
       this.output = null;
   }
   
   public void run() {
       while (true) {
           if (this.output == null) {
                try {
                  this.socket = new Socket(host, port);
                  this.socket.setTcpNoDelay(true);
                  this.socket.setSoTimeout(1000);
                  this.output = socket.getOutputStream();
                  println("Connected to OPC server " + this.host);
                } catch (ConnectException e) {
                  dispose();
                } catch (IOException e) {
                  dispose();
                }
           }
           try {
             Thread.sleep(2000);
           } catch (InterruptedException e) {
           }
       }
   }
}

public class OPC
{
  //Socket socket;
  //OutputStream output;
  
  Connector connector;
  
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;
  
  boolean wasConnected;

  OPC(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    this.connector = new Connector(host, port);
    this.enableShowLocations = true;
    this.wasConnected = false;
    parent.registerMethod("draw", this);
  }

  public void startConnect() {
     this.connector.startConnect(); 
  }

  // Set the location of a single LED
  public void led(int index, int x, int y)  
  {
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }
  
  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip.
  public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0f) * spacing * c + 0.5f),
        (int)(y + (i - (count-1)/2.0f) * spacing * s + 0.5f));
    }
  }

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
  public void ledRing(int index, int count, float x, float y, float radius, float angle)
  {
    for (int i = 0; i < count; i++) {
      float a = angle + i * 2 * PI / count;
      led(index + i, (int)(x - radius * cos(a) + 0.5f),
        (int)(y - radius * sin(a) + 0.5f));
    }
  }

  // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  public void ledGrid(int index, int stripLength, int numStrips, float x, float y,
               float ledSpacing, float stripSpacing, float angle, boolean zigzag)
  {
    float s = sin(angle + HALF_PI);
    float c = cos(angle + HALF_PI);
    for (int i = 0; i < numStrips; i++) {
      ledStrip(index + stripLength * i, stripLength,
        x + (i - (numStrips-1)/2.0f) * stripSpacing * c,
        y + (i - (numStrips-1)/2.0f) * stripSpacing * s, ledSpacing,
        angle, zigzag && (i % 2) == 1);
    }
  }

  // Set the location of 64 LEDs arranged in a uniform 8x8 grid.
  // (x,y) is the center of the grid.
  public void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag)
  {
    ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag);
  }

  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  public void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }
  
  // Enable or disable dithering. Dithering avoids the "stair-stepping" artifact and increases color
  // resolution by quickly jittering between adjacent 8-bit brightness levels about 400 times a second.
  // Dithering is on by default.
  public void setDithering(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x01;
    else
      firmwareConfig |= 0x01;
    sendFirmwareConfigPacket();
  }

  // Enable or disable frame interpolation. Interpolation automatically blends between consecutive frames
  // in hardware, and it does so with 16-bit per channel resolution. Combined with dithering, this helps make
  // fades very smooth. Interpolation is on by default.
  public void setInterpolation(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x02;
    else
      firmwareConfig |= 0x02;
    sendFirmwareConfigPacket();
  }

  // Put the Fadecandy onboard LED under automatic control. It blinks any time the firmware processes a packet.
  // This is the default configuration for the LED.
  public void statusLedAuto()
  {
    firmwareConfig &= 0x0C;
    sendFirmwareConfigPacket();
  }    

  // Manually turn the Fadecandy onboard LED on or off. This disables automatic LED control.
  public void setStatusLed(boolean on)
  {
    firmwareConfig |= 0x04;   // Manual LED control
    if (on)
      firmwareConfig |= 0x08;
    else
      firmwareConfig &= ~0x08;
    sendFirmwareConfigPacket();
  } 

  // Set the color correction parameters
  public void setColorCorrection(float gamma, float red, float green, float blue)
  {
    colorCorrection = "{ \"gamma\": " + gamma + ", \"whitepoint\": [" + red + "," + green + "," + blue + "]}";
    sendColorCorrectionPacket();
  }
  
  // Set custom color correction parameters from a string
  public void setColorCorrection(String s)
  {
    colorCorrection = s;
    sendColorCorrectionPacket();
  }

  // Send a packet with the current firmware configuration settings
  public void sendFirmwareConfigPacket()
  {
    if (!connector.isConnected()) {
      return;
    }
 
    byte[] packet = new byte[9];
    packet[0] = 0;          // Channel (reserved)
    packet[1] = (byte)0xFF; // Command (System Exclusive)
    packet[2] = 0;          // Length high byte
    packet[3] = 5;          // Length low byte
    packet[4] = 0x00;       // System ID high byte
    packet[5] = 0x01;       // System ID low byte
    packet[6] = 0x00;       // Command ID high byte
    packet[7] = 0x02;       // Command ID low byte
    packet[8] = firmwareConfig;

    try {
      connector.output.write(packet);
    } catch (Exception e) {
      dispose();
    }
  }

  // Send a packet with the current color correction settings
  public void sendColorCorrectionPacket()
  {
    if (colorCorrection == null) {
      // No color correction defined
      return;
    }
    if (!connector.isConnected()) {
      return;
    }

    byte[] content = colorCorrection.getBytes();
    int packetLen = content.length + 4;
    byte[] header = new byte[8];
    header[0] = 0;          // Channel (reserved)
    header[1] = (byte)0xFF; // Command (System Exclusive)
    header[2] = (byte)(packetLen >> 8);
    header[3] = (byte)(packetLen & 0xFF);
    header[4] = 0x00;       // System ID high byte
    header[5] = 0x01;       // System ID low byte
    header[6] = 0x00;       // Command ID high byte
    header[7] = 0x01;       // Command ID low byte

    try {
      connector.output.write(header);
      connector.output.write(content);
    } catch (Exception e) {
      dispose();
    }
  }

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  public void draw()
  {
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }
 
    if (!connector.isConnected()) {
      return;
    }
    
    // handle first draw after connect
    if (!this.wasConnected) {
        sendColorCorrectionPacket();
        sendFirmwareConfigPacket();
        this.wasConnected = true;
    }
 
    int numPixels = pixelLocations.length;
    int ledAddress = 4;

    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];

      packetData[ledAddress] = (byte)(pixel >> 16);
      packetData[ledAddress + 1] = (byte)(pixel >> 8);
      packetData[ledAddress + 2] = (byte)pixel;
      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
  }
  
  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  public void setPixelCount(int numPixels)
  {
    int numBytes = 3 * numPixels;
    int packetLen = 4 + numBytes;
    if (packetData == null || packetData.length != packetLen) {
      // Set up our packet buffer
      packetData = new byte[packetLen];
      packetData[0] = 0;  // Channel
      packetData[1] = 0;  // Command (Set pixel colors)
      packetData[2] = (byte)(numBytes >> 8);
      packetData[3] = (byte)(numBytes & 0xFF);
    }
  }
  
  // Directly manipulate a pixel in the output buffer. This isn't needed
  // for pixels that are mapped to the screen.
  public void setPixel(int number, int c)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = (byte) (c >> 16);
    packetData[offset + 1] = (byte) (c >> 8);
    packetData[offset + 2] = (byte) c;
  }
  
  // Read a pixel from the output buffer. If the pixel was mapped to the display,
  // this returns the value we captured on the previous frame.
  public int getPixel(int number)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      return 0;
    }
    return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
  }

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  public void writePixels()
  {
    if (packetData == null || packetData.length == 0) {
      // No pixel buffer
      return;
    }
    
    if (!connector.isConnected()) {
        return;
    }
    
    try {
      connector.output.write(packetData);
    } catch (Exception e) {
      dispose();
    }
  }

  public void dispose()
  {
      println("Disconnected from " + this.host + ". Retrying...");
      connector.dispose();
      this.wasConnected = false; 
  }

}
  public void settings() { 
size(200, 300); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "nightlights_plasma" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
