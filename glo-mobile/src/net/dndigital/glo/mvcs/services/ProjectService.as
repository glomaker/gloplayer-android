package net.dndigital.glo.mvcs.services
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.system.System;
	
	import net.dndigital.glo.GloError;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.glo.mvcs.utils.validateGlo;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * <code>IProjectService</code> can be used to load and parse *.glo project files.
	 * 
	 * @see		net.dndigital.glo.mvcs.services.IProjectService
	 * @see		net.dndigital.glo.mvcs.models.vo.Project
	 * 
	 * @author		David "nirth" Sergey
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
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
		//  IProjectService
		//
		//--------------------------------------------------------------------------
		
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
				file.nativePath = File.applicationDirectory.nativePath + "/assets";
				file.addEventListener(Event.SELECT, fileSelected);
				file.browse([GLO_FILE_FILTER]);
				
			return this;
		}
		
		/**
		 * Loads GLO project XML from a file reference. 
		 * @param file
		 * @throws GLOError.INVALID_GLO_FILE if the XML doesn't validate.
		 */		
		public function loadFromFile( file:File ):void
		{
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.position = 0;
			
			var xml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
			
			if(!validateGlo(xml))
				throw GloError.INVALID_GLO_FILE;
			
			parse(xml);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Method
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
			
			try{
				loadFromFile( file );
			}catch(e:Error){
				dispatch( new ProjectEvent( ProjectEvent.GLO_VALIDATE_ERROR ) );
			}
		}
		
		/**
		 * @private
		 * Parses an XML file.
		 */
		protected function parse(xml:XML):void
		{
			_project = net.dndigital.glo.mvcs.services.parse(xml);
			eventDispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.PROJECT, _project));
			System.disposeXML(xml);
		}
	}
}