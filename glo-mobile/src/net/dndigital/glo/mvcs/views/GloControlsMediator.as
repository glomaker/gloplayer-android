package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public final class GloControlsMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloControlsMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var view:GloControls;
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			eventMap.mapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.MENU, handleMenuClick);
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE_CHANGED, pageChanged);
		}

		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			eventMap.unmapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.MENU, handleMenuClick);
			eventMap.unmapListener(eventDispatcher, ProjectEvent.PAGE_CHANGED, pageChanged);
		}
		
		/**
		 * Event handler - controls background was clicked. 
		 * @param e
		 */		
		protected function handleMenuClick(event:ProjectEvent):void
		{
			dispatch(ApplicationEvent.SHOW_MENU_EVENT);
		}
		
		/**
		 * @private
		 */
		protected function pageChanged(event:ProjectEvent):void
		{
			view.currentPage = event.index;
			view.totalPages = event.project.length;
		}
	}
}