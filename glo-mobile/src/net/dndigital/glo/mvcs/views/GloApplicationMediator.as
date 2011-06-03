package net.dndigital.glo.mvcs.views
{
	import flash.events.StageOrientationEvent;
	
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GloApplicationMediator extends Mediator
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
		protected static var log:Function = eu.kiichigo.utils.log(GloApplicationMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var view:GloApplication;
		
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
			//log("onRegister() view={0}", view);
			
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_PLAYER, showPlayer);
			eventMap.mapListener(view, ApplicationEvent.INITIALIZED, showMenu);
			
			view.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChange);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Invokes showPlayer on view.
		 */
		protected function showPlayer(event:ApplicationEvent):void
		{
			//log("startPlayer() event={0}", event);
			view.showPlayer();
		}
		
		/**
		 * @private
		 * Invokes showPlayer on view.
		 */
		protected function showMenu(event:ApplicationEvent):void
		{
			//log("startPlayer() event={0}", event);
			view.showMenu();
		}
		
		/**
		 * @private
		 * Handles orientation changing.
		 */
		protected function orientationChange(event:StageOrientationEvent):void
		{
			view.width = contextView.stage.fullScreenWidth;
			view.height = contextView.stage.fullScreenHeight;
			log("orientationChange({0})", event);
		}
	}
}