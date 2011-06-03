package net.dndigital.glo.mvcs.models
{
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.glo.mvcs.models.vo.Page;
	
	import org.robotlegs.mvcs.Actor;

	public class GloModel extends Actor
	{
		/**
		 * @private
		 */
		protected var _orientation:int;
		/**
		 * orientation.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get orientation():int { return _orientation; }
		/**
		 * @private
		 */
		public function set orientation(value:int):void
		{
			if (_orientation == value)
				return;
			_orientation = value;
		}
		
	}
}