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
	
	import net.dndigital.components.EnhancedGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.utils.FontUtil;
	
	/**
	 * Represents a step in the journey route.
	 * 
	 * @author haykel
	 * 
	 */
	public class JourneyStep extends EnhancedGUIComponent
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var indexDisplay:TextField = new TextField();
		
		//--------------------------------------------------
		// index
		//--------------------------------------------------
		
		private var _index:uint;
		private var indexChanged:Boolean;

		/**
		 * Defines the index of this step in the journey.
		 */
		public function get index():uint
		{
			return _index;
		}

		/**
		 * @private
		 */
		public function set index(value:uint):void
		{
			if (value == _index)
				return;
			
			_index = value;
			
			indexChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------
		// selected
		//--------------------------------------------------
		
		private var _selected:Boolean;

		/**
		 * Defines whether the step is currently selected (current step).
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			if (value == _selected)
				return;
			
			_selected = value;
			
			invalidateDisplay();
		}
		
		//--------------------------------------------------
		// visited
		//--------------------------------------------------
		
		private var _visited:Boolean;

		/**
		 * Defines whether the step has been visited by the user.
		 */
		public function get visited():Boolean
		{
			return _visited;
		}

		/**
		 * @private
		 */
		public function set visited(value:Boolean):void
		{
			if (value == _visited)
				return;
			
			_visited = value;
			
			invalidateDisplay();
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		override protected function commited():void
		{
			super.commited();
			
			if (indexChanged)
			{
				indexChanged = false;
				indexDisplay.text = index.toString();
				invalidateDisplay();
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			indexDisplay.defaultTextFormat = new TextFormat(FontUtil.FONT_BOLD, 18);
			indexDisplay.embedFonts = true;
			indexDisplay.multiline = false;
			indexDisplay.wordWrap = false;
			indexDisplay.mouseEnabled = false;
			indexDisplay.selectable = false;
			indexDisplay.autoSize = TextFieldAutoSize.LEFT;
			addChild(indexDisplay);
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.clear();
			
			indexDisplay.x = (width - indexDisplay.width) / 2;
			indexDisplay.y = (height - indexDisplay.height) / 2;
			
			if (selected)
			{
				indexDisplay.textColor = ColourPalette.JOURNEY_DARK_BLUE;
				
				graphics.beginFill(0xffffff);
				graphics.drawEllipse(0, 0, width, height);
				graphics.endFill();
			}
			else if (visited)
			{
				indexDisplay.textColor = 0xffffff;
				
				graphics.lineStyle(2, 0xffffff);
				graphics.beginFill(ColourPalette.JOURNEY_LIGHT_BLUE);
				graphics.drawEllipse(1, 1, width - 2, height - 2);
				graphics.endFill();
				graphics.lineStyle();
			}
			else
			{
				indexDisplay.textColor = ColourPalette.JOURNEY_LIGHT_BLUE;
				
				graphics.lineStyle(2, ColourPalette.JOURNEY_LIGHT_BLUE);
				graphics.beginFill(ColourPalette.JOURNEY_DARK_BLUE);
				graphics.drawEllipse(1, 1, width - 2, height - 2);
				graphics.endFill();
				graphics.lineStyle();
			}
		}
	}
}