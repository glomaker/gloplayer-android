package net.dndigital.glo.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
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
	public class Component extends Sprite
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
		protected static var log:Function = eu.kiichigo.utils.log(Component);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function Component()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		//--------------------------------------------------------------------------
		//
		//  Protected Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Flag determines whether display is being invalidated;
		 */
		protected var idisplay:Boolean = false;
		
		/**
		 * @private
		 * Flag determines whether data is being invalidated;
		 */
		protected var idata:Boolean = false;
		
		
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
		
		//--------------------------------------------------------------------------
		//
		//  IComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#initialize
		 */
		public function initialize():void
		{
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#delay
		 */
		public function delay(fun:Function, args:Array = null):void
		{
			delayed.push(new Fun(fun, args));
			if(root) {
				if(!delayInProgress) {
					root.addEventListener(Event.RENDER, invokeDelayed);
					root.addEventListener(Event.ENTER_FRAME, invokeDelayed);
					delayInProgress = true;
				}
				
				if(root.stage)
					root.stage.invalidate();
			}
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#invalidateDisplay
		 */
		public function invalidateDisplay():void
		{
			if(idisplay)
				return;
			
			delay(validateDisplay);
			idisplay = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#displayUpdated
		 */
		public function invalidateData():void
		{
			if(idata)
				return;
			
			delay(validateData);
			idata = true;
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#displayUpdated
		 */
		public function displayUpdated(width:Number, height:Number):void
		{
			log("displayUpdated({0}, {1})", width, height);
		}
		
		/**
		 * @copy		net.dndigital.glo.components.IComponent#dataUpdated
		 */
		public function dataUpdated():void
		{
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
			idisplay = true;
			displayUpdated(_width, _height);
			
		}
		
		/**
		 * @private
		 * Validates data and properties, and invokes dataUpdated method. This method should not be called manually.
		 */
		protected function validateData():void
		{
			idata = true;
			dataUpdated();
		}
		
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
		 * @private
		 * Dispatched when component is added to stage.
		 */
		protected function added(event:Event):void
		{
			invalidateData();
			invalidateDisplay();
			initialize();
		}
	}
}

