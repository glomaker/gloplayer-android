package net.dndigital.glo.mvcs.services
{
	import flash.filesystem.File;

	public interface IFileService
	{
		/**
		 * Retreives list of files in application directory.
		 * 
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get files():Vector.<File>;
		
		/**
		 * Retrieves the documents directory that the service scans for installed GLOs. 
		 * @return 
		 */		
		function get gloDir():File;
	}
}