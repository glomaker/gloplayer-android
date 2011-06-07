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
		
		public static const SELECT_FILE_EVENT:GloMenuEvent = new GloMenuEvent(GloMenuEvent.SELECT_FILE);
		public static const LOAD_GLO_1_EVENT:GloMenuEvent = new GloMenuEvent(GloMenuEvent.LOAD_GLO_1);
		
		//--------------------------------------------------------------------------
		//
		//  Event Types Constants
		//
		//--------------------------------------------------------------------------
		
		public static const SELECT_FILE:String = "selectFile";
		public static const LOAD_GLO_1:String = "loadGLO1";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function GloMenuEvent(type:String, file:File = null)
		{
			super(type);

			_file = file;
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
			return new GloMenuEvent(type, file);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("GloMenuEvent", "file");
		}
	}
}