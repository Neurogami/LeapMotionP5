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

  // myParent is a reference to the parent sketch
  PApplet owner;

  public final static String VERSION = "##library.prettyVersion##";


  /**
   * a Constructor, usually called in the setup() method in your sketch to
   * initialize and start the library.
   * 
   * @example LeapMotionP5
   * @param owner
   */
  public LeapMotionP5(PApplet ownerP) {
    owner = ownerP;
//    owner.registerMethod("dispose", this);
  }

  public Controller createController(Listener listener) {
    return(new Controller(listener));
  }

  public void dispose() {
    // Need to clean up any objects we created, such as listener or controller.
  }

  // private void welcome() {
  //  System.out.println("##library.name## ##library.prettyVersion## by ##author##");
  // }


  /**
   * return the version of the library.
   * 
   * @return String
   */
  public static String version() {
    return VERSION;
  }


}

