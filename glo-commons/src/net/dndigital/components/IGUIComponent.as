/*
Copyright (c) 2011 DN Digital Ltd (http://dndigital.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package net.dndigital.components
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
	public interface IGUIComponent extends IEventDispatcher, IBitmapDrawable
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Indicates position along horizontal axis.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get x():Number;
		/**
		 * @private
		 */
		function set x(value:Number):void;
		
		/**
		 * Indicates position along vertical axis.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get y():Number;
		/**
		 * @private
		 */
		function set y(value:Number):void;
		
		/**
		 * Indicates width of an <code>IGUIComponent</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get width():Number;
		/**
		 * @private
		 */
		function set width(value:Number):void;
		
		/**
		 * Indicates height of an <code>IGUIComponent</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get height():Number;
		/**
		 * @private
		 */
		function set height(value:Number):void;
		
		/**
		 * Indicates whether component is visible or not.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get visible():Boolean;
		/**
		 * @private
		 */
		function set visible(value:Boolean):void;
		
		/**
		 * Name of default state that component is initialized with.
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get defaultState():String;
		
		/**
		 * Current State.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get state():String;
		/**
		 * @private
		 */
		function set state(value:String):void;
		
		/**
		 * <code>IGUIComponent</code>'s unique name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get name():String;
		/**
		 * @private
		 */
		function set name(value:String):void;
		
		/**
		 * Reference to an instance of <code>IContainer</code> that's owns current <code>IGUIComponent</code>.
		 * 
		 * @see		net.dndigital.core.IContainer
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get owner():IContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Override this method to process any initialization that should be done prior to components first rendering.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function initialize():IGUIComponent;
		
		/**
		 * Method passed in <code>fun</code> argument will be invoked with <code>args</code> as arguments next time <code>IGUIComponent</code> redraws.
		 *  
		 * @param fun	<code>Function</code> closure to be invoked.
		 * @param args	<code>Function</code> closure's arguments.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function delay(fun:Function, args:Array = null):void;
		
		/**
		 * Invalidates display. Any logic in <code>IComponent.commited</code> will be processed next time component redraws.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function invalidateDisplay():void;
		
		/**
		 * Invalidates data. Any logic in <code>IGUIComponent.resized</code> will be processed next time component redraws.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function invalidateData():void;
		
		/**
		 * Invalidates state. Any logic in <code>IGUIComponent.stateChanged</code> will be processed next time component redraws.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function invalidateState():void;
		
		/**
		 * Forces validation of an <code>IGUIComponent</code> instance immediately.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function validate():void;
		
		/**
		 * Invalidates whole component.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function invalidate():void;
		
		/**
		 * Returns string representation of an instance of <code>IGUIComponent</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function toString():String;
	}
}