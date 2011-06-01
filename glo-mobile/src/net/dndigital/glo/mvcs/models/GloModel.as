package net.dndigital.glo.mvcs.models
{
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.glo.mvcs.models.vo.Node;
	
	import org.robotlegs.mvcs.Actor;

	public class GloModel extends Actor
	{
		/**
		 * @private
		 */
		private var _project:Project;
		
		/**
		 * Currently loaded and parsed Project.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get project():Project { return _project; }
		/**
		 * @private
		 */
		public function set project(value:Project):void
		{
			if ( _project == value )
				return;
			_project = value;
		}
		
		/**
		 * @private
		 */
		private var _slides:Vector.<Node>;
		
		/**
		 * slides.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get slides():Vector.<Node { return _project || _project.; }
	}
}