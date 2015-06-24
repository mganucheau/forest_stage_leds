OPC opcc,opcu,opcs,opct,opca;
import processing.video.*;
Movie myMovie;

void setup() {
  size(640, 480);
  frameRate(30);
  myMovie = new Movie(this, "water.avi");
  myMovie.loop();

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
  }
 
  if (opcu != null){
    println("Initializing Unicorn");
    opcu.ledStrip(0, 32, width/2, height/2-10, width / 70.0, 0, false);
    opcu.ledStrip(1000, 64, width/2, height/2-25, width / 70.0, 0, false);
    opcu.ledStrip(2000, 32, width/2, height/2-35, width / 70.0, 0, false);
  }
  
  if (opcs != null){
    println("Initializing Strawberry");
    opcs.ledStrip(0, 24, width/2, height/2-45, width / 70.0, 0, false);
    opcs.ledStrip(1000, 16, width/2, height/2+20, width / 70.0, 0, false);
  }
  
  if (opct != null){
    println("Initializing Toast");
    opct.ledStrip(0, 32, width/2+10, height/2-5, width / 70.0, 0, false);
  }
  
  if (opca != null){
    println("Initializing Apple");
    opca.ledStrip(0, 16, width/2, height/2+5, width / 70.0, 0, false);
    opca.ledStrip(1000, 16, width/2, height/2-50, width / 70.0, 0, false);
    opca.ledStrip(2000, 48, width/2, height/2-40, width / 70.0, 0, false);
    opca.ledStrip(3000, 16, width/2, height/2+50, width / 70.0, 0, false);    
  }
}

void draw() {
  image(myMovie, 0, 0);
}

void movieEvent(Movie m) {
  m.read();
}

