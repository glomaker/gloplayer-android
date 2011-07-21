package net.dndigital.glo.mvcs.services
{
	import eu.kiichigo.utils.log;
	
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import net.dndigital.glo.mvcs.models.vo.Glo;
	
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
		
		
		/**
		 * Default GLO directory subpath inside File.documentsDirectory.
		 * This directory will be scanned for GLO project files. 
		 */		
		protected static const DEFAULT_GLO_DIRECTORY:String = "GLO_Maker/GLOs";

		
		/**
		 * File extension for GLO Maker files. 
		 */		
		protected static const GLO_FILE_EXTENSION:String = "glo";
		
		
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
		public function get files():Vector.<Glo>
		{
			return scanDirectory(gloDir).concat(
				   scanDirectory(File.applicationDirectory));
		}
		
		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#gloDir 
		 * @return 
		 */		
		public function get gloDir():File
		{
			return File.documentsDirectory.resolvePath( DEFAULT_GLO_DIRECTORY );
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
		protected function scanDirectory(directory:File, list:Vector.<Glo> = null, tailed:Boolean = false):Vector.<Glo>
		{
			if (list == null)
				list = new Vector.<Glo>;
			
			if ( !directory.exists )
				return list;
			
			var dir:Array = directory.getDirectoryListing();
			
			for (var i:int = 0; i < dir.length; i ++) {
				const current:File = dir[i] as File;
				if (current.isDirectory)
					scanDirectory(current, list, true);
				else if (current.extension == GLO_FILE_EXTENSION )
					list.push( new Glo( current, getDisplayName( current ) ) );
			}
			if (!tailed)
				list.fixed = true;
			return list;
		}
		
		
		/**
		 * Creates a display name from a given GLO file. 
		 * @param file
		 * @return 
		 */		
		private function getDisplayName( file:File ):String
		{
			// we use the name of the .glo file
			// unless it's the generic 'project.glo', in which case we use the parent folder instead
			var lowerName:String = file.name.toLowerCase();
			
			if( lowerName != "project.glo" || !file.parent )
			{
				// strip off the '.glo' extension
				return file.name.substr( 0, lowerName.lastIndexOf(".") );
			}
						
			// generic filename
			// use parent folder name instead
			return file.parent.name;
		}
		
	}
}