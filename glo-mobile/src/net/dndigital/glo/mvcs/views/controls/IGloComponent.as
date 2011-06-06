package net.dndigital.glo.mvcs.views.controls
{
	import net.dndigital.core.IUIComponent;

	/**
	 * The IGloComponent interface defines api that programmer must implement to create child components for <code>IGloPlayer</code>.
	 *  
	 * @see		net.dndigital.core.IUIComponent
	 * @see		net.dndigital.core.UIComponent
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
	public interface IGloComponent extends IUIComponent
	{
		/**
		 * Any additional data passed to component from *.glo file.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Component
		 */
		function get data():Object;
		/**
		 * @private
		 */
	}
}