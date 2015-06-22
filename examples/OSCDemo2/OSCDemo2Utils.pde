com.leapmotion.leap.Vector avgPos           = com.leapmotion.leap.Vector.zero();
com.leapmotion.leap.Vector normalizedAvgPos = com.leapmotion.leap.Vector.zero();

int   zMap = 0;
int   y    = 0; 
int   x    = 0; 

int brushWidth = 20;
boolean DEBUG = true;

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
void updateCursorValues() {
  zMap = 10; // FIXME Magic numbers are bad news.
  if ( havePinch() ) { zMap = 100; }
  y = mapYforScreen( normalizedAvgPos.getY() );
  x = mapXforScreen(normalizedAvgPos.getX()); 
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
  int redTone = int( (1.0 - currentConfidence()) * 255 );
  colorMode(HSB);
  stroke(0, redTone, redTone );
  fill(0,0);
  rect(0,0, width, height);
}
