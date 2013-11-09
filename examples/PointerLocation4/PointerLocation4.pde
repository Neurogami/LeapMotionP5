import com.neurogami.leaphacking.*;

Vector avgPos;

float yMax, xMax;
float yMin, xMin;

LeapMotionP5 leap;


void setup() {
  size(displayWidth-30, displayHeight-30, OPENGL);

  noLoop();
  yMax = xMax =  -100;
  yMin = xMin =  1300;

  avgPos = Vector.zero();
  leap = new LeapMotionP5(this, true);
  leap.allowBackgroundProcessing(true);
  
}

void onFrame(com.leapmotion.leap.Controller controller) {
  println("SKETCH onFrame!");
  processController(controller);
}

void processController(com.leapmotion.leap.Controller controller) {


  Frame frame = controller.frame();
  HandList hands = frame.hands();

  if (hands != null) {
    if (hands.count() > 0 ) {

      println("\tDraw: Have hands.count() = " + hands.count() );
      println("****************** Hand ****************************");
      Hand hand = hands.get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println(" ******** Fingers " + fingers.count() + " ****** ");

        avgPos = Vector.zero();

        for (Finger finger : fingers) {
          avgPos = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );

        //       writePosition();
        redraw();
      } // if fingers

    } //  if hands 

  }

}
//-------------------------------------------------------------------
void draw() {
  background(255);

  writePosition();
}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector  lp = avgPos;

  // Although the point-rendering is restricted to the size of the screen,
  // it's interesting to see the range values detected.
  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(lp);

  return lp;
}



int mapXforScreen(float xx) {
  int topX = 150;
  int x  = constrain( int(xx), topX * -1, topX);
  return( int( map(x, topX * -1, topX, 0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {

  int topY = 300;
  int y  = constrain( int(yy), 0, topY);

  return( int( map(y, 0, topY,  height, 0) ) );
}


//-------------------------------------------------------------------
int zToColorInt(float fz) {

  int z = int(fz);

  int minZ = -220;
  int maxZ = 200;

  if (z < minZ) {
    return 0;
  }

  if (z > maxZ) {
    return 255;
  }

  return int(map(z, minZ, maxZ,  0, 255));
}

void writePosition(){

  int zMap = zToColorInt(lastPos().getZ());
  int baseY = mapYforScreen( lastPos().getY() );
  int inc = 30;
  int xLoc = mapXforScreen(lastPos().getX()); 

  textSize(32);
  fill(zMap, zMap, zMap);

  println("lastPos() X : " + lastPos() );
  text("X: " + lastPos().getX() , xLoc, baseY);
  text("Y: "  + lastPos().getY(), xLoc, baseY + inc*2 );
  text("Z: "  + lastPos().getZ(), xLoc, baseY + inc*3 );

  text("min X: "  + xMin, xLoc, baseY + inc*4 );
  text("max X: "  + xMax, xLoc, baseY + inc*5 );

  text("min Y: "  + yMin, xLoc, baseY + inc*6 );
  text("max Y: "  + yMax, xLoc, baseY + inc*7 );

}
