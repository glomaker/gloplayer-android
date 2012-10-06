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
	import com.greensock.TweenLite;
	
	import eu.kiichigo.utils.log;
	
	import flash.display.BlendMode;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.dndigital.components.*;
	import net.dndigital.utils.drawRectangle;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	
	/**
	 * Dispatched when the popup is closed.
	 */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Notifications are used by Application to notify user.
	 * 
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.GloComponent
	 * @see		net.dndigital.glo.mvcs.views.GloApplication
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Notification extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(Notification);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const textField:TextField = new TextField;
		
		/**
		 * @private
		 * If set 'true', the notification will be closed automatically on one of these events:
		 *   1. After a timeout of 10 seconds
		 *   2. The user clicks anywhere in the app
		 *   3. The size of the stage changes (i.e. user rotates device)
		 * 
		 * If set to 'false', the dialog must closed programmatically by calling 'destoy()'.
		 */
		protected var autoClose:Boolean = true;
		
		/**
		 * @private
		 * Timeout Id.
		 */
		protected var timeoutId:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _text:String = "";
		/**
		 * Text that will be shown in notification.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get text():String { return _text; }
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			value = value ? value : "";
			if (_text == value)
				return;
			_text = value;
			invalidateData();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			height = ScreenMaths.mmToPixels(14);
			
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			
			if (autoClose)
			{
				stage.addEventListener(MouseEvent.CLICK, destroy);
				timeoutId = setTimeout(destroy, 10000);
			}
			
			blendMode = BlendMode.LAYER;
			filters = [ new DropShadowFilter(3, 90, 0x000000, .6, 8, 8, 1, 2) ];
			
			return super.initialize();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			textField.defaultTextFormat = new TextFormat("Verdana", 16, 0xEAEAEA, true);
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			addChild(textField);
			
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (textField.text != _text) {
				textField.text = _text;
				width = textField.width + 15; // 30 is 15 pixel padding.
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.lineStyle( 1, 0xffffff, 1, true, LineScaleMode.NONE );
			drawRectangle(this, 0x000000, width, height, .75, 25);
			
			x = (stage.fullScreenWidth - width) / 2;
			y = (stage.fullScreenHeight - height) / 2;
			textField.x = (width - textField.width) / 2;
			textField.y = (height - textField.height) / 2;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Reposition on stage resize.
		 */
		protected function stage_resizeHandler(event:Event):void
		{
			if (autoClose)
				destroy();
			else
				invalidateDisplay();
		}
		
		/**
		 * @private
		 * Removes notification from screen.
		 */
		protected function destroy(event:Event = null):void
		{
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
			
			if (autoClose)
			{
				stage.removeEventListener(MouseEvent.CLICK, destroy);
				clearTimeout(timeoutId);
			}
			
			invalidateDisplay();
			validateDisplay();
			
			TweenLite.to(this, 0.5, {alpha: 0, onComplete: completed});
		}
		
		/**
		 * @private
		 */
		protected function completed():void
		{
			if (parent)
				parent.removeChild(this);
			
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}