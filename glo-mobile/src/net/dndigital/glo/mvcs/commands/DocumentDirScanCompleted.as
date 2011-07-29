package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.models.vo.Glo;
	import net.dndigital.glo.mvcs.services.IFileService;
	
	import org.robotlegs.mvcs.Command;

	/**
	 * Document directory scanning has completed. 
	 * @author nilsmillahn
	 */	
	public class DocumentDirScanCompleted extends Command
	{
		
		[Inject(name="appFileService")]
		public var appDirService:IFileService;
		
		[Inject(name="docFileService")]
		public var docsDirService:IFileService;
		
		
		/**
		 * @inheritDoc 
		 */		
		override public function execute():void
		{
			super.execute();
			
			// get glos
			var glos:Vector.<Glo> = appDirService.glos.concat( docsDirService.glos );
			
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