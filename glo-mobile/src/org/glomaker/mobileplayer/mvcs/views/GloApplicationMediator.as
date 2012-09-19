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
	import flash.events.Event;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
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
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_QR_CODE_READER, showQRCodeReader);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.HIDE_QR_CODE_READER, hideQRCodeReader);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.ENTER_FULL_SCREEN, fullScreen);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.LEAVE_FULL_SCREEN, fullScreen);
			eventMap.mapListener(eventDispatcher, NotificationEvent.NOTIFICATION, notify);
			eventMap.mapListener(eventDispatcher, LoadProjectEvent.SHOW, clear);
			
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
		 */
		protected function notify(event:NotificationEvent):void
		{
			const notification:Notification = new Notification;
				  notification.text = event.message;  
			contextView.addChild(notification);
		}
	}
}