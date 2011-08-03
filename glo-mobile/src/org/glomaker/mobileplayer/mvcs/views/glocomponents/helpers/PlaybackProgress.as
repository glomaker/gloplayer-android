package org.glomaker.mobileplayer.mvcs.views.glocomponents.helpers
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Shape;
	
	import net.dndigital.components.GUIComponent;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
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
			addChild(indicator);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);

			drawRectangle(background, ColourPalette.SLATE_BLUE, width, height);
			drawRectangle(indicator, 0xFFFFFF, width * _percentage, height);
		}
	}
}