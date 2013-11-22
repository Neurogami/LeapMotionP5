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

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }
  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  d(lp.toString());

  return lp;
}



//-------------------------------------------------------------------
void draw() {
  background(255);

  if (globalHands!=null) {
    if (globalHands.count() > 0 ) {

      d("\tDraw: Have globalHands.count() = " + globalHands.count() );
      d("****************** Hand ****************************");
      Hand hand = globalHands.get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        d("Fingers!");
        avgPos = Vector.zero();
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        d("avgPos x: " + avgPos.getX() );

      } // if fingers
    } //  if hands 
    writePosition();
  }
}



