package net.dndigital.glo.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.services.IFileService;
	
	import org.robotlegs.mvcs.Command;
	
	public final class ListGLODirectory extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(ListGLODirectory);
		
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 * An instance of <code>IFileService</code> that's used to get list of glo projects.
		 */
		public var fileService:IFileService;
		
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

			// create GLO directory in device documents folder if it doesn't already exist
			// this will allow users to transfer GLO projects directly via cable/file-manager
			var f:File = fileService.gloDir;
			if( !f.exists )
			{
				f.createDirectory();
			}
			
			// scan + retrieve + send to application
			dispatch(new GloMenuEvent(GloMenuEvent.DIRECTORY_LISTED, null, fileService.files));
		}
	}
}