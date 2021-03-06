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
	
	import eu.kiichigo.utils.getClassName;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.dndigital.utils.Fun;
	
	/**
	 * Represents basic visual Component instances. Instances of IGUIComponent classes can be added to <code>IContainer</code>.
	 * 
	 * @see		net.dndigital.glo.components.IContainer
	 * @see		net.dndigital.glo.components.IGUIComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GUIComponent extends Sprite implements IGUIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Protected Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Flag determines whether display is being invalidated.
		 */
		protected var resizing:Boolean = false;
		
		/**
		 * @private
		 * Flag determines whether data is being invalidated.
		 */
		protected var commiting:Boolean = false;
		
		/**
		 * @private
		 * Flag determines whether state is being invalidated.
		 */
		protected var changingState:Boolean = false;
		
		
		/**
		 * @private
		 * Used to store queue of events to be dispatched on next frame or render.
		 */
		protected const delayed:Vector.<Fun> = new Vector.<Fun>;
		
		/**
		 * @private
		 * There is a bug (139381) where we occasionally get callLaterDispatcher()
    	 *  even though we didn't expect it. (adobe).
		 */
		protected var delayInProgress:Boolean = false;
		
		/**
		 * @private
		 * Indicates whether an instance of <code>IGUIComponent</code> was initialized or not.
		 */
		protected var initialized:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function GUIComponent()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		//--------------------------------------------------------------------------
		//
		//  IComponent Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _defaultState:String = "normal";
		/**
		 * @copy	net.dndigital.core.IGUIComponent#defaultState
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get defaultState():String { return _defaultState; }
		
		/**
		 * @private
		 */
		protected var _state:String;
		/**
		 * @copy	net.dndigital.core.IGUIComponent#state
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get state():String
		{
			if (_state == null)
				_state = _defaultState;
			return _state;
		}
		/**
		 * @private
		 */
		public function set state(value:String):void
		{
			if (_state == value)
				return;
			_state = value;
			invalidateState();
		}
		
		/**
		 * @copy	net.dndigital.core.IComponent#owner
		 * 
		 * @see		net.dndigital.core.IContainer
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get owner():IContainer { return parent as IContainer; }
		
		//--------------------------------------------------------------------------
		//
		//  IComponent Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#initialize
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function initialize():IGUIComponent
		{
			if(initialized)
				return this;
			
			createChildren();
			invalidate();
			
			initialized = true;
			
			return this;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#delay
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function delay(fun:Function, args:Array = null):void
		{
			var add:Boolean = true;
			for (var i:int = 0; i < delayed.length; i ++)
				if (delayed[i].fun == fun && args == null)
					add = false;
			
			// Storing funciton with arguments.
			if (add)
				delayed.push(new Fun(fun, args));
			
			// Add handlers for next frame.
			if(root) {
				if(!delayInProgress) {
					root.addEventListener(Event.RENDER, invokeDelayed);
					root.addEventListener(Event.ENTER_FRAME, invokeDelayed);
					delayInProgress = true;
				}
				
				// Force the stage to update.
				if(root.stage)
					root.stage.invalidate();
			}
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#invalidateDisplay
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function invalidateDisplay():void
		{
			if(resizing)
				return;
			
			// Invalidate parent's
			if (owner)
				owner.invalidateDisplay()
			
			delay(validateDisplay);
			resizing = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#invalidateData
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function invalidateData():void
		{
			if(commiting)
				return;
			
			delay(validateData);
			commiting = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#invalidateState
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function invalidateState():void
		{
			if(changingState)
				return;
			
			delay(validateState);
			changingState = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#validate
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function validate():void
		{
			// Set to invalidate.
			invalidate();
			
			// And immediately validate
			validateData();
			validateDisplay();
			validateState();
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#invalidate
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function invalidate():void
		{
			// Set to invalidate.
			invalidateData();
			invalidateDisplay();
			invalidateState();
		}

				
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _width:Number = 0;
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#width
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		override public function get width():Number
		{
			return _width;
		}
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(_width == value)
				return;
			_width = value;
			invalidateDisplay();
		}
		
		
		/**
		 * @private
		 */
		protected var _height:Number = 0;
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#height
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		override public function get height():Number
		{
			return _height;
		}
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(_height == value)
				return;
			_height = value;
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _name:String = null;
		/**
		 * @copy		net.dndigital.glo.components.IGUIComponent#name
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		override public function get name():String
		{
			if (_name == null)
				_name = getClassName(this);
			return _name;
		}
		/**
		 * @private
		 */
		override public function set name(value:String):void
		{
			if (_name == value)
				return;
			_name = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  toString
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		/**
		 * Returns a string containing some of instance's properties.
		 * 
		 * @return	Class name and some of instance properties and values.
		 */
		override public function toString():String
		{
			if(owner)
				var str:String = owner.toString() + "." + name;
			else
				str = name;
			return str;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Validates display, and invokes <code>IGUIComponent.resized</code>. This method should not be called manually.
		 */
		protected function validateDisplay():void
		{
			if(!resizing)
				return;
			resizing = false;
			resized(_width, _height);	
		}
		
		/**
		 * Validates data and properties, and invokes <code>IGUIComponent.commited</code> method. This method should not be called manually.
		 */
		protected function validateData():void
		{
			if(!commiting)
				return;
			
			commiting = false;
			commited();
		}
		
		/**
		 * Validates state, and invokes <code>IGUIComponent.stateChanged</code> method. This method should not be called manually.
		 */
		protected function validateState():void
		{
			if(!changingState)
				return;

			changingState = false;
			stateChanged(state);
		}
		
		/**
		 * Method called when components is resized via width or height property or custom progammer defined way. Override this method to extend or change functionality. This method shouldn't be called manually, use invalidateDisplay to schedule instead.
		 * 
		 * @param	width	New components width.
		 * @param	height	New components height.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function resized(width:Number, height:Number):void {}
		
		/**
		 * Method called when components properties updated. Override this method to extend or change functionality. This method shouldn't be called manually, use invalidateData to schedule instead.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function commited():void {}
		
		/**
		 * Method called when components state is updated. Override this method to extend or change functionality. This method shouldn't be called manually, use invalidateState to schedule instead.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function stateChanged(newState:String):void {}
		
		/**
		 * @private
		 * Method invokes and flushed any method stored via <code>IGUIComponent</code> delay.
		 */
		protected function invokeDelayed(event:Event):void
		{
			if(root && delayInProgress) {
				root.removeEventListener(Event.RENDER, invokeDelayed);
				root.removeEventListener(Event.ENTER_FRAME, invokeDelayed);
				delayInProgress = false;
			}
			
			while(delayed.length)
				invoke(delayed.pop());
		}
	
		/**
		 * @private
		 * Invokes Fun.
		 */
		protected function invoke(fun:Fun):void
		{
			fun.fun.apply(null, fun.args);
			fun.fun = null, fun.args = null;
		}
		
		/**
		 * Override this method to create and add children to the display list.
		 */
		protected function createChildren():void {}
		
		/**
		 * @private
		 * Handles added to stage. This handler should be invoked only if parent is not IContainer.
		 */
		protected function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			if (parent is Container || this is Application)
				return;
			
			initialize();
		}
	}
}