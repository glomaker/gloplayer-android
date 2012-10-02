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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.GUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.utils.FontUtil;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	
	/**
	 * A panel of information of the journey manager (for the journey name and Glo location).
	 * 
	 * @author haykel
	 * 
	 */
	public class JourneyInfoPanel extends GUIComponent
	{
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		public static const HEIGHT:uint = ScreenMaths.mmToPixels(7);
		public static const PADDING:uint = ScreenMaths.mmToPixels(1);
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var titleDisplay:TextField = new TextField();
		protected var textDisplay:TextField = new TextField();
		
		//--------------------------------------------------
		// title
		//--------------------------------------------------
		
		private var _title:String = "";
		private var titleChanged:Boolean;

		/**
		 * Title.
		 */
		public function get title():String
		{
			return _title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			value = value ? value : "";
			
			if (value == _title)
				return;
			
			_title = value;
			
			titleChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------
		// text
		//--------------------------------------------------
		
		private var _text:String = "";
		private var textChanged:Boolean;
		
		/**
		 * Text.
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			value = value ? value : "";
			
			if (value == _text)
				return;
			
			_text = value;
			
			textChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (titleChanged)
			{
				titleChanged = false;
				titleDisplay.text = _title;
				invalidateDisplay();
			}
			
			if (textChanged)
			{
				textChanged = false;
				textDisplay.text = _text;
				invalidateDisplay();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			titleDisplay.defaultTextFormat = new TextFormat(FontUtil.FONT_REGULAR, 10, ColourPalette.JOURNEY_LIGHT_BLUE);
			textDisplay.embedFonts = true;
			titleDisplay.multiline = false;
			titleDisplay.wordWrap = false;
			titleDisplay.selectable = false;
			titleDisplay.autoSize = TextFieldAutoSize.LEFT;
			addChild(titleDisplay);
			
			textDisplay.defaultTextFormat = new TextFormat(FontUtil.FONT_BOLD, 20, 0xffffff);
			textDisplay.embedFonts = true;
			textDisplay.multiline = false;
			textDisplay.wordWrap = false;
			textDisplay.selectable = false;
			textDisplay.autoSize = TextFieldAutoSize.LEFT;
			addChild(textDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			titleDisplay.x = PADDING;
			titleDisplay.y = (height - titleDisplay.textHeight - textDisplay.textHeight) / 2;
			
			textDisplay.x = PADDING;
			textDisplay.y = titleDisplay.y + titleDisplay.textHeight;
			
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}