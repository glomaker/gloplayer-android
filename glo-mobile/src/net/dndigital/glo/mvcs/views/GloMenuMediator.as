package net.dndigital.glo.mvcs.views
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import thanksmister.touchlist.events.ListItemEvent;
	
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
			eventMap.mapListener(view, ListItemEvent.ITEM_SELECTED, selected);
			
			dispatch(new GloMenuEvent(GloMenuEvent.LIST_FILES));
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(eventDispatcher, GloMenuEvent.DIRECTORY_LISTED, directoryListed);
			eventMap.unmapListener(view, GloMenuEvent.LOAD_FILE, dispatch);
			eventMap.unmapListener(view, ListItemEvent.ITEM_SELECTED, selected);
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
			view.files = event.files;
		}
		
		/**
		 * Menu list item was selected.
		 * @private 
		 * @param event
		 */		
		protected function selected(event:ListItemEvent):void
		{
			trace("click", event.renderer.data);
		}
	}
}