

class NgListener extends Listener {

  Vector avgPos;

  //------------------------------------------------------------
  void onInit(Controller controller) {
    println("Initialized");
    avgPos = Vector.zero();
  }

  //------------------------------------------------------------
  void onConnect(Controller controller) {
    println("Connected");
  }

  //------------------------------------------------------------
  void onDisconnect(Controller controller) {
    println("Disconnected");
  }

  //------------------------------------------------------------
  void onFrame(Controller controller) {

    Frame frame = controller.frame();
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      println("Hand!");
      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println("Fingers!");
          avgPos = Vector.zero();
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );

      } // if fingers
    } //  if hands 

  } 


  //------------------------------------------------------------
  Vector lastPos(){
    return(avgPos);
  }
} 

