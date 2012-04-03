/* 
* GLO Mobile Player: Copyright (c) 2011 LTRI, University of West London. An
* Open Source Release under the GPL v3 licence (see http://www.gnu.org/licenses/).
* Authors: DN Digital Ltd, Tom Boyle, Lyn Greaves, Carl Smith.

* This program is free software: you can redistribute it and/or modify it under the terms 
* of the GNU General Public License as published by the Free Software Foundation, 
* either version 3 of the License, or (at your option) any later version. This program
* is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* 
* For GNU Public licence see http://www.gnu.org/licenses/ or http://www.opensource.org/licenses/.
*
* External libraries used:
*
* Greensock Tweening Library (TweenLite), copyright Greensock Inc
* "NO CHARGE" NON-EXCLUSIVE SOFTWARE LICENSE AGREEMENT
* http://www.greensock.com/terms_of_use.html
*	
* A number of utility classes Copyright (c) 2008 David Sergey, published under the MIT license
*
* A number of utility classes Copyright (c) DN Digital Ltd, published under the MIT license
*
* The ScaleBitmap class, released open-source under the RPL license (http://www.opensource.org/licenses/rpl.php)
*/
package org.glomaker.mobileplayer.mvcs.services
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.glomaker.mobileplayer.mvcs.events.BusyIndicatorEvent;

	/**
	 * Dispatched when a long running operation has started.
	 */
	[Event(name="show", type="org.glomaker.mobileplayer.mvcs.events.BusyIndicatorEvent")]

	/**
	 * Dispatched when a long running operation finished.
	 */
	[Event(name="hide", type="org.glomaker.mobileplayer.mvcs.events.BusyIndicatorEvent")]
	
	/**
	 * A file service for GLOs provided in zip files.
	 * 
	 * @author Haykel
	 * 
	 */
	public class ZippedFileService extends FileService
	{
		//--------------------------------------------------
		// Getters / Setters
		//--------------------------------------------------
		
		override public function get gloDir():File
		{
			// abstract - don't call super.gloDir()
			return File.applicationStorageDirectory.resolvePath( "unzipped" );
		}
		
		/**
		 * Returns the directory where to look for zipped GLOs.
		 */
		public function get zippedDir():File
		{
			return File.documentsDirectory;
		}
		
		private var _isSyncing:Boolean = false;
		
		/**
		 * Returns whether <code>zippedDir</code> and <code>gloDir</code> are being synced.
		 */
		public function get isSyncing():Boolean
		{
			return _isSyncing;
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		protected function doScan(event:Event=null):void
		{
			eventMap.unmapListeners();
			_isSyncing = false;
			
			super.scan();
			
			dispatch(new BusyIndicatorEvent(BusyIndicatorEvent.HIDE));
		}
		
		protected function showBusyIndicator(event:Event=null):void
		{
			dispatch(new BusyIndicatorEvent(BusyIndicatorEvent.SHOW));
		}
		
		//--------------------------------------------------
		// Overridden functions
		//--------------------------------------------------
		
		/**
		 * Overridden to synchronize <code>zippedDir</code> and <code>gloDir</code> before running the actual scan operation.
		 * 
		 * @inheritDoc
		 * 
		 */
		override public function scan():void
		{
			//Call parent implementation to throw an exception if completeEvent is null
			if (completeEvent == null)
				super.scan();
			
			//sync operations can require much time and resources and if more than operation
			//are running in parallel they can lead to unpredictable results as they will be working
			//on the same files and directories, so we prevent this from happening.
			if (isSyncing)
				return;
			
			_isSyncing = true;
			
			var zippedScanner:DirectoryScanner = new DirectoryScanner(zippedDir, true);
			var unzippedScanner:DirectoryScanner = new DirectoryScanner(gloDir, false);
			var unzippedCleaner:UnzippedCleaner = new UnzippedCleaner(zippedScanner, unzippedScanner);
			var unzipper:Unzipper = new Unzipper(zippedScanner, gloDir);
			
			eventMap.mapListener(zippedScanner, Event.COMPLETE, unzippedScanner.run, Event);
			eventMap.mapListener(unzippedScanner, Event.COMPLETE, unzippedCleaner.run, Event);
			eventMap.mapListener(unzippedCleaner, Event.COMPLETE, unzipper.run, Event);
			eventMap.mapListener(unzippedCleaner, START, showBusyIndicator, Event);
			eventMap.mapListener(unzipper, Event.COMPLETE, doScan, Event);
			eventMap.mapListener(unzipper, START, showBusyIndicator, Event);
			
			zippedScanner.run();
		}
	}
}

