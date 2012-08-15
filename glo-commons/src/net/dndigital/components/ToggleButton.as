/*
Copyright (c) 2012 DN Digital Ltd (http://dndigital.net)

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
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * Dispathed when the 'selected' property changes through user interaction.
	 */
	[Event(name="change", type="flash.events.Event")]
	
	public class ToggleButton extends GUIComponent
	{
		
		//--------------------------------------------------
		// Class constants
		//--------------------------------------------------
		
		protected static const STATE_UP:String = "up";
		protected static const STATE_DOWN:String = "down";
		protected static const STATE_SELECTED_UP:String = "selectedUp";
		protected static const STATE_SELECTED_DOWN:String = "selectedDown";
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function ToggleButton()
		{
			super();
		}
		
		//--------------------------------------------------
		// selected
		//--------------------------------------------------
		
		private var _selected:Boolean;

		/**
		 * Defines whether the toggle button is selected.
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
			if (value == selected)
				return;
			
			_selected = value;
			
			updateState();
		}
		
		//--------------------------------------------------
		// down
		//--------------------------------------------------
		
		private var _down:Boolean;

		/**
		 * Button is currently down?
		 */
		protected function get down():Boolean
		{
			return _down;
		}

		/**
		 * @private
		 */
		protected function set down(value:Boolean):void
		{
			if (value == down)
				return;
			
			_down = value;
			
			updateState();
		}

		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		protected function updateState():void
		{
			if (down)
				state = selected ? STATE_SELECTED_DOWN : STATE_DOWN;
			else
				state = selected ? STATE_SELECTED_UP : STATE_UP;
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			_defaultState = STATE_UP;
			
			buttonMode = mouseEnabled = useHandCursor = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouse);
			addEventListener(MouseEvent.MOUSE_UP, handleMouse);
			addEventListener(MouseEvent.CLICK, handleMouse);
			
			return super.initialize();
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * @private
		 */
		protected function handleMouse(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					down = true;
					break;
				
				case MouseEvent.MOUSE_UP:
					down = false;
					break;
				
				case MouseEvent.CLICK:
					selected = !selected;
					dispatchEvent(new Event(Event.CHANGE));
					break;
			}
		}

	}
}