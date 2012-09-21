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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.Button;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	
	/**
	 * A button with text label.
	 * 
	 * @author haykel
	 * 
	 */
	public class LabelButton extends Button
	{
		
		//--------------------------------------------------
		// Instance vriables
		//--------------------------------------------------
		
		protected const labelDisplay:TextField = new TextField();
		
		//--------------------------------------------------
		// label
		//--------------------------------------------------
		
		private var _label:String;

		/**
		 * Button label.
		 */
		public function get label():String
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			if (value == label)
				return;
			
			_label = value;
			invalidateDisplay();
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			labelDisplay.multiline = false;
			labelDisplay.wordWrap = false;
			labelDisplay.autoSize = TextFieldAutoSize.LEFT;
			labelDisplay.mouseEnabled = false;
			labelDisplay.defaultTextFormat = new TextFormat("Verdana", 24, 0xffffff);
			addChild(labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			labelDisplay.text = label;
			labelDisplay.x = (width - labelDisplay.width) / 2;
			labelDisplay.y = (height - labelDisplay.height) / 2;
			
			graphics.clear();
			graphics.lineStyle(4, ColourPalette.HIGHLIGHT_BLUE, 0.4, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			graphics.beginFill(ColourPalette.DISABLED_BLUE, 0.4);
			graphics.drawRoundRect(2, 2, width - 4, height - 4, 12, 12);
			graphics.endFill();
			graphics.lineStyle();
		}
	}
}