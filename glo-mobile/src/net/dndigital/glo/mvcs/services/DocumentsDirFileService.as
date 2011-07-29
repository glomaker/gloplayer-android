package net.dndigital.glo.mvcs.services
{
	import flash.filesystem.File;

	public class DocumentsDirFileService extends FileService
	{
		
		override public function get gloDir():File
		{
			// abstract - don't call super.gloDir()
			return File.documentsDirectory.resolvePath( "GLO_Maker/GLOs" );
		}
		
		
	}
}