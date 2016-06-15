OPC opcc,opcu,opcs,opct,opca;
import oscP5.*;

PImage dot;
OscP5 oscP5;
int lastMillis;

// A place to store settings, and we'll define their default values

//bottom center
float dot1_rpm = 16;
float dot1_size = 0.57;
float dot1_brightness = 90;
float dot1_hue = 13;
float dot1_angle = 0;

//left
float dot2_rpm = -16;
float dot2_size = 0.57;
float dot2_brightness = 90;
float dot2_hue = 13;
float dot2_angle = 0;

//top
float dot3_rpm = -16;
float dot3_size = .56;
float dot3_brightness = 90;
float dot3_hue = 13;
float dot3_angle = 180;

//front
float dot4_rpm = -16;
float dot4_size = .59;
float dot4_brightness = 90;
float dot4_hue = 35;
float dot4_angle = 0;


//back
float dot5_rpm = -16;
float dot5_size = 0.56;
float dot5_brightness = 90;
float dot5_hue = 13;
float dot5_angle = 0;

//right
float dot6_rpm = -16;
float dot6_size = 0.56;
float dot6_brightness = 90;
float dot6_hue = 13;
float dot6_angle = 0;

//bottom center
float dot7_rpm = -26;
float dot7_size = 0.59;
float dot7_brightness = 90;
float dot7_hue = 80;
float dot7_angle = 60;

//left
float dot8_rpm = 26;
float dot8_size = 0.59;
float dot8_brightness = 90;
float dot8_hue = 80;
float dot8_angle = 50;

//top
float dot9_rpm = 26;
float dot9_size = .59;
float dot9_brightness = 90;
float dot9_hue = 80;
float dot9_angle = 30;

//front
float dot10_rpm = 26;
float dot10_size = .59;
float dot10_brightness = 90;
float dot10_hue = 80;
float dot10_angle = 20;


//back
float dot11_rpm = 26;
float dot11_size = 0.59;
float dot11_brightness = 90;
float dot11_hue = 80;
float dot11_angle = 10;

//right
float dot12_rpm = 26;
float dot12_size = 0.59;
float dot12_brightness = 90;
float dot12_hue = 80;
float dot12_angle = 15;


