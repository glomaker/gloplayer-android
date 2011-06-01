package net.dndigital.glo.components
{
	/**
	 * Components-implementors of Image are capable of displaying still images inside Glo Projects.
	 * 
	 * @see		net.dndigital.glo.components.IGloComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IImage extends IGloComponent
	{
		/**
		 * <code>String</code> or <code>IBitmapDrawable</code>. If string is passed component assumes it's a URL. Otherwise <code>IBitmapDrawable</code> will be rendered.
		 * 
		 * @see		flash.display.IBitmapDrawable
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get source():Object;
		/**
		 * @private
		 */
		function set source(value:Object):void;
	}
}