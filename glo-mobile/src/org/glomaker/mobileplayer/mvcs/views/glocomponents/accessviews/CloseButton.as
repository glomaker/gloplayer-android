/* 
* GLO Mobile Player: Copyright (c) 2012 LTRI, University of West London. An
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
package org.glomaker.mobileplayer.mvcs.views.glocomponents.accessviews
{
	import flash.display.Graphics;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.views.components.AnimatedButton;

	/**
	 * Button for closing speaker popup. 
	 */	
	public class CloseButton extends AnimatedButton
	{
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// prepare drawing
			var g:Graphics = graphics;
			g.clear();
			
			// background
			g.beginFill( ColourPalette.SLATE_BLUE, 0.5 );
			g.drawRoundRectComplex(0, 0, width, height, 10, 10, 10, 10);
			g.endFill();
			
			// icon
			var w1:Number = 0.23 * width;
			var w2:Number = 0.33 * width;
			var w3:Number = 0.40 * width;
			var wc:Number = width / 2;
			
			var h1:Number = 0.23 * height;
			var h2:Number = 0.33 * height;
			var h3:Number = 0.40 * height;
			var hc:Number = height / 2;
			
			g.beginFill( 0xffffff, 0.8 );
			g.moveTo( w1, h2 );
			g.lineTo( w2, h1 );
			g.lineTo( wc, h3 );
			g.lineTo( width - w2, h1 );
			g.lineTo( width - w1, h2 );
			g.lineTo( width - w3, hc );
			g.lineTo( width - w1, height - h2 );
			g.lineTo( width - w2, height - h1 );
			g.lineTo( wc, height - h3 );
			g.lineTo( w2, height - h1 );
			g.lineTo( w1, height - h2 );
			g.lineTo( w3, hc );
			g.lineTo( w1, h2 );
			g.endFill();
		}
	}
}