package org.glomaker.mobileplayer.mvcs.views
{
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Page;
	import org.glomaker.mobileplayer.mvcs.views.components.PageNumberDisplay;
	
	import org.robotlegs.mvcs.Mediator;

	/**
	 * Integrates a PageNumberDisplay component into the application. 
	 * @author nilsmillahn
	 */	
	public class PageNumberDisplayMediator extends Mediator
	{
		
		[Inject]
		public var view:PageNumberDisplay;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE_CHANGED, handlePageChanged, ProjectEvent );
			view.hide( false );
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			eventMap.unmapListener( eventDispatcher, ProjectEvent.PAGE_CHANGED, handlePageChanged );
		}
		
		protected function handlePageChanged( e:ProjectEvent ):void
		{
			view.labelText = "Slide " + ( e.index + 1 ) + " of " + e.project.pages.length;
			view.show();
			
		}
		
		
	}
}