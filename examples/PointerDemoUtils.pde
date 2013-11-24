com.leapmotion.leap.Vector avgPos = com.leapmotion.leap.Vector.zero();


float yMax = 0;
float xMax = 0;
float yMin = 0;
float xMin = 0;
int   minZ = -220;
int   maxZ = 200;
int   topX = 150;
int   topY = 300;


boolean DEBUG = false;

void d(String msg) {
  if (DEBUG) {
    println(msg);
  }
}


int mapXforScreen(float xx) {
  int x  = constrain( int(xx), topX * -1, topX);
  return( int( map(x, topX * -1, topX, 0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {
  int y  = constrain( int(yy), 0, topY);
  return( int( map(y, 0, topY,  height, 0) ) );
}


//-------------------------------------------------------------------
int zToColorInt(float fz) {
  int z = int(fz);
  if (z < minZ) { return 0; }
  if (z > maxZ) { return 255; }
  return int(map(z, minZ, maxZ,  0, 255));
}

void writePosition(){

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
