import com.neurogami.leaphacking.*;


LeapMotionP5 leap;


void setup() {
  size(displayWidth-30, displayHeight-30, OPENGL);

  noLoop();
  yMax = xMax =  -100;
  yMin = xMin =  1300;

  avgPos = Vector.zero();
  leap = new LeapMotionP5(this, true);
  leap.allowBackgroundProcessing(true);
  
}

void onFrame(com.leapmotion.leap.Controller controller) {
  processData(controller);
}

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

        //       writePosition();
        redraw();
      } // if fingers

    } //  if hands 

  }

}
//-------------------------------------------------------------------
void draw() {
  background(255);
  writePosition();
}

