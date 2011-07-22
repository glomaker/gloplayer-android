package net.dndigital.glo.mvcs
{
	import flash.display.DisplayObjectContainer;
	
	import net.dndigital.glo.mvcs.commands.*;
	import net.dndigital.glo.mvcs.events.*;
	import net.dndigital.glo.mvcs.models.GloModel;
	import net.dndigital.glo.mvcs.services.*;
	import net.dndigital.glo.mvcs.views.*;
	import net.dndigital.glo.mvcs.views.components.PageNumberDisplay;
	import net.dndigital.glo.mvcs.views.components.ProgressBar;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class GloContext extends Context
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
		protected static var log:Function = eu.kiichigo.utils.log(GloContext);
		
		public function GloContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function startup():void
		{
			// Singletons
			injector.mapSingletonOf(IProjectService, ProjectService);
			injector.mapSingletonOf(IFileService, FileService);
			injector.mapSingletonOf(GloModel, GloModel);
			
			// Controllers and Commands
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, Bootstrap, ContextEvent, true);
			
			commandMap.mapEvent(GloMenuEvent.LIST_FILES, ListGLODirectory, GloMenuEvent);
			commandMap.mapEvent(GloMenuEvent.LOAD_FILE, LoadProject, GloMenuEvent);
			commandMap.mapEvent(ProjectEvent.PROJECT, ShowProject, ProjectEvent);
			commandMap.mapEvent(ProjectEvent.NEXT_PAGE, Paginate, ProjectEvent);
			commandMap.mapEvent(ProjectEvent.PREV_PAGE, Paginate, ProjectEvent);
			
			// Views and Mediators
			mediatorMap.mapView(GloApplication, GloApplicationMediator);
			mediatorMap.mapView(GloPlayer, GloPlayerMediator);
			mediatorMap.mapView(GloMenu, GloMenuMediator);
			mediatorMap.mapView(GloControls, GloControlsMediator);
			mediatorMap.mapView(PageNumberDisplay, PageNumberDisplayMediator);
			mediatorMap.mapView(ProgressBar, ProgressBarMediator);
			
			super.startup();
		}
	}
}