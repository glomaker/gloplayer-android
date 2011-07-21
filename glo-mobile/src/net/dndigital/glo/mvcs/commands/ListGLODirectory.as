package net.dndigital.glo.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.models.vo.Glo;
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

			// GLO directory
			var f:File = fileService.gloDir;
			
			// transition older demo GLO directory to proper folder
			// @TODO: This code can be removed in production version
			const OLD_GLO_DIRECTORY:String = "GloPlayer/Glos";
			var old:File = File.documentsDirectory.resolvePath( OLD_GLO_DIRECTORY );
			if( old.exists && !f.exists )
			{
				old.moveTo( f );
				old.parent.deleteDirectory( true );
			}
			
			// create GLO directory in device documents folder if it doesn't already exist
			// this will allow users to transfer GLO projects directly via cable/file-manager
			if( !f.exists )
			{
				f.createDirectory();
			}
			
			// scan
			var glos:Vector.<Glo> = fileService.files;
			
			// alphabetical sort
			// unfortunately no sortOn for vectors - but this should be a fast approach with small arrays
			glos.sort( sortF ); 
			
			// pass on to application
			dispatch(new GloMenuEvent(GloMenuEvent.DIRECTORY_LISTED, null, glos));
		}
		
		
		/**
		 * Sort function to carry out an alphabetical comparison.
		 * @param g1
		 * @param g2
		 * @return 0 if equal, 1 if g1 > g2, -1 if g2 < g1
		 */		
		protected function sortF( g1:Glo, g2:Glo ):int
		{
			var n1:String = g1.displayName.toLowerCase();
			var n2:String = g2.displayName.toLowerCase();
			
			if( n1 > n2 )
			{
				return 1;
			}else if( n1 < n2 ){
				return -1;
			}
			
			return 0;
		}
	}
}