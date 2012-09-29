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
package org.glomaker.mobileplayer.mvcs.views.components
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;

	/**
	 * Button to open the QR code reader.
	 * 
	 * @author haykel
	 */	
	public class QRCodeButton extends ShapeButton
	{
		override protected function drawShape():void
		{
			shape.graphics.clear();
			
			shape.graphics.lineStyle(4, ColourPalette.BUTTON_UP_BLUE, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			shape.graphics.drawRect(-25, -25, 20, 20);
			shape.graphics.drawRect(5, -25, 20, 20);
			shape.graphics.drawRect(-25, 5, 20, 20);
			shape.graphics.lineStyle();
			
			shape.graphics.beginFill(ColourPalette.BUTTON_UP_BLUE);
			shape.graphics.drawRect(-19, -19, 8, 8);
			shape.graphics.drawRect(11, -19, 8, 8);
			shape.graphics.drawRect(-19, 11, 8, 8);
			shape.graphics.endFill();
		}
	}
}