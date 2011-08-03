package org.glomaker.mobileplayer.mvcs.views
{
	import flash.events.Event;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.views.components.Notification;
	
	import org.robotlegs.mvcs.Mediator;
	
	public final class GloApplicationMediator extends Mediator
	{

		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Timeout identifier used for notifications.
		 */
		protected var notificationTimeout:uint;
		
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
			super.onRegister();			
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_PLAYER, showPlayer);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_MENU, showMenu);
			eventMap.mapListener(eventDispatcher, NotificationEvent.NOTIFICATION, notify);
			eventMap.mapListener(eventDispatcher, GloMenuEvent.LOAD_FILE, clear);
			
			eventMap.mapListener(view, ApplicationEvent.INITIALIZED, showMenu);
			
			view.stage.addEventListener(Event.RESIZE, stageResized);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			super.onRemove();
			view.stage.removeEventListener(Event.RESIZE, stageResized);
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
		protected function showPlayer(event:Event = null):void
		{
			view.showPlayer();
		}
		
		/**
		 * @private
		 * Invokes showPlayer on view.
		 */
		protected function showMenu(event:Event = null):void
		{
			view.showMenu();
		}
		
		/**
		 * @private
		 * Invokes showPlayer on view.
		 */
		protected function clear(event:Event = null):void
		{
			view.clear();
		}
		
		/**
		 * @private
		 * Handles orientation changing.
		 */
		protected function stageResized(event:Event):void
		{
			// FIXME: Find a way to use Application widht and height instead of full screen width/height.
			view.width = contextView.stage.fullScreenWidth;
			view.height = contextView.stage.fullScreenHeight;
			//view.validate();
		}
		
		/**
		 * @private
		 * Method handles notification received from various parts of Application. This notifications will be presented to user.
		 */
		protected function notify(event:NotificationEvent):void
		{
			const notification:Notification = new Notification;
				  notification.text = event.message;  
			contextView.addChild(notification);
		}
	}
}