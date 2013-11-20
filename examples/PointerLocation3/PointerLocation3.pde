import com.neurogami.leaphacking.*;

LeapMotionP5 leap;

void setup() {
  size(displayWidth-30, displayHeight-30, OPENGL);
  leap = new LeapMotionP5(this);
}


//-------------------------------------------------------------------
void draw() {
  background(255);

  if (leap.hands() != null) {
    if (leap.hands().count() > 0 ) {

      println("\tDraw: Have leap.hands().count() = " + leap.hands().count() );
      println("****************** Hand ****************************");
      Hand hand = leap.hands().get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println(" ******** Fingers " + fingers.count() + " ****** ");
      
        avgPos = Vector.zero();
        
        for (Finger finger : fingers) {
          avgPos = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );
       writePosition();
      } // if fingers
    
    } //  if hands 

  }
}


