package net.dndigital.glo.mvcs.views.glocomponents.helpers
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.utils.drawRectangle;
	
	public class PlaybackProgress extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(PlaybackProgress);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const background:Shape = new Shape;
		
		/**
		 * @private
		 */
		protected const indicator:Shape = new Shape;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _percentage:Number = 0;
		/**
		 * Indicates percentage, 0 (0%) to 1 (100%).
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get percentage():Number { return _percentage; }
		/**
		 * @private
		 */
		public function set percentage(value:Number):void
		{
			if (_percentage == value)
				return;
			_percentage = value;
			invalidateDisplay();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(background);
			
			indicator.filters = [new GlowFilter(0xFFFF6600, .7, 6, 6, 3, 2)];
			addChild(indicator);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);

			drawRectangle(background, 0xAAAAAA, width, height);
			drawRectangle(indicator, 0xFFFFFF, width * _percentage, height);
		}
	}
}