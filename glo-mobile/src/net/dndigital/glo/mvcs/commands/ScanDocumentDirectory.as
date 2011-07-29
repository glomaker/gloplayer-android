package net.dndigital.glo.mvcs.commands
{
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.events.FileServiceEvent;
	import net.dndigital.glo.mvcs.services.IFileService;
	
	import org.robotlegs.mvcs.Command;
	
	public final class ScanDocumentDirectory extends Command
	{
		
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject(name="docFileService")]
		public var docsDirService:IFileService;
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();

			// create documents directory if it doesn't already exist
			// this will allow users to transfer GLO projects directly via cable/file-manager
			var f:File = docsDirService.gloDir;
			if( !f.exists )
			{
				f.createDirectory();
			}
			
			// start scanning directories
			// execution will continue when completedEvent is dispatched
			docsDirService.completeEvent = FileServiceEvent.DOCUMENTS_SCAN_COMPLETED_EVENT;
			docsDirService.scan();
			
			
		}			
	}
}