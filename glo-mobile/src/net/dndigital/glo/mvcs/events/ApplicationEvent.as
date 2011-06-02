package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.views.GloApplication;
	import net.dndigital.glo.mvcs.views.GloApplicationMediator;

	public class ApplicationEvent extends Event
	{
		// Cached pre-allocated events.
		public static const START_PLAYER_EVENT:ApplicationEvent = new ApplicationEvent(START_PLAYER);
		
		// Event constants, per ActionScript Event Model best practices
		public static const START_PLAYER:String = "startPlayer";
		
		public static const INITIALIZED:String = "initialized";

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