package net.dndigital.glo.mvcs.views
{
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.vo.Page;
	import net.dndigital.glo.mvcs.views.components.PageNumberDisplay;
	import net.dndigital.glo.mvcs.views.components.ProgressBar;
	
	import org.robotlegs.mvcs.Mediator;

	/**
	 * Integrates a ProgressBar component into the application. 
	 * @author nilsmillahn
	 */	
	public class ProgressBarMediator extends Mediator
	{
		
		[Inject]
		public var view:ProgressBar;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE_CHANGED, handlePageChanged, ProjectEvent );
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			eventMap.unmapListener( eventDispatcher, ProjectEvent.PAGE_CHANGED, handlePageChanged );
		}
		
		protected function handlePageChanged( e:ProjectEvent ):void
		{
			if( e.project && e.project.length > 0 )
			{
				if( e.project.length == 1)
				{
					// single page only - always viewing at 100%
					view.percent = 1;	
				}else{
					// more than one page, calculate percentage
					view.percent = e.index / (e.project.length - 1);
				}
			}else{
				view.percent = 0;
			}
			
		}
		
		
	}
}