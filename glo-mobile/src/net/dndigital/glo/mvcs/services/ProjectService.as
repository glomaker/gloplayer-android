package net.dndigital.glo.mvcs.services
{
	import flash.filesystem.File;
	
	import net.dndigital.glo.mvcs.models.vo.Project;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ProjectService extends Actor implements IProjectService
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Field holds temporary XML before it will be parsed.
		 */
		protected var xml:XML;
		
		/**
		 * @private
		 * Field holds temporary File before it will be parsed.
		 */
		protected var file:File;
		//--------------------------------------------------------------------------
		//
		//  IProjectService
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _source:Object;
		/**
		 * @copy		net.dndigital.glo.mvcs.services.IProjectService#source
		 */
		public function get source():Object { return _source; };
		/**
		 * @private
		 */
		public function set source(value:Object):void
		{
			
		}
		
		/**
		 * @private
		 */
		protected var _project:Project;
		/**
		 * @copy		net.dndigital.glo.mvcs.services.IProjectService#project
		 */
		public function get project():Project { return _project; }
	}
}