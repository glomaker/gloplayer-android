package net.dndigital.core
{
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	
	/**
	 * Represents basic visual Component instances. Instances of Component classes can be added to <code>IContainer</code>.
	 * 
	 * @see		net.dndigital.glo.components.IContainer
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IComponent extends IEventDispatcher, IBitmapDrawable
	{
		/**
		 * Override this method to process any initialization that should be done prior to components first rendering.
		 */
		function initialize():void;
		
		/**
		 * Method passed in <code>fun</code> argument will be invoked with <code>args</code> as arguments next time <code>IComponent</code> redraws.
		 *  
		 * @param fun	<code>Function</code> closure to be invoked.
		 * @param args	<code>Function</code> closure's arguments.
		 * 
		 */
		function delay(fun:Function, args:Array):void;
		
		/**
		 * Invalidates display. Any logic in <code>IComponent.displayUpdated</code> will be processed next time component redraws.
		 */
		function invalidateDisplay():void;
		
		/**
		 * Invalidates data. Any logic in <code>IComponent.dataUpdated</code> will be processed next time component redraws.
		 */
		function invalidateData():void;
	}
}