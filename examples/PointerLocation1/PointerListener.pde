
class PointerListener extends Listener {

  private Vector avgPos;
  private Vector normalizedAvgPos;

  //------------------------------------------------------------
  void onInit(Controller controller) {
    // `d` is a helper method for printing debug stuff.
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();
  }

  //------------------------------------------------------------
  void onConnect(Controller controller) {
    d("Connected");
  }


  //------------------------------------------------------------
  void onFocusGained(Controller controller) {
    d(" Focus gained");
  }

  //------------------------------------------------------------
  void onFocusLost(Controller controller) {
    d("Focus lost");
  }

  //------------------------------------------------------------
  void onDisconnect(Controller controller) {
    d("Disconnected");
  }

  //------------------------------------------------------------
  void onFrame(Controller controller) {

    Frame frame = controller.frame();
    InteractionBox box = frame.interactionBox();
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      d("Hand!");
      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() > 0) {
        d("Fingers!");
        avgPos = Vector.zero();
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        d("avgPos x: " + avgPos.getX() );
        normalizedAvgPos = box.normalizePoint(avgPos, true);

      } // if fingers
    } //  if hands 
  } 


  //------------------------------------------------------------
  com.leapmotion.leap.Vector avgPos(){
    return new com.leapmotion.leap.Vector(avgPos);
  }


  //------------------------------------------------------------
  com.leapmotion.leap.Vector normalizedAvgPos(){
    return new com.leapmotion.leap.Vector(normalizedAvgPos);
  }
} 

