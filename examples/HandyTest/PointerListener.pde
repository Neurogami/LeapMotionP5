import com.leapmotion.leap.*;

HandList globalHands;
InteractionBox box;

class PointerListener extends Listener {


  //------------------------------------------------------------
  void onInit(Controller controller) {
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();

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
     globalHands  = controller.frame().hands();
     box          = controller.frame().interactionBox();
  } 

} 

