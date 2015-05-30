// April Arcus, 2014

int numParticles = 10;

OPC opc;
PImage dot;
PImage planck;
KtoRGB KtoRGB;
Particle[] particles;
float heat;

void setup()
{
  size(800, 200, P3D);
  frameRate(15);
  smooth();
  heat = 3000;

  dot = loadImage("dot.png");
  KtoRGB = new KtoRGB();

  // Connect to the local instance of fcserver
  opc = new OPC(this, "unicorn.local", 7890);

  opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
  
  particles = new Particle[numParticles];
  
  for (int i=0; i < particles.length; i++) {
     particles[i] = new Particle(random(height),heat); 
  }

}

void draw()
{
  background(0);

  for (int i = 0; i < particles.length; i++) {
    if (particles[i].center.x < 0 || particles[i].center.x > width || 
        particles[i].center.y < 0 || particles[i].center.y > height ||
        particles[i].temperature < 800) {
      particles[i] = new Particle(height-50,heat);
    }
    particles[i].draw();
  }
}

