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
		protected var _enabled:Boolean;
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
			_defaultState = "up";
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
					state = "disabled";
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
					state = "down";
					break;
				case MouseEvent.MOUSE_UP:
					state = "up";
					break;
				default:
					state = "up";
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