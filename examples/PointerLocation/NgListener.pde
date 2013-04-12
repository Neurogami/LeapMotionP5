<<<<<<< HEAD
/***********************************************************************

  A typical Leap app works like this:

  Instantiate a Listener class, and pass that instance to the
  constructor of a Controller instance.
  For each frame of data, the onFrame method of the  Listener instance
  is called, with the controller instance passed in.

  From that controller instance the listener can get the current frame
  and from that frame get things like hands, fingers, gestures, etc. that
  have been detected.

  So, in order to have custom code you need to write your own Listener class
  that extends com.leapmotion.leap.Listener.

  You then jazzy-up onFrame to handle what has been detected.

  Where it gets tricky is when you want your custom Listener to
  interact with the Processing environment.

  You have some choices.  One is to create custom properties or methods on
  your Listener that will report whatever useful data you select.  Then, in draw() 
  (in your main sketch code) you query the Listener instance for these details.

  The nice thing about this is that you Listener class is not coupled to the main
  PApplet of your sketch.

  A possible down side depends on what you want to render.  

  Another approach is to give your Listener a reference to the main PApplet instance.

  For example

  // Assumes you have already defined a private "PApplet owner" someplace 
  void setOwner(PApplet ownerPapplet) {
    owner = ownerPapplet;
  }

Then your Listener code can use this reference to do the rendering.

This approach can get very tricky.  You need to understand how to work with Processig
graphics here.   But it's an option.



 ************************************************************************/
class NgListener extends Listener {

  Vector avgPos;

  //------------------------------------------------------------
  void onInit(Controller controller) {
    println("Initialized");
    avgPos = Vector.zero();
  }

  //------------------------------------------------------------
  void onConnect(Controller controller) {
=======
class NgListener extends Listener {

  com.leapmotion.leap.Vector avgPos;

  //------------------------------------------------------------
  public void onInit(Controller controller) {
    println("Initialized");
    avgPos = com.leapmotion.leap.Vector.zero();
  }

  //------------------------------------------------------------
  public void onConnect(Controller controller) {
>>>>>>> Developing lib based on tangible use cases
    println("Connected");
  }

  //------------------------------------------------------------
<<<<<<< HEAD
  void onDisconnect(Controller controller) {
=======
  public void onDisconnect(Controller controller) {
>>>>>>> Developing lib based on tangible use cases
    println("Disconnected");
  }

  //------------------------------------------------------------
<<<<<<< HEAD
  void onFrame(Controller controller) {

    Frame frame = controller.frame();
=======
  public void onFrame(Controller controller) {

    com.leapmotion.leap.Frame frame = controller.frame();
>>>>>>> Developing lib based on tangible use cases
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      println("Hand!");
      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println("Fingers!");
<<<<<<< HEAD
        avgPos = Vector.zero();
=======
        avgPos = com.leapmotion.leap.Vector.zero();
>>>>>>> Developing lib based on tangible use cases
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        println("avgPos x: " + avgPos.getX() );

      } // if fingers
    } //  if hands 

<<<<<<< HEAD
  } 


  //------------------------------------------------------------
  Vector lastPos(){
    return(avgPos);
  }
} 
=======
  } // onFrame

  //------------------------------------------------------------
  com.leapmotion.leap.Vector lastPos(){

    return(avgPos);
  }
} // class
>>>>>>> Developing lib based on tangible use cases

