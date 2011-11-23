/* 
* GLO Mobile Player: Copyright (c) 2011 LTRI, University of West London. An
* Open Source Release under the GPL v3 licence (see http://www.gnu.org/licenses/).
* Authors: DN Digital Ltd, Tom Boyle, Lyn Greaves, Carl Smith.

* This program is free software: you can redistribute it and/or modify it under the terms 
* of the GNU General Public License as published by the Free Software Foundation, 
* either version 3 of the License, or (at your option) any later version. This program
* is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* 
* For GNU Public licence see http://www.gnu.org/licenses/ or http://www.opensource.org/licenses/.
*
* External libraries used:
*
* Greensock Tweening Library (TweenLite), copyright Greensock Inc
* "NO CHARGE" NON-EXCLUSIVE SOFTWARE LICENSE AGREEMENT
* http://www.greensock.com/terms_of_use.html
*	
* A number of utility classes Copyright (c) 2008 David Sergey, published under the MIT license
*
* A number of utility classes Copyright (c) DN Digital Ltd, published under the MIT license
*
* The ScaleBitmap class, released open-source under the RPL license (http://www.opensource.org/licenses/rpl.php)
*/
package org.glomaker.mobileplayer.mvcs.utils
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;

	/**
	 * Utility functions for drawing things. 
	 * @author nilsmillahn
	 */	
	public class DrawingUtils
	{
		/**
		 * Matrix for gradient fills.
		 * Single instance reused - better for mobile devices. 
		 */		
		protected static const GRADIENT_MATRIX:Matrix = new Matrix;
		

		/**
		 * Draw a standard gradient fill, vertical, lighter to darker.
		 * Colours will be taken from the ColourPalette class. 
		 * @param g
		 * @param w
		 * @param h
		 */		
		public static function drawStandardGradient( g:Graphics, w:Number, h:Number, x:Number = 0, y:Number = 0, clearFirst:Boolean = true ):void
		{
			if( clearFirst )
			{
				g.clear();
			}
			
			var m:Matrix = GRADIENT_MATRIX;
			m.createGradientBox(w, h, Math.PI/2);
			
			g.beginGradientFill( GradientType.LINEAR, [ ColourPalette.GRADIENT_START, ColourPalette.GRADIENT_END ], [1, 1], [0, 255], m );
			g.drawRect(x, y, w, h);
			g.endFill();
		}
	}
}