import com.neurogami.leaphacking.*;


/*

vi


This examples show how to use the angle between fingers to determin 
what has been detected.

*/

NgListener listener = new NgListener();
Controller controller;

float yMax, xMax;
float yMin, xMin;

LeapMotionP5 leap;

void setup() {
  size(700, 500, OPENGL);

  yMax = xMax =  -100;
  yMin = xMin =  1300;


controller = new Controller(listener);

}


//-------------------------------------------------------------------
void draw() {
  background(255);
  renderHand();
}




int mapXforScreen(float xx) {
  int topX = 150;
  int x  = constrain( int(xx), topX * -1, topX);
  return( int( map(x, topX * -1, topX, 0, width) ) );
}

//-------------------------------------------------------------------
int mapYforScreen(float yy) {

  int topY = 300;
  int y  = constrain( int(yy), 0, topY);

  return( int( map(y, 0, topY,  height, 0) ) );
}


//-------------------------------------------------------------------
int zToColorInt(float fz) {

  int z = int(fz);
   
  int minZ = -220;
  int maxZ = 200;

  if (z < minZ) {
    return 0;
  }

  if (z > maxZ) {
    return 255;
  }

  return int(map(z, minZ, maxZ,  0, 255));
}

//-------------------------------------------------------------------
void renderHand(){

//   int zMap = zToColorInt(lastPos().getZ());
//    int baseY = mapYforScreen( lastPos().getY() );
//    int inc = 30;
//    int xLoc = mapXforScreen(lastPos().getX()); 

  textSize(32);
  fill(250, 30, 90);

  println("haveGun() X : " + listener.haveGun() );
  text("haveGun() X : " + listener.haveGun() , 100, 100 );

}
