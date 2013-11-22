import com.neurogami.leaphacking.*;

PointerListener listener   = new PointerListener();
com.leapmotion.leap.Controller      controller = new com.leapmotion.leap.Controller(listener);

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
com.leapmotion.leap.Vector lastPos() {
  com.leapmotion.leap.Vector lp = listener.avgPos();

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(lp);

  return lp;
}


