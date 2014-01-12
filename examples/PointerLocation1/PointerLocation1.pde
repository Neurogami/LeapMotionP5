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
Vector lastPos() {
  // New, with interactoin box.  Use the normalized vector instead of the raw values
  // But we stil want to track the range of the raw values
  Vector normlp = listener.normalizedAvgPos();
  Vector lp = listener.avgPos();

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(normlp);

  return normlp;
}


