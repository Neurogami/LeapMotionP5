HandList globalHands;

class NgListener extends Listener {


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
     globalHands = controller.frame().hands();
  } 

} 

