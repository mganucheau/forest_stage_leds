OPC opc;
PImage im;

float speed = 0.02;

void setup()
{
  size(800, 200);

  // Load a sample image
  im = loadImage("twinkle-lights.jpg");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "unicorn.local", 7890);

  // Map one 64-LED strip to the center of the window
  opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
}

void draw()
{
  // Scale the image so that it matches the width of the window
  int imHeight = im.height * width / im.width;


  float newmouseX = map(mouseX, 0, width, 0.01, 0.07);
  // Scroll down slowly, and wrap around
  speed = newmouseX;
  float y = (millis() * -speed) % imHeight;
  
  // Use two copies of the image, so it seems to repeat infinitely  
  image(im, 0, y, width, imHeight);
  image(im, 0, y + imHeight, width, imHeight);
}

