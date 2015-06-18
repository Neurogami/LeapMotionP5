import com.neurogami.leaphacking.*;
import com.leapmotion.leap.*;

import java.util.Map;


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


//-------------------------------------------------------------------
void setup() {
  config = new Configgy("config.jsi");  

  size(config.getInt("width"), config.getInt("height"), P2D); // Is there a better rendering option?
  brushWidth = config.getInt("brushWidth");
  pinchThreshold = config.getFloat("pinchThreshold");

  args =  new HashMap<Character,Float>();
  osc = new OscManager(config);
  pinchMsgFormats = config.getStringList("pinch");
  pinchMsgFormatCount = pinchMsgFormats.length;
  

}

//-------------------------------------------------------------------
void draw() {
  background(255);
  
  updateCursorValues(listener);  
   
  if ( listener.havePinch()  ) { onPinchEvent(); }

  if (keyPressed) {
    if (key == 'c' || key == 'C') {
      onCircleEvent();
    }
    if (key == 'p' || key == 'P') {
      onPinchEvent();
    }  

  } 

  renderCursor();
  renderConfidenceBorder();
  print(".");
}



//-------------------------------------------------------------------
void onPinchEvent() {

  args.clear();
  args.put('x', listener.normalizedAvgPos().getX() );
  args.put('y', listener.normalizedAvgPos().getY());
  args.put('z', listener.normalizedAvgPos().getZ());
  
  println("call sendBundle with " + args.toString() );

  osc.sendBundle(pinchMsgFormats, args );

}

//-------------------------------------------------------------------
void onCircleEvent() {


}


