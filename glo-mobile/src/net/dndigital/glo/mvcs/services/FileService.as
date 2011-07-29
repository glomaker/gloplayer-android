package net.dndigital.glo.mvcs.services
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.models.vo.Glo;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Abstract class to provide filesystem scanning services.
	 * You must subclass it in order to override the gloDir getter. 
	 * @author nilsmillahn
	 * 
	 */	
	public class FileService extends Actor implements IFileService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * File extension for GLO Maker files. 
		 */		
		protected static const GLO_FILE_EXTENSION:String = "glo";

		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _cache:Vector.<Glo>;
		protected var _pendingDirs:Vector.<File>;
		protected var _isScanning:Boolean = false;
		protected var _completeEvent:Event;
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#isScanning 
		 * @return 
		 */
		public function get isScanning():Boolean
		{
			return _isScanning;
		}
		
		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#gloDir 
		 * @return 
		 */		
		public function get gloDir():File
		{
			// read-only property - override in sub-class to set to a specific value
			throw new Error("Abstract method - implement in subclass.");
			return null;
		}

		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#glos 
		 * @return 
		 */
		public function get glos():Vector.<Glo>
		{
			if( _cache == null )
			{
				throw new Error("Must call 'scan()' first and wait for complete event.");
			}
			return _cache;
		}
		
		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#completeEvent
		 * @return 
		 */
		public function set completeEvent( value:Event ):void
		{
			_completeEvent = value;
		}
		public function get completeEvent():Event
		{
			return _completeEvent;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy	net.dndigital.glo.mvcs.services.IFileService#scan
		 * @return 
		 */
		public function scan():void
		{
			if( gloDir == null )
			{
				throw new Error("Must set directory before scanning.");
			}
			
			if( completeEvent == null )
			{
				throw new Error("Must set completeEvent before scanning.");
			}
			
			_cache = null;
			_isScanning = true;
			
			var f:File = gloDir; // NB: doesn't work directly on gloDir, presumably because there is no setter
			f.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
			f.addEventListener(IOErrorEvent.IO_ERROR, handleIOError );
			f.getDirectoryListingAsync();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler - directory scan has completed. 
		 * @param event
		 */
		protected function directoryListingHandler(event:FileListEvent):void
		{
			// cleanup
			File( event.target ).removeEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
			File( event.target ).removeEventListener(IOErrorEvent.IO_ERROR, handleIOError );
			
			// process
			_cache = new Vector.<Glo>();
			_pendingDirs = new Vector.<File>();
			
			for each( var f:File in event.files )
			{
				if( f.isDirectory )
				{
					// need to process further (we just go 1 level deeper, not full recursion)
					_pendingDirs.push( f );
				}else if( f.extension == GLO_FILE_EXTENSION ){
					// this is already a GLO, store it
					_cache.push( new Glo( f, getDisplayName( f ) ) );
				}
			}
			
			// process any pending directories
			// if there aren't any, this method will also send the completeEvent
			processNextPendingDir();
		}
		
		/**
		 * Event handler - IO Error occured while scanning directories. 
		 * @param event
		 */		
		protected function handleIOError( event:IOErrorEvent ):void
		{
			trace("FileService::io error", event.text);
		}
		
		/**
		 * Event handler - getDirectoryListingAsync() on subdirectory has completed.
		 * @param event
		 */		
		protected function processSubDir( event:FileListEvent ):void
		{
			// cleanup
			File( event.target ).removeEventListener( FileListEvent.DIRECTORY_LISTING, processSubDir );
			
			// find all the GLO files in this subdirectory
			for each( var f:File in event.files )
			{
				if( !f.isDirectory && f.extension == GLO_FILE_EXTENSION )
				{
					// this is a GLO, store it
					_cache.push( new Glo( f, getDisplayName( f ) ) );
				}
			}
			
			// next
			processNextPendingDir();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Take the next pending subdirectory and start getDirectoryListingAsync.
		 * If no more subdirectories are waiting to be processed, dispatches the 'completeEvent' event. 
		 */		
		protected function processNextPendingDir():void
		{
			// anything left to process?
			if( _pendingDirs.length == 0 )
			{
				dispatch( completeEvent );
				return;
			}
			
			// next one - must be directory, as it's in _pendingDirs
			var f:File = _pendingDirs.pop();
			f.addEventListener(FileListEvent.DIRECTORY_LISTING, processSubDir);
			f.getDirectoryListingAsync();
		}
		
		
		/**
		 * Creates a display name from a given GLO file. 
		 * @param file
		 * @return 
		 */		
		protected function getDisplayName( file:File ):String
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