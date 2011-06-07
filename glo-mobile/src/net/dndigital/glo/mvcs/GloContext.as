package net.dndigital.glo.mvcs
{
	import flash.display.DisplayObjectContainer;
	
	import net.dndigital.glo.mvcs.commands.*;
	import net.dndigital.glo.mvcs.events.*;
	import net.dndigital.glo.mvcs.models.GloModel;
	import net.dndigital.glo.mvcs.services.*;
	import net.dndigital.glo.mvcs.views.*;
	
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
		
		override public function startup():void
		{
			// Singletons
			injector.mapSingletonOf(IProjectService, ProjectService);
			injector.mapSingletonOf(GloModel, GloModel);
			
			// Controllers and Commands
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, Bootstrap, ContextEvent, true);
			commandMap.mapEvent(GloMenuEvent.SELECT_FILE, SelectProject, GloMenuEvent);
			commandMap.mapEvent(GloMenuEvent.LOAD_GLO_1, LoadGLODirect, GloMenuEvent);
			commandMap.mapEvent(ProjectEvent.PROJECT, ShowProject, ProjectEvent);
			commandMap.mapEvent(ProjectEvent.NEXT_PAGE, Paginate, ProjectEvent);
			commandMap.mapEvent(ProjectEvent.PREV_PAGE, Paginate, ProjectEvent);
			
			// Views and Mediators
			mediatorMap.mapView(GloApplication, GloApplicationMediator);
			mediatorMap.mapView(GloPlayer, GloPlayerMediator);
			mediatorMap.mapView(GloMenu, GloMenuMediator);
			mediatorMap.mapView(GloControls, GloControlsMediator);
			
			super.startup();
		}
	}
}