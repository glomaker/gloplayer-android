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
			eventMap.mapListener(view.bg, MouseEvent.CLICK, handleBgClick);
		}

		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			eventMap.unmapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.unmapListener(view.bg, MouseEvent.CLICK, handleBgClick);
		}
		
		/**
		 * Event handler - controls background was clicked. 
		 * @param e
		 */		
		protected function handleBgClick( e:MouseEvent ):void
		{
			// bit of a hack - if the click was somewhere near the middle, return to menu
			// cf. ticket #30
			if( e.localX > 100 && e.localX < view.stage.stageWidth - 100 )
			{
				dispatch( ApplicationEvent.SHOW_MENU_EVENT );
			}
		}
		
	}
}