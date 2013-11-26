# The Pointer Location Examples, Part 1 #


The [`LeapMotionP5`](https://github.com/Neurogami/LeapMotionP5) library started off as a simple wrapper for the Leap Motion Java library that is part of the [Leap Motion software developer kit (SDK)](https://developer.leapmotion.com/getting_started).

It worked, and worked well.  The first version of the `Pointer Location` example was written to use that early version.

Later, `LeapMotionP5` was updated to allow other ways of accessing the Leap Motion data.  As the library evolved new versions of the `Pointer Location` were created to show usage.

This, a subsequent articles, is meant to help explain how to the use the `LeapMotionP5` library by way of some examples.  In particular, there is a simple example that takes the average of finger-top positions and renders that data on a corresponding screen location.  This basic premises is presented in multiple ways to show the different ways you can use the `LeapMotionP5` library.

## A note about library development ##

I try as best I can to build code based on tangible use cases.  I mostly go by my own needs and experience, but do try to consider how others may use my code and what they might expect.  The `LeapMotionP5` library has undergone a number ofchanges since first made public.  There are likely to be more changes over time, though hopefully nothing that wreaks havoc with existing sketches. 


### Running the example code ###

There are multiple versions of the basic `Pointer Location` demo, and while each shows different ways of interacting with the `LeapMotionP5` library there is some amount of common code.

Processing sketches expect to find all required code files within the sketch folder.  Rather than have to maintain the same code across multiple examples there is a file, `PointerDemoUtils.pde`, in the root of the `examples` folder, that has the common code.  You need to copy that file into each of the `Pointer Location` folders before running any of them.

Once that is done you can just load any of the examples in the Processing IDE or run them from command line.


## Version 1: The raw SDK approach ##

If you look at the [Leap Motion SDK docs for the Java library](https://developer.leapmotion.com/documentation/Languages/Java/Guides/Leap_Overview.html) you'll see a simple example and an explanation of how to write Leap Motion programs using Java.  

Basically, you use an instance of a `Controller` class to handle the connection between your program and the Leap device, and a `Listener` object that handles events (e.g. "Here's some hand and finger data!") dispatched by the Leap.

The two are intertwingled:  You first create a `Listener` thing and pass that to the creation of your `Controller` thing; your `Listener` must have a method named `onFrame` that is called every time the Leap has new data, and when that method gets called the `Controller` is passed in.

The `Controller` class is the one provided by the Leap SDK.  Your `Listener` class, however, needs to be written by you (although it will be based on the  `Listener` class alos provided by the Leap SDK).  This turns out to be pretty simple.  

The reason you need to provide your own `Listener` class is because it is there that all the fun stuff happens.  You need to decide what should happen inside `onFrame` with the Leap data.

You may be used to doing all or most of your Processing sketch programming inside the `draw` method of your main sketch file.  You can still do this if you like.    The different `Pointer Location`  examples include ways to do it.

### Using a Listener class ###

Note: You should be familiar with the official documentation from Leap Motion.  The API docs for the `Listener` class are [here](https://developer.leapmotion.com/documentation/Languages/Java/API/classcom_1_1leapmotion_1_1leap_1_1_listener.html).

The first `Pointer Location` sketch, `PointerLocation1`, uses a separate file to define a custom `Listener` class.  We do not need to create the class from scratch; we can (and should) `extend` the existing `Listener` class provided by the Leap Motion SDK.

    class PointerListener extends Listener {
      // code goes here 
    }


You can name the class as you like; if putting it in a separate file (usually a good idea) just name the file to match the class name.

This is example is simple: Look for hands.  If any are found grab the first one and look for fingers. Get the location for all finger tips and compute the average.  Then, in `draw`, render that average on the screen at the corresponding location.

Your `Listener` class  has a number of methods of special interest.   These are the `onSomethingOrOther` methods. (See [here](https://developer.leapmotion.com/documentation/Languages/Java/API/classcom_1_1leapmotion_1_1leap_1_1_listener.html).) They are automatically called (via the Leap device) when different events occur.

For example, when you first connect to the Leap device your `onConnect` method gets called.  These are handy when you want to take some action for specific conditions. For example, if the Leap device becomes disconnected you could use `onDisconnect` to trigger a warning message to the user.

`onInit` is useful for preparing your `Listener` class for use.  The Pointer example uses a `Vector` property,  `avgPos` to store the calculated average finger position.  Since the main sketch will be asking for the value of this property, `onInit` is used to assign it a starting value.  This way the `Listener` class can always return something even if it has yet to detect any hands or fingers.

The most important method, however, is `onFrame`.  Once the Leap is connected it starts looking for hands, fingers, "pointables", and so on.  It does this very quickly, over and over, and reports what it finds in a data "frame." Each time it collects a frame of data it calls `onFrame`. 

`onFrame` is passed a `Controller` instance.  You use this to pull out Leap data.  (That's not _all_ you can do with this `Controller` instance but that's the main interest for now.)  

More specifically, you use the `Controller` instance to get the current `frame` value.  From that, you can get hands, fingers, and so on.  (See [](http://127.0.0.1/leapdocs/Java/API_Reference/classcom_1_1leapmotion_1_1leap_1_1_frame.html).)

For example:


    void onFrame(Controller controller) {

      Frame frame = controller.frame();
      HandList hands = frame.hands();

      if (hands.count() > 0 ) {
        println("Hand!");
        Hand hand = hands.get(0);
        FingerList fingers = hand.fingers();
        if (fingers.count() > 0) {
          println("Fingers!");
          avgPos = Vector.zero();
          for (Finger finger : fingers) {
            avgPos = avgPos.plus(finger.tipPosition());
          }

          avgPos = avgPos.divide(fingers.count());

        } // if fingers
      } //  if hands 
    } 


And that is how the example sketch gets the average finger location.  

### Meanwhile, back in the main sketch code ... ###

But there still remains the rendering part.  In `PointerLocation1.pde`, the code method pulls the `avgPos` value and uses it to assemble  some text for presentation.

At the start of the sketch the code declares a `Controller` and a `Listener`:

    import com.neurogami.leaphacking.*;
    import com.leapmotion.leap.*;

    PointerListener listener   = new PointerListener();
    Controller      controller = new Controller(listener);

That's all the Leap set-up needed to use your `Listener` code.   Note that this is a really simple demo; for example, it makes no use of Gestures.  Later sample sketches show more.

With this in place the `draw` method just needs to call `listener.avgPos()`.

To render the postion on the screen some value conversion is needed.  You cannot just map directly the Leap finger coordinates to a Processing.  For one thing, the Leap X value (the left/right direction) works from the point directly over the center of the Leap device; -10 is a position just lef to of center.  On the Processing screen, -10 is off the screen, as 0 is at the left edge.  The Leap Y value starts at 0 at the glass screen and gets larger as you move up, whereas with Processing 0 is at the top of the screen as gets larger as you move down.

Further, your computer screen is unlikely to have the same height and width as what the Leap can detect.

So, two forms for coordinate transformation take place using some built-in Processing methods.  [`constrain`](http://processing.org/reference/constrain_.html) forces a value to fall within a given range; basically, if given a number too big or too small the result is whatever tyou set as the largest or smallest value.

[`map`](http://processing.org/reference/map_.html) is a related transformation.  It, too, works with a range; two, in fact.  `map` assumes that you start with a value that is within a know range (something `constrain` can provide).  

This sketch code takes, for example, the Y value of the average finger position and uses `constrain` to ensure that it is never less than 0 and never greater than some maximum height (such as 300).

This new value of, now force to sit in the range of 0 to 300, is passed to `map`, where it is converted to a screen Y position.  To ensure that the Y location is always visible it is mapped to the range `height` to 0.  Notice that by using a range that goes from the screen height down to zero the orientation is aromatically inverted, which is what we want. 

The same (more or less) happens for the X value.  The original value is force to be no higher or lower than some fixed value (in this case 150 and -150), and then `map` is used to convert a value within this range to a location on the screen, the range 0 to `width`.

All off this wrapped up in some helper methods, `mapXforScreen` and `mapYforScreen`.

There is also a method `writePosition` that grabs the current position data and writes it to the screen at the calculated location.

I've not mentioned the Z value.  Since a 3D position is being mapped to a 2D screen, the Z value is used to alter the color of the rendered text. The further away from the screen (relative to the Leap, of course) the fainter the text.

That leaves this:

    void draw() {
      background(255);
      writePosition();
    }


## Wrapping up, and some observations ##

This is just one of a few different versions of this simple example. Assorted things have been glossed over; more will be covered in write-up for the other versions.

First, some comments about this approach to using the Leap Motion SDK in a Processing sketch.  This came about because this is how the Leap SDK makes itself available to Java programs.  Processing, under the hood, is Java, so following the Leap Java style makes it quite easy to apply what's show for Java in Processing.   

The counter to this is that many, perhaps most, people using Processing are not recovering Java programmers.  They do not want to think in terms of Java to do something in Processing.  Valid point, and this is why `LeapMotionP5` offers other, perhaps more 'Processing native", options.

The second point to be made is use of an additional class to manage the Leap data.  To jump ahead a bit, `LeapMotionP5` will also let you do this:

    void draw() {
      
      if (leap.hands().count() > 0 ) {
        println("\tDraw: Have leap.hands().count() = " + leap.hands().count() );
          
        Hand hand = leap.hands().get(0);
        // Do more stuff with that hand ...
        
      }
    }


This is perhaps exactly what many P5 fans would expect.  Which is fine, but still not what I would advocate (though I do show *exactly* that in an example, for educational purposes only).  

I am more of a fan of trying to keep things reasonably decoupled.  I use the weasel-word "reasonably" to avoid getting sidetracked.  The basic idea is this: My sketch may work best with a Leap Motion, but it may also be quite usable with a mouse.  Or a Wii remote. Or several things.  My my main body of code (e.g. `draw`) should not have to be so intimately aware of how `avgPos` is determined.  It only needs to be able to grab it an use it.  So, even when you have the option of direct access to controller (broadly speak, not just Leap Motion) data in your main code you should consider abstracting that a bit so that you can still develop, test, and use you sketch even when attaching and using an actual Leap device isn't practical.
























