package org.glomaker.mobileplayer.mvcs.events
{
	import flash.events.Event;

	public class PlayerEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Cached Events
		//
		//--------------------------------------------------------------------------
		
		public static const DESTROY_EVENT:PlayerEvent = new PlayerEvent(DESTROY);
		public static const ENTER_FULL_SCREEN_EVENT:PlayerEvent = new PlayerEvent(ENTER_FULL_SCREEN);
		public static const EXIT_FULL_SCREEN_EVENT:PlayerEvent = new PlayerEvent(EXIT_FULL_SCREEN);
		
		//--------------------------------------------------------------------------
		//
		//  Event Constants
		//
		//--------------------------------------------------------------------------
		
		public static const DESTROY:String = "destroy";
		public static const ENTER_FULL_SCREEN:String = "enterFullScreen";
		public static const EXIT_FULL_SCREEN:String = "exitFullScreen";

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PlayerEvent(type:String)
		{
			super(type, false, false);
		}

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
			return new PlayerEvent(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("PlayerEvent");
		}
	}
}