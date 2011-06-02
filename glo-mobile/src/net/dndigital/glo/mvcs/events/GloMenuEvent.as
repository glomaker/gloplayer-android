package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class GloMenuEvent extends Event
	{
		public static const SELECT:String = "select";

		public function GloMenuEvent(type:String, file:File)
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
			return new GloMenuEvent(type,file);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("GloMenuEvent","file");
		}
	}
}