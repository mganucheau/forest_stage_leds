OPC opcc,opcu,opcs,opct,opca;
import ddf.minim.analysis.*;
import ddf.minim.*;

PImage dot;
PImage colors;
Minim minim;
AudioInput in;
FFT fft;
float[] fftFilter;

float spin = 0.001;
float radiansPerBucket = radians(2);
float decay = .96;
float opacity = 20;
float minSize = 0.0001;
float sizeScale = .5;


void setup()
{
  size(500, 500, P3D);

 minim = new Minim(this); 

  // Small buffer size!
  in = minim.getLineIn();

  fft = new FFT(in.bufferSize(), in.sampleRate());
  fftFilter = new float[fft.specSize()];

  dot = loadImage("dot.png");
  colors = loadImage("colors.png");

  // Connect to the local instance of fcserver
  opcc = new OPC(this, "cloud.local", 7890);
  opcu = new OPC(this, "unicorn.local", 7890);
  opcs = new OPC(this, "strawberry.local", 7890);
  opct = new OPC(this, "toast.local", 7890);
  opca = new OPC(this, "apple.local", 7890);


  if (opcc != null){
    println("Initializing Cloud");
    opcc.ledStrip(0, 16, width/2, height/2, width / 70.0, 0, false);
    opcc.ledStrip(1000, 16, width/2, height/2-15, width / 70.0, 0, false);
    opcc.ledStrip(2000, 16, width/2, height/2-30, width / 70.0, 0, false);
    opcc.ledStrip(3000, 48, width/2, height/2+15, width / 70.0, 0, false);
    opcc.ledStrip(4000, 32, width/2, height/2+30, width / 70.0, 0, false);
    opcc.ledStrip(5000, 32, width/2, height/2+45, width / 70.0, 0, false);
    
    opcc.startConnect();
  }
 
  if (opcu != null){
    println("Initializing Unicorn");
    opcu.ledStrip(0, 32, width/2, height/2-10, width / 70.0, 0, false);
    opcu.ledStrip(1000, 64, width/2, height/2-25, width / 70.0, 0, false);
    opcu.ledStrip(2000, 32, width/2, height/2-35, width / 70.0, 0, false);
    
    opcu.startConnect();
  }
  
  if (opcs != null){
    println("Initializing Strawberry");
    opcs.ledStrip(0, 24, width/2, height/2-45, width / 70.0, 0, false);
    opcs.ledStrip(1000, 16, width/2, height/2+20, width / 70.0, 0, false);
    
    opcs.startConnect();
  }
  
  if (opct != null){
    println("Initializing Toast");
    opct.ledStrip(0, 32, width/2+10, height/2-5, width / 70.0, 0, false);
    
    opct.startConnect();
  }
  
  if (opca != null){
    println("Initializing Apple");
    opca.ledStrip(0, 16, width/2, height/2+5, width / 70.0, 0, false);
    opca.ledStrip(1000, 16, width/2, height/2-50, width / 70.0, 0, false);
    opca.ledStrip(2000, 48, width/2, height/2-40, width / 70.0, 0, false);
    opca.ledStrip(3000, 16, width/2, height/2+50, width / 70.0, 0, false);

    opca.startConnect();    
  }
}

void draw()
{
  background(0);

  fft.forward(in.mix);
  for (int i = 0; i < fftFilter.length; i++) {
    fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
  }
 
  for (int i = 0; i < fftFilter.length; i += 3) {   
    color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height/2);
    tint(rgb, fftFilter[i] * opacity);
    blendMode(ADD);
 
    float size = height * (minSize + sizeScale * fftFilter[i]);
    PVector center = new PVector(width * (fftFilter[i] * 0.2), 0);
    center.rotate(millis() * spin + i * radiansPerBucket);
    center.add(new PVector(width * 0.5, height * 0.5));
 
    image(dot, center.x - size/2, center.y - size/2, size, size);
  }
}


