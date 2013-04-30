import com.neurogami.leaphacking.*;
import saito.objloader.*;

/*

   v7

   This examples show how to use the angle between fingers to determin 
   what has been detected.

 */

NgListener listener = new NgListener();
Controller controller;

OBJModel model ;

float rotX, rotY, rotZ;


boolean haveGun = false;

Vector handDirection;
Vector palmNormal;
Vector palmPosition;
boolean pause;

int NUMHEARTS = 8;
int colorIncrement = 0;

PShape[] heartShapes;


int pauseMax = 300;
int pauseCount = 0;

// LeapMotionP5 leap;

//-------------------------------------------------------------------
void setup() {
  // size(displayWidth-90, displayHeight-90, P3D);
  size(displayWidth, displayHeight, P3D);

  model = new OBJModel(this, "jgb-experiment.obj", "absolute", TRIANGLES);
  model.enableDebug();
  model.scale(40);
  model.translateToCenter();

  heartShapes = new PShape[NUMHEARTS];
  controller = new Controller(listener);
  loadHearts();
  
}


void loadHearts(){
  for(int i=0; i< NUMHEARTS ; i++) {
    heartShapes[i] = loadShape("Love_Heart_symbol_00" + i + ".svg");
    heartShapes[i].scale(0.5, 0.5);
  } 
}

void grabHandData() {
  haveGun = listener.haveGun(); 
  handDirection =   listener.handDirection();
  palmNormal = listener.palmNormal();
  palmPosition = listener.palmPosition();

}


//-------------------------------------------------------------------
void draw() {
  print(".");

  processBlamPause();  
  if (!pause) { 
    background(255);
    renderHand();
  }

}


//-------------------------------------------------------------------
void processBlamPause() {
  int offsetX = width/6;
  int offsetY = height/6;
  int tX, tY;

  if (pause)  {
    pauseCount++;
    if (pauseCount % 8  == 0 ) {
      colorIncrement++;
      colorIncrement = colorIncrement%NUMHEARTS;
      heartShapes[colorIncrement].scale(1.5);  
      tX = (int) (random(offsetX, width-offsetX)  - heartShapes[pauseCount%NUMHEARTS].width/2);
      tY = (int) (random(offsetY, height-offsetY) - heartShapes[pauseCount%NUMHEARTS].height/2);
  tint(255, 126);  // Display at half opacity
      shape(heartShapes[colorIncrement], tX, tY );   
    }
    if (pauseCount > pauseMax) {
      pause = false;
      pauseCount = 0;
      loadHearts();
    }
  }
}

/*-------------------------------------------------------------------

  The Leap coordinates are:

  |   +
  |    
  Y | 
  |  0
  -X ---------------------- +X

  /   -Z (as you cross over the Leap device
  /
  /
  /+ Z


  The P3D coords are not quite the same:

  Z goes from 0 at the place and gets negative as you go into the plane.  This is more or less the same as Leap (if you treat the Leap physicxal location as the screen plane.

  X starts from the upper left-hand corner and moves from 0 to positve as you go right.  SO -X is off the screen to the left.

  Y starts in the same place and gooes fomr 0 to postive as you move down. -Y is off the screen top.

  To match Leap to P5 we need to do some translation or adjusting.

  Fo example, ignoreing Z, if I have the hand in the center and ust above the leap I may have  (0, 10, 100)

  X == 0 means width/2.

  -------------------------------------------------------------------*/
void renderHand() {

  grabHandData();
  textSize(32);
  fill(20, 30, 190);

  text("haveGun() X : " + haveGun , 100, 100 );

  lights();
  if(haveGun) {
    pushMatrix();

    translate(palmPosition.getX()+(displayWidth/2), palmPosition.getY(), palmPosition.getZ() );

    model.draw();
    popMatrix();

  }else {
    model.draw();
  }

  if (listener.havePull()) {
    handleBlam();
  }
}


void handleBlam() {
  textSize(182);
  background(255, 100, 60);
  fill(90, 250, 90);
  text("B L A M O !", 200, 200 );
  pause = true;

}


void keyPressed() {
  background(0);
  text(key,width/2,height/2.5);
  try {
    println("Write hand data to file " + sketchPath + "/data.log" );
    java.io.FileWriter file = new java.io.FileWriter( sketchPath + "/data.log", true);

    String s = "Key: "  +key+ "; listener.haveGun() = " +listener.haveGun();
    s += "; handDirection() = " +  listener.handDirection() + "; palmNormal() = " + listener.palmNormal()  + "\n"; 

      file.write(s);
    file.flush();
    file.close();
  }
  catch (IOException ioe) {
    println("error: " + ioe);
  }

  if ( key == 'q' ){
    handleBlam() ;
  }
}


/*

http://commons.wikimedia.org/wiki/File:Love_Heart_symbol.svg



 */
