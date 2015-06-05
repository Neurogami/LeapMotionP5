import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.neurogami.leaphacking.*; 
import com.leapmotion.leap.*; 
import java.util.Map; 
import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PointerLocation1 extends PApplet {




PointerListener listener   = new PointerListener();
Controller      controller = new Controller(listener);
PGraphics       drawing;

Configgy config;

float pinchThreshold = 0.9f;

//-------------------------------------------------------------------
public void setup() {
  config = new Configgy("config.jsi");  
  size(config.getInt("width"), config.getInt("height"), P2D); // Is there a better rendering option?
  drawing = createGraphics(width, height);
  brushWidth = config.getInt("brushWidth");
  minHue = config.getInt("minHue");
  maxHue = config.getInt("maxHue");
  pinchThreshold = config.getFloat("pinchThreshold");
}


//-------------------------------------------------------------------
public void draw() {
  background(255);

  updateCursorValues();  

  if (listener.haveOpenHandSwipe())   drawing = createGraphics(width, height);
  
  //  For some reason the app always starts off as if there is a pinch.
  //  For best results enter the interaction area with an open hand.
  if (listener.havePinch() ) {

     // TODO:  The code needs to paint to an offscreen buffer, adding to the image
     // when the fingers are pinched.
     // On draw(), the iamge is blt'ed to the screen and whatever else
     // gets overlayed.
     // If the hand is fully extended, then the buffer image is wiped so
     // the user can start fresh.
     // https://processing.org/examples/creategraphics.html
     // https://processing.org/discourse/beta/num_1275325290.html
     // https://processing.org/reference/PGraphics.html
  
    addToDrawing(drawing);
  
  } else {
    // FIXME This needs to be be in the utils thing
     lastDrawingX = NULL_DRAWING_VALUE;
     lastDrawingY = NULL_DRAWING_VALUE;
  }
  
  bltImage(drawing);

  //writePosition();
  renderCursor();
  renderConfidenceBorder();
}

//-------------------------------------------------------------------
// Track last postion as both normalized value and as raw value, and
// make note of the largests and smallest raw values so we can see 
// what range we get.
// Why is this not part of the utils? Does it change in each pointer example?
public Vector lastPos() {

  Vector normlp = listener.normalizedAvgPos();
  Vector lp = listener.avgPos();

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(normlp);

  return normlp;
}





class Configgy {

  String[] configTextLines;
  JSONObject json;

  Configgy(String configFile) {
    try {
      configTextLines = getDataLines(loadStrings(configFile));

      String line = trim(configTextLines[0]);
      if (line.charAt(0) == '{') {
        json = loadJSONObject(configFile);
      } else {
        String jsonString = configToJson(configTextLines);
        json = parseJSONObject(jsonString);
      }
    } catch(Exception e) {
      println("Error loading data from '" + configFile + "'");
      e.printStackTrace();
    }


  }

  // Return just the lines that have config data
  public String[] getDataLines(String[] configTextLines) {
    String[] dataLines = {};
    String line;

    for (int i=0; i < configTextLines.length; i++) {
      line = trim(configTextLines[i]);

      if ( ( line.indexOf("#") != 0 ) &&  ( line.indexOf(":") > 0 ) )  {
        dataLines = append(dataLines,  line);  
      }
    }
    return dataLines ;
  }


  // Assumes we have a set of congig lines, each being of the form
  //    keyName: validJsonExpression
  public String configToJson(String[] configTextLines) {
    String line;
    String[] jsonStrings = {"{" };
    String[] splitString;
    String newJsonLine = "";
    for (int i=0; i < configTextLines.length; i++) {
      line = trim(configTextLines[i]);

      if ( ( line.indexOf("#") != 0 ) &&  ( line.indexOf(":") > 0 ) )  {
        splitString = split(configTextLines[i], ':'); 
        newJsonLine = "\"" + splitString[0] + "\":"  + join(subset(splitString,1), ":" ) + ", ";
        jsonStrings = append(jsonStrings,  newJsonLine);  

      }
    }

    jsonStrings = append(jsonStrings, "}"  );  
    return  join(jsonStrings, "\n");
  }


  // Assorted accessor methods
  public String getValue(String k) { return json.getString(k); }
  
  public String getValue(String k, String defaultVal ) { 
    String val = defaultVal;
    try {
      val =  json.getString(k); 
      return val;
    } catch(Exception e) {
      return defaultVal;
    }
  }

  public String getString(String k) { return json.getString(k); }

  public String getString(String k, String defaultVal ) { 
    String val = defaultVal;
    try {
      val =  json.getString(k); 
      return val;
    } catch(Exception e) {
      return defaultVal;
    }
  }


  public int getInt(String k) { return json.getInt(k); }

  public int getInt(String k, int defaultVal ) { 
    int val = defaultVal;

    try {
      val = json.getInt(k);
      return val;

    } catch(Exception e) {
      return defaultVal;
    }
  }

  public float getFloat(String k) { return json.getFloat(k); }
  public float getFloat(String k, float defaultVal ) { 
    float val = defaultVal;

    try {
      val = json.getFloat(k);
      return val;

    } catch(Exception e) {
      return defaultVal;
    }
  }

  public boolean getBoolean(String k) { return json.getBoolean(k); }

  public boolean getBoolean(String k, boolean defaultVal) { 
    boolean val = defaultVal;

    try {
      val = json.getBoolean(k);
      return val;
    } catch(Exception e) {
      return defaultVal;
    }
  }

  public String[] getStrings(String k) {
    JSONArray values = json.getJSONArray(k);
    String[] strings = new String[values.size()];
    for (int i = 0; i < values.size(); i++) {
      strings[i] = values.getString(i);
    }
    return strings;
  }

  // Assumes the JSON "hashmap" is string:string.
  // Might look at adding some ways to get other kinds of maps.
  // However, if the client really needs, say, strings and ints then
  // the values returned can be casted or otherwise converted.
  public HashMap<String,String> getHashMap(String k) {
    HashMap<String, String> h = new HashMap<String, String>();
    JSONObject jo = json.getJSONObject(k);

    Iterator keys = jo.keyIterator();

    while( keys.hasNext() ) {
      String key_name = (String) keys.next(); 
      h.put(key_name,  jo.getString(key_name));

    }

    return h;

  }


  public int[] getInts(String k) {
    JSONArray values = json.getJSONArray(k);
    int[] ints = new int[values.size()];
    for (int i = 0; i < values.size(); i++) {
      ints[i] = values.getInt(i); 
    }
    return ints;
  }

  public float[] getFloats(String k) {
    JSONArray values = json.getJSONArray(k);
    float[] floats = new float[values.size()];
    for (int i = 0; i < values.size(); i++) {
      floats[i] = values.getFloat(i); 
    }
    return floats;
  }


  public boolean[] getBooleans(String k) {
    JSONArray values = json.getJSONArray(k);
    boolean[] booleans= new boolean[values.size()];
    for (int i = 0; i < values.size(); i++) {
      booleans[i] = values.getBoolean(i); 
    }
    return booleans;
  }

}


com.leapmotion.leap.Vector avgPos           = com.leapmotion.leap.Vector.zero();
com.leapmotion.leap.Vector normalizedAvgPos = com.leapmotion.leap.Vector.zero();

int NULL_DRAWING_VALUE = -99;

float yMax = 0;
float xMax = 0;
float yMin = 0;
float xMin = 0; 
int   minZ = 0;
int   maxZ = 1;
int   topX = 1;
int   topY = 1;
int   zMap = 0;
int   y    = 0; 
int   x    = 0; 


int lastDrawingX = NULL_DRAWING_VALUE;
int lastDrawingY = NULL_DRAWING_VALUE;

int brushWidth = 20;

int minHue = 0;
int maxHue = 255;

boolean DEBUG = true;

int opacity = 128;


//-------------------------------------------------------------------
public void d(String msg) {
  if (DEBUG) {
    println(msg);
  }
}

//-------------------------------------------------------------------
public int mapXforScreen(float xx) {
  return( PApplet.parseInt( map(xx, 0.0f, 1.0f, 0.0f, width) ) );
}

//-------------------------------------------------------------------
public int mapYforScreen(float yy) {
  return( PApplet.parseInt( map(yy, 0.0f, 1.0f,  height, 0) ) );
}


//-------------------------------------------------------------------
public int zToColorInt(float fz) {
  if (fz < minZ) { return minHue; }
  if (fz > maxZ) { return maxHue; }
  return PApplet.parseInt(map(fz, minZ, maxZ,  minHue, maxHue));
}

//-------------------------------------------------------------------
// This works, sort of.
// The problme is latency in detecting pinch and then placing the ellipse.
public void addToDrawing(PGraphics pg) {
  // You want to be sure updateCursorValues() was called before this is used

  pg.beginDraw();
  pg.colorMode(HSB);
  pg.stroke(zMap, 255, 255, opacity);

  pg.fill(zMap, 255, 255, opacity);

  if (lastDrawingX == NULL_DRAWING_VALUE ) {
    pg.ellipse(x, y, 1, 1);
  } else {
    pg.strokeWeight(brushWidth/2);
    pg.line(lastDrawingX, lastDrawingY, x, y );
  }

  pg.endDraw();

  lastDrawingX = x;
  lastDrawingY = y;
}

public void bltImage(PGraphics pg) {
  image(pg, 0, 0); 
}


public void updateCursorValues() {
  zMap = zToColorInt(lastPos().getZ());
  y = mapYforScreen( lastPos().getY() );
  x = mapXforScreen(lastPos().getX()); 


}

// Is there a better way, something that avlid having to
// recalc these positional values everplace they are needed?
// Like an updateScreenCoords() ?
public void renderCursor() {
  colorMode(HSB);
  fill(zMap, 255, 255);
  stroke(zMap, 255, 255);
  ellipse(x, y, brushWidth/2, brushWidth/2);
}


public void renderConfidenceBorder() {
  strokeWeight(10);
  int redTone = PApplet.parseInt( (1.0f - listener.currentConfidence()) * 255 );
  colorMode(HSB);
  stroke(0, redTone, redTone );
  fill(0,0);
  rect(0,0, width, height);
}

//-------------------------------------------------------------------
// You want to be sure updateCursorValues() was called before this
public void writePosition(){
  int inc = 30;

  textSize(32);

  colorMode(HSB);
  fill(zMap, 255, 100);

  //  d("lastPos() : " + lastPos() );
  // d("normalizedAvgPos  : " + normalizedAvgPos );

  text("X: " + lastPos().getX(), x, y);
  text("Y: " + lastPos().getY(), x, y + inc*2 );
  text("Z: " + lastPos().getZ(), x, y + inc*3 );

  text("min X: "  + xMin, x, y + inc*4 );
  text("max X: "  + xMax, x, y + inc*5 );

  text("min Y: "  + yMin, x, y + inc*6 );
  text("max Y: "  + yMax, x, y + inc*7 );

}

class PointerListener extends Listener {
  // Hmm.  These are also defined in the utils file.
  private Vector avgPos;
  private Vector normalizedAvgPos;
  private float ps;
  private boolean handSpread;
  private boolean handSpreadSwipe;
  private float currentConfidence; 
  private GestureList gestureList;  

  //------------------------------------------------------------
  public void onInit(Controller controller) {
    // `d` is a helper method for printing debug stuff.
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();
    currentConfidence = 0.0f;
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  }

  //------------------------------------------------------------
  public void onConnect(Controller controller) {
    d("Connected");
  }

  //------------------------------------------------------------
  public void onFocusGained(Controller controller) {
    d(" Focus gained");
  }

  //------------------------------------------------------------
  public void onFocusLost(Controller controller) {
    d("Focus lost");
  }

  //------------------------------------------------------------
  public void onDisconnect(Controller controller) {
    d("Disconnected");
  }

  //------------------------------------------------------------
  public void onFrame(Controller controller) {
    Frame frame = controller.frame();
    InteractionBox box = frame.interactionBox();
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      d("Hand!");
      Hand hand = hands.get(0);
      currentConfidence = hand.confidence(); 
      FingerList fingers = hand.fingers();
      if (fingers.count() > 0) {
        gestureList = frame.gestures();
        detectOpenHandSwipe(hand);
        d("Fingers!");
        avgPos = Vector.zero();
        ps = constrain(hand.pinchStrength(), 0.0f, 1.0f);
        d("pinch Strength = " + ps );

        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        d("avgPos x: " + avgPos.getX() );
        normalizedAvgPos = box.normalizePoint(avgPos, true);

      } 
    } //  if hands 
  } 


  //------------------------------------------------------------
  public com.leapmotion.leap.Vector avgPos(){
    return new com.leapmotion.leap.Vector(avgPos);
  }

  //------------------------------------------------------------
  public boolean haveSpreadHand() {
    return handSpread;
  }

  //------------------------------------------------------------
  public void detectHandSpread(Hand h) {

    handSpread = false;
    if (h.fingers().count() < 5 )  return;

    for (Finger finger : h.fingers()) {
      if ( !finger.isExtended() ) return ;
    }
    handSpread = true;
  }

  //------------------------------------------------------------
  public float currentConfidence() {
    return currentConfidence;
  }

  //------------------------------------------------------------
  public boolean haveOpenHandSwipe()  {
    return handSpreadSwipe;
  }


  //------------------------------------------------------------
  // FIXME Make this reobust. This versoin assumes an awful lot.
  public void detectOpenHandSwipe(Hand h) {
    handSpreadSwipe = false;
    detectHandSpread(h);
    if (!haveSpreadHand() )  return;
    if ( gestureList.count() ==  0 ) return ;
    handSpreadSwipe = true;
  }

  //------------------------------------------------------------
  public boolean havePinch() {
    if (ps > pinchThreshold ) return true; 
    return false;

  }
  //------------------------------------------------------------
  public com.leapmotion.leap.Vector normalizedAvgPos(){
    return new com.leapmotion.leap.Vector(normalizedAvgPos);
  }
} 

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PointerLocation1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
