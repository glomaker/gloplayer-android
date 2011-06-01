package net.dndigital.glo.mvcs.models.vo
{
	public class Project
	{
		//=================================
		//
		// Properties
		//
		//=================================
		
		/**
		 * @private
		 */
		private var _width:uint;
		
		/**
		 * width.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get width():uint { return _width; }
		/**
		 * @private
		 */
		public function set width( value:uint ):void
		{
			if (_width == value)
				return;
			_width = value;
		}
		
		
		/**
		 * @private
		 */
		private var _height:uint;
		
		/**
		 * height.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get height():uint { return _height; }
		/**
		 * @private
		 */
		public function set height( value:uint ):void
		{
			if ( _height == value )
				return;
			_height = value;
		}
		
		
		/**
		 * @private
		 */
		private var _background:uint = 16777215;
		
		/**
		 * Background. Default value is white ( #FFFFFF, 16777215 ).
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get background():uint { return _background; }
		/**
		 * @private
		 */
		public function set background( value:uint ):void
		{
			if ( _background == value )
				return;
			_background = value;
		}
		
		
		
		/**
		 * @private
		 */
		private var _pattern:String;
		
		/**
		 * pattern.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get pattern():String { return _pattern; }
		/**
		 * @private
		 */
		public function set pattern( value:String ):void
		{
			if ( _pattern == value )
				return;
			_pattern = value;
		}
		
		
		
	}
}