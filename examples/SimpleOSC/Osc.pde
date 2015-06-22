import oscP5.*;
import netP5.*;

import java.util.HashMap;

class OscManager {

  OscP5 oscP5;
  NetAddress oscServer;
  OscMessage msg;


  /***************************************************************/
  OscManager(Configgy config ) {
    oscP5 = new OscP5(this, config.getInt("oscListeningPort"));
    oscServer = new NetAddress(config.getString("oscServerIP"), config.getInt("oscServerPort"));
  }


  /***************************************************************/
  public void sendBundle(String[][] addrPatternAndArgsArray, HashMap<Character,Float> args ) {
    // println("* send OSC BUNDLE to " + addrPatternAndArgsArray );
    ThreadedOscSend _ts = new ThreadedOscSend(oscP5, oscServer);
    _ts.setBundleData(addrPatternAndArgsArray, args);
    new Thread(_ts).start();
  }

}

