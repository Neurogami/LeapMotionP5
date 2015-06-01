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


class State {

  int stateNum;
  int nextState;
  color stateColor;
  
  State( int stateNum, int nextState, color c) {
  
  this.stateNum   = stateNum;
  this.nextState  = nextState;
  this.stateColor = c;
  }

  public int nextState() {
    return this.nextState;
  }
  
  public color col() {
    return this.stateColor;
  }

 public int num() {
    return this.stateNum;
  }

}

ConcurrentHashMap<Integer, State> stateMap = new ConcurrentHashMap<Integer, State>();

int currentState = 0;
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
  // State s1 = new State(0, 1, color(255, 200, 200) );

stateMap.clear();

stateMap.put( 0,  new State(0, 1, color(255, 200, 200) ));
stateMap.put( 1, new State(1, 2, color(200, 255, 200) ) );
stateMap.put( 2, new State(2, 0, color(200, 200, 255) ) );


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

    Iterator<String> iterate = gestureInfo.keySet().iterator();
    while (iterate.hasNext() ) {
      String gi =  iterate.next();
      decay = gestureInfo.get(gi);
      fill(rgb, decay*DECAY_CO);   

      text(" " + gi, x, y);
      y += delta;
      decay--;

      if (decay < 1) {
        iterate.remove();
      } else {
        gestureInfo.put(gi, decay);
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

//  stateMap.get(currentState).col();
  background( stateMap.get(currentState).col());


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


void setNextState() {
  currentState = stateMap.get(currentState).nextState()  ;
}

