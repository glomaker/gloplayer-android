package net.dndigital.glo.mvcs.models.vo
{
	import eu.kiichigo.utils.formatToString;

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
	public class Page
	{
		/**
		 * @private
		 */
		protected var _components:Vector.<Component>;
		/**
		 * Collection of <code>Component</code> instances belonging to this page.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get components():Vector.<Component> { return _components; }
		/**
		 * @private
		 */
		public function set components(value:Vector.<Component>):void
		{
			if (_components == value)
				return;
			_components = value;
		}
		
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
			return eu.kiichigo.utils.formatToString(this, "components");
		}
	}
}