//--------------------------------------------------
// Helper classes
//--------------------------------------------------

import deng.fzip.FZip;
import deng.fzip.FZipErrorEvent;
import deng.fzip.FZipFile;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FileListEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLRequest;
import flash.utils.Dictionary;

/**
 * Constant for type of events dispatched to indicte that a long-running operation has started.
 */
const START:String = "start";

//--------------------------------------------------
// DirectoryScanner
//--------------------------------------------------

/**
 * Dispatched when the scan completes, either successfully or with an error.
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Helper class for scanning directories for either zip files or directories.
 * 
 * @author Haykel
 * 
 */
final class DirectoryScanner extends EventDispatcher
{
	public var files:Vector.<File>;
	public var names:Vector.<String>;
	
	private var dir:File;
	private var zipped:Boolean;
	
	/**
	 * Creates a scanner for the specified directory. If <code>zipped</code> is true, scan for zip files,
	 * otherwise scan for directories.
	 * 
	 * @param dir Directory to scan.
	 * @param zipped Whether to scan for zip files (true) or directories (false).
	 * 
	 */
	public function DirectoryScanner(dir:File, zipped:Boolean)
	{
		this.dir = dir;
		this.zipped = zipped;
	}
	
	/**
	 * Runs the scan operation.
	 */
	public function run(event:Event=null):void
	{
		files = null;
		names = null;
		
		dir.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
		dir.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		dir.getDirectoryListingAsync();
	}
	
	/**
	 * Remove data for the file at the specifed index.
	 */
	public function removeAt(index:uint):File
	{
		var file:File = files[index];
		names.splice(index, 1);
		files.splice(index, 1);
		return file;
	}
	
	/**
	 * Remove data for the specified file.
	 */
	public function remove(file:File):File
	{
		return removeAt(files.indexOf(file));
	}
	
	/**
	 * Remove data for the file corresponding to the specified name.
	 */
	public function removeByName(name:String):File
	{
		return removeAt(names.indexOf(name));
	}
	
