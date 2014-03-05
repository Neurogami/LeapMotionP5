// Goal: Render info about the current hand, including left or right hand, and joint data
/*

  file:///C:/Users/james/Dropbox/LeapMotion/LeapDeveloperKit_skeleton-api_win_1.3.0+12767/LeapSDK/docs/cpp/devguide/Intro_Skeleton_API.html 

The additions include:

Identification of right or left handedness
Identification of digits
Reporting of the positions of each finger joint
Reporting of grip factors indicating whether a user is pinching or grasping
Reporting of five fingers for each hand
Reporting whether a finger is extended or not


Perhaps the most significant change for existing applications is the improved 
persistence of hands and fingers. This should improve the usability of most 
Leap Motion-enabled apps. However, if you relied on fingers disappearing when 
curled into the hand or when they touched, then you may have to make some changes. 
For example, if you count visible fingers or otherwise distinguish between fingers 
extended outward and those retracted toward the hand, you will have to use at the 
new isExtended finger properties to know which fingers are extended or not. 

If, on the other hand, you relied on fingers disappearing when they touched each 
other, then you will have to establish a minimum distance threshold between the 
finger tips instead, since the fingers will no longer disappear.

The new skeleton model
As noted already, the changes in the API to support the new skeletal model are surprisingly small. The changes are:

Hand class:

Hand.isLeft
Hand.isRight
Hand.grabStrength
Hand.pinchStrength


 */

import com.neurogami.leaphacking.*;

PointerListener listener = new PointerListener();
Controller controller    = new Controller(listener);

//-------------------------------------------------------------------
boolean sketchFullScreen() {
  return true;
}

//-------------------------------------------------------------------
void setup() {
  size(displayWidth, displayHeight, OPENGL);
  DEBUG = true;
}

//-------------------------------------------------------------------
Vector lastPos() {
  Vector lp = new Vector(avgPos);
  Vector normlp = new Vector( normalizedAvgPos);

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }
  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  d(normlp.toString());

  return normlp ;
}

color grabStrengthToColor(Hand h) {
  // grabStrength runs from 0 to 1.
  // The idea is to slide from yellow to red
  // Docs say the value should range from 0 to 1 but 
  // values >1 do appear.  
  float gs = constrain(h.grabStrength(), 0.0, 1.0);

  println("\tgrab strength:\t" + gs );
  
  if (gs > 1.0) {
    // Oddness.  The previous println seems to occasionally show values > 1.0, but this 
    // println does get get executed ...
   println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! gs > 1.0 : " + gs + " !!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  }

  return color( (int) map(gs, 0,1, 0,255), (int) map(gs, 0,1, 255, 0), 0);

}
//-------------------------------------------------------------------
void draw() {
  int extendedFingers = 0;
  color bg = color(255);

  background(bg);

  if (globalHands!=null) {
    if (globalHands.count() > 0 ) {

      d("\tDraw: Have globalHands.count() = " + globalHands.count() );
      d("****************** Hand ****************************");
      Hand hand = globalHands.get(0);
      bg = grabStrengthToColor(hand);

      println("Is hand 0 the left hand? " + hand.isLeft() );


      FingerList fingers = hand.fingers();
      
      // Seems there are ALWAYS five fingers detected.
      // But you can check if  afinger is extended.
      // Ths actually works well for the "gun-hand pulls trigger" detection
      if (fingers.count() >= 1) {
        d("\t* " + fingers.count() + " Fingers!");
        avgPos = Vector.zero();
 
        for (Finger finger : fingers) {
          println("\t* finger type:\t" + finger.type() + "\t is extended? " + finger.isExtended() );
          if  (finger.isExtended() ) {
              extendedFingers++;
              avgPos  = avgPos.plus(finger.tipPosition());
          }

        }

        

        if (extendedFingers>0) {
          avgPos = avgPos.divide(extendedFingers);
          d("avgPos x: " + avgPos.getX() );
          normalizedAvgPos = box.normalizePoint(avgPos, true);
        }
      } // if fingers
    } //  if hands 
    background(bg);

    writePosition();
  }
}


