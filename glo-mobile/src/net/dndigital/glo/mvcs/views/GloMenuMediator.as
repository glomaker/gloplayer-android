package net.dndigital.glo.mvcs.views
{
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GloMenuMediator extends Mediator
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
		protected static var log:Function = eu.kiichigo.utils.log(GloMenuMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 * An instance of GloMenu view.
		 */
		public var view:GloMenu;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			//log("onRegister() view={0}", view);
			
			eventMap.mapListener(view, GloMenuEvent.SELECT_FILE, selectFile);
		}
		
		/**
		 * @private
		 * Starts file selection routine.
		 */
		protected function selectFile(event:GloMenuEvent):void
		{
			dispatch(event);
		}
	}
}