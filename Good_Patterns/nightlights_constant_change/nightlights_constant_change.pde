OPC opcc,opcu,opcs,opct,opca;
int SCREENWIDTH  = 200;
int SCREENHEIGHT = 200;

int GRADIENTLEN = 1500;
// use this factor to make things faster, esp. for high resolutions
int SPEEDUP = 1;
 
// swing/wave function parameters
int SWINGLEN = GRADIENTLEN*3;
int SWINGMAX = GRADIENTLEN / 2 - 1;
 
// gradient & swing curve arrays
private int[] colorGrad;
private int[] swingCurve;

void setup()
{
size(200, 200);
    makeGradient(GRADIENTLEN);
    makeSwingCurve(SWINGLEN, SWINGMAX);


  //// Connect to the local instance of fcserver
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
    opct.ledStrip(0, 32, width/2, height/2-2, width / 70.0, 0, false);
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

void draw() {
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
    println(millis()  % 10);
    
    if (millis() % 2 == 1) {
      makeGradient(GRADIENTLEN);
    }
}
 
// create a new random gradient when mouse is pressed
void mousePressed() {
    if (mouseButton == LEFT)
        makeGradient(GRADIENTLEN);
    else if (mouseButton == RIGHT)
        makeSwingCurve(SWINGLEN, SWINGMAX);
}
   
// fill the given array with a nice swingin' curve
// three cos waves are layered together for that
// the wave "wraps" smoothly around, uh, if you know what i mean ;-)
void makeSwingCurve(int arrlen, int maxval) {
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
    int rf = 1;
    int gf = 1;
    int bf = 2;
    int rd = 804;
    int gd = 1137;
    int bd = 547;
    
    
    if (colorGrad == null) {
        // first call
        colorGrad = new int[GRADIENTLEN];
    } else {
        // we are called again: random gradient
        //rf = rf;
        //gf = gf;
        //bf = bf;
        //rd = (rd + millis() / 17) % arrlen;
        gd = (gd + millis() / 1000) % arrlen;
       bd = (bd + millis() / 1000) % arrlen;
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