void setup()
{
  size(300, 300);

  dot = loadImage("gray-dot.png");

  // Connect to the local instance of fcserver
  opcc = new OPC(this, "cloud.local", 7890);
  opcu = new OPC(this, "unicorn.local", 7890);
  opcs = new OPC(this, "strawberry.local", 7890);
  opct = new OPC(this, "toast.local", 7890);
  opca = new OPC(this, "apple.local", 7890);

  float spacing = 6;

  if (opcc != null){
    println("Initializing Cloud");
    opcc.ledGrid(0, 4, 4, width * 1/12, height/16, spacing, spacing, 0, false);
    opcc.ledGrid(1000, 4, 4, width * 3/12, height/16, spacing, spacing, 0, false);
    opcc.ledGrid(2000, 4, 4, width * 5/12 , height/16, spacing, spacing, 0, false);
    opcc.ledGrid(3000, 8, 6, width * 7/12, height/16, spacing, spacing, 0, false);
    opcc.ledGrid(4000, 8, 4, width * 9/12, height/16, spacing, spacing, 0, false);
    opcc.ledGrid(5000, 8, 4, width * 11/12, height/16, spacing, spacing, 0, false);
    
    opcc.startConnect();
  }
 
  if (opcu != null){
    println("Initializing Unicorn");
    opcu.ledGrid(0, 8, 4, width * 3/12, height * 4/16, spacing, spacing, 0, false);
    opcu.ledGrid(1000, 8, 8, width * 6/12, height * 4/16, spacing, spacing, 0, false);
    opcu.ledGrid(2000, 8, 4, width * 9/12, height * 4/16, spacing, spacing, 0, false);

    opcu.startConnect();
  }
//  
//  if (opcs != null){
//    println("Initializing Strawberry");
//    opcs.ledStrip(0, 24, width/2, height/2-45, width / 70.0, 0, false);
//    opcs.ledStrip(1000, 16, width/2, height/2+20, width / 70.0, 0, false);
//    
//    opcs.startConnect();
//  }
//  
//  if (opct != null){
//    println("Initializing Toast");
//    opct.ledStrip(0, 32, width/2+10, height/2-5, width / 70.0, 0, false);
//    
//    opct.startConnect();
//  }
//  
//  if (opca != null){
//    println("Initializing Apple");
//    opca.ledStrip(0, 16, width/2, height/2+5, width / 70.0, 0, false);
//    opca.ledStrip(1000, 16, width/2, height/2-50, width / 70.0, 0, false);
//    opca.ledStrip(2000, 48, width/2, height/2-40, width / 70.0, 0, false);
//    opca.ledStrip(3000, 16, width/2, height/2+50, width / 70.0, 0, false);
//
//    opca.startConnect();    
//  }
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  // Connect OSC message names to function names
  oscP5.plug(this, "set_dot1_rpm",        "/dot1/rpm");
  oscP5.plug(this, "set_dot1_size",       "/dot1/size");
  oscP5.plug(this, "set_dot1_brightness", "/dot1/brightness");
  oscP5.plug(this, "set_dot1_hue",        "/dot1/hue");
  oscP5.plug(this, "set_dot2_rpm",        "/dot2/rpm");
  oscP5.plug(this, "set_dot2_size",       "/dot2/size");
  oscP5.plug(this, "set_dot2_brightness", "/dot2/brightness");
  oscP5.plug(this, "set_dot2_hue",        "/dot2/hue");
  oscP5.plug(this, "set_dot3_rpm",        "/dot3/rpm");
  oscP5.plug(this, "set_dot3_size",       "/dot3/size");
  oscP5.plug(this, "set_dot3_brightness", "/dot3/brightness");
  oscP5.plug(this, "set_dot3_hue",        "/dot3/hue");
  oscP5.plug(this, "set_dot4_rpm",        "/dot4/rpm");
  oscP5.plug(this, "set_dot4_size",       "/dot4/size");
  oscP5.plug(this, "set_dot4_brightness", "/dot4/brightness");
  oscP5.plug(this, "set_dot4_hue",        "/dot4/hue");
  oscP5.plug(this, "set_dot5_rpm",        "/dot5/rpm");
  oscP5.plug(this, "set_dot5_size",       "/dot5/size");
  oscP5.plug(this, "set_dot5_brightness", "/dot5/brightness");
  oscP5.plug(this, "set_dot5_hue",        "/dot5/hue");
  oscP5.plug(this, "set_dot6_rpm",        "/dot6/rpm");
  oscP5.plug(this, "set_dot6_size",       "/dot6/size");
  oscP5.plug(this, "set_dot6_brightness", "/dot6/brightness");
  oscP5.plug(this, "set_dot6_hue",        "/dot6/hue");
  oscP5.plug(this, "set_dot7_rpm",        "/dot7/rpm");
  oscP5.plug(this, "set_dot7_size",       "/dot7/size");
  oscP5.plug(this, "set_dot7_brightness", "/dot7/brightness");
  oscP5.plug(this, "set_dot7_hue",        "/dot7/hue");
  oscP5.plug(this, "set_dot8_rpm",        "/dot8/rpm");
  oscP5.plug(this, "set_dot8_size",       "/dot8/size");
  oscP5.plug(this, "set_dot8_brightness", "/dot8/brightness");
  oscP5.plug(this, "set_dot8_hue",        "/dot8/hue");
  oscP5.plug(this, "set_dot9_rpm",        "/dot9/rpm");
  oscP5.plug(this, "set_dot9_size",       "/dot9/size");
  oscP5.plug(this, "set_dot9_brightness", "/dot9/brightness");
  oscP5.plug(this, "set_dot9_hue",        "/dot9/hue");
  oscP5.plug(this, "set_dot10_rpm",        "/dot10/rpm");
  oscP5.plug(this, "set_dot10_size",       "/dot10/size");
  oscP5.plug(this, "set_dot10_brightness", "/dot10/brightness");
  oscP5.plug(this, "set_dot10_hue",        "/dot10/hue");
  oscP5.plug(this, "set_dot11_rpm",        "/dot11/rpm");
  oscP5.plug(this, "set_dot11_size",       "/dot11/size");
  oscP5.plug(this, "set_dot11_brightness", "/dot11/brightness");
  oscP5.plug(this, "set_dot11_hue",        "/dot11/hue");
  oscP5.plug(this, "set_dot12_rpm",        "/dot12/rpm");
  oscP5.plug(this, "set_dot12_size",       "/dot12/size");
  oscP5.plug(this, "set_dot12_brightness", "/dot12/brightness");
  oscP5.plug(this, "set_dot12_hue",        "/dot12/hue");
}

