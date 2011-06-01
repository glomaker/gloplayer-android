package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.views.Application;
	import net.dndigital.glo.mvcs.views.ApplicationMediator;

	public class ApplicationEvent extends Event
	{
		// Cached pre-allocated events.
		public static const START_PLAYER_EVENT:ApplicationEvent = new ApplicationEvent(START_PLAYER);
		
		// Event constants, per ActionScript Event Model best practices
		public static const START_PLAYER:String = "startPlayer";

		public function ApplicationEvent(type:String, application:Application = null)
		{
			super(type);
			
			_application = application;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _application:Application;
		/**
		 * Instance of <code>Application</code> sent with current event.
		 */
		public function get application():Application { return _application }
		
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
			return new ApplicationEvent(type, _application);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("ApplicationEvent", "application");
		}
	}
}