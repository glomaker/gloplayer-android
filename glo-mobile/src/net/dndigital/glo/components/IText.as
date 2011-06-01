package net.dndigital.glo.components
{
	/**
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IText
	{
		/**
		 * 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get text():String;
		/**
		 * @private
		 */
		function set text( value:String ):void;
		
		
		/**
		 * 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get format():Object;
		/**
		 * @private
		 */
		function set format( value:Object ):void;
	}
}