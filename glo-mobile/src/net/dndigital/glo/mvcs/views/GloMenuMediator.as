package net.dndigital.glo.mvcs.views
{
	import flash.events.Event;
	
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
			
			eventMap.mapListener(view, GloMenuEvent.SELECT_FILE, passThruEvent);
			eventMap.mapListener(view, GloMenuEvent.LOAD_GLO_1, passThruEvent);
		}
		
		/**
		 * @private
		 * Starts file selection routine.
		 */
		protected function passThruEvent(event:Event):void
		{
			dispatch(event);
		}
	}
}