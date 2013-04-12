import com.neurogami.leaphacking.*;

/*

This example takes an average of all detected pointables and uses that 
as the point to render on the screen.  

It shows the point coordinate values at the  x,y location

Z value is rendered by chaging the darkness of the font color; they further 
away the lighter it gets.



*/

NgListener listener = new NgListener();
Controller controller;

float yMax, xMax;
float yMin, xMin;

LeapMotionP5 leap;

void setup() {
  // This makes it full-screen
  size(displayWidth, displayHeight, OPENGL);

  yMax = xMax =  -100;
  yMin = xMin =  1300;

  leap = new LeapMotionP5(this);
   listener.setOwner(this);
  controller = leap.createController(listener);
// There are two ways to get a controller instance; not usre
// usng a helper metod buy you anything since you can just do it
// yourself

//  controller = new Controller(listener);

}


//-------------------------------------------------------------------
void draw() {
  background(255);
  writePosition();
}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector  lp = listener.lastPos();

// Although the point-rendering is restricted to the size of the screen,
// it's interesting to see the range values detected.
  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(lp);

  return lp;
}


//-------------------------------------------------------------------
/* The trick to guestimate the upper and lower bounds for the X value
   so as to map it to the width of the screen while not losing the finger at the edges.

   One question is, do you get different values of X depending on your Y and Z?  

   For example:  Given this are marked out above the Leap


   -----------------------
   |                     |
   |                     |
   |                     |
   |                     |
   -----------------------
   [leap]

   Is the X value stable as you move your finger up either the left or right side?


   The Leap can sense greater values of X the further up you are.  But it seems to return
   the same X value as you directly normal to the front.

   If you are about 7 inches or so away you can get a range pf -200 to +200

   Y seems to range from 0 to about 400, after which things get flakey.

   The trick is to find an X/Y range that works OK, and then somehow corral outliers into
   that range.  Using `constrain` seems to make it sort of jumpy.

   Perhaps we could assign keys for setting the "view" range, where you hit l, r, t, and b
   for left, right, top, bottom and the current X or Y value is then assigned to the contrain
   and amp range.  These values can then be saved and reloaded.  This way you can set a smaller view and
   have `map` make the adjustments.


 */
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

void writePosition(){

  int zMap = zToColorInt(lastPos().getZ());
  int baseY = mapYforScreen( lastPos().getY() );
  int inc = 30;
  int xLoc = mapXforScreen(lastPos().getX()); 

  textSize(32);
  fill(zMap, zMap, zMap);

  println("lastPos() X : " + lastPos() );
  text("X: " + lastPos().getX() , xLoc, baseY);
  text("Y: "  + lastPos().getY(), xLoc, baseY + inc*2 );
  text("Z: "  + lastPos().getZ(), xLoc, baseY + inc*3 );

  text("min X: "  + xMin, xLoc, baseY + inc*4 );
  text("max X: "  + xMax, xLoc, baseY + inc*5 );

  text("min Y: "  + yMin, xLoc, baseY + inc*6 );
  text("max Y: "  + yMax, xLoc, baseY + inc*7 );

}
