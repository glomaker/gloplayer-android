package net.dndigital.glo.mvcs.models
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.vo.Page;
	import net.dndigital.glo.mvcs.models.vo.Project;
	
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
	}
}