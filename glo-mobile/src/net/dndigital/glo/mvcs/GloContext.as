package net.dndigital.glo.mvcs
{
	import flash.display.DisplayObjectContainer;
	
	import net.dndigital.glo.mvcs.commands.Bootstrap;
	import net.dndigital.glo.mvcs.commands.StartPlayer;
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.views.Application;
	import net.dndigital.glo.mvcs.views.ApplicationMediator;
	import net.dndigital.glo.mvcs.views.Controls;
	import net.dndigital.glo.mvcs.views.ControlsMediator;
	import net.dndigital.glo.mvcs.views.GloPlayer;
	import net.dndigital.glo.mvcs.views.GloPlayerMediator;
	
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
			// Controllers and Commands
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, Bootstrap, ContextEvent, true);
			
			// Views and Mediators
			mediatorMap.mapView(Application, ApplicationMediator);
			mediatorMap.mapView(GloPlayer, GloPlayerMediator);
			mediatorMap.mapView(Controls, ControlsMediator);
			
			log("startup()");
			super.startup();
		}
	}
}