package net.dndigital.glo.mvcs.commands
{
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.services.IProjectService;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Loads a GLO file directly from the filesystem. 
	 * @author nilsmillahn
	 */	
	public class LoadGLODirect extends Command
	{
		
		[Inject]
		public var service:IProjectService;
		
		override public function execute():void
		{
			// hard-coded filename for testing and no error handling for non-existent files
			// file will be copied to applicationStorageDirectory on first use
			var f:File = File.applicationStorageDirectory.resolvePath("assets/singlepage.glo");
			
			// copy (no overwrite)
			if( !f.exists )
			{
				var source:File = File.applicationDirectory.resolvePath("assets/singlepage.glo");
				source.copyTo( f, false );
			}
			
			// load
<<<<<<< HEAD
			service.loadFromFile( f );
=======
			try{
				service.loadFromFile( f );
			}catch(e:Error){
				dispatch( new ProjectEvent( ProjectEvent.GLO_VALIDATE_ERROR ) );
			}
						
>>>>>>> 67c606f2d6b0fc68e614cd0eec4720d1e1766c14
		}
		
	}
}