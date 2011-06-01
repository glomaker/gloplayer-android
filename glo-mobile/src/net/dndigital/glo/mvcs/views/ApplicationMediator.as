package net.dndigital.glo.mvcs.views
{
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ApplicationMediator extends Mediator
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
		protected static var log:Function = eu.kiichigo.utils.log(ApplicationMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var view:Application;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
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
			log("onRegister() view={0}", view);
			
			eventMap.mapListener(eventDispatcher, ApplicationEvent.START_PLAYER, showPlayer);
		}
		
		/**
		 * @private
		 * Invokes showPlayer on view.
		 */
		protected function showPlayer(event:ApplicationEvent):void
		{
			log("startPlayer() event={0}", event);
			view.showPlayer();
		}
	}
}