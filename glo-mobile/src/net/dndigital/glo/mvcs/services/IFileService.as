package net.dndigital.glo.mvcs.services
{
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.models.vo.Glo;

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
		function get files():Vector.<Glo>;
		
		/**
		 * Retrieves the documents directory that the service scans for installed GLOs. 
		 * @return 
		 */		
		function get gloDir():File;
	}
}