OPC opcc,opcu,opcs,opct,opca;
PImage im;

void setup()
{
  size(400, 100);
  colorMode(HSB, 100);

  // Load a sample image
  im = loadImage("flames.jpeg");

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
    opct.ledStrip(1000, 51, width/2, height/2-7, width / 70.0, 0, false);
    
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
  // Scale the image so that it matches the width of the window
  int imHeight = im.height * width / im.width;

  // Scroll down slowly, and wrap around
  float speed = 0.05;
  float y = (millis() * -speed) % imHeight;
  
  // Use two copies of the image, so it seems to repeat infinitely  
  image(im, 0, y, width, imHeight);
  image(im, 0, y + imHeight, width, imHeight);

}