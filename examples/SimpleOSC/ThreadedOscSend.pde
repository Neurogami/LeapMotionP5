import oscP5.*;
import netP5.*;

import java.util.HashMap;

//-------------------------------------------------------------------
class ThreadedOscSend extends Thread {

  OscMessage msg;
  OscBundle  bundle;
  String[]   argStrings;
  String[][] addrPatternAndArgsArray;
  HashMap<Character,Float> args;
  String addressPattern;

  NetAddress remoteOscServer;
  OscP5 oscP5;
  boolean sendOSC = true;
  boolean haveArgs = false;


  //-------------------------------------------------------------------
  // See if these server things are not available as global stuff thanks to the main sketch
  public ThreadedOscSend(OscP5 oscP5, NetAddress remoteOscServer ){
    this.oscP5 = oscP5;
    this.remoteOscServer = remoteOscServer;
  }

  //-------------------------------------------------------------------
  //   public void setMsgData(String[] addrPatternAndArgs, HashMap<Character,Float> args) {
  //     addressPattern = addrPatternAndArgs[0];
  //     this.argStrings = addrPatternAndArgs[1].split(",");
  //     this.args = args;
  //     this.haveArgs  = false;
  //   }

  //-------------------------------------------------------------------
  // It gets even more tricky if we want that args to contain values other than
  // float, but for now ..
  // FIXME: Think of efficient way to pass args of varyinf data types. 
  public void setBundleData(String[][] addrPatternAndArgsArray, HashMap<Character,Float> args) {
    this.addrPatternAndArgsArray = addrPatternAndArgsArray;
    this.args = args;
    this.haveArgs  = false;
  }



  //-------------------------------------------------------------------
  //   public void setMsgData(String addrPattern, int i) {
  //     addressPattern = addrPattern;
  //     this.argStrings = argStrings;
  //     this.args = args;
  //     this.haveArgs  = false;
  //   }


  //-------------------------------------------------------------------
  // new version: There is a use caae with Renoise where the message 
  // requires a specific value, and not one from the Leap data.
  // For example:
  //   /renoise/song/track/1/device/2/set_parameter_by_name "X-Axis", <x>
  // So we need a way to hard-code specific values in a list arg info.
  //
  // one way would be to make the config item a list of strings.
  // s[0] is the pattern.  all the rest are args.  If an arg string
  // has a ':' then it indicates a tag type followed by the fixed data.
  // else we assume it is some placeholder for Leap data (whose type
  // will be known).
  //
  // Since this wil never change, can the message be cached and on 
  // future calls just have the Leap values updated?

  public OscMessage makeMessage(String[] msgStuff) {

    String addressPattern = msgStuff[0];

    String[] argStrings     = msgStuff[1].split(",");

    // println("argStrings = " + argStrings ); 
    //println("args = " + args.toString()  ); 
    msg = new OscMessage(addressPattern);
    //String t = "";

    for( String t : argStrings) {
      // FIXME: We assume the tag types are always float,
      // and that what we are checking are hash keys
      // println("t = " + t );
      if (t.indexOf(':') > 0 ) {
        String[] foo = t.split(":");
        switch ( foo[0].charAt(0) ) {
          case 'i':
            msg.add( parseInt( foo[1] ));
            break;
          case 'f':
            msg.add( parseFloat(foo[1]  ));
            break;
          case 's':
            msg.add( foo[1]  );
            break;
        }
      }
      else { 
        // Why does a NPE sometimes occur here?
        msg.add( args.get(t.charAt(0))  );
      }
    }

    return msg;
  }

  //-------------------------------------------------------------------
  public void makeMessages() {
    bundle = new OscBundle();

    for( int i = 0; i < addrPatternAndArgsArray.length;  i++ ){
      bundle.add(makeMessage(addrPatternAndArgsArray[i]));
    }
  }

  //-------------------------------------------------------------------
  public void run(){
    makeMessages();
    //    println("Sending " + msg + " to " + remoteOscServer);
    oscP5.send(bundle, remoteOscServer); 
    //    try {
    //    Thread.sleep(this.duration);
    //} catch(InterruptedException ie) {
    //}

    //    oscP5.send(noteOffMsg, remoteOscServer); 
  }
}

