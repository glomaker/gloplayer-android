package net.dndigital.core
{
	import flash.events.Event;

	/**
	 * Represents top level container used as main Application component.
	 * 
	 * @see		net.dndigital.glo.components.IComponent
	 * @see		net.dndigital.glo.components.Component
	 * @see		net.dndigital.glo.components.ILayout
	 * @see		net.dndigital.glo.components.IContainer
	 * @see		net.dndigital.glo.components.Container
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Application extends Container
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function Application()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handling
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function added(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			initialize();
		}

		/**
		 * @private
		 */
		protected function removed(event:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
	}
}