package net.dndigital.core
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.dndigital.utils.Fun;
	
	/**
	 * Represents basic visual Component instances. Instances of Component classes can be added to <code>IContainer</code>.
	 * 
	 * @see		net.dndigital.glo.components.IContainer
	 * @see		net.dndigital.glo.components.IComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class UIComponent extends Sprite implements IUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(UIComponent);
		
		//--------------------------------------------------------------------------
		//
		//  Protected Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Flag determines whether display is being invalidated;
		 */
		protected var resizing:Boolean = false;
		
		/**
		 * @private
		 * Flag determines whether data is being invalidated;
		 */
		protected var commiting:Boolean = false;
		
		
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
		 * Indicates whether an instance of <code>Component</code> was initialized or not.
		 */
		protected var initialized:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  IComponent Properties
		//
		//--------------------------------------------------------------------------
		
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
		 * @copy		net.dndigital.glo.components.IComponent#initialize
		 */
		public function initialize():IUIComponent
		{
			if(initialized)
				return this;
			
			createChildren();
			invalidate();
			
			initialized = true;
			
			if(!(parent is IContainer) && !(this is Application))
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			return this;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#delay
		 */
		public function delay(fun:Function, args:Array = null):void
		{
			// Storing funciton with arguments.
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
		 * @copy		net.dndigital.glo.components.IComponent#invalidateDisplay
		 */
		public function invalidateDisplay():void
		{
			if(resizing)
				return;
			
			delay(validateDisplay);
			resizing = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#displayUpdated
		 */
		public function invalidateData():void
		{
			if(commiting)
				return;
			
			delay(validateData);
			commiting = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#validate
		 */
		public function validate():void
		{
			// Set to invalidate.
			invalidate();
			
			// And immediately validate
			validateData();
			validateDisplay();
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#invalidate
		 */
		public function invalidate():void
		{
			// Set to invalidate.
			invalidateData();
			invalidateDisplay();
		}

				
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _width:Number;
		/**
		 * @inheritDoc
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
		protected var _height:Number;
		/**
		 * @inheritDoc
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
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Validates display, and invokes displayUpdated method. This method should not be called manually.
		 */
		protected function validateDisplay():void
		{
			resizing = false;
			resized(_width, _height);
			
		}
		
		/**
		 * @private
		 * Validates data and properties, and invokes dataUpdated method. This method should not be called manually.
		 */
		protected function validateData():void
		{
			commiting = false;
			commited();
		}
		
		/**
		 * Method called when components is resized via width or height property or custom progammer defined way. Override this method to extend or change functionality.  This method shouldn't be called manually, use invalidateDisplay to schedule instead.
		 * 
		 * @param	width	New components width.
		 * @param	height	New components height.
		 */
		protected function resized(width:Number, height:Number):void {}
		
		/**
		 * Method called when components properties updated. Override this method to extend or change functionality.  This method shouldn't be called manually, use invalidateData to schedule instead.
		 */
		protected function commited():void {}
		
		/**
		 * @private
		 * Method invokes and flushed any method stored via <code>IComponent</code> delay.
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
			if(owner== null && !(this is Application)) {
				log("{0} is invalidating", this);
				validate();
			}
		}
	}
}