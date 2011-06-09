package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class GloMenuEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Cached Events
		//
		//--------------------------------------------------------------------------
		
		public static const LIST_FILES_EVENT:GloMenuEvent = new GloMenuEvent(GloMenuEvent.LIST_FILES);
		
		//--------------------------------------------------------------------------
		//
		//  Event Types Constants
		//
		//--------------------------------------------------------------------------
		
		public static const LIST_FILES:String = "listFiles";
		public static const DIRECTORY_LISTED:String = "directoryListed";
		public static const LOAD_FILE:String = "loadFile";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function GloMenuEvent(type:String, file:File = null, files:Vector.<File> = null)
		{
			super(type);

			_file = file;
			_files = files;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _file:File;
		/**
		 * File selected via <code>GloMenu</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.view.GloMenu
		 */
		public function get file():File { return _file }
		
		/**
		 * @private
		 */
		protected var _files:Vector.<File>;
		/**
		 * Collection of files.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get files():Vector.<File> { return _files; }
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new GloMenuEvent(type, _file, _files);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("GloMenuEvent", "file", "files");
		}
	}
}