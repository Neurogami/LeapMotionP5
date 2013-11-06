# Using the LeapMotionP5 Library #

## Intro ##

`LeapMotionP5` is a Processing library to allow your sketches to use the Leap Motion controller.

As with many such libraries for Processing it is a work in progress. Changes will be based on actual usage over time.

There are a few design goals.  One is that it be relatively easy to use.  The other is that is avoid feature creep.

It should be, more or less, a wrapper around the Leap Motion SDK libraries with some small number of affordances to assist in use with Processing sketches.


## The basic case ##

The Leap Motion SDK provides libraries for use with Java applications.  Processing sketches are, under the hood, Java programs, so they can use Leap Java SDK libraries.

If you look at the Leap Motion Java SDK documentation (and this is highly recommended, no matter what Processing Leap library you are using), you'll find that Leap library talks to the outside world by means of two key classes: `Listener` and `Controller`.

The  `Listener` (or more accurately, your subclass of the `Listener` class) does the interesting stuff.  The `Controller` is the thing that manages communication with the Leap device.

There should be some examples included with the LeapMotionP5 distribution.  One one them is (or should be) `PointerLocation`.

This is a very basic sketch that does a nice job of showing you how to use the Leap Motion in the default or "basic" way.

In order to get data from the Leap and act on it you need to create your own `Listener` class and define a variable for the default  `Controller` instance:

    // Include the library for LeapMotionP5
    import com.neurogami.leaphacking.*;
    
    // Prepare your key Leap variables. 
    MyListener listener = new MyListener();
    Controller controller;


Then, in `setup`:

    controller = new Controller(listener);

Now your `Listener` subclass will be able to grab data from the Leap.

### Creating a Listener subclass ###

Classes in Processing look like this:

    class MyClassName  {
      // class code goes here
    }


See [http://processing.org/reference/class.html](http://processing.org/reference/class.html) for more details.

The key part here is that you can create a `subclass` of an existing class using `extends`:

    class MyListener extends Listener {
       // Your code goes here
    }

The `Listener` class is made available for use when you include the `LeapMotionP5` library in your main sketch file.


The subclass of `Listener` should have a few methods. The first three are possibly handy if you want to prepare or clean up any other resources:


    void onInit(Controller controller) {
      println("Initialized");
      avgPos = Vector.zero();
    }

    void onConnect(Controller controller) {
      println("Connected");
    }

    void onDisconnect(Controller controller) {
      println("Disconnected");
    }


The essential method is `onFrame`.  The Leap Motion will be spewing out "frames" of data, quite rapidly.  `onFrame` is a callback function: It gets called on each new frame being available.  

All these methods are passed the `Controller` instance you originally instantiated.  It is this `controller` variable that has the Leap data.

By the way, `controller` has not just frame data but other information about the Leap device as well. Here we are only lookng at frame data, as that's where we get hand and finger details.


To look for hand data, you can do this:

    Frame frame = controller.frame();
    HandList hands = frame.hands();

You can then see if there are any hands detected:


    if (hands.count() > 0 ) {
      println("Hand!");
 
and, if so, if any fingers can be seen on the first hand:

      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() >= 1) {
        println("Fingers!");
      }
    }


Your best reference for the available methods on `Frame`, `HandList`, `Hand`, and other Leap Motion classes is the SDK documentation.  
   

Look also at the examples included with `LeapMotionP5` to see some practical usage.





## Why must I do all that Listener coding stuff? ##

There are some other Processing libraries for using the Leap Motion that take a different approach.  For example, one of them assumes that your main `draw` function will want to reference the Leap data source directly.  Your code need just grab a reference to a list of `Hand` instances and pull the data.

The up side to this approach is that it may be easier for a newcomer. The downside, though, is the coupling of your main code to a specific controller.

However, if you really want to use the "reference data directly via `draw`" approach, you can.

`LeapMotionP5` comes with a default `Listener` subclass called (surprise!) `DefaultListener`.   If you use the "basic" or raw approach then, once you have included a reference to the `LeapMotionP5` package path (i.e. `import com.neurogami.leaphacking.*;`) then you actually skip referencing the `LeapMotionP5` proper because you load the Leap Motin libs more or less directly.

However, the `LeapMotionP5` library itself performs some behind-the-scenes stuff to use that default  `Listener` subclass to instantiate a `Controller` and make Leap `HandList` data available.

Here's yet another way then to get Leap data (from `PointerLocation3.pde`); this example has no `.pde` file for the `Listener` subclass:

    import com.neurogami.leaphacking.*;

    LeapMotionP5 leap;

    void setup() {
      size(displayWidth-30, displayHeight-30, OPENGL);
      leap = new LeapMotionP5(this);
    }


    void draw() {
      if (leap.hands() != null) {
        if (leap.hands().count() > 0 ) {
          println("Have leap.hands().count() = " + leap.hands().count() );
          Hand hand = leap.hands().get(0);
         // More stuff ...
       }
     }




### Using an intermediate data object ###



The `PointerLocation` example uses a `Listener` subclass to provide the data to be rendered, but this class does not handle the rendering itself. Instead, it populates a data structure accessible from the `draw` method. Each time `draw` is invoked it pulls the data from this structure and uses it to decide what to render and where to render it. (The sketch renders your finger coordinates, with some variations in shading based on distance along the Z axis.)

This indirection provides a few benefits. One, your main code is not coupled to a specific data source. `draw` need not know anything about hands or fingers.   You could provide control data from a number of sources (mouse, keyboard, OSC messages, Xbox Kinect, as well as the Leap Motion) and the central `draw` logic can stay the same.  

This is particularly handy when you do not want to have to test your sketch using a Leap.  For example, suppose you want to check that your code is correctly handling when the cursor has been moved to the center of the screen.  You could use the Leap and move your hand about in order to provide the needed input, or you could use the mouse.  Or reader data from a file.  Trust me, you arm and hands can get tired when you are constantly moving about adjusting a program or tracking down a bug.


# NOTE! RETHINK #

Explaining the loop stuff is hard to get right.  So skip it in the first post about the lib.

Also, clean up the lib and forget about having clever callbacks that are invoked on gestures.  

Here's why: Unless there is a clear use case for having a separate method called to respond to the detection of a gesture, the usage so far says that you are more likely to want to check for gestures along with other state conditions.  In other words, when you find that there has been a Circle Gesture you will also want to know the number of hands, fingers, and other gestures, are when in some special state, time since last event of note and so on.

All of this info is available from the current frame (and frame history) as found in `onFrame()`.

Or, if you prefer, you get that in `draw()`.  But parcelling out discrete event detection does not seem to make anything easier.  Your main logic method (either in or called from `draw` or `onFrame`) will just need to fetch the results acquired in your event callbacks. You don't get any less code, but more indirection.



## Event loops in Processing ##

It's probably safe to say that for most use of Processing you do not need to understand what, technically, is happening under the hood. You mostly know that `draw` gets called over and over, and each time it updates what you see or hear.  Part of the value and appeal of Processing is that is nicely obscures many otherwise technical details.  However, knowing these details can be useful.



    [REFERENCE: https://code.google.com/p/processing/issues/detail?id=187]


    [REFERENCE: https://developer.leapmotion.com/forums/forums/general-discussion/topics/0-7-1-leap-creates-new-thread-for-each-onframe]


