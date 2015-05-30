OPC opc;
import processing.video.*;
Movie myMovie;

void setup() {
  size(640, 480);
  frameRate(30);
  myMovie = new Movie(this, "water.avi");
  myMovie.loop();

  opc = new OPC(this, "unicorn.local", 7890);
  opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
}

void draw() {
  image(myMovie, 0, 0);
}

void movieEvent(Movie m) {
  m.read();
}

