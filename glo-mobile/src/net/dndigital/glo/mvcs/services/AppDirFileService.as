package net.dndigital.glo.mvcs.services
{
	import flash.filesystem.File;

	public class AppDirFileService extends FileService
	{
		
		override public function get gloDir():File
		{
			// abstract - don't call super.gloDir()
			return File.applicationDirectory.resolvePath( "assets" );
		}
		
		
	}
}