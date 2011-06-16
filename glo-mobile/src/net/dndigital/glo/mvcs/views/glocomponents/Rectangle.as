package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.components.IGUIComponent;

	/**
	 * Rectangle component draws rectangular shapes on Player's page.
	 * 
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.IGloComponent
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.GloComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public final class Rectangle extends GloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(Rectangle);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _cornerRadius:Number = 0;
		/**
		 * Rectangle's corner radious in pixels.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get cornerRadius():Number { return _cornerRadius; }
		/**
		 * @private
		 */
		public function set cornerRadius(value:Number):void
		{
			if (_cornerRadius == value)
				return;
			_cornerRadius = value;
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _color:uint = 0xFFFFFF;
		/**
		 * Color in which rectangle should be filled.
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
		override public function initialize():IGUIComponent
		{
			mapProperty("cornerRadius");
			mapProperty("bgcolour", "color");
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRoundRect(0, 0, width, height, _cornerRadius, _cornerRadius);
			graphics.endFill();
			
		}
	
	}
}