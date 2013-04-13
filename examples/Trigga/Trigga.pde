import com.neurogami.leaphacking.*;

/*

   v4

   This examples show how to use the angle between fingers to determin 
   what has been detected.

 */

NgListener listener = new NgListener();
Controller controller;

boolean pause;
int pauseMax = 100;
int pauseCount = 0;

// LeapMotionP5 leap;

//-------------------------------------------------------------------
void setup() {
  size(700, 500, OPENGL);
  controller = new Controller(listener);
}


//-------------------------------------------------------------------
void draw() {
  processBlamPause(); 
  if (!pause) { 
    background(255);
    renderHand();
  }
}

//-------------------------------------------------------------------
void processBlamPause() {
  if (pause)  {
    pauseCount++;

    if (pauseCount > pauseMax) {
      pause = false;
      pauseCount = 0;
    }
  }
}

//-------------------------------------------------------------------
void renderHand() {

  textSize(32);
  fill(20, 30, 190);

  text("haveGun() X : " + listener.haveGun() , 100, 100 );

  if (listener.havePull()) {
    textSize(42);
    background(250, 30, 90);
    fill(0, 0, 0);
    text("B L A M O !", 100, 100 );
    pause = true;
  }
}

