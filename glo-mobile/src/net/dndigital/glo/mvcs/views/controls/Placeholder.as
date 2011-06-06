package net.dndigital.glo.mvcs.views.controls
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.core.UIComponent;
	
	public class Placeholder extends GloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(Placeholder);
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _color:uint = 0xFFFFFF;
		/**
		 * Placeholder's color. Default value is 0xFFFFFF (white).
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get color():uint { return _color; }
		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if (_color == value)
				return;
			_color = value;
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
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			//log("resized({0}, {1})", width, height);
		}
	}
}