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

  float maxPinch = -1.0;

  //------------------------------------------------------------
  void onInit(Controller controller) {
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();

    controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
    controller.enableGesture(Gesture.Type.TYPE_KEY_TAP);
    controller.enableGesture(Gesture.Type.TYPE_SCREEN_TAP);
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);
    controller.config().setFloat("Gesture.Circle.MinArc", 3);
    controller.config().save();
    
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
    float pinchStrenth;

    if (useCurrentFrameForGestures) {
      gestures = controller.frame().gestures( controller.frame() ); // You can also pass a frame index, but what index would you want?
    } else {
      gestures = controller.frame().gestures(); 
    }

    box = controller.frame().interactionBox();
    if (gestures.count() > 0 ) {

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
            println( gestures.get(index).type() ); 
            handledGestures.put( new Integer(gestures.get(index).id()), gestures.get(index) );
          }
        }
      }
    }

    // Now look for other interesting behavior, like pinching or whatever
    /*

       Pinch detection is tricky.

       First, LM seems a bit fussy about catching it.

       But, assuming the pinch is detected you likely do not want to react to every pinch position; 
       the goal is to catch distinct pinch events, not all the steps leading to and from the pinch
       threshold you set.

       So, this code tries to trap when an actual pinch has occured and the fingers have then retracted.

     */
    if ( globalHands.count() > 0 ){
      pinchStrenth = globalHands.frontmost().pinchStrength();
      if ( (pinchStrenth > 0.8 ) && ( globalHands.frontmost().fingers().extended().count() > 2 ) ) {
        if (pinchStrenth > maxPinch ) {
          maxPinch = pinchStrenth;
        }
        println( maxPinch  + " - " +  pinchStrenth + " = " + (maxPinch  - pinchStrenth));  
        if ( maxPinch  - pinchStrenth > 0.09   ) {
          pinchInfo.put("PINCH: " + globalHands.frontmost().fingers().extended().count() + " " + pinchStrenth, DECAY_MAX);
          maxPinch  = -1.0;
          setNextState();
        }
      }
    }
  } 

} 



