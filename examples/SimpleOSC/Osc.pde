import oscP5.*;
import netP5.*;

// import java.util.Map;
import java.util.HashMap;

class OscManager {

  OscP5 oscP5;

  NetAddress oscServer;

  OscMessage msgOn;
  OscMessage msgOff;
  OscMessage msg;



  int renoiseInstr = 0;
  int renoiseTrack = 1;


  /*
     This code needs to drop the Renoise hard-coded stuff and allow for easier 
     sending of whatever OSC.

     The probelm is that OSC messages come in all shpaes and sizes.

     An ideal solution would allow something like:

     sendOSC( "/my/cool/address/pattern", 0.3, "Some string", 5);

     This would require a Java/Processing method that accepted near-arbitrary arguments.

     That might not be a possible thing.

     The next option might be to pass all that stuff as a single argument, a list thing.


     A third thing might be to use a single carefully-crafted string:

     sendOSC( "/my/cool/address/pattern  0.3 'Some string' 5");

     or something.

     Then some other code would need to figure out what that meant.

     Option 2 is possible: http://stackoverflow.com/questions/16363547/how-to-declare-an-array-of-different-data-types

     but it has a problem in common with option 3: How does the code know the types of OSC arguments?


     There is Ruby code that does some regexy stuff to sort out what something is.

     It feels fragile to try to port it to Java.

     Some othre ideas:

     Require the use to define their OSC calls in some special file.  

     Then call those with runtime values.

Or: Require OSC commands to look like this:

[  "/my/cool/address/pattern", "fsi",  "0.3",  "Some string", "5" ]

An array of strings that use the first 2 items for the address pattern and tag types.


Is there some way to cache any of the evaluation?  Store what we know about an OSC message pattern?

There's still parsing, but splitting the tag type into chars seems easier tha guessing data types.


This approach works, though there is some latency.

What if there were also some arg-specific methods? for example:
   * oscInt1(addressPattern,  n1)
   * oscInt2(addressPattern,  n1, n2)

   Many OSC servers do work with a fairly smallish range of argument options. 

   So provide semi-generic "args of these kinds" methods to avoid doing type parsing.



   */
  /***************************************************************/
  OscManager(Configgy config ) {
    println("Creating an OscManager!");
    oscP5 = new OscP5(this, config.getInt("oscListeningPort"));
    oscServer = new NetAddress(config.getString("oscServerIP"), config.getInt("oscServerPort"));
  }

 //   /***************************************************************/
 //   public void sendMessage(String[] addrPatternAndArgs, HashMap<Character,Float> args ) {
 //     println("* send OSC message to " + addrPatternAndArgs );
 //     ThreadedOscSend _ts = new ThreadedOscSend(oscP5, oscServer);
 //     _ts.setBundleData(addrPatternAndArgs, args);
 // 
 //     new Thread(_ts).start();
 //   }


  /***************************************************************/
  public void sendBundle(String[][] addrPatternAndArgsArray, HashMap<Character,Float> args ) {
    println("* send OSC BUNDLE to " + addrPatternAndArgsArray );


    ThreadedOscSend _ts = new ThreadedOscSend(oscP5, oscServer);

    _ts.setBundleData(addrPatternAndArgsArray, args);
    new Thread(_ts).start();
  }




}

