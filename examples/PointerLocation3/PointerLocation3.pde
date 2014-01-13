import com.neurogami.leaphacking.*;

import com.leapmotion.leap.*;

LeapMotionP5 leap;

void setup() {
  size(displayWidth-30, displayHeight-30, OPENGL);
  leap = new LeapMotionP5(this);
  DEBUG = true;
}


//-------------------------------------------------------------------
void draw() {
  background(255);

  if (leap.hands() != null) {
    if (leap.hands().count() > 0 ) {

      d("\tDraw: Have leap.hands().count() = " + leap.hands().count() );
      d("****************** Hand ****************************");
      Hand hand = leap.hands().get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        d(" ******** Fingers " + fingers.count() + " ****** ");
      
        avgPos = Vector.zero();
        
        for (Finger finger : fingers) {
          avgPos = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        normalizedAvgPos = leap.frame().interactionBox().normalizePoint(avgPos, true);

        d("avgPos  " + avgPos );
        d("normalizedAvgPos: " + normalizedAvgPos );
       writePosition();
      } // if fingers
    } //  if hands 
  }
}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector lp = new Vector(avgPos);
  Vector normlp = new Vector(normalizedAvgPos);


  // Although the point-rendering is restricted to the size of the screen,
  // it's interesting to see the range values detected.
  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  d(normlp .toString());

  return normlp ;
}



