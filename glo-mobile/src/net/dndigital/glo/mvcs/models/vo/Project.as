package net.dndigital.glo.mvcs.models.vo
{
	import eu.kiichigo.utils.formatToString;

	/**
	 * ValueObject. Represents data about Glo Project.
	 * 
	 * @see		net.dndigital.glo.mvcs.models.vo.Node
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Project
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _width:uint;
		
		/**
		 * Glo Project's width.
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
		public function set width(value:uint):void
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
		 * Glo Project's height.
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
		public function set height(value:uint):void
		{
			if (_height == value)
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
		public function set background(value:uint):void
		{
			if ( _background == value )
				return;
			_background = value;
		}
		
		
		
		/**
		 * @private
		 */
		private var _hasFullPaths:Boolean;
		
		/**
		 * Indicates whether file path are absolute (full) or relative.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get hasFullPaths():Boolean { return _hasFullPaths; }
		/**
		 * @private
		 */
		public function set hasFullPaths(value:Boolean):void
		{
			if (_hasFullPaths == value)
				return;
			_hasFullPaths = value;
		}
		
		
		/**
		 * @private
		 */
		private var _pages:Vector.<Page>;
		
		/**
		 * Collection of nodes that belong to current Glo Project
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get pages():Vector.<Page> { return _pages; }
		/**
		 * @private
		 */
		public function set pages(value:Vector.<Page>):void
		{
			if (_pages == value)
				return;
			_pages = value;
		}
		
		/**
		 * @private
		 */
		protected var _length:int;
		/**
		 * Length of the Project in number of pages.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get length():int{ return int(_pages) || _pages.length; }
		
		//--------------------------------------------------------------------------
		//
		//  toString
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns a string containing some of instance's properties.
		 * 
		 * @return	Class name and some of instance properties and values.
		 */
		public function toString():String
		{
			return eu.kiichigo.utils.formatToString(this, "width", "height", "background", "hasFullPaths", "length", "pages");
		}
	}
}