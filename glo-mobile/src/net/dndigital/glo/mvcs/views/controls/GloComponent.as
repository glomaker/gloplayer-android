package net.dndigital.glo.mvcs.views.controls
{
	import eu.kiichigo.utils.log;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import net.dndigital.components.Application;
	import net.dndigital.components.IContainer;
	import net.dndigital.components.IUIComponent;
	import net.dndigital.components.UIComponent;
	
	public class GloComponent extends UIComponent implements IGloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloComponent);
		
		//--------------------------------------------------------------------------
		//
		//  Property
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _data:Dictionary;
		/**
		 * data.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get data():Dictionary { return _data; }
		/**
		 * @private
		 */
		public function set data(value:Dictionary):void
		{
			if (_data == value)
				return;
			_data = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overrien API
		//
		//--------------------------------------------------------------------------
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
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
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