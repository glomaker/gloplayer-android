package org.glomaker.mobileplayer.mvcs.views
{
	import flash.events.TransformGestureEvent;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Project;
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
			
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE, changePage);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate);
			eventMap.mapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PAGE_CHANGED, dispatch);
			eventMap.mapListener(view, NotificationEvent.NOTIFICATION, dispatch);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			eventMap.unmapListener(eventDispatcher, ProjectEvent.PAGE, changePage);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate);
			eventMap.unmapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PAGE_CHANGED, dispatch);
			eventMap.unmapListener(view, NotificationEvent.NOTIFICATION, dispatch);
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
		protected final function applyProject(event:ProjectEvent):void
		{
			view.project = event.project
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