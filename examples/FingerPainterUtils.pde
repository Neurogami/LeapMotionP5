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
void d(String msg) {
  if (DEBUG) {
    println(msg);
  }
}

//-------------------------------------------------------------------
int mapXforScreen(float xx) {
  return( int( map(xx, 0.0, 1.0, 0.0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {
  return( int( map(yy, 0.0, 1.0,  height, 0) ) );
}


//-------------------------------------------------------------------
int zToColorInt(float fz) {
  if (fz < minZ) { return minHue; }
  if (fz > maxZ) { return maxHue; }
  return int(map(fz, minZ, maxZ,  minHue, maxHue));
}

//-------------------------------------------------------------------
// This works, sort of.
// The problem is latency in detecting pinch and then placing the ellipse.
void addToDrawing(PGraphics pg) {
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

void bltImage(PGraphics pg) {
  image(pg, 0, 0); 
}


void updateCursorValues() {
  zMap = zToColorInt(lastPos().getZ());
  y = mapYforScreen( lastPos().getY() );
  x = mapXforScreen(lastPos().getX()); 


}

// Is there a better way, something that avlid having to
// recalc these positional values everplace they are needed?
// Like an updateScreenCoords() ?
void renderCursor() {
  colorMode(HSB);
  fill(zMap, 255, 255);
  stroke(zMap, 255, 255);
  ellipse(x, y, brushWidth/2, brushWidth/2);
}


void renderConfidenceBorder() {
  strokeWeight(10);
  int redTone = int( (1.0 - listener.currentConfidence()) * 255 );
  colorMode(HSB);
  stroke(0, redTone, redTone );
  fill(0,0);
  rect(0,0, width, height);
}

//-------------------------------------------------------------------
// You want to be sure updateCursorValues() was called before this
void writePosition(){
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
