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
	public interface IContainer extends IComponent
	{
		/**
		 * 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get layout():ILayout;
		/**
		 * @private
		 */
		function set layout( value:ILayout ):void;
		
		
		/**
		 * 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get children():Vector.<IComponent>;
		
		
		/**
		 * 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function add( component:IComponent, properties:Object = null ):IComponent;
		
		
		/**
		 * 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function remove( object:Object ):IComponent;
	}
}