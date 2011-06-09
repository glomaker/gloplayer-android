package net.dndigital.glo.mvcs.services
{
	import eu.kiichigo.utils.log;
	
	import flash.filesystem.File;
	
	import org.robotlegs.mvcs.Actor;
	
	public final class FileService extends Actor implements IFileService
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(FileService);
		
		
		protected static const DEFAULT:File = File.applicationDirectory;
		
		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#files
		 * 
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get files():Vector.<File>
		{
			return scanDirectory(DEFAULT);
		}
		
		/**
		 * Scans directory and sub directories for glo projects.
		 * 
		 * @param	directory	Directory that's will be scanned for files.
		 * @param	to			<code>Vector.<File></code>. Collection of files that used as primary storage.
		 * @param	tailed		Auxiliary argument, should not be used by user manually. Indicates whether function is in tail-recursion mode, this argument emulates tail recursion without creating another function for tail-only.
		 * 
		 * @return	Vector.<File> filed with glo projects.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function scanDirectory(directory:File, list:Vector.<File> = null, tailed:Boolean = false):Vector.<File>
		{
			if (list == null)
				list = new Vector.<File>;
			
			var dir:Array = directory.getDirectoryListing();
			
			for (var i:int = 0; i < dir.length; i ++)
				if((dir[i] as File).isDirectory)
					scanDirectory(dir[i] as File, list, true);
				else if(dir[i].extension == "glo")
					list.push(dir[i] as File);
			
			if (!tailed)
				list.fixed = true;
			return list;
		}
	}
}