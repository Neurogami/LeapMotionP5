import com.leapmotion.leap.*;

HandList globalHands;

class PointerListener extends Listener {


  //------------------------------------------------------------
  void onInit(Controller controller) {
    d("Initialized");
    avgPos = Vector.zero();
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
  } 

} 

