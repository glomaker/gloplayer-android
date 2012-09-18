/*
Copyright (c) 2011 DN Digital Ltd (http://dndigital.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package net.dndigital.components
{
	import eu.kiichigo.utils.log;
	
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;

	/**
	 * Use instances of <code>Buttons</code> when minimalistic and simple implementation of button functionality is needed.
	 * 
	 * @see		net.dndigital.components.IUIComponent
	 * @see		net.dndigital.components.UIComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Button extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(Button);
		
		//--------------------------------------------------------------------------
		//
		//  State Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public static const UP:String = "up";
		
		/**
		 * @private
		 */
		public static const DOWN:String = "down";
		
		/**
		 * @private
		 */
		public static const DISABLED:String = "disabled";
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var enabledChanged:Boolean;
		/**
		 * @private
		 */
		protected var _enabled:Boolean = true;
		/**
		 * enabled.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get enabled():Boolean { return _enabled; }
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			_enabled = value;
			enabledChanged = true;
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
			// Set IUIComponent.defaultState to be "up".
			_defaultState = UP;
			// Usual button UI nasties.
			buttonMode = mouseEnabled = useHandCursor = true;
			mouseChildren = false;
			// Suscribe to mouse and touch listeners.
			// FIXME: see if there is more touchevents to listen to.
			addEventListener(MouseEvent.CLICK, handleMouse);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouse);
			addEventListener(TouchEvent.TOUCH_TAP, handleTouch);
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (enabledChanged) {
				if (_enabled)
					state = _defaultState;
				else
					state = DISABLED;
				mouseEnabled = _enabled;
				enabledChanged = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handling
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function handleMouse(event:MouseEvent):void
		{
			//log("handleMouse({0})", event);
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					state = DOWN;
					break;
				case MouseEvent.MOUSE_UP:
					state = UP;
					break;
				default:
					state = UP;
					break;
			}
		}
		
		/**
		 * @private
		 */
		protected function handleTouch(event:TouchEvent):void
		{
			log("handleTouch({0})", event);
		}
	}
}