package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;

	public class PlayerEvent extends Event
	{
		// Cached pre-allocated events.
		public static const START_PLAYER_EVENT:PlayerEvent = new PlayerEvent( START_PLAYER );
		
		// Event constants, per ActionScript Event Model best practices
		public static const START_PLAYER:String = "startPlayer";

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