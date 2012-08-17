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
package net.dndigital.components
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * TextArea component renders formatted and not formatted text.
	 * 
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.IGloComponent
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.GloComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public final class TextArea extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(TextArea);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields.
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const textField:TextField = new TextField;
		
		/**
		 * @private
		 * Flag, indicates whether border should ber redrawn.
		 */
		protected var redrawBorder:Boolean = false;
		
		/**
		 * @private 
		 */		
		protected var scrollIndicator:Shape = new Shape;
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @copy	flash.display.TextField#htmlText
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get htmlText():String { return textField.htmlText; }
		/**
		 * @private
		 */
		public function set htmlText(value:String):void { 
			textField.htmlText = value;
			invalidateDisplay();
		}
		
		/**
		 * @copy	flash.display.TextField#text
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get text():String { return textField.text; }
		/**
		 * @private
		 */
		public function set text(value:String):void {
			textField.text = value || "";
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _border:Boolean = false;
		/**
		 * @copy	flash.display.TextField#border
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get border():Boolean { return _border; }
		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			if( value != _border )
			{
				_border = value;
				invalidateDisplay();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			textField.multiline = true;
			textField.defaultTextFormat = new TextFormat("Verdana", 14, 0x0B333C);
			textField.wordWrap = true;
			textField.border = false;
			addChild(textField);
			
			scrollIndicator.visible = false;
			scrollIndicator.cacheAsBitmap = true;
			addChild( scrollIndicator );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			textField.width = width;
			textField.height = height;
			
			//
			scrollIndicator.x = width + 2;
			
			// scrollbar needs redrawing to reflect available scroll area
			if( textField.maxScrollV > 1 )
			{
				scrollIndicator.visible = true;
				textField.addEventListener( Event.SCROLL, updateScrollbarPosition, false, 0, true );
				
				var visibleLines:uint = textField.bottomScrollV - ( textField.scrollV - 1 );
				var scrollH:Number = height * visibleLines / textField.numLines;
				
				var g:Graphics = scrollIndicator.graphics;
				g.clear();
				g.beginFill( 0x5a6678, 0.3 );
				g.drawRoundRectComplex( 0, 0, 5, scrollH, 3, 3, 3, 3  );
				
				updateScrollbarPosition();
				
			}else{
				
				scrollIndicator.visible = false;
				textField.removeEventListener( Event.SCROLL, updateScrollbarPosition );
				
			}
			
			// draw border
			graphics.clear();
			if (_border) {
				graphics.lineStyle(1, 0xb7babc, 1, true, LineScaleMode.NONE);
				graphics.drawRect(0, 0, width, height);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler - text field has been scrolled.
		 * Can also be called as a normal function. 
		 * @param e
		 */		
		protected function updateScrollbarPosition( e:Event = null ):void
		{
			// NB: scrollV and maxScrollV are 1-based indices
			scrollIndicator.y = ( ( textField.scrollV - 1 ) / ( textField.maxScrollV - 1 ) ) * ( textField.height - scrollIndicator.height );
		}
	}
}