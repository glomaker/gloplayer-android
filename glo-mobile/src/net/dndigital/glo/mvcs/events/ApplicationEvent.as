package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.views.GloApplication;
	import net.dndigital.glo.mvcs.views.GloApplicationMediator;

	public final class ApplicationEvent extends Event
	{
		// Cached pre-allocated events.
		public static const ACTIVATE_EVENT:ApplicationEvent = new ApplicationEvent(ACTIVATE);
		public static const DEACTIVATE_EVENT:ApplicationEvent = new ApplicationEvent(DEACTIVATE);
		public static const SHOW_PLAYER_EVENT:ApplicationEvent = new ApplicationEvent(SHOW_PLAYER);
		public static const SHOW_MENU_EVENT:ApplicationEvent = new ApplicationEvent(SHOW_MENU);

		// Event constants, per ActionScript Event Model best practices
		public static const ACTIVATE:String = "ApplicationEvent.Activate";
		public static const DEACTIVATE:String = "ApplicationEvent.Deactivate";
		public static const SHOW_PLAYER:String = "showPlayer";
		public static const SHOW_MENU:String = "showMenu";
		
		public static const INITIALIZED:String = "initialized";

		
		/**
		 * @Constructor 
		 * @param type
		 */		
		public function ApplicationEvent(type:String)
		{
			super(type);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new ApplicationEvent(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("ApplicationEvent");
		}
	}
}