import oscP5.*;
import netP5.*;


class ThreadedSend extends Thread{

  OscMessage noteOnMsg;
  OscMessage noteOffMsg;
  NetAddress remoteoscServer;
  OscP5 oscP5;

  public ThreadedSend(OscP5 oscP5, NetAddress remoteoscServer, OscMessage noteOnMsg, OscMessage noteOffMsg){
    this.oscP5 = oscP5;
    this.noteOnMsg = noteOnMsg;
    this.noteOffMsg = noteOffMsg;
    this.remoteoscServer = remoteoscServer;
  }

  public void run(){
    oscP5.send(noteOnMsg, remoteoscServer); 
    try {
      Thread.sleep(300);
    }catch(InterruptedException ie) {
      //Log message if required.
    }

    oscP5.send(noteOffMsg, remoteoscServer); 
  }
}

