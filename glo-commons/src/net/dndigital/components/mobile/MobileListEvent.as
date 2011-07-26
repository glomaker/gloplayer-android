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