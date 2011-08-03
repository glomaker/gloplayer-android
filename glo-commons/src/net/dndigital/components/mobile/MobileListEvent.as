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

package net.dndigital.components.mobile
{
	import flash.events.Event;

	/**
	 * Custom events class for events dispatched by the MobileList view component. 
	 * @author nilsmillahn
	 */	
	public class MobileListEvent extends Event
	{
		
		/**
		 * Event type - a list item was selected. 
		 */		
		public static const ITEM_SELECTED:String = "itemSelected";

		/**
		 * Item associated with this event (if any) 
		 */		
		public var item:IMobileListItemRenderer;

		/**
		 * @constructor 
		 * @param type
		 * @param item
		 * @param bubbles
		 * @param cancelable
		 */
		public function MobileListEvent(type:String, item:IMobileListItemRenderer = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.item = item;
		}
		
		/**
		 * @inheritDoc 
		 * @return 
		 */		
		override public function clone():Event
		{
			return new MobileListEvent( type, item, bubbles, cancelable );
		}
	}
}