package net.dndigital.glo.mvcs.views
{
	import flash.events.TransformGestureEvent;
	
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.glo.mvcs.services.IProjectService;
	
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
			eventMap.mapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PREV_PAGE, dispatch);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			eventMap.unmapListener(eventDispatcher, ProjectEvent.PAGE, changePage);
			eventMap.unmapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PREV_PAGE, dispatch);
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
	}
}