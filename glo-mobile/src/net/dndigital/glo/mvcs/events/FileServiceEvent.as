package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	public class FileServiceEvent extends Event
	{

		public static const APPDIR_SCAN_COMPLETED_EVENT:FileServiceEvent = new FileServiceEvent( FileServiceEvent.APPDIR_SCAN_COMPLETED );
		public static const DOCUMENTS_SCAN_COMPLETED_EVENT:FileServiceEvent = new FileServiceEvent( FileServiceEvent.DOCUMENTS_SCAN_COMPLETED );
		
		public static const APPDIR_SCAN_COMPLETED:String = "AppDirScanCompleted";
		public static const DOCUMENTS_SCAN_COMPLETED:String = "DocumentScanCompleted";
		
		
		/**
		 * @constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function FileServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc 
		 */		
		override public function clone():Event
		{
			return new FileServiceEvent( type, bubbles, cancelable );
		}
	}
}