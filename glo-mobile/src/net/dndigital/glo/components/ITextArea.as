package net.dndigital.glo.components
{
	/**
	 * Represents multi or single line non editable text.
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface ITextArea extends IGloComponent
	{
		/**
		 * Indicates rendered text in current component.
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
	}
}