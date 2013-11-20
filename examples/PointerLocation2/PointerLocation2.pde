import com.neurogami.leaphacking.*;

PointerListener listener = new PointerListener();
Controller controller    = new Controller(listener);


// Vector avgPos;


/******************************************************************/
boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight, OPENGL);
}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector lp = new Vector( avgPos);


  // Although the point-rendering is restricted to the size of the screen,
  // it's interesting to see the range values detected.
  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(lp);

  return lp;
}



//-------------------------------------------------------------------
void draw() {
  background(255);

  if (globalHands!=null) {
    if (globalHands.count() > 0 ) {

      println("\tDraw: Have globalHands.count() = " + globalHands.count() );
      println("****************** Hand ****************************");
      Hand hand = globalHands.get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println("Fingers!");
        avgPos = Vector.zero();
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );

      } // if fingers
    } //  if hands 
    writePosition();
  }
}



