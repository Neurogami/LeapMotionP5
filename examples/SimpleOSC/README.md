# Simple OSC Demo

This sketch shows how to create your own `Listener` class, customize it to grab the data of interest (as well tell it what gestures to track), and make assorted state available through public class instance methods.

It follows a common approach to writing a Processing sketch: Initialize assorted variables in `setup`, then have the code in `draw` decide what to do on each invocation.

The "Leap smarts" is in the `SimpleOSCListener` class.  In this case it looks for an open-handed sweep gesture, as well as for finger pinching.

## Using the sketch

First, please keep in mind that this is a demo sketch intended to show some ways to interact with the `LeapMotionP5` library.  It is important that it work, and be reasonably useful, but it is hardly feature-complete.


The demo using `Configgy` to load the file `data\config.jsi`.   That file defines a number of key data, such as as IP address and port of the OSC server (here assumed to be a local instance of Renoise).

The sketch explores the idea of an app having multiple states; the results of some user interaction depends on the current state.

The sketch starts in state 0, and you "roll over" to the next state by sweeping your hand up.  When the last state is reached then state rolls over again to 0.   The current state number is rendered in the upper-left corner of the sketch window.

The config file uses the `states` entry to map states to a set of OSC message templates.  The example is fairly simple; each set of messages send a pair of messages to an "XY Pad" effect on different tracks.  You sweep you hand up to change what track will be the recipient of the messages.

If you pinch your fingers then the X and Y Leap coordinates (remapped to the range -1.0 to 1.0) are sent.


##  Renoise

[Renoise](http://www.renoise.com/) is [DAW software](https://en.wikipedia.org/wiki/Digital_audio_workstation). It is also a tracker.

It is a terrific tool for creating and performing music.  

If you do not have it then you can [download a free demo version.](http://www.renoise.com/download)

The demo has a few restrictions but nothing that will prevent you from loading the sample song and playing around with the example.



## The demo song 


This track was created in order to have some simple but usable for the demo.  

The song (and Renoise file) is copyright [James Britt](jamesbritt.com) / [Neurogami](https://neurogami.com)

It is provided under the Creative Commons license  Attribution-NonCommercial-ShareAlike  [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/)


## OSC 

Learn more about OSC at [osc.justthebestparts.com](http://osc.justthebestparts.com)




## Copyright and license 

Copyright [James Britt](jamesbritt.com) / [Neurogami](https://neurogami.com)

The code is released under the [MIT license](http://opensource.org/licenses/MIT)


    Feed your head
    Hack your world
    Live curious

