package net.dndigital.glo.mvcs.services
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.core.IProgrammaticSkin;
	
	import net.dndigital.glo.mvcs.models.vo.Project;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ProjectService extends Actor implements IProjectService
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(ProjectService);
		
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Glo and XML file filter.
		 */
		protected static const GLO_FILE_FILTER:FileFilter = new FileFilter("Glo and XML file filter", "*.glo;*.xml");
		
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
		 * @copy	net.dndigital.glo.mvcs.services.IProjectService#source
		 * 
		 * @see		XML
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
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
		 * @copy	net.dndigital.glo.mvcs.services.IProjectService#project
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
		 * Initiates File Selection.
		 * 
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function select():IProjectService
		{
			var file:File = new File;
				file.addEventListener(Event.SELECT, fileSelected);
				file.browse([GLO_FILE_FILTER]);
				
			return this;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handling
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Handles file selection.
		 */
		protected function fileSelected(event:Event):void
		{
			var file:File = event.target as File;
				file.removeEventListener(Event.SELECT, fileSelected);
				file.addEventListener(Event.COMPLETE, fileLoaded);
				file.load();
				log("fileSelected()");
		}
		
		/**
		 * @private
		 * Handles file loading.
		 */
		protected function fileLoaded(event:Event):void
		{
			log("fileLoaded() file={0} data={1}", file, file.data);
			var file:File = event.target as File;
				//file.removeEventListener(Event.COMPLETE, fileLoaded);
		}
	}
}