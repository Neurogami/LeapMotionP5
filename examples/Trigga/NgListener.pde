
class NgListener extends Listener {

//  We want to track a)  Do we have a "gun" hand formation, and b) if so, 
//  in what direction is it pointing, and at what angle?
// Do we want to track yaw, pitch, and roll?

  boolean haveGun = false;
  Vector  direction = Vector.zero();

  //------------------------------------------------------------
  void onInit(Controller controller) {
    println("Initialized");
    //avgPos = Vector.zero();
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

// What we want to do is somehwo detect when the user curls then uncurls the "trigger" finger
// That means we have two states: gun ( exactly 2 fingers, of proper angle), and then 1 finger.
// Can we detect when the trigger finger is curling?  Not _missing_, but halfway to being curled
// back into the hand. 
// We also need to track the time delta between "gun" and "shooting" so that we initiate
// only one "fire!" event.

    if (hands.count() > 0 ) {
      println("Hand!");
      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() == 2) {
        Finger f1 = fingers.get(0);
        Finger f2 = fingers.get(1);
        println("2 Fingers! Lengths: 1 = " + f1.length() + ";\t2 = " + f2.length() );
      } // if 2 fingers
    } //  if hands 

  } 


  //------------------------------------------------------------
  Vector direction(){
    return direction;
  }


  //------------------------------------------------------------
  boolean haveGun(){
    return haveGun;
  }
} 

