package org.glomaker.mobileplayer.mvcs.services
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;

	public interface IFileService
	{
		/**
		 * Retrieves list of GLOs in the associated directory
		 */
		function get glos():Vector.<Glo>;
		
		/**
		 * Retrieves the documents directory that the service scans for installed GLOs. 
		 * @return 
		 */		
		function get gloDir():File;
		
		/**
		 * Checks whether the service is still scanning the file system. 
		 * @return 
		 */		
		function get isScanning():Boolean;
		
		/**
		 * Event dispatched when the service has completed scanning.
		 * @return 
		 */		
		function get completeEvent():Event;
		function set completeEvent( value:Event ):void;
		
		/**
		 * Starts a new filesystem scan.
		 * Any previously retrieved glos are discarded and won't become available until the 'completeEvent' has been dispatched. 
		 */		
		function scan():void;
	}
}