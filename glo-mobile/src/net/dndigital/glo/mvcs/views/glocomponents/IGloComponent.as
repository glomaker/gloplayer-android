package net.dndigital.glo.mvcs.views.glocomponents
{
	import flash.utils.Dictionary;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.models.vo.Component;
	import net.dndigital.glo.mvcs.views.GloPlayer;

	/**
	 * The IGloComponent interface defines api that programmer must implement to create child components for <code>IGloPlayer</code>.
	 *  
	 * @see		net.dndigital.components.IUIComponent
	 * @see		net.dndigital.components.UIComponent
	 * @see		net.dndigital.glo.mvcs.models.vo.Component
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IGloComponent extends IGUIComponent
	{
		/**
		 * Data VO received from file. Containing component's data.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Component
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get component():Component;
		/**
		 * @private
		 */
		function set component(value:Component):void;
		
		/**
		 * Reference to an instance of <code>GloPlayer</code> that's owns current instance of <code>IGloComponent</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.views.GloPlayer
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get player():GloPlayer;
		/**
		 * @private
		 */
		function set player(value:GloPlayer):void;
	}
}