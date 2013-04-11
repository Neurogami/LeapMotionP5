class NgListener extends Listener {

  com.leapmotion.leap.Vector avgPos;

  //------------------------------------------------------------
  public void onInit(Controller controller) {
    println("Initialized");
    avgPos = com.leapmotion.leap.Vector.zero();
  }

  //------------------------------------------------------------
  public void onConnect(Controller controller) {
    println("Connected");
  }

  //------------------------------------------------------------
  public void onDisconnect(Controller controller) {
    println("Disconnected");
  }

  //------------------------------------------------------------
  public void onFrame(Controller controller) {

    com.leapmotion.leap.Frame frame = controller.frame();
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      println("Hand!");
      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println("Fingers!");
        avgPos = com.leapmotion.leap.Vector.zero();
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );

      } // if fingers
    } //  if hands 

  } // onFrame

  //------------------------------------------------------------
  com.leapmotion.leap.Vector lastPos(){

    return(avgPos);
  }
} // class

