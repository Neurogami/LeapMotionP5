// GestureTest
import com.neurogami.leaphacking.*;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;

PointerListener listener = new PointerListener();
Controller controller    = new Controller(listener);

int DECAY_MAX = 32;
int DECAY_CO =  256/DECAY_MAX;

boolean useCurrentFrameForGestures = false;



/*

   What we want is to detect assorted gestures and such (pinching, for example)
   and then render something in response.

https://developer.leapmotion.com/documentation/java/api/Leap.Gesture.html

*/

ConcurrentHashMap<String, Integer> circleInfo     = new ConcurrentHashMap<String, Integer>();
ConcurrentHashMap<String, Integer> screenTapInfo  = new ConcurrentHashMap<String, Integer>();
ConcurrentHashMap<String, Integer> keyTapInfo     = new ConcurrentHashMap<String, Integer>();
ConcurrentHashMap<String, Integer> swipeInfo      = new ConcurrentHashMap<String, Integer>();
ConcurrentHashMap<String, Integer> pinchInfo      = new ConcurrentHashMap<String, Integer>();

ConcurrentHashMap <Integer, Gesture> handledGestures = new ConcurrentHashMap <Integer, Gesture>();

//-------------------------------------------------------------------
boolean sketchFullScreen() {
  return true;
}

//-------------------------------------------------------------------
void setup() {
  size(displayWidth, displayHeight, OPENGL);
  DEBUG = false;
}


void writeGestures( ConcurrentHashMap<String, Integer>  gestureInfo, int rgb, int xOffset) {
  writeGestures( gestureInfo,  rgb, xOffset, 50);
}

void writeGestures( ConcurrentHashMap<String, Integer>  gestureInfo, int rgb, int xOffset, int yOffset) {
  int y = yOffset;
  int x = xOffset;
  int delta = 36;
  int decay = 0;
  textSize(32);


  synchronized(this) {  

    //        println( "GT:   64" );   
    Iterator<String> iterate = gestureInfo.keySet().iterator();
     println( "GT:   66" );   
    while (iterate.hasNext() ) {
      String gi =  iterate.next();
      decay = gestureInfo.get(gi);
      println( "GT:   70" );   
      fill(rgb, decay*DECAY_CO);   

      text(" " + gi, x, y);
      y += delta;
      decay--;

      if (decay < 1) {
        println( "GT:   78" );   
        iterate.remove();
        println( "GT:   80" );   
      } else {
        println( "GT:   82" );   
        gestureInfo.put(gi, decay);
        println( "GT:   84" );   
      }
    }
  }
}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector lp = new Vector( avgPos);
  Vector normlp = new Vector( normalizedAvgPos);

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }
  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  d(normlp.toString());

  return normlp ;
}


//-------------------------------------------------------------------
void draw() {
  background(255);


  writeGestures( swipeInfo, #00ff00, 10);
  writeGestures( circleInfo, #ff0000, 270);
  writeGestures( screenTapInfo, #0000ff, 550);
  writeGestures( keyTapInfo,   #339900, 800);

  writeGestures( pinchInfo, #006699, 10, 500);

  // If onFrame is called on a seprate thread then 
  // we are likely to get race conditions on looping over the gesture info.

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
        normalizedAvgPos = box.normalizePoint(avgPos, true);

      } // if fingers
    } //  if hands 
    writePosition();
  }
}



void keyPressed() {
  if (key == 'c') {
    useCurrentFrameForGestures  = true;
  } 
  if (key == 'C') {
    useCurrentFrameForGestures = false;
  } 

}


