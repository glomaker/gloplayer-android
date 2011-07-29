package net.dndigital.glo.mvcs.services
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.system.System;
	
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
		 * @private
		 */
		protected var _file:File;
		/**
		 * file.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get file():File { return _file; }
		/**
		 * @private
		 */
		public function set file(value:File):void
		{
			if (_file == value)
				return;
			_file = value;
			loadFile(value);
		}
		
		/**
		 * FileStream instance used to read from files. 
		 */		
		protected var _stream:FileStream;

		//--------------------------------------------------------------------------
		//
		//  Private Method
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Loads GLO project XML from a file reference.
		 * @param file
		 * @returns The file object if load completed successfully, null otherwise.
		 */		
		protected function loadFile(file:File):void
		{
			if(file == null)
				return;
			
			// cleanup previous stream
			if( _stream )
			{
				_stream.close();
				_stream.removeEventListener( Event.COMPLETE, fileCompleteHandler );
			}
			
			// new stream
			// async reading makes the app more responsive on mobile devices
			_stream = new FileStream();
			_stream.addEventListener(Event.COMPLETE, fileCompleteHandler)
			_stream.openAsync(file, FileMode.READ);
		}
		
		/**
		 * Event handler - file has finished async open operation.
		 * Data is now loaded and ready. 
		 * @param event
		 */		
		protected function fileCompleteHandler(event:Event):void
		{
			// read
			var xml:XML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
				
			// cleanup
			_stream.close();
			_stream.removeEventListener( Event.COMPLETE, fileCompleteHandler );
			
			// Validate project's integrity.
			if(!validateGlo(xml))
			{
				dispatch( new ProjectEvent( ProjectEvent.GLO_VALIDATE_ERROR ) );
				return;
			}
			
			// Parse project
			const project:Project = net.dndigital.glo.mvcs.services.parse(xml, file.parent);
			_project = project;
			
			// Notify application that project is parsed.
			eventDispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.PROJECT, _project));
			
			// Clean up xml.
			System.disposeXML(xml);
		}
	}
}