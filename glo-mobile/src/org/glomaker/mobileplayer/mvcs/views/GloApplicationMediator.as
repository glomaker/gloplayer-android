/* 
* GLO Mobile Player: Copyright (c) 2011 LTRI, University of West London. An
* Open Source Release under the GPL v3 licence (see http://www.gnu.org/licenses/).
* Authors: DN Digital Ltd, Tom Boyle, Lyn Greaves, Carl Smith.

* This program is free software: you can redistribute it and/or modify it under the terms 
* of the GNU General Public License as published by the Free Software Foundation, 
* either version 3 of the License, or (at your option) any later version. This program
* is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* 
* For GNU Public licence see http://www.gnu.org/licenses/ or http://www.opensource.org/licenses/.
*
* External libraries used:
*
* Greensock Tweening Library (TweenLite), copyright Greensock Inc
* "NO CHARGE" NON-EXCLUSIVE SOFTWARE LICENSE AGREEMENT
* http://www.greensock.com/terms_of_use.html
*	
* A number of utility classes Copyright (c) 2008 David Sergey, published under the MIT license
*
* A number of utility classes Copyright (c) DN Digital Ltd, published under the MIT license
*
* The ScaleBitmap class, released open-source under the RPL license (http://www.opensource.org/licenses/rpl.php)
*/
package org.glomaker.mobileplayer.mvcs.views
{
	import com.juankpro.ane.localnotif.Notification;
	import com.juankpro.ane.localnotif.NotificationIconType;
	import com.juankpro.ane.localnotif.NotificationManager;
	
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
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
		
		/**
		 * @private
		 * Manages native notifications.
		 */
		protected var nativeNotificationManager:NotificationManager;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var model:GloModel;
		
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
		
		public function GloApplicationMediator()
		{
			super();
			
			if (NotificationManager.isSupported)
				nativeNotificationManager = new NotificationManager();
		}
		
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
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_MENU, showMenu, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_PLAYER, showPlayer, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_JOURNEY_MANAGER, showJourneyManager, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_QR_CODE_READER, showQRCodeReader, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.HIDE_QR_CODE_READER, hideQRCodeReader, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.ENTER_FULL_SCREEN, fullScreen, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.LEAVE_FULL_SCREEN, fullScreen, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, NotificationEvent.NOTIFICATION, notify, NotificationEvent);
			eventMap.mapListener(eventDispatcher, NotificationEvent.NATIVE_NOTIFICATION, nativeNotify, NotificationEvent);
			eventMap.mapListener(eventDispatcher, NotificationEvent.CANCEL_NATIVE_NOTIFICATION, cancelNativeNotification, NotificationEvent);
			eventMap.mapListener(eventDispatcher, LoadProjectEvent.SHOW, clear, LoadProjectEvent);
			
			eventMap.mapListener(view, ApplicationEvent.INITIALIZED, showMenu, ApplicationEvent);
			
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
		protected function showMenu(event:Event = null):void
		{
			model.glo = null;
			view.showMenu();
		}
		
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
		 * Invokes showJourneyManager on view.
		 */
		protected function showJourneyManager(event:Event = null):void
		{
			view.showJourneyManager();
		}
		
		/**
		 * @private
		 * Invokes showQRCodeReader on view.
		 */
		protected function showQRCodeReader(event:Event = null):void
		{
			view.showQRCodeReader();
		}
		
		/**
		 * @private
		 * Invokes hideQRCodeReader on view.
		 */
		protected function hideQRCodeReader(event:Event = null):void
		{
			view.hideQRCodeReader();
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
		 * Handles fullscreen display.
		 */
		protected function fullScreen(event:ApplicationEvent):void
		{
			switch(event.type)
			{
				case ApplicationEvent.ENTER_FULL_SCREEN:
					view.fullScreen = true;
					break;
					
				case ApplicationEvent.LEAVE_FULL_SCREEN:
					view.fullScreen = false;
					break;
			}
		}
		
		/**
		 * @private
		 * Method handles notification received from various parts of Application. This notifications will be presented to user.
		 * 
		 * NOTE: the current implementation only supports one modal dialog at a time!!
		 */
		protected function notify(event:NotificationEvent):void
		{
			if (!event.message && !event.dialog)
				return;
			
			var notification:org.glomaker.mobileplayer.mvcs.views.components.Notification;
			if (event.dialog)
				notification = event.dialog;
			else
			{
				notification = new org.glomaker.mobileplayer.mvcs.views.components.Notification();
				notification.text = event.message; 
			}
			
			if (event.modal)
			{
				view.mouseEnabled = false;
				view.mouseChildren = false;
				view.filters = [ new BlurFilter(3, 3) ];
				
				notification.addEventListener(Event.CLOSE, notification_closeHandler);
			}
			
			view.stage.addChild(notification);
		}
		
		/**
		 * @private
		 * Handles dialog close for modal dialogs.
		 */
		protected function notification_closeHandler(event:Event):void
		{
			var notification:org.glomaker.mobileplayer.mvcs.views.components.Notification = event.target as org.glomaker.mobileplayer.mvcs.views.components.Notification;
			notification.removeEventListener(Event.CLOSE, notification_closeHandler);
			
			view.mouseEnabled = true;
			view.mouseChildren = true;
			view.filters = null;
		}
		
		/**
		 * @private
		 * Method handles notification received from various parts of Application. These notifications will use the device native
		 * notification system if supported.
		 */
		protected function nativeNotify(event:NotificationEvent):void
		{
			if (nativeNotificationManager && event.message)
			{
				var notification:com.juankpro.ane.localnotif.Notification = new com.juankpro.ane.localnotif.Notification();
				//notification.actionLabel = "OK";
				notification.iconType = NotificationIconType.FLAG;
				notification.body = event.message;
				notification.title = "GLO Player";
				notification.playSound = true;
				notification.vibrate = true;
				notification.cancelOnSelect = true;
				notification.hasAction = true;
				//notification.actionData = {sampleData:"Hello World!"}
				
				nativeNotificationManager.notifyUser("GLO_MAKER_NOTIFICATION", notification);
			}
		}
		
		/**
		 * @private
		 * Handle request for canceling any native notifications (removed from notification list of device).
		 */
		protected function cancelNativeNotification(event:NotificationEvent):void
		{
			if (nativeNotificationManager)
				nativeNotificationManager.cancel("GLO_MAKER_NOTIFICATION");
		}
	}
}