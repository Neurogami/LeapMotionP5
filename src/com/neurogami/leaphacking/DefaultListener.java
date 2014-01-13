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

import java.lang.reflect.Method;
import processing.core.*; 
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.State;

class DefaultListener extends Listener {

  public HandList globalHands;
  public Frame    globalFrame;
//  public InteractionBox globalBox;
  public PApplet owner;
  public boolean useFrameCallback = false;

  Method onFrameCallback = null;
  /*
     Need to think about how the user can set or enable or detect gestures.
     */

  //------------------------------------------------------------
  public void onFrame(Controller controller) {
    globalFrame = controller.frame();
    globalHands = globalFrame.hands();
  //  globalBox   = globalFrame.interactionBox();
    
      if (useFrameCallback == true ) {
      // System.err.println("useFrameCallback!");

      // This needs to be dynamic!
      //       owner.onFrame(controller);
      try {
        //  Need to see how to cache the method reference. This plan here isn't working.
        //  It seems that on each pass the refernce ot the method is no good.
        //      if ( onFrameCallback == null ) {
        // System.err.println("Need to acquire the method ...");
        Class[] cArg = new Class[1];
        cArg[0] = com.leapmotion.leap.Controller.class;
        // System.err.println("Have cArg[0]");
        Method onFrameCallback = this.owner.getClass().getMethod( "onFrame", cArg );
        // System.err.println("Have onFrameCallback " + onFrameCallback.toString());


        //    }

        //System.err.println("Try to invoke the onFrameCallback ... ");
        onFrameCallback.invoke(this.owner, controller);

      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  } 


  public HandList hands(){
    return globalHands;
  }

  
  public Frame frame(){
    return globalFrame;
  }

}


