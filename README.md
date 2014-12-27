LeapMotionP5
============

Processing  library for the Leap Motion controller


[James Britt / Neurogami](http://www.neurogami.com)

james@neurogami.com

See also the [Leap Hacking](http://leaphacking.com) Web site for news and articles about making the most of your Leap Motion device.


Description
===========

This is (as you may have guessed) a [Processing](http://processing.org) library to make it easier to use the Leap Motion Java libraries in your sketches.

Distribution of the actual Leap Motion library files is currently not allowed by Leap Motion so you have to provide those yourself.

You should use the most current Leap Motion libraries available.  If this P5 library does not work with the latest Leap libs then this library is broken.


Building the library
====================

I've only ever bothered to use this on Windows, but if you are on OSX you should be able to adapt these steps with little trouble.

You need to have Apache `ant` installed in order ot run the build.

These steps assume the `ant`  executable is already on your `%PATH%`. If not, then you can use the full path the executable.


    cd resources
    ant 
    cd ..
    

 Seems pretty simple, right? Here's the catch: every so often this fails. I get errors such as


       c:\Users\james\repos\LeapMotionP5\resources\build.xml:268: Couldn't rename temporary file

Re-running the process usually takes care of this.  


Another issue is when ant decides it will not delete the old jar file before copying over the new one.

What seems to be the cause is a hidden Java (i.e.Processing) process running that is referencing that jar.  If you are trying out the library and kill your sketch it is possible for the sketch to appear to close while the underlying java.exe process is still running.


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

Feed your head. Hack your world. Live curious.
