import com.neurogami.leaphacking.*;


LeapMotionP5 leap;


//-------------------------------------------------------------------
void setup() {
  size(displayWidth-30, displayHeight-30, OPENGL);

  noLoop();
  yMax = xMax =  -100;
  yMin = xMin =  1300;

  avgPos = Vector.zero();
  leap = new LeapMotionP5(this, true);
  leap.allowBackgroundProcessing(true);
  
}

//-------------------------------------------------------------------
void draw() {
  background(255);
  writePosition();
}


//-------------------------------------------------------------------
void onFrame(com.leapmotion.leap.Controller controller) {
  processData(controller);
}


//-------------------------------------------------------------------
void processData(com.leapmotion.leap.Controller controller) {

  Frame frame = controller.frame();
  HandList hands = frame.hands();

  if (hands != null) {
    if (hands.count() > 0 ) {

      println("\tDraw: Have hands.count() = " + hands.count() );
      println("****************** Hand ****************************");
      Hand hand = hands.get(0);

      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println(" ******** Fingers " + fingers.count() + " ****** ");

        avgPos = Vector.zero();

        for (Finger finger : fingers) {
          avgPos = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );
        redraw();
      } // if fingers
    } //  if hands 

  }

}


//-------------------------------------------------------------------
Vector lastPos() {
  Vector lp = new Vector(avgPos);


  // Although the point-rendering is restricted to the size of the screen,
  // it's interesting to see the range values detected.
  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(lp);

  return lp;
}