// Trivial functions that store dot parameters
void set_dot1_rpm(float x)        { dot1_rpm = x; }
void set_dot1_size(float x)       { dot1_size = x; }
void set_dot1_brightness(float x) { dot1_brightness = x; }
void set_dot1_hue(float x)        { dot1_hue = x; }
void set_dot2_rpm(float x)        { dot2_rpm = x; }
void set_dot2_size(float x)       { dot2_size = x; }
void set_dot2_brightness(float x) { dot2_brightness = x; }
void set_dot2_hue(float x)        { dot2_hue = x; }
void set_dot3_rpm(float x)        { dot3_rpm = x; }
void set_dot3_size(float x)       { dot3_size = x; }
void set_dot3_brightness(float x) { dot3_brightness = x; }
void set_dot3_hue(float x)        { dot3_hue = x; }
void set_dot4_rpm(float x)        { dot4_rpm = x; }
void set_dot4_size(float x)       { dot4_size = x; }
void set_dot4_brightness(float x) { dot4_brightness = x; }
void set_dot4_hue(float x)        { dot4_hue = x; }
void set_dot5_rpm(float x)        { dot5_rpm = x; }
void set_dot5_size(float x)       { dot5_size = x; }
void set_dot5_brightness(float x) { dot5_brightness = x; }
void set_dot5_hue(float x)        { dot5_hue = x; }
void set_dot6_rpm(float x)        { dot6_rpm = x; }
void set_dot6_size(float x)       { dot6_size = x; }
void set_dot6_brightness(float x) { dot6_brightness = x; }
void set_dot6_hue(float x)        { dot6_hue = x; }
void set_dot7_rpm(float x)        { dot7_rpm = x; }
void set_dot7_size(float x)       { dot7_size = x; }
void set_dot7_brightness(float x) { dot7_brightness = x; }
void set_dot7_hue(float x)        { dot7_hue = x; }
void set_dot8_rpm(float x)        { dot8_rpm = x; }
void set_dot8_size(float x)       { dot8_size = x; }
void set_dot8_brightness(float x) { dot8_brightness = x; }
void set_dot8_hue(float x)        { dot8_hue = x; }
void set_dot9_rpm(float x)        { dot9_rpm = x; }
void set_dot9_size(float x)       { dot9_size = x; }
void set_dot9_brightness(float x) { dot9_brightness = x; }
void set_dot9_hue(float x)        { dot9_hue = x; }
void set_dot10_rpm(float x)        { dot10_rpm = x; }
void set_dot10_size(float x)       { dot10_size = x; }
void set_dot10_brightness(float x) { dot10_brightness = x; }
void set_dot10_hue(float x)        { dot10_hue = x; }
void set_dot11_rpm(float x)        { dot11_rpm = x; }
void set_dot11_size(float x)       { dot11_size = x; }
void set_dot11_brightness(float x) { dot11_brightness = x; }
void set_dot11_hue(float x)        { dot11_hue = x; }
void set_dot12_rpm(float x)        { dot12_rpm = x; }
void set_dot12_size(float x)       { dot12_size = x; }
void set_dot12_brightness(float x) { dot12_brightness = x; }
void set_dot12_hue(float x)        { dot12_hue = x; }


// This is a function which knows how to draw a copy of the "dot" image with a color tint.
void colorDot(float x, float y, float hue, float saturation, float brightness, float size)
{
  blendMode(ADD);
  colorMode(HSB, 100);
  tint(hue, saturation, brightness);
  
  image(dot, x - size/2, y - size/2, size, size); 
  
  noTint();
  colorMode(RGB, 255);
  blendMode(NORMAL);
}

