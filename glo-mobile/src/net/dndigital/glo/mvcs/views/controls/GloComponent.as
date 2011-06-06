package net.dndigital.glo.mvcs.views.controls
{
	import flash.events.Event;
	
	import net.dndigital.components.Application;
	import net.dndigital.components.IContainer;
	import net.dndigital.components.IUIComponent;
	import net.dndigital.components.UIComponent;
	
	public class GloComponent extends UIComponent implements IGloComponent
	{
		/**
		 * @inheritDoc
		 */
		override public function initialize():IUIComponent
		{
			super.initialize();
			
			if(!(parent is IContainer) && !(this is Application))
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			return this;
		}
		
		/**
		 * @private
		 * Handles added to stage. This handler should be invoked only if parent is not IContainer.
		 */
		protected function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			if(owner== null && !(this is Application))
				validate();
		}
	}
}