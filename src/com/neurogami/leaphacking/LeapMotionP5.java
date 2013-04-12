/**
 * ##library.name##
 * ##library.sentence##
 * ##library.url##
 *
 * Copyright ##copyright## ##author##
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
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

  public final static String VERSION = "##library.prettyVersion##";

  /**
   * a Constructor, usually called in the setup() method in your sketch to
   * initialize and start the library.
   *
   * It isn't essential for this library, as you can just import the library 
   * and then create Leap Motion class instances on your own.
   * 
   * @example LeapMotionP5
   * @param ownerP
   */
  public LeapMotionP5(PApplet ownerP) {
    owner = ownerP;
  }

  public Controller createController(Object listener) {
    return( new Controller( (Listener) listener) );
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

