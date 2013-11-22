import com.neurogami.leaphacking.*;


LeapMotionP5 leap;


void setup() {
  size(displayWidth-30, displayHeight-30, OPENGL);

  noLoop();

  leap = new LeapMotionP5(this, true);
  leap.allowBackgroundProcessing(true);

}

void draw() {
  background(255);
  writePosition();
}

void onFrame(com.leapmotion.leap.Controller controller) {
  processData(controller);
}

void processData(com.leapmotion.leap.Controller controller) {

  Frame frame = controller.frame();
  HandList hands = frame.hands();

  if (hands != null) {
    if (hands.count() > 0 ) {

      d("\tDraw: Have hands.count() = " + hands.count() );
      d("****************** Hand ****************************");
      Hand hand = hands.get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        d(" ******** Fingers " + fingers.count() + " ****** ");

        avgPos = Vector.zero();

        for (Finger finger : fingers) {
          avgPos = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        d("avgPos x: " + avgPos.getX() );
        redraw();
      } 
    } 
  }
}

Vector lastPos() {
  Vector lp = new Vector(avgPos);

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  d(lp.toString());

  return lp;
}



