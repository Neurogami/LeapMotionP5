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

int lastDrawingX = NULL_DRAWING_VALUE;
int lastDrawingY = NULL_DRAWING_VALUE;



boolean DEBUG = true;

//-------------------------------------------------------------------
void d(String msg) {
  if (DEBUG) {
    println(msg);
  }
}

//-------------------------------------------------------------------
int mapXforScreen(float xx) {
  return( int( map(xx, 0.0, 1.0, 0.0, width-130) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {
  return( int( map(yy, 0.0, 1.0,  height, 10) ) );
}


//-------------------------------------------------------------------
int zToColorInt(float fz) {
  // If we are getting normalized values then they
  // should always be within the the range ...
  if (fz < minZ) { return 0; }
  if (fz > maxZ) { return 255; }
  return int(map(fz, minZ, maxZ,  0, 255));
}




//-------------------------------------------------------------------
// This works, sort of.
// The problme is latency in detecting pinch and then placing the ellipse.
// Even if you never release the pinhc there are gaps.  
// Something needs to track the last location and draw a line form that point to the new point.
// If the pinch is released then the last point get s set to nil or something; then the
// new drawing begins as a solo point, not a line.
void addToDrawing(PGraphics pg) {
  int drawingWeight = 3;
  int zMap = zToColorInt(lastPos().getZ());
  int y = mapYforScreen( lastPos().getY() );
  int x = mapXforScreen(lastPos().getX()); 

  pg.beginDraw();
  pg.colorMode(HSB);
  pg.stroke(zMap, 255, 100);
  pg.strokeWeight(drawingWeight);
  pg.fill(zMap, 255, 100);


  if (lastDrawingX == NULL_DRAWING_VALUE ) {
     pg.ellipse(x, y, drawingWeight/2, drawingWeight/2);
    } else {
    pg.line(lastDrawingX, lastDrawingY, x, y );

  }

  lastDrawingX = x;
  lastDrawingY = y;

  pg.endDraw();
}

void bltImage(PGraphics pg) {
  image(pg, 0, 0); 
}
//-------------------------------------------------------------------
void writePosition(){
  int zMap = zToColorInt(lastPos().getZ());
  int baseY = mapYforScreen( lastPos().getY() );
  int inc = 30;
  int xLoc = mapXforScreen(lastPos().getX()); 

  textSize(32);

  // TEST 1: See if the Z value can be used to drive HSB
  colorMode(HSB);
  fill(zMap, 255, 100);

  //  d("lastPos() : " + lastPos() );
  // d("normalizedAvgPos  : " + normalizedAvgPos );

  text("X: " + lastPos().getX(), xLoc, baseY);
  text("Y: " + lastPos().getY(), xLoc, baseY + inc*2 );
  text("Z: " + lastPos().getZ(), xLoc, baseY + inc*3 );

  text("min X: "  + xMin, xLoc, baseY + inc*4 );
  text("max X: "  + xMax, xLoc, baseY + inc*5 );

  text("min Y: "  + yMin, xLoc, baseY + inc*6 );
  text("max Y: "  + yMax, xLoc, baseY + inc*7 );



}
