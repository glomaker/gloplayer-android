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
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.services.IProjectService;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class GloPlayerMediator extends Mediator implements IMediator
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
		protected static var log:Function = eu.kiichigo.utils.log(GloPlayerMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var view:GloPlayer;
		
		[Inject]
		/**
		 * @private
		 */
		public var service:IProjectService;
				
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
			view.project = service.project;
			
			eventMap.mapListener(eventDispatcher, ApplicationEvent.SHOW_PLAYER, applyProject);
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE, changePage);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate);
			eventMap.mapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PAGE_CHANGED, dispatch);
			eventMap.mapListener(view, NotificationEvent.NOTIFICATION, dispatch);
			eventMap.mapListener(view, ApplicationEvent.ENTER_FULL_SCREEN, dispatch);
			eventMap.mapListener(view, ApplicationEvent.LEAVE_FULL_SCREEN, dispatch);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.SHOW_PLAYER, applyProject);
			eventMap.unmapListener(eventDispatcher, ProjectEvent.PAGE, changePage);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate);
			eventMap.unmapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PAGE_CHANGED, dispatch);
			eventMap.unmapListener(view, NotificationEvent.NOTIFICATION, dispatch);
			eventMap.unmapListener(view, ApplicationEvent.ENTER_FULL_SCREEN, dispatch);
			eventMap.unmapListener(view, ApplicationEvent.LEAVE_FULL_SCREEN, dispatch);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Applies project to current instance of player.
		 */
		protected final function applyProject(event:ApplicationEvent):void
		{
			view.project = service.project;
		}
		
		/**
		 * @private
		 * Handles page changing logic, from Context down to view.
		 */
		protected final function changePage(event:ProjectEvent):void
		{
			view.index = event.index;
		}
		
		/**
		 * Event handler - ApplicationEvent.ACTIVATE 
		 * @param event
		 */		
		protected final function handleActivate(event:ApplicationEvent):void
		{
			view.activateAllComponents();
		}
		
		/**
		 * Event handler - ApplicationEvent.DEACTIVATE 
		 * @param event
		 */		
		protected final function handleDeactivate(event:ApplicationEvent):void
		{
			view.deactivateAllComponents();
		}
	}
}