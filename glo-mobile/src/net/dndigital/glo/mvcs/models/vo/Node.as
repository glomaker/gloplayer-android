package net.dndigital.glo.mvcs.models.vo
{
	/**
	 * ValueObject. Represents data about single Node.
	 * 
	 * @see		net.dndigital.glo.mvcs.models.vo.Project
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Node
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