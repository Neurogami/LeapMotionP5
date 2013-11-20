import com.neurogami.leaphacking.*;

PointerListener listener = new PointerListener();
Controller controller    = new Controller(listener);

/******************************************************************/
boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight, OPENGL);
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



