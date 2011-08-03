package org.glomaker.mobileplayer.mvcs.views
{
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GloMenuMediator extends Mediator
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
		protected static var log:Function = eu.kiichigo.utils.log(GloMenuMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 * An instance of GloMenu view.
		 */
		public var view:GloMenu;
		
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
			
			eventMap.mapListener(eventDispatcher, GloMenuEvent.DIRECTORY_LISTED, directoryListed);
			eventMap.mapListener(view, GloMenuEvent.LOAD_FILE, dispatch);
			
			dispatch(new GloMenuEvent(GloMenuEvent.LIST_FILES));
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(eventDispatcher, GloMenuEvent.DIRECTORY_LISTED, directoryListed);
			eventMap.unmapListener(view, GloMenuEvent.LOAD_FILE, dispatch);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * 
		 */
		protected function directoryListed(event:GloMenuEvent):void
		{
			// each time the app switches to the menu, the system re-scans the documents directory
			// that in turn results in an update call here and when the menu is updated, the scroll position is lost
			// to avoid this, we only update if the length of the files list has changed - so you can still test by adding new GLOs but don't lose out during normal use
			// it would of course be more correct to check if there are any new files but that would be too expensive
			if( view.files == null || event.files.length != view.files.length )
			{
				view.files = event.files;
			}
		}
	}
}