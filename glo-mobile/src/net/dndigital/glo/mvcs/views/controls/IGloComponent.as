package net.dndigital.glo.mvcs.views.controls
{
	import flash.utils.Dictionary;
	
	import net.dndigital.components.IGUIComponent;

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
		 * <code>Dictionary</code> containing data needed for <code>IGloComponent's</code> rendering.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Component
		 */
		function get data():Object;
		/**
		 * @private
		 */
		function set data(value:Object):void;
	}
}