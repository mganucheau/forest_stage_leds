// This is an empty Processing sketch with support for Fadecandy.

OPC opc;

void setup()
{
  size(600, 300);
  opc = new OPC(this, "unicorn.local", 7890);

  opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
}

void draw()
{
  background(0);

  // Draw each frame here
}