	/**
	 * Handle directory listing result event.
	 */
	private function directoryListingHandler(event:FileListEvent):void
	{
		File(event.target).removeEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
		File(event.target).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		
		files = new Vector.<File>();
		names = new Vector.<String>()
		
		for each (var file:File in event.files)
		{
			var name:String = null;
			
			if (zipped && !file.isDirectory && file.extension == "zip")
				name = file.name.substr(0, file.name.length - 4); //name without the .zip extension
			else if (!zipped && file.isDirectory)
				name = file.name;
			
			if (name)
			{
				names.push(name);
				files.push(file);
			}
		}
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	/**
	 * Handle directory listing error event.
	 */
	private function ioErrorHandler(event:IOErrorEvent):void
	{
		File(event.target).removeEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
		File(event.target).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
}

//--------------------------------------------------
// UnzippedCleaner
//--------------------------------------------------

/**
 * Dispatched to indicate that the operation of deleting directories has started.
 */
[Event(name="start", type="flash.events.Event")]

/**
 * Dispatched when the clean operation completes, either successfully or with an error.
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Helper class for comparing the lists of zip files and unzipped directories and deleting unzipped directories
 * without corresponding zip files. After the run, the zipped file list only contains files without
 * corresponding unzipped directories. 
 * 
 * @author Haykel
 * 
 */
final class UnzippedCleaner extends EventDispatcher
{
	private var zipped:DirectoryScanner;
	private var unzipped:DirectoryScanner;
	
	public function UnzippedCleaner(zipped:DirectoryScanner, unzipped:DirectoryScanner)
	{
		this.zipped = zipped;
		this.unzipped = unzipped;
	}
	
	/**
	 * Start the cleaning operation.
	 */
	public function run(event:Event=null):void
	{
		//remove up-to-date files and directories
		if (zipped.files && zipped.files.length > 0 && unzipped.files && unzipped.files.length > 0)
		{
			//Create a copy of the names as we might be messing with unzipped.names.
			var names:Vector.<String> = unzipped.names.concat();
			for each (var name:String in names)
			{
				if (zipped.names.indexOf(name) >= 0)
				{
					zipped.removeByName(name);
					unzipped.removeByName(name);
				}
			}
		}
		
		//delete remaining dirs
		if (unzipped.files && unzipped.files.length > 0)
		{
			dispatchEvent(new Event(START));
			
			for each (var file:File in unzipped.files)
			{
				file.addEventListener(Event.COMPLETE, deleteFinishedHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR, deleteFinishedHandler);
				
				try
				{
					file.deleteDirectoryAsync(true);
				}
				catch (e:Error)
				{
					//Simply continue on error
					fileDeleted(file);
				}
			}
		}
		else
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	/**
	 * Clean and check status after a file finished deleting.
	 */
	private function fileDeleted(file:File):void
	{
		file.removeEventListener(Event.COMPLETE, deleteFinishedHandler);
		file.removeEventListener(IOErrorEvent.IO_ERROR, deleteFinishedHandler);
		
		unzipped.remove(file);
		
		if (unzipped.files.length == 0)
			dispatchEvent(new Event(Event.COMPLETE));
	}
	
	/**
	 * Handle file deletion end event, either successfully or with an error.
	 */
	private function deleteFinishedHandler(event:Event):void
	{
		fileDeleted(File(event.target));
	}
}

//--------------------------------------------------
// Unzipper
//--------------------------------------------------

/**
 * Dispatched to indicate that the operation of unzipping files has started.
 */
[Event(name="start", type="flash.events.Event")]

/**
 * Dispatched when the unzip operation completes, either successfully or with an error.
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Helper class for unzipping files to a specific directory.
 * 
 * @author Haykel
 * 
 */
final class Unzipper extends EventDispatcher
{
	private var zipped:DirectoryScanner;
	private var dir:File;
	
	private var currentTargetDir:File;
	private var currentFiles:Vector.<FZipFile>;
	
	public function Unzipper(zipped:DirectoryScanner, dir:File)
	{
		this.zipped = zipped;
		this.dir = dir;
	}
	
	/**
	 * Starts the unzip operation.
	 */
	public function run(event:Event=null):void
	{
		if (zipped.files && zipped.files.length > 0)
			dispatchEvent(new Event(START));
		
		unzipNext();
	}
	
	/**
	 * Unzip the next available file. A <code>complete</code> event is dispatched
	 * when there are no more files to unzip.
	 */
	private function unzipNext():void
	{
		if (zipped.files && zipped.files.length > 0)
		{
			var zip:FZip = new FZip();
			zip.addEventListener(Event.COMPLETE, zip_completeHandler);
			zip.addEventListener(IOErrorEvent.IO_ERROR, zip_errorHandler);
			zip.addEventListener(SecurityErrorEvent.SECURITY_ERROR, zip_errorHandler);
			zip.addEventListener(FZipErrorEvent.PARSE_ERROR, zip_errorHandler);
			
			currentTargetDir = dir.resolvePath(zipped.names[0]);
			zip.load(new URLRequest(zipped.removeAt(0).url));
		}
		else
		{
			currentTargetDir = null;
			currentFiles = null;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	/**
	 * Extracts the next file from the current zip file being processed. It calls <code>unzipNext()</code>
	 * when there are no more files to extract.
	 */
	private function extractNext():void
	{
		if (currentFiles && currentFiles.length > 0)
		{
			var zipFile:FZipFile = currentFiles.shift();
			var file:File = currentTargetDir.resolvePath(zipFile.filename);
			
			var stream:FileStream = new FileStream();
			stream.addEventListener(IOErrorEvent.IO_ERROR, extract_ioErrorHandler);
			stream.addEventListener(Event.CLOSE, extract_closeHandler);
			
			try
			{
				if (!file.parent.exists)
					file.parent.createDirectory();
				
				stream.openAsync(file, FileMode.WRITE);
				stream.writeBytes(zipFile.content);
				stream.close();
			}
			catch (e:Error)
			{
				extractFailed(stream);
			}
		}
		else
		{
			unzipNext();
		}
	}
	
	/**
	 * If an extract operation fails, the current zip file is skipped and its directory is deleted
	 * to avoid having files being only partially unzipped and to make it possibe to retry
	 * on the next scan operation.
	 */
	private function extractFailed(stream:FileStream):void
	{
		stream.removeEventListener(IOErrorEvent.IO_ERROR, extract_ioErrorHandler);
		stream.removeEventListener(Event.CLOSE, extract_closeHandler);
		stream.close();
		try
		{
			currentTargetDir.deleteDirectory(true);
		}
		catch (e2:Error)
		{}
		
		unzipNext();
	}

	/**
	 * Handle zip file load completion event. Populate the list of files to be extracted
	 * skipping directories and start the extraction process.
	 */
	private function zip_completeHandler(event:Event):void
	{
		var zip:FZip = FZip(event.target);
		zip.removeEventListener(Event.COMPLETE, zip_completeHandler);
		zip.removeEventListener(IOErrorEvent.IO_ERROR, zip_errorHandler);
		zip.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, zip_errorHandler);
		zip.removeEventListener(FZipErrorEvent.PARSE_ERROR, zip_errorHandler);
		
		currentFiles = new Vector.<FZipFile>();
		
		for (var i:uint=0; i < zip.getFileCount(); i++)
		{
			var zipFile:FZipFile = zip.getFileAt(i);
			
			//skip directories
			if (zipFile.filename.charAt(zipFile.filename.length - 1) == '/')
				continue;
			
			currentFiles.push(zipFile);
		}
		
		extractNext();
	}
	
	/**
	 *  Handle zip file load error event. Skips the file.
	 */
	private function zip_errorHandler(event:Event):void
	{
		var zip:FZip = FZip(event.target);
		zip.removeEventListener(Event.COMPLETE, zip_completeHandler);
		zip.removeEventListener(IOErrorEvent.IO_ERROR, zip_errorHandler);
		zip.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, zip_errorHandler);
		zip.removeEventListener(FZipErrorEvent.PARSE_ERROR, zip_errorHandler);
		
		unzipNext();
	}
	
	/**
	 * Handle close event for an extracted file. This is called after the file has been
	 * successfully written and closed. Start extrationg the next file.
	 */
	protected function extract_closeHandler(event:Event):void
	{
		var stream:FileStream = FileStream(event.target);
		stream.removeEventListener(IOErrorEvent.IO_ERROR, extract_ioErrorHandler);
		stream.removeEventListener(Event.CLOSE, extract_closeHandler);
		
		extractNext();
	}
	
	/**
	 * Handle io error event for an extracted file. Calls <code>extracFailed()</code>.
	 */
	protected function extract_ioErrorHandler(event:IOErrorEvent):void
	{
		extractFailed(FileStream(event.target));
	}
}
