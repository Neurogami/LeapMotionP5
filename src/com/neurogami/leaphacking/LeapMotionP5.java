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


import com.leapmotion.leap.*;
import processing.core.*; 

public class LeapMotionP5 {

  // owner is a reference to the parent sketch
  PApplet owner;
  public Controller defaultController;

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
    defaultController = createController(defaultListener);
  }

  public LeapMotionP5(PApplet ownerP, boolean useCallbackListener ) {
    owner = ownerP;
    defaultListener = new DefaultListener();
    defaultListener.owner = ownerP;
    defaultListener.useFrameCallback = useCallbackListener;
    defaultController = createController(defaultListener);
  }


  public Controller createController(Object listener) {
    return( new Controller( (Listener) listener) );
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

