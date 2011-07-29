package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.FileServiceEvent;
	import net.dndigital.glo.mvcs.services.IFileService;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Starts scanning the application directory for GLOs.
	 */
	public class ScanAppDirectory extends Command
	{

		[Inject(name="appFileService")]
		public var appDirService:IFileService;
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			// start scanning directory
			// execution will continue when completedEvent is dispatched
			appDirService.completeEvent = FileServiceEvent.APPDIR_SCAN_COMPLETED_EVENT;
			appDirService.scan();
		}
	}
}