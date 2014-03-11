import saito.objloader.*;

OBJModel model ;

float rotX, rotY;

// http://en.wikipedia.org/wiki/Hitscan
//

PShape target;
Target heart;

int targetDepth = -1600;
color bgColor = color(0,0,0);

void setup() {
  size(800, 600, P3D);
  frameRate(30);
  model = new OBJModel(this, "jgb-experiment.obj", "absolute", TRIANGLES);
  model.enableDebug();

  model.scale(20);
  model.translateToCenter();

  stroke(255);
  noStroke();

  heart = new Target("Love_Heart_symbol_002.svg", width-10, height - 10, targetDepth);
}





void draw() {
  int xLoc, yLoc, zLoc;

  background(bgColor);
  lights();

  heart.render();  
  pushMatrix();

  // The model s, byt defalt, at 0,0.
  // You need to translate it.
  // But what you are really transalting is the whole coordinate system,
  // so 0,0 is the center. 
  xLoc = width/2;
  yLoc = height/2;
  zLoc = -100;

  translate(xLoc, yLoc, zLoc);


  strokeWeight(0);
  rotateX(rotX);
  rotateY(rotY);
  model.draw();

  strokeWeight(10);
  stroke(0,0,255);

  //  line(0,-30, 0, 0, -30, targetDepth*2);
  // Draw a series of circles along this line.  

  strokeWeight(3);
  stroke(255,128,255);
  boolean zHit = false;
  bgColor  = color(133,0,0);
  
  for( int z = 0; z > targetDepth*4; z-=30) {
      pushMatrix();
      translate(0, -30, z);     
      ellipse(0, 0, 20, 20  );
      popMatrix();
     
      if (screenZ(0,0,z) < heart.scrZ() ) {
        println("\nHIT! " + screenZ(0,0,z) + " <  " + heart.scrZ() );
        zHit = true;
      } else { 
        println("\nNO HIT! " + screenZ(0,0,z) + " >  " + heart.scrZ() );
       zHit = false; 
    }
    
    

   if (zHit) {
      println("zHit = " + zHit + ". We have reached target z: screenZ(0,0,z) = " + screenZ(0,0,z) + " ; heart.screenZ()  = " + heart.scrZ()  );
      println("Line x:y = " + screenX(0,0,z) + ":" + screenY(0,0,z) + ". Target x:y = " + heart.scrX() + ":" + heart.scrY() );     
      println("Have an XY  hit? " + heart.haveIntersectXY(screenX(0,0,z), screenY(0,0,z)) );
      if ( heart.haveIntersectXY(screenX(0,0,z), screenY(0,0,z)) ) {
        bgColor = color(0,0,255);
    }
   }
  }


  // This draws a line 400 units out from the model.
  // How can we tell if this hits or intersects some given point? 
  //  In particualr, if we a re moving another model under its
  //  own translation/rotatio, how do we get the absolute line points and
  //  model locations?
  //  If we so  a translate x,y,z then we know the model is at that point.
  //  If we translate/rotate the end point of the line we n


  println("Line endpoint is " + screenX(0,-30, targetDepth) + ", " + screenY(0,-30, targetDepth) + ", " + screenZ(0,-30, targetDepth) );
  /*

     The thing is, after you draw a line and rotate it you don't know if the end is before or after the inital z plane, since the
     line has been rotated.


http://gamedev.stackexchange.com/questions/25524/line-segment-and-sphere-intersect

http://www.realtimerendering.com/intersections.html
http://geomalgorithms.com/a06-_intersect-2.html


"Assume we have a ray R (or segment S) from P0 to P1, 
and a plane P through V0 with normal n"

In our case we use the z-plane where the target sits; assume it is 
always facing forwards.

"The intersection of the parametric line L: P(r)=P0+r(P1-P0) 
and the plane P occurs at the point P(rI) with parameter value:"

r(I) = ( n . (V0 - P0) )/ (n . (P1 - P0))  

Those are dot products of vectors

"When the denominator n_dot_(P1-P0)=0, the line L is parallel 
to the plane P , and thus either does not intersect it or else 
lies completely in the plane (whenever either P0 or P1 is in P )"

Fucking math.

What if we did some ballistic shit?

Draw spheres or something at a set of intervals and checked for object intersection. Or point proximity.

We know a z coordinate.


http://answers.yahoo.com/question/index?qid=20081005181048AAXRDdK
http://www.math.washington.edu/~king/coursedir/m445w04/notes/vector/equations.html

" A plane in 3-space has the equation"
ax + by + cz = d,






   */



  /*

     screenX/Y/Z will return the actual screen location for coordinates.
     If we store those when drawing stuff and placing things we can then tell if something is a hit
http://www.processing.org/discourse/alpha/board_Syntax_action_display_num_1050420270.html

We need aproximate intersection to see if a line is passing through some target.  


http://workshop.evolutionzone.com/2011/04/06/code-modelbuilder-library-public-release/
https://github.com/mariuswatz/ITP2013Parametric/blob/master/src-modelbuilderMk2/README%20-%20ModelbuilderMk2.md

Given two points we can find the slope.  Given a thrid pint we can see if it falls on that line (maybe be getting 
a secnd slope with that new point and seeing if it matches the first slope.)

Or: Assume a flat target along the z-plane; it has x and y dimensions.
If we draw a line from the model that extends to the same z location as the target we can get the
x and y of the line endpoint and see if that 2D point falls withing the 2D shape of the target

We want a "good-enough" match

http://forum.processing.org/two/discussion/2619/how-to-rotate-many-3d-planes-around-their-center-along-the-y-axis/p1

We start with the model facing a known direction in a known place.

The rendering is just donw in a translated space.

Can we calcualte the start and end poiints of a line, tranlates those points as we translate tje
model, and draw the line?

That is, we know that if we are at 0,0,0, and want to draw a line 10 units away it 
goes to 0,0,-10

We then translate and rotate those two points.

Or draw a line a trans- rotate it?

http://forum.processing.org/two/discussion/2619/how-to-rotate-many-3d-planes-around-their-center-along-the-y-axis/p1


   */



  popMatrix();

  // We know the location so we just draw there.
  fill(255,0,0);
  stroke(255,0, 0);
  strokeWeight(5);
  ellipse(xLoc, yLoc,  100, 100); 



}

boolean bTexture = true;
boolean bStroke = false;

void keyPressed() {
  if(key == 't') {
    if(!bTexture) {
      model.enableTexture();
      bTexture = true;
    } 
    else {
      model.disableTexture();
      bTexture = false;
    }
  }

  if(key == 's') {
    if(!bStroke) {
      stroke(255);
      bStroke = true;
    } 
    else {
      noStroke();
      bStroke = false;
    }
  }

  else if(key=='1')
    model.shapeMode(POINTS);
  else if(key=='2')
    model.shapeMode(LINES);
  else if(key=='3')
    model.shapeMode(TRIANGLES);
}

void mouseDragged() {
  // Swapped so that things move aling the line of roation that looks more natural
  rotY += (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

