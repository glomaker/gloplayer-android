package net.dndigital.glo.mvcs.models.vo
{
	public class Slide
	{
		/**
		 * @private
		 */
		private var _index:uint;
		
		/**
		 * index.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get index():uint { return _index; }
		/**
		 * @private
		 */
		public function set index(value:uint):void
		{
			if (_index == value)
				return;
			_index = value;
		}

		
	}
}