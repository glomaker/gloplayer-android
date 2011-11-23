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
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import net.dndigital.components.mobile.IMobileListItemRenderer;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;

	/**
	 * List item for the menu list.
	 * This is a copy of the TouchListItemRenderer from thanksmister with some tweaks.
	 * @author nilsmillahn
	 */	
	public class MenuListItem extends Sprite implements IMobileListItemRenderer
	{
		protected var _data:Object;
		protected var _index:Number = 0;
		protected var _itemWidth:Number = 0;
		protected var _itemHeight:Number = 0;
		
		protected var initialized:Boolean = false;
		protected var textField:TextField;
		protected var shadowFilter:DropShadowFilter;
		
		//-------- properites -----------
		
		public function get itemWidth():Number
		{
			return _itemWidth;
		}
		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
			draw();
		}
		
		public function get itemHeight():Number
		{
			return _itemHeight;
		}
		public function set itemHeight(value:Number):void
		{
			_itemHeight = value;
			draw();
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
			draw();
		}
		
		public function get index():Number
		{
			return _index;
		}
		public function set index(value:Number):void
		{
			_index = value;
		}
		
		public function MenuListItem()
		{
			createChildren();
			cacheAsBitmap = true;
			opaqueBackground = 0x000000;
		}
		
		//-------- public methods -----------
		
		/**
		 * Show our item in default state.
		 * */
		public function unselectItem():void
		{
			draw();
		}
		
		/**
		 * Show our item selected.
		 * */
		public function selectItem():void
		{
			this.graphics.clear();
			
			// background
			this.graphics.beginFill( ColourPalette.HIGHLIGHT_BLUE, .9);
			this.graphics.drawRect(0, 0, itemWidth, itemHeight);
			this.graphics.endFill();
			
			// underline
			this.graphics.lineStyle( 1, 0x757575, 1, true, LineScaleMode.NONE );
			graphics.moveTo( 0, _itemHeight - 1 );
			graphics.lineTo( _itemWidth, _itemHeight - 1 );

			// text and shadow
			this.textField.textColor = 0x000000;
			this.filters = [shadowFilter];
		}
		
		public function destroy():void
		{
			this.removeChild(textField);
			
			this.graphics.clear();
			this.filters = [];
			
			textField = null;
			shadowFilter = null;
			_data = null;
			
			initialized = false;
		}
		
		//-------- protected methods -----------
		
		/**
		 * Install the DroidSans front from Google:
		 * http://code.google.com/webfonts/family?family=Droid+Sans
		 * */
		protected function createChildren():void
		{
			if(!textField) {
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = 0xEAEAEA;
				textFormat.size = 34;
				textFormat.font = "Arial";
				
				textField = new TextField();
				textField.mouseEnabled = false;
				textField.defaultTextFormat = textFormat;
				
				this.addChild(textField);
			}
			
			initialized = true;
			
			draw();
			
			shadowFilter = new DropShadowFilter(3, 90, 0x000000, .6, 8, 8, 1, 2, true);
		}
		
		protected function draw():void
		{
			if(!initialized) return 
				
			textField.x = 5;
			textField.text = String(data);
			textField.textColor = 0xffffff;
			
			var lm:TextLineMetrics = textField.getLineMetrics(0);
			textField.height = Math.ceil( lm.height + lm.descent );
			
			textField.width = itemWidth - 10;
			textField.y = Math.floor( ( itemHeight - textField.height )/2 );
			
			this.graphics.clear();
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, itemWidth, itemHeight);
			this.graphics.endFill();
			
			// underline
			graphics.lineStyle( 1, 0x757575, 1, true, LineScaleMode.NONE );
			graphics.moveTo( 0, _itemHeight - 2 );
			graphics.lineTo( _itemWidth, _itemHeight - 2 );
			
			this.filters = [];
		}
		
		
		// ----- event handlers --------
		
	}
}