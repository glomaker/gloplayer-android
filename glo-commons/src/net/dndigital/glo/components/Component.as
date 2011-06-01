package net.dndigital.glo.components
{
	import flash.display.Sprite;
	
	/**
	 * Represents basic visual Component instances. Instances of Component classes can be added to <code>IContainer</code>.
	 * 
	 * @see		net.dndigital.glo.components.IContainer
	 * @see		net.dndigital.glo.components.IComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Component extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _width:Number;
		/**
		 * @copy	flash.display.DisplayObject#width
		 */
		override public function get width():Number
		{
			return _width;
		}
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(_width == value)
				return;
			_width = value;
			resized();
		}
		
		
		/**
		 * @private
		 */
		protected var _height:Number;
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return _height;
		}
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(_height == value)
				return;
			_height = value;
			resized();
		}
		
		protected function resized():void
		{
			
		}
	}
}

