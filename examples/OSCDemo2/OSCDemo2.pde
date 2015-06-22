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

char SPACE = ' ';
int extendedFingerCount = 0;

float ps;


int textSize = 18;
float locX = 0;
float locY = 0;
float locZ = 0;

int currentState = 0;
int maxStates = 1;
HashMap<Integer,String> stateMap;
HashMap<Integer,Integer> muteMap;


int lastMuteChange  = millis();
int lastStateChange = millis();
int SPACE_CHANGE_DELAY = 100;
int STATE_CHANGE_DELAY = 1000;

int placementFlag = 0;

boolean handSpread;
boolean handSpreadSwipe;
float currentConfidence; 
GestureList gestureList;  

// This example is going to end up with a number of things
// that are specific to the song and the designated OSC messages
// A better sketch might have  away to isolate these things
// or make them configurable or something.

boolean[] trackMuteLastSent = new boolean[5];

//-------------------------------------------------------------------
void setup() {
  config = new Configgy("config.jsi");  

  for(int x=0; x< trackMuteLastSent.length; x++) 
      trackMuteLastSent[x] = false;

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();

  size(config.getInt("width"), config.getInt("height")); // Is there a better rendering option?
  noLoop(); // The sketch will call `redraw` as needed; that in turn calls `draw`

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
  muteMap = config.getHashMapNN("muteMapping"); 
  maxStates = stateMap.size();

  setCurrentMessages();
  lastStateChange = millis();

}




//-------------------------------------------------------------------
void draw() {
  background(255);
  textSize(textSize);
  fill(20);
  text(currentState, 4, textSize+4);
  text(extendedFingerCount, height-textSize, width-textSize);
  // TODO: Find out why the placement code needs repeated invocation
  if (placementFlag < 2) { placeWindow(); }

  updateCursorValues();  
  renderCursor();
  renderConfidenceBorder();
}


int getExtendedFingerCount(FingerList fingers) {
  int n = 0;
    for (Finger finger : fingers) {
    if ( finger.isExtended() ) n++;
  }

    return n;

}

//-------------------------------------------------------------------
void onFrame(com.leapmotion.leap.Controller controller) {
  com.leapmotion.leap.Frame frame = controller.frame();
  InteractionBox box = frame.interactionBox();
  HandList hands = frame.hands();
  extendedFingerCount  = 0;

  if (hands.count() > 0 ) {
    Hand hand = hands.get(0);
    currentConfidence = hand.confidence(); 
    FingerList fingers = hand.fingers();
    extendedFingerCount = getExtendedFingerCount(fingers);
    if (extendedFingerCount > 0) {
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


void onSpaceFingers(int numFingers) {
println("* * * * *  onSpaceFingers " + numFingers);
  if (millis() - lastMuteChange > SPACE_CHANGE_DELAY) { 
    lastMuteChange = millis();
    // TODO Figure out a way to make this behavior configurable
    sendMuteOsc(numFingers); 
  }

}


void keyPressed() {
  if (keyCode == SPACE ) {
    println( " SPACE .. extendedFingerCount = " + extendedFingerCount );
    if (extendedFingerCount > 0) {
      onSpaceFingers(extendedFingerCount); 
    }
  }
}


void sendMuteOsc(int numFingers) {

println("sendMuteOsc: " + numFingers);
// How do we send no args?
//  So far we have been send string arrays like this:
//  ["/renoise/song/track/2/device/2/set_parameter_by_name", "s:Y-Axis,y"]
   
  String[][] muteMessage = new String[1][2];
  String cmd = "mute";

  if (trackMuteLastSent[numFingers-1]) { /// last sent was true; i.e. mute
      cmd  = "unmute";
     trackMuteLastSent[numFingers-1] = false;
  }     else {
   trackMuteLastSent[numFingers-1] = true;
  }


  println("trackMuteLastSent[numFingers-1] = " + trackMuteLastSent[numFingers-1] );

    muteMessage[0][0] = "/renoise/song/track/"+muteMap.get(numFingers)+"/" + cmd;
    muteMessage[0][1] = "" ;
   osc.sendBundle(muteMessage, args);
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



