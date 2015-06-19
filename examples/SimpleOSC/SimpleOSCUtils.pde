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

boolean DEBUG = true;

int opacity = 128;


//-------------------------------------------------------------------
void d(String msg) { if (DEBUG) println(msg); }

//-------------------------------------------------------------------
int mapXforScreen(float xx) {
  return( int( map(xx, 0.0, 1.0, 0.0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {
  return( int( map(yy, 0.0, 1.0,  height, 0) ) );
}


//-------------------------------------------------------------------
int del_zToColorInt(float fz) {
  if (fz < minZ) { return minZ; }
  if (fz > maxZ) { return maxZ; }
  return int(map(fz, minZ, maxZ,  0, 255));
}



//-------------------------------------------------------------------
void updateCursorValues(SimpleOSCListener listener) {
  zMap = 10; // FIXME Magic numbers are bad news.
  if ( listener.havePinch() ) { zMap = 100; }
  y = mapYforScreen( listener.normalizedAvgPos().getY() );
  x = mapXforScreen(listener.normalizedAvgPos().getX()); 
}

//-------------------------------------------------------------------
void renderCursor() {
  colorMode(HSB);
  fill(zMap, 255, 255);
  stroke(zMap, 255, 255);
  ellipse(x, y, brushWidth/2, brushWidth/2);
}

//-------------------------------------------------------------------
void renderConfidenceBorder() {
  strokeWeight(10);
  int redTone = int( (1.0 - listener.currentConfidence()) * 255 );
  colorMode(HSB);
  stroke(0, redTone, redTone );
  fill(0,0);
  rect(0,0, width, height);
}

//-------------------------------------------------------------------
void writePosition(SimpleOSCListener listener){
  
  updateCursorValues(listener);

  int inc = 30;

  textSize(32);

  colorMode(HSB);
  fill(zMap, 255, 100);

  // d("normalizedAvgPos  : " + normalizedAvgPos );

  text("X: " + listener.normalizedAvgPos().getX(), x, y);
  text("Y: " + listener.normalizedAvgPos().getY(), x, y + inc*2 );
  text("Z: " + listener.normalizedAvgPos().getZ(), x, y + inc*3 );

  text("min X: "  + xMin, x, y + inc*4 );
  text("max X: "  + xMax, x, y + inc*5 );

  text("min Y: "  + yMin, x, y + inc*6 );
  text("max Y: "  + yMax, x, y + inc*7 );

}
