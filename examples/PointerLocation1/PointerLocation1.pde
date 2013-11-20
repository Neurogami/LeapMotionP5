import com.neurogami.leaphacking.*;


PointerListener listener   = new PointerListener();
Controller      controller = new Controller(listener);




void setup() {
  // This makes it full-screen
  size(displayWidth, displayHeight, OPENGL);
}


//-------------------------------------------------------------------
void draw() {
  background(255);
  writePosition();
}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector lp = listener.avgPos();


  // Although the point-rendering is restricted to the size of the screen,
  // it's interesting to see the range values detected.
  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(lp);

  return lp;
}


