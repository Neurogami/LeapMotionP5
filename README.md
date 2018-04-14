Project has moved to GitLab
===========================

All deveopment is now happening over on [GitLab](https://gitlab.com/ProcessingNG/LeapMotion).

Code has been updated to work wth Provessing v3 and the latest Leap Motion SDK.




LeapMotionP5
============

Processing V2 library for the Leap Motion controller


[James Britt / Neurogami](http://www.neurogami.com)

james@neurogami.com

See also the [Leap Hacking](http://leaphacking.jamesbritt.com/) Web site for news and articles about making the most of your Leap Motion device.


Description
===========

This is (as you may have guessed) a [Processing](http://processing.org) library to make it easier to use the Leap Motion Java libraries in your sketches.

Distribution of the actual Leap Motion library files is currently not allowed by Leap Motion so you have to provide those yourself.

You should use the most current Leap Motion libraries available.  If this P5 library does not work with the latest Leap libs then this library is broken (and a bug report should be filed).


Building the library
====================

To get the build process working on different development machines a few environment variables are needed:

`P5_SKETCHBOOK` defines the location of your Processing sketchbook folder
`ECLIPSE_WORKSPACE` defines the location of your Eclipse `workspace` folder (needed to provide some core Processing files)

See `build.properties` for more details on building a Processing library.

You need to have Apache `ant` installed in order to run the build.

These steps assume the `ant`  executable is already on your `%PATH%`. If not, then you can use the full path the executable.

    cd resources
    ant 
    cd ..
    

Seems pretty simple, right? Here's the catch: every so often this fails (on Windows). 

I get errors such as

       c:\Users\james\repos\LeapMotionP5\resources\build.xml:268: Couldn't rename temporary file

Re-running the process usually takes care of this.  

Another issue is when ant decides it will not delete the old jar file before copying over the new one.

What seems to be the cause is a hidden Java (i.e.Processing) process running that is referencing that jar.  If you are trying out the library and kill your sketch it is possible for the sketch to appear to close while the underlying java.exe process is still running.



The examples
============

One of the goals of this library was to afford different ways for a Processing sketch to interact with the Leap code.

Most Processing tutorials teach users to create a `setup` function that prepares a few things, and a `draw` function that (often) handles the core sketch code.

More advanced Processing sketches, however, make use of callback handlers.  Rather than relying on `draw` to initiate some action, a callback can be invoked by the behavior of some other code, often running in its own thread.

People who want to use a Leap Motion with their Processing sketches should not have to pick one approach over another.  

Being able to grab Leap data on each call of `draw` makes it very easy to get started.  Being able to use callbacks makes certain kinds of sketches easier to write.  `LeapMotionP5` aims to allow for a variety of programming approaches.

Towards that end the examples are geared to showing just how to do this.

The first such example was the "Pointer Location" demo.

A new example has been added that allows one to do finger painting.

There are multiple "Pointer Location" sketches, each designed somewhat differently.

There is currently just one "Finger Paint" demo, showing the "grab data inside draw()" approach to using the Leap library.  

That will be expanded to show the other approaches.

Because the examples are quite similar there is a fair amount of common code.  To avoid duplication there are some files holding the shared code.  They need to be copied into each example sketch folder before running the sketch.

Note: these things were just recently updated, so some stuff might still be flakey.



License 
========


(The MIT License)

Copyright (c)  James Britt / Neurogami

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Feed your head. 
Hack your world. 
Live curious.
