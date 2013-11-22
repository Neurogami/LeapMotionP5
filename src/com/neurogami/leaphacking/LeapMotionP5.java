/**
 * ##library.name##
 * ##library.sentence##
 * ##library.url##
 *
 * Copyright 2013 James Britt / Neurogami 
 *
 * The MIT License (MIT)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *  
 * 
 * @author      ##author##
 * @modified    ##date##
 * @version     ##library.prettyVersion## (##library.version##)
 */


package com.neurogami.leaphacking;


// import com.leapmotion.leap.*;

import com.leapmotion.leap.Config;
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.HandList;
import com.leapmotion.leap.Listener;
import com.leapmotion.leap.Pointable;
import com.leapmotion.leap.ScreenList;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;


import processing.core.*; 

public class LeapMotionP5 {

  // owner is a reference to the parent sketch
  PApplet owner;
  public Controller controller;

  public HandList globalHands;
  public DefaultListener defaultListener;
  public final static String VERSION = "##library.prettyVersion##";

  /**
   * a Constructor, usually called in the setup() method in your sketch to
   * initialize and start the library.
   *
   * It isn't essential to have this library, as you can just import the library 
   * and then create Leap Motion class instances on your own.
   * 
   * @example LeapMotionP5
   * @param ownerP
   */
  public LeapMotionP5(PApplet ownerP) {
    owner = ownerP;
    defaultListener = new DefaultListener();
    defaultListener.owner = ownerP;
    controller = createController(defaultListener);
  }

  public LeapMotionP5(PApplet ownerP, boolean useCallbackListener ) {
    owner = ownerP;
    defaultListener = new DefaultListener();
    defaultListener.owner = ownerP;
    defaultListener.useFrameCallback = useCallbackListener;
    controller = createController(defaultListener);
  }


  public Controller createController(Object listener) {
    return( new Controller( (Listener) listener) );
  }

  public void  allowBackgroundProcessing( boolean policy ) {
    if (policy == true ) {
      controller.setPolicyFlags(Controller.PolicyFlag.POLICY_BACKGROUND_FRAMES);
    } else {
      controller.setPolicyFlags(Controller.PolicyFlag.POLICY_DEFAULT);
    }
  
  }

  public HandList hands() {
    return defaultListener.hands();
  }


  /**
   * return the version of the library.
   * 
   * @return String
   */
  public static String version() {
    return VERSION;
  }


}

