package org.glomaker.mobileplayer.mvcs.events
{
	import flash.events.Event;

	public class NetStreamEvent extends Event
	{
		public static const META_DATA:String = "metaData";

		public function NetStreamEvent(type:String, width:int = 0, height:int = 0, duration:Number = 0)
		{
			super(type,false,false);

			_width = width;
			_height = height;
			_duration = duration;
		}

		/**
		 * @private
		 */
		protected var _width:int;
		/**
		 * Width of the Video.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get width():int
		{
			return _width;
		}

		/**
		 * @private
		 */
		protected var _height:int;
		/**
		 * Height of the Video.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get height():int
		{
			return _height;
		}

		/**
		 * @private
		 */
		protected var _duration:Number;
		/**
		 * Duration of the Video.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new NetStreamEvent(type, _width, _height, _duration);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("NetStreamEvent", "width", "height", "duration");
		}
	}
}