// Goal: Do something that relies on new API stuff
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
import saito.objloader.*;


boolean DEBUG = true;
LeapListener listener = new LeapListener();
Controller controller    = new Controller(listener);


OBJModel model;
float rotX, rotY, rotZ;


com.leapmotion.leap.Vector handPos           = com.leapmotion.leap.Vector.zero();
com.leapmotion.leap.Vector normalizedHandPos = com.leapmotion.leap.Vector.zero();

int SHOOT_COUNTDOWN_MAX = 10;

boolean readyToShoot = false;
int shootCountdown = 0;


void d(String msg) {
  if(DEBUG){println(msg);}
}

int mapXforScreen(float xx) {
  return( int( map(xx, 0.0, 1.0, 0.0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {
  return( int( map(yy, 0.0, 1.0,  height, 0) ) );
}

int mapZforScreen(float f) {
  return( int( map(f, 0.0, 1.0, -20, 200) ) );
}


//-------------------------------------------------------------------
boolean sketchFullScreen() {
  //return true;
  return false;
}

//-------------------------------------------------------------------
void setup() {
  size(displayWidth, displayHeight, OPENGL);
  //  size(displayWidth, displayHeight, P3D);

  model = new OBJModel(this, "jgb-experiment.obj", "absolute", TRIANGLES);
  model.enableDebug();
  model.scale(40);
  model.translateToCenter();
}

//-------------------------------------------------------------------
Vector lastPos() {
  // Vector lp = new Vector(handPos);
  Vector normlp = new Vector( normalizedHandPos);
  d(normlp.toString());
  return normlp ;
}

//-------------------------------------------------------------------
color grabStrengthToColor(Hand h) {
  // grabStrength runs from 0 to 1.
  // The idea is to slide from yellow to red
  // Docs say the value should range from 0 to 1 but 
  // values >1 do appear.  
  float gs = constrain(h.grabStrength(), 0.0, 1.0);
  println("\tgrab strength:\t" + gs );
  return color( (int) map(gs, 0,1, 0,255), (int) map(gs, 0,1, 255, 0), 0);
}


//-------------------------------------------------------------------
void draw() {
  int extendedFingers = 0;
  color bg = color(255);

  background(bg);
  Hand hand;

  shootCountdown--;

  if (shootCountdown > 0) { 
    bg = color(0,0,255); 
  } else { 
    shootCountdown = 0; 
  }


  if (globalHands!=null) {
    if (globalHands.count() > 0 ) {

      d("\tDraw: Have globalHands.count() = " + globalHands.count() );
      d("****************** Hand ****************************");
      hand = globalHands.get(0);

      if (shootCountdown < 1 ) {
        bg = grabStrengthToColor(hand);
        background(bg);
      }

      println("Is hand 0 the left hand? " + hand.isLeft() );


      FingerList fingers = hand.fingers();

      // Seems there are ALWAYS five fingers detected.
      // But you can check if  afinger is extended.
      // Ths actually works well for the "gun-hand pulls trigger" detection
      if (fingers.count() >= 1) {
        d("\t* " + fingers.count() + " Fingers!");
        handPos = Vector.zero();

        for (Finger finger : fingers) {
          println("\t* finger type:\t" + finger.type() + "\t is extended? " + finger.isExtended() );
          if  (finger.isExtended() ) {
            if( finger.type().toString().equals("TYPE_INDEX") ) {
              readyToShoot = true;
            }
            extendedFingers++;
            handPos  = handPos.plus(finger.tipPosition());
          } else  {
            if ( finger.type().toString().equals("TYPE_INDEX") ) {
              println(" - - - - - INDEX is not extended, readyToShoot = "+readyToShoot+";hand.grabStrength()  = " + hand.grabStrength()  );
              if (readyToShoot &&  (shootCountdown == 0 ) && hand.grabStrength() > 0.2  ) {
                readyToShoot = false;
                shootCountdown = SHOOT_COUNTDOWN_MAX;
              }
            }
          }

        }



        if (extendedFingers>0) {
          handPos = hand.palmPosition(); //handPos.divide(extendedFingers);
          d("handPos x: " + handPos.getX() );
          normalizedHandPos = box.normalizePoint(handPos, true);
        }
      } // if fingers
      background(bg);
      renderHand(hand);

    } else { 
      background(bg); 
    } 

  }

}



// So fr, the hand (really the gun model) stays at a fixed rotation
// to mimic "gansta" shooting style.
//
// The gun will tilt up/down and left/right.
//
// It does not move in or out based on Leap Z location.
//
// A goal is to be able to draw a line parallel to the gun barrel
// out towards some target some distance away.
// We can get Hand direction().
//
//  Given that,  assume for now we want a line for the
//  hand "location" AKA palm postition
//
//  Let's start with a line that just goes from the palm center
//  to a fixed point.
//  
//  The next trick is to draw a draw parallel to the direction of the hand
//
//      P2 = P1 + n * V
//  
//  Whihc should be "destination point is the current point + some distance N * the unit vector of direction.
//   
void renderHand(Hand hand){

  rotZ = -1.5; 
  rotY = -1 * hand.direction().yaw();
  rotX = -1 * hand.direction().pitch();

  if (hand.isLeft() ) { rotZ *= -1; }

  // lastPos returns a normalizedHandPostion (which comes from palm postion)
  // This means the values are in a 0..1 range
  int yLoc = mapYforScreen(lastPos().getY());
  int xLoc = mapXforScreen(lastPos().getX());
  int zLoc =  mapZforScreen(lastPos().getZ());
  println("Hand pitch:\t" + hand.direction().pitch());


  fill(255,0,0);
  strokeWeight(10);

  ellipse(xLoc, yLoc,  100, 100); 

  strokeWeight(20);
  stroke(255, 128,126);
  line( xLoc, yLoc,  width/2, height/2);

  //      P2 = P1 + n * V
  stroke(128, 128, 255);
  int shotDistance = 10;


  int count = 20;
  com.leapmotion.leap.Vector distV;
  for(int n=count; n > 0; n--) {
    distV =  handPos.plus(hand.direction().times(shotDistance * n));
    distV = box.normalizePoint(distV, true);
    //println("distV is\t\t" + distV );
    stroke(n*10);
    strokeWeight( count - n );
    //  println("mapXforScreen(distV.getX()) = " + mapXforScreen(distV.getX()) ); 
    ellipse(mapXforScreen(distV.getX()), mapYforScreen(distV.getY()),  count-n, count-n );   
  }

  distV =  handPos.plus(hand.direction().times(shotDistance * count));
  distV = box.normalizePoint(distV, true);

  line( xLoc, yLoc, 0,   mapXforScreen(distV.getX()),  mapYforScreen(distV.getY()), - (shotDistance * count)) ;

  lights();

  pushMatrix();  //-------------------------------------------------------

  translate(xLoc, yLoc, zLoc );
  BoundingBox bbox = new BoundingBox(this, model);
  println("moidel box center:\t" + bbox.getCenter());


  // translate(xLoc, yLoc, 0 ); 
  rotateX(rotX);
  rotateY(rotY);
  rotateZ(rotZ);
  strokeWeight(0);
  model.draw();

  popMatrix(); //-------------------------------------------------------


  strokeWeight(0);


}

