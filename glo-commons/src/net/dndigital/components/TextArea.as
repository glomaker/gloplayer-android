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
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	
	import eu.kiichigo.utils.log;
	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

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
		protected const textFieldScrollRect:Rectangle = new Rectangle();
		
		/**
		 * @private
		 * Flag, indicates whether border should ber redrawn.
		 */
		protected var redrawBorder:Boolean = false;
		
		/**
		 * @private 
		 */		
		protected var scrollIndicator:Shape = new Shape;
		protected var scrollIndicatorMask:Shape = new Shape;
		
		// scroll management
		protected var lastMouseY:Number;
		protected var lastMouseY2:Number;
		protected var lastMouseTime:int;
		
		
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
		
		/**
		 * @private
		 * Vertical text scroll position.
		 */
		public function get scrollerY():Number
		{
			return textFieldScrollRect.y;
		}
		/**
		 * @private
		 */
		public function set scrollerY(value:Number):void
		{
			textFieldScrollRect.y = value;
			textField.scrollRect = textFieldScrollRect;
			updateScrollbarPosition();
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
			
			textField.defaultTextFormat = new TextFormat("Verdana", 14, 0x0B333C);
			textField.selectable = false;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.border = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.addEventListener(MouseEvent.MOUSE_DOWN, textField_mouseDownHandler);
			addChild(textField);
			
			addChild(scrollIndicatorMask);
			
			scrollIndicator.visible = false;
			scrollIndicator.cacheAsBitmap = true;
			scrollIndicator.mask = scrollIndicatorMask;
			addChild( scrollIndicator );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			textFieldScrollRect.width = width;
			textFieldScrollRect.height = height;
			
			textField.width = width;
			textField.scrollRect = textFieldScrollRect;
			
			// scrollbar needs redrawing to reflect available scroll area
			scrollIndicatorMask.x = width + 2;
			scrollIndicatorMask.graphics.clear();
			scrollIndicatorMask.graphics.beginFill(0xFF0000);
			scrollIndicatorMask.graphics.drawRect(0, 0, 5, height);
			scrollIndicatorMask.graphics.endFill();
			
			scrollIndicator.x = scrollIndicatorMask.x;
			if (textField.height > height && textField.textHeight > 0)
			{
				var scrollH:Number = height * height / textField.textHeight;
				
				scrollIndicator.graphics.clear();
				scrollIndicator.graphics.beginFill( 0x5a6678, 0.8 );
				scrollIndicator.graphics.drawRoundRectComplex( 0, 0, 5, scrollH, 3, 3, 3, 3  );
				scrollIndicator.graphics.endFill();
				
				scrollIndicator.visible = true;
				updateScrollbarPosition();
			}
			else
			{
				scrollIndicator.visible = false;
			}
			
			// draw border
			graphics.clear();
			
			if (_border)
			{
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
		 * Update scrollbar position.
		 */		
		protected function updateScrollbarPosition():void
		{
			scrollIndicator.y = (textField.textHeight > 0 ? textFieldScrollRect.y * height / textField.textHeight : 0);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handle mouse down on text field. Initialize scrolling if required.
		 */
		protected function textField_mouseDownHandler(event:MouseEvent):void
		{
			// do not scroll if not required
			if (textField.textHeight <= textFieldScrollRect.height)
				return;
			
			TweenLite.killTweensOf(this);
			lastMouseY = event.stageY;
			lastMouseY2 = lastMouseY;
			lastMouseTime = getTimer();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		/**
		 * Handle stage mouse move when scrolling.
		 */
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var dy:Number = event.stageY - lastMouseY;
			lastMouseY2 = lastMouseY;
			lastMouseY = event.stageY;
			lastMouseTime = getTimer();
			
			if (textFieldScrollRect.y - dy >= 0 && textFieldScrollRect.bottom - dy <= textField.textHeight) 
				scrollerY -= dy;
			else
				scrollerY -= (dy / 2);
			
			event.updateAfterEvent();
		}
		
		/**
		 * Handle stage mouse up. Finish scrolling and play any throw/rebound animations.
		 */
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			
			var dy:Number = 0;
			var duration:Number = 0.5;
			var ease:Function = Expo.easeOut;
			
			if (textFieldScrollRect.y < 0)
			{
				// rebound on top
				dy = -textFieldScrollRect.y;
			}
			else if (textFieldScrollRect.bottom > textField.textHeight)
			{
				// rebound on botton
				dy = textField.textHeight - textFieldScrollRect.bottom;
			}
			else
			{
				// throw
				var time:Number = (getTimer() - lastMouseTime) / 1000;
				var velocity:Number = (event.stageY - lastMouseY2) / time;
				var distance:Number = 0.5 * velocity;
				
				if (distance < 0)
					dy = Math.min(-distance, textField.textHeight - textFieldScrollRect.bottom);
				else if (distance > 0)
					dy = Math.max(-distance, -textFieldScrollRect.y);
				
				duration = dy / -distance;
				ease = Cubic.easeOut;
			}
			
			if (dy != 0)
				TweenLite.to(this, duration, {"scrollerY": textFieldScrollRect.y + dy, "ease": ease});
		}
	}
}