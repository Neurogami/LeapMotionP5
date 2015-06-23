# Finger Painter Demo

This is a low-feature demo sketch to show the use of the `LeapMotionP5` library.

Its main value is in showing how to create an instance of `LeapMotionP5`, tell it to look for certain gestures, and provide custom `Listener` class methods to expose state.  The sketch relies on the `draw` loop to pull data from the listener and decide what to do.

The sketch looks to see if the user is pinching, and if so it will paint to the screen.  When the pinch is released the drawing stops, but the cursor continues to show your hand location.

The cursor/drawing color is based on the hand Z coordinate; as you move you hand in or out from the Leap the color should change.

If you sweep your hand upwards the image is erased so you can start over.

The border of the sketch window changes based on the "confidence" value of the Leap.  As you move your hand out of the Leap's detection range the border will change from black to red.

It's a code demo; there is no way to save, no undo.  Some things can be configured in the `data\config.jsi` file, such as windows size, brush/cursor size, and the range of colors.



## Copyright and license 

Copyright [James Britt](jamesbritt.com) / [Neurogami](https://neurogami.com)

The code is released under the [MIT license](http://opensource.org/licenses/MIT)


    Feed your head
    Hack your world
    Live curious

