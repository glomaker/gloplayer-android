package org.glomaker.mobileplayer.mvcs.models
{
	import eu.kiichigo.utils.formatToString;
	
	import flash.events.Event;
	
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Page;
	import org.glomaker.mobileplayer.mvcs.models.vo.Project;
	
	import org.robotlegs.mvcs.Actor;

	public class GloModel extends Actor
	{
		/**
		 * @private
		 */
		protected var _index:int = -1;
		/**
		 * index.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get index():int { return _index; }
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			if (_index == value)
				return;
			_index = value;
			dispatch(new ProjectEvent(ProjectEvent.PAGE, null, _index));
		}
		
		/**
		 * @private
		 */
		protected var _length:int = -1;
		/**
		 * length.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get length():int { return _length; }
		/**
		 * @private
		 */
		public function set length(value:int):void
		{
			if (_length == value)
				return;
			_length = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  toString
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns a string containing some of instance's properties.
		 * 
		 * @return	Class name and some of instance properties and values.
		 */
		public function toString():String
		{
			return eu.kiichigo.utils.formatToString(this, "index", "length");
		}
	}
}