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
	 * View component - button to go back to Menu from Player. 
	 * @author nilsmillahn
	 */	
	public class BackToMenuButton extends ShapeButton
	{
		override protected function drawShape():void
		{
			shape.graphics.clear();
			shape.graphics.lineStyle(4, ColourPalette.BUTTON_UP_BLUE, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			shape.graphics.moveTo(-26, 23);
			shape.graphics.lineTo(3, 23);
			shape.graphics.lineTo(3, 7);
			shape.graphics.lineTo(13, 7);
			shape.graphics.lineTo(13, 23);
			shape.graphics.lineTo(26, 23);
			shape.graphics.lineTo(26, -1);
			shape.graphics.lineTo(0, -26);
			shape.graphics.lineTo(-26, -1);
			shape.graphics.lineTo(-26, 23);
			shape.graphics.lineStyle();
		}
	}
}