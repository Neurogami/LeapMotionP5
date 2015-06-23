# OSC Demo 2 #

This example is similar to the `Simple OSC` example.  They both use essentially the same approach and code: Load in some OSC message templates from  a config file, associate these messages with certain events (such as a Leap Motion gesture), and then generate the OSC message by inserting Leap values into the OSC message template.

In this version the `LeapMotionP5` library is used in callback mode.  

What this means is that once you've instantiated a `LeapMotionP5` instance that instance will use a default built-on `Listener` class.  And that class will expect your main sketch code to implement an `onFrame` function. The function will be called on each `Listener` `onFrame` event, and will pass along the `Controller` instance.

Basically, what you put in this `onFrame` function is what you might put into the `onFrame` of your own `Listener` instance.

A typical Processing sketch works by repeatedly invoking the `draw` function. In the `Simple OSC` version the `draw` function would ask the `Listener` instance for assorted state and data, and then do stuff.

Using the callback approach we turn this around.  Now the sketch is driven by the `onFrame` function.  It grabs whatever Leap state and data needed and in turn calls other functions as needed.

The sketch still needs to render a UI, so, after `onFrame` dispatches assorted behavior it calls `redraw` to manually trigger `draw`.

Learn more about [noLoop](https://processing.org/reference/noLoop_.html) and [redraw](https://processing.org/reference/redraw_.html).

There are a few advantages to using the callback approach.  One, you don't need to create your own `Listener` class.  Two, it can feel more natural for sketch behavior to be driven by what the Leap is doing inside `onFrame`.

A downside is that you lose some code isolation.  Listener helper methods are not neatly contained in the listener class file.  


## Using the sketch

First, please keep in mind that this is a demo sketch intended to show some ways to interact with the `LeapMotionP5` library.  It is important that it work, and be reasonably useful, but it is hardly feature-complete.

The demo using `Configgy` to load the file `data\config.jsi`.   That file defines a number of key data, such as as IP address and port of the OSC server (here assumed to be a local instance of Renoise).

The sketch explores the idea of an app having multiple states; the results of some user interaction depends on the current state.

The sketch starts in state 0, and you "roll over" to the next state by sweeping your hand up.  When the last state is reached then state rolls over again to 0.   The current state number is rendered in the upper-left corner of the sketch window.

The config file uses the `states` entry to map states to a set of OSC message templates.  The example is fairly simple; each set of messages send a pair of messages to an "XY Pad" effect on different tracks.  You sweep you hand up to change what track will be the recipient of the messages.

If you pinch your fingers then the X and Y Leap coordinates (remapped to the range -1.0 to 1.0) are sent.

The sketch also uses the spacebar key.  If you simply extend fingers and hit the spacebar the sketch sends an OSC message to mute or unmute a track.  The target track is based on the number of extended fingers detected; this is shown in the lower right corner of the sketch window.

Being limited to only toggling mute on the first four of five tracks would be annoying, so there's `muteMapping` config option that maps the finger-count value to the actual track to address.

The demo song (see details below) has various tracks collected in "groups" (a feature of Renoise). These are the mapped muting targets.

These group tracks also have an "XY Pad" effect in the device chain.  This is a device that you map to the parameters of another device for that track.

Renoise has a built-in OSC server and a set of [default OSC messages](http://tutorials.renoise.com/wiki/Open_Sound_Control) it understands.

One of them allows you to send a value to named parameter on a device on a track.  

The OSC template code allows for swapping OSC message arguments but does not yet have a way to alter the address pattern itself. The config file therefore is set for specific tracks and devices.

The track muting has no configuration option. It is simply built-in to the sketch code.  This is far from ideal. 

## Odds and ends

The sketch includes code to remove the sketch window border, relocate it to the bottom-right corner of the screen, and always stay on top.

The code tells the Leap to keep working in the background (you may have to adjust your own Leap settings to allow this).

This way you can interact with Renoise (or any other OSC server) while not losing site of the sketch window.

Know that in order for the sketch to react to the spacebar the sketch has to have focus.  


##  Renoise

[Renoise](http://www.renoise.com/) is [DAW software](https://en.wikipedia.org/wiki/Digital_audio_workstation). It is also a tracker.

It is a terrific tool for creating and performing music.  

If you do not have it then you can [download a free demo version.](http://www.renoise.com/download)

The demo has a few restrictions but nothing that will prevent you from loading the sample song and playing around with the example.


## The demo song 


"Faceless" is a track from the upcoming album from Neurogami, "Maximum R&D".  

You can hear more at [http://music.neurogami.com](music.neurogami.com)

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

