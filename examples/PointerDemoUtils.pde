com.leapmotion.leap.Vector avgPos = com.leapmotion.leap.Vector.zero();


float yMax = 0;
float xMax = 0;
float yMin = 0;
float xMin = 0; 
int   minZ = 0;
int   maxZ = 1;
int   topX = 1;
int   topY = 1;


boolean DEBUG = false;

void d(String msg) {
  if (DEBUG) {
    println(msg);
  }
}


int mapXforScreen(float xx) {
  // We get a value from 0 to 1 that maps from 0 to width
//  int x  = constrain( int(xx), topX * -1, topX);
  return( int( map(xx, 0.0, 1.0, 0.0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {
  return( int( map(yy, 0.0, 1.0,  height, 0) ) );
}


//-------------------------------------------------------------------
int zToColorInt(float fz) {
//  int z = int(fz);
  //println("z = " + z);
  if (fz < minZ) { return 0; }
  if (fz > maxZ) { return 255; }
  return int(map(fz, minZ, maxZ,  0, 255));
}

void writePosition(){
/// New: Now we are using a normalized vector so the 
//range of values is 0.0 to 1.0.
  int zMap = zToColorInt(lastPos().getZ());
  int baseY = mapYforScreen( lastPos().getY() );
  int inc = 30;
  int xLoc = mapXforScreen(lastPos().getX()); 

  textSize(32);
  fill(zMap, zMap, zMap);

  d("lastPos() X : " + lastPos() );
  text("X: " + lastPos().getX() , xLoc, baseY);
  text("Y: "  + lastPos().getY(), xLoc, baseY + inc*2 );
  text("Z: "  + lastPos().getZ(), xLoc, baseY + inc*3 );

  text("min X: "  + xMin, xLoc, baseY + inc*4 );
  text("max X: "  + xMax, xLoc, baseY + inc*5 );

  text("min Y: "  + yMin, xLoc, baseY + inc*6 );
  text("max Y: "  + yMax, xLoc, baseY + inc*7 );

}