void draw()
{
  background(0);

  int thisMillis = millis();
  int elapsedTime = thisMillis - lastMillis;
  lastMillis = thisMillis;

  // Dot 1
  dot1_angle = (dot1_angle + elapsedTime * dot1_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius1 = 0.08;
  float x1 = width/8 + width * radius1 * cos(dot1_angle);
  float y1 = height/16 + width * radius1 * sin(dot1_angle);
  colorDot(x1, y1, dot1_hue, 80, dot1_brightness, width * dot1_size);
  colorDot(x1, y1, dot1_hue, 10, dot1_brightness, width * dot1_size * 0.25);

  // Dot 2
  dot2_angle = (dot2_angle + elapsedTime * dot2_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius2 = 0.08;
  float x2 = 40*5 + width * radius2 * cos(dot2_angle);
  float y2 = width/2 + width * radius2 * sin(dot2_angle);
  colorDot(x2, y2, dot2_hue, 80, dot2_brightness, width * dot2_size);
  colorDot(x2, y2, dot2_hue, 10, dot2_brightness, width * dot2_size * 0.25);
   
    // Dot 3
  dot3_angle = (dot3_angle + elapsedTime * dot3_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius3 = 0.08;
  float x3 = 40*3 + width * radius3 * cos(dot3_angle);
  float y3 = width/2 + width * radius3 * sin(dot3_angle);
  colorDot(x3, y3, dot3_hue, 80, dot3_brightness, width * dot3_size);
  colorDot(x3, y3, dot3_hue, 10, dot3_brightness, width * dot3_size * 0.25);
  
      // Dot 4
  dot4_angle = (dot4_angle + elapsedTime * dot4_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius4 = 0.08;
  float x4 = width/5 + width * radius4 * cos(dot4_angle);
  float y4 = height / 16 + width * radius4 * sin(dot4_angle);
  colorDot(x4, y4, dot4_hue, 80, dot4_brightness, width * dot4_size);
  colorDot(x4, y4, dot4_hue, 10, dot4_brightness, width * dot4_size * 0.25);
  
        // Dot 5
  dot5_angle = (dot5_angle + elapsedTime * dot5_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius5 = 0.08;
  float x5 = width/2 + width * radius5 * cos(dot5_angle);
  float y5 = 40*5 + width * radius5 * sin(dot5_angle);
  colorDot(x5, y5, dot5_hue, 80, dot5_brightness, width * dot5_size);
  colorDot(x5, y5, dot5_hue, 10, dot5_brightness, width * dot5_size * 0.25);
  
          // Dot 6
  dot6_angle = (dot6_angle + elapsedTime * dot6_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius6 = 0.08;
  float x6 = 40*9 + width * radius6 * cos(dot6_angle);
  float y6 = width/2 + width * radius6 * sin(dot6_angle);
  colorDot(x6, y6, dot6_hue, 80, dot6_brightness, width * dot6_size);
  colorDot(x6, y6, dot6_hue, 10, dot6_brightness, width * dot6_size * 0.25);
  
  // Dot 7
  dot7_angle = (dot7_angle + elapsedTime * dot7_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius7 = 0.08;
  float x7 = width/2 + width * radius7 * cos(dot7_angle);
  float y7 = height/2 + width * radius7 * sin(dot7_angle);
  colorDot(x7, y7, dot7_hue, 80, dot7_brightness, width * dot7_size);
  colorDot(x7, y7, dot7_hue, 10, dot7_brightness, width * dot7_size * 0.25);

  // Dot 8
  dot8_angle = (dot8_angle + elapsedTime * dot8_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius8 = 0.08;
  float x8 = 40*5 + width * radius8 * cos(dot8_angle);
  float y8 = width/2 + width * radius8 * sin(dot8_angle);
  colorDot(x8, y8, dot8_hue, 80, dot8_brightness, width * dot8_size);
  colorDot(x8, y8, dot8_hue, 10, dot8_brightness, width * dot8_size * 0.25);
   
    // Dot 9
  dot9_angle = (dot9_angle + elapsedTime * dot9_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius9 = 0.08;
  float x9 = 40*3 + width * radius9 * cos(dot9_angle);
  float y9 = width/2 + width * radius9 * sin(dot9_angle);
  colorDot(x9, y9, dot9_hue, 80, dot9_brightness, width * dot9_size);
  colorDot(x9, y9, dot9_hue, 10, dot9_brightness, width * dot9_size * 0.25);
  
      // Dot 10
  dot10_angle = (dot10_angle + elapsedTime * dot10_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius10 = 0.08;
  float x10 = width/2 + width * radius10 * cos(dot10_angle);
  float y10 = 40*9 + width * radius10 * sin(dot10_angle);
  colorDot(x10, y10, dot10_hue, 80, dot10_brightness, width * dot10_size);
  colorDot(x10, y10, dot10_hue, 10, dot10_brightness, width * dot10_size * 0.25);
  
        // Dot 11
  dot11_angle = (dot11_angle + elapsedTime * dot11_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius11 = 0.08;
  float x11 = width/2 + width * radius11 * cos(dot11_angle);
  float y11 = 40*5 + width * radius11 * sin(dot11_angle);
  colorDot(x11, y11, dot11_hue, 80, dot11_brightness, width * dot11_size);
  colorDot(x11, y11, dot11_hue, 10, dot11_brightness, width * dot11_size * 0.25);
  
          // Dot 12
  dot12_angle = (dot12_angle + elapsedTime * dot12_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius12 = 0.08;
  float x12 = 40*9 + width * radius12 * cos(dot12_angle);
  float y12 = width/2 + width * radius12 * sin(dot12_angle);
  colorDot(x12, y12, dot12_hue, 80, dot12_brightness, width * dot12_size);
  colorDot(x12, y12, dot12_hue, 10, dot12_brightness, width * dot12_size * 0.25);
  

}