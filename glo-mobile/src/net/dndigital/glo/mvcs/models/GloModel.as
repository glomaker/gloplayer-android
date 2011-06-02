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
		private var _project:Project;
		
		/**
		 * Currently loaded and parsed Project.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Project
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
		 * Indicates collection of nodes that belonged to current <code>GloModel.project</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Node
		 * @see		net.dndigital.glo.mvcs.models.vo.Project
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get pages():Vector.<Page>
		{
			if(_project != null)
				return _project.pages;
			return null;
		}
	}
}