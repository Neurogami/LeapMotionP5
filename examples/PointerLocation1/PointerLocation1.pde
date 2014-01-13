import com.neurogami.leaphacking.*;
import com.leapmotion.leap.*;

PointerListener listener   = new PointerListener();
Controller      controller = new Controller(listener);

//-------------------------------------------------------------------
void setup() {
  size(displayWidth, displayHeight, OPENGL);
}

//-------------------------------------------------------------------
void draw() {
  background(255);
  writePosition();
}

//-------------------------------------------------------------------
// Track last postion as both normalized value and as raw value, and
// make note of the largests and smallest raw values so we can see 
// what range we get.
Vector lastPos() {

  Vector normlp = listener.normalizedAvgPos();
  Vector lp = listener.avgPos();

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(normlp);

  return normlp;
}


