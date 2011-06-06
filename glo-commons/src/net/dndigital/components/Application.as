package net.dndigital.components
{
	import flash.events.Event;

	/**
	 * Represents top level container used as main Application component.
	 * 
	 * @see		net.dndigital.components.IComponent
	 * @see		net.dndigital.components.Component
	 * @see		net.dndigital.components.ILayout
	 * @see		net.dndigital.components.IContainer
	 * @see		net.dndigital.components.Container
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
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(Application);
		
		
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
			log("removed()");
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
	}
}