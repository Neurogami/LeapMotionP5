import com.neurogami.leaphacking.*;
import com.leapmotion.leap.*;

import java.awt.DisplayMode;
import java.awt.Frame;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.core.PApplet;

LeapMotionP5 leap;

Configgy config;

float pinchThreshold = 0.9;

String addrPatternPinch;
String addrPatternCircle;

OscManager osc;

String addressPattern;
String argOrder;
HashMap<Character,Float> args;
String[][] pinchMsgFormats;
int pinchMsgFormatCount;

float ps;

float locX = 0;
float locY = 0;
float locZ = 0;


int currentState = 0;
int maxStates = 1;
HashMap<Integer,String> stateMap;

int lastStateChange = millis();
int STATE_CHANGE_DELAY = 1000;

int placementFlag = 0;

boolean handSpread;
boolean handSpreadSwipe;
float currentConfidence; 
GestureList gestureList;  

//-------------------------------------------------------------------
void setup() {
  config = new Configgy("config.jsi");  


  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();

  size(config.getInt("width"), config.getInt("height")); // Is there a better rendering option?
  noLoop();
  // Use this constructor: LeapMotionP5(PApplet ownerP, boolean useCallbackListener )
  // It means the Leap listener will call back to the onFrame method defined here
  leap = new LeapMotionP5(this, true);
  leap.allowBackgroundProcessing(true);

    currentConfidence = 0.0;

    // Currently, the callback approach does not let you do stuff in the
  // Listner instance onInit to set gestreu stuff.  But you can still do it by grabbing
  // the Controller instance that is part of the LeapMotionP5 instance.
    leap.controller.setPolicy(Controller.PolicyFlag.POLICY_BACKGROUND_FRAMES);
    leap.controller.enableGesture(Gesture.Type.TYPE_SWIPE);
    leap.controller.config().setFloat("Gesture.Swipe.MinLength", 66000.0f);
    leap.controller.config().save();


  frame.setAlwaysOnTop(true);
  placementFlag = 0;

  brushWidth = config.getInt("brushWidth");
  pinchThreshold = config.getFloat("pinchThreshold");

  args =  new HashMap<Character,Float>();
  osc = new OscManager(config);

  stateMap = config.getHashMapN("states"); 
  maxStates = stateMap.size();

  setCurrentMessages();
  lastStateChange = millis();

}




//-------------------------------------------------------------------
void draw() {
  background(255);
  textSize(32);
  fill(20);
  text(currentState, 2, 32);

  // TODO: Find out why the placement code needs repeated invocation
  if (placementFlag < 2) { placeWindow(); }

  updateCursorValues();  
  renderCursor();
  renderConfidenceBorder();

  

}



//-------------------------------------------------------------------
void onFrame(com.leapmotion.leap.Controller controller) {
  com.leapmotion.leap.Frame frame = controller.frame();
  InteractionBox box = frame.interactionBox();
  HandList hands = frame.hands();

  if (hands.count() > 0 ) {
    Hand hand = hands.get(0);
    currentConfidence = hand.confidence(); 
    FingerList fingers = hand.fingers();
    if (fingers.count() > 0) {
      gestureList = frame.gestures();
      detectOpenHandSwipe(hand);
      avgPos = Vector.zero();
      ps = constrain(hand.pinchStrength(), 0.0, 1.0);

      for (Finger finger : fingers) {
        avgPos  = avgPos.plus(finger.tipPosition());
      }

      avgPos = avgPos.divide(fingers.count());
      normalizedAvgPos = box.normalizePoint(avgPos, true);

      if (haveOpenHandSwipe() ) {onSwipeEvent();}
      if (havePinch() ) {onPinchEvent();}
    }
    redraw(); 
  } 
}


//////////////////////////////////////////////////

//------------------------------------------------------------
boolean haveSpreadHand() {
  return handSpread;
}

//------------------------------------------------------------
void detectHandSpread(Hand h) {
  handSpread = false;
  if (h.fingers().count() < 5 )  return;
  for (Finger finger : h.fingers()) {
    if ( !finger.isExtended() ) return ;
  }
  handSpread = true;
}

//------------------------------------------------------------
float currentConfidence() {
  return currentConfidence;
}

//------------------------------------------------------------
boolean haveOpenHandSwipe()  {
  return handSpreadSwipe;
}

//------------------------------------------------------------
void detectOpenHandSwipe(Hand h) {

  handSpreadSwipe = false;
  detectHandSpread(h);
  if (!haveSpreadHand() )  return;
  if ( gestureList.count() ==  0 ) return ;
  handSpreadSwipe = true;
}

//------------------------------------------------------------
boolean havePinch() {
  if (ps > pinchThreshold ) return true; 
  return false;

}

//-------------------------------------------------------------------
void setCoordArgs() {
  args.clear();
  args.put('x', normalizedAvgPos.getX() );
  args.put('y', normalizedAvgPos.getY());
  args.put('z', normalizedAvgPos.getZ());
}

//-------------------------------------------------------------------
void onPinchEvent() {
  setCoordArgs();
  osc.sendBundle(pinchMsgFormats, args );

}

//-------------------------------------------------------------------
void setCurrentMessages() {
  String mappedMsg = (String) stateMap.get(currentState); 
  pinchMsgFormats =  config.getStringList(mappedMsg);
}

//-------------------------------------------------------------------
void rotateCurrentState(){
  currentState++;
  currentState %= maxStates;
  setCurrentMessages();
}

//-------------------------------------------------------------------
void onSwipeEvent() { 
  if (millis() - lastStateChange > STATE_CHANGE_DELAY) { 
    lastStateChange = millis();
    rotateCurrentState(); 
  }
}

//-------------------------------------------------------------------
void placeWindow() {
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] gs = ge.getScreenDevices();
  java.awt.Rectangle rec = ge.getMaximumWindowBounds();
  int leftLoc = rec.width - width;
  int topLoc = rec.height - height;
  println("Place window at " + leftLoc + ", " + topLoc);
  frame.setLocation(leftLoc, topLoc);
  placementFlag++; 
}





