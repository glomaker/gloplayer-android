package net.dndigital.components
{
	/**
	 * Represents instances of Containers. Containers used to hold multiple instances of <code>IComponents</code> and <code>IContainers</code> and align them properly.
	 *  
	 * @see		net.dndigital.glo.components.IGUIComponent
	 * @see		net.dndigital.glo.components.ILayout
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IContainer extends IGUIComponent
	{
		/**
		 * Indicates current Layout engine. Layout engine should implement <code>ILayout</code> interface. If <code>IContainer.layout</code> is null display children are not aligned.
		 * 
		 * @see		net.dndigital.components.ILayout
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
		 * List of currently displayed by <code>IContainer</code> display children.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get children():Vector.<IGUIComponent>;
		
		
		/**
		 * Adds an instance of <code>IGUIComponent</code> to current <code>IContainer</code>. Layout engine will be used to align items.
		 *
		 * @param	component	<code>IGUIComponent</code>, an instance of <code>IComponent</code> to be added to display list.
		 * @param	properties	<code>Object</code> or <code>Dictionary</code>, properties to be applied to newly added instance of <code>IComponent</code>.
		 * @param	index		<code>IGUIComponent</code> index (depth) inside of an insance of <code>IContainer</code>.
		 * 
		 * @return				Newly added instance of <code>IGUIComponent</code>.
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function add(component:IGUIComponent, properties:Object = null, index:int = -1):IGUIComponent;
		
		
		/**
		 * Removes an instance of <code>IGUIComponent</code> from display list.
		 * 
		 * @param	component	<code>IGUIComponent</code> or Number. If an instance of <code>IComponent</code> passsed, it will be removed from a display list. If Number item on index matching it will be removed.
		 *
		 * @return	Removed instance.
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function remove(component:Object):IGUIComponent;
		
		/**
		 * Removes all children from it's display list.
		 * 
		 * @param	destructor	<code>Function</code> that will by applied for each component, to finilise it's existence. <code>Function</code> signature: <code>function(component:IGUIComponent):void</code>.
		 * 
		 * @return	Reference to an instance of <code>IContainer</code>.
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function removeAll(destructor:Function = null):IContainer;
		
		/**
		 * Brings provided in argument <code>component</code> instance of <code>IGUIComponent</code> too front.
		 * 
		 * @param	component	An instance of <code>IGUIComponent</code> to be brought to front.
		 * 
		 * @return	<code>IGUIComponent</code> provided in argument.
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function bringToFront(component:IGUIComponent):IGUIComponent;
		
		/**
		 * Invalidates children. Any logic in <code>IContainer.measured</code> will be processed next time component redraws.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function invalidateChildren():void;
	}
}