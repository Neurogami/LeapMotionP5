import com.leapmotion.leap.*;

HandList globalHands;
InteractionBox box;
GestureList gestures;

/*
Important: Recognition for each type of gesture must be enabled using 
the Controller::enableGesture() function; otherwise no gestures are 
recognized or reported.

https://developer.leapmotion.com/documentation/java/api/Leap.Gesture.html#javaclasscom_1_1leapmotion_1_1leap_1_1_gesture

 */
class PointerListener extends Listener {

  //------------------------------------------------------------
  void onInit(Controller controller) {
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();

    controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
    controller.enableGesture(Gesture.Type.TYPE_KEY_TAP);
    controller.enableGesture(Gesture.Type.TYPE_SCREEN_TAP);
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);

  }

  //------------------------------------------------------------
  void onConnect(Controller controller) {
    d("Connected");
  }

  //------------------------------------------------------------
  void onDisconnect(Controller controller) {
    d("Disconnected");
  }

  

  //------------------------------------------------------------
  void onFrame(Controller controller) {


    globalHands = controller.frame().hands();

    if (useCurrentFrameForGestures) {
      gestures = controller.frame().gestures( controller.frame() ); // You can also pass a frame index, but what index would you want?
    } else {
      gestures = controller.frame().gestures(); 
    }

    box = controller.frame().interactionBox();
    if (gestures.count() > 0 ) {

      // synchronized(this) {  

      for (int index = 0; index < gestures.count(); index++) {
        if (!handledGestures.containsKey(new Integer( gestures.get(index).id())) ) {

          if (gestures.get(index).state() == Gesture.State.STATE_STOP ) {
            switch (gestures.get(index).type()) {
              case TYPE_CIRCLE:
                circleInfo.put("" + gestures.get(index).type() + ":" + gestures.get(index).id(), DECAY_MAX );
                break;
              case TYPE_KEY_TAP:
                keyTapInfo.put("" + gestures.get(index).type() + ":" + gestures.get(index).id(), DECAY_MAX );
                break;
              case TYPE_SCREEN_TAP:
                screenTapInfo.put("" + gestures.get(index).type() + ":" + gestures.get(index).id(), DECAY_MAX );
                break;
              case TYPE_SWIPE:
                swipeInfo.put("" + gestures.get(index).type() + ":" + gestures.get(index).id(), DECAY_MAX );
                break;
              default:
                break;
            }
println( "GTL:   79" ); 
            println( gestures.get(index).type() ); 
            println( "GTL:   81" ); 
            handledGestures.put( new Integer(gestures.get(index).id()), gestures.get(index) );
            println( "GTL:   83" ); 
          }
          println( "GTL:   85" ); 
        }
        println( "GTL:   87" ); 
      }
      // } //  sync
    }

    // Now look for other interesting behavior, like pinching or whatever

    if ( globalHands.count() > 0 ){
      if ( (globalHands.frontmost().pinchStrength() > 0.9 ) && ( globalHands.frontmost().fingers().extended().count() > 2 ) ) {
     //synchronized(this) {   // is this needed if the pinchInfo structure is a ConcurrentHashMap?
        println( "GTL:   101" ); 
        pinchInfo.put("PINCH: " + globalHands.frontmost().fingers().extended().count() + " " + globalHands.frontmost().pinchStrength(), DECAY_MAX);
                println( "GTL:   103" ); 
     // }
     }
    }
  } 

} 



