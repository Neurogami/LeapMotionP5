

import com.neurogami.leaphacking.*;
import com.leapmotion.leap.*;

import java.awt.DisplayMode;
import java.awt.Frame;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.core.PApplet;


SimpleOSCListener listener   = new SimpleOSCListener();
Controller      controller = new Controller(listener);

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


float locX = 0;
float locY = 0;
float locZ = 0;


int currentState = 0;
int maxStates = 1;
HashMap<Integer,String> stateMap;

int lastStateChange = millis();
int STATE_CHANGE_DELAY = 1000;

int placementFlag = 0;

//-------------------------------------------------------------------
void setup() {
  config = new Configgy("config.jsi");  


  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();

  size(config.getInt("width"), config.getInt("height")); // Is there a better rendering option?

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
  
  updateCursorValues(listener);  
  renderCursor();
  renderConfidenceBorder();

  if ( listener.havePinch()  ) { onPinchEvent(); }
  if ( listener.haveOpenHandSwipe()  ) { onSwipeEvent(); }

  if (keyPressed) {
    if (key == 's' || key == 'S') {
      onSwipeEvent();
    }
    if (key == 'p' || key == 'P') {
      onPinchEvent();
    }  
  } 

}

//-------------------------------------------------------------------
void setCoordArgs() {
  args.clear();
  args.put('x', listener.normalizedAvgPos().getX() );
  args.put('y', listener.normalizedAvgPos().getY());
  args.put('z', listener.normalizedAvgPos().getZ());
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




