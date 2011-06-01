package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.models.vo.Slide;

	public class SlideEvent extends Event
	{
		public static const NEXT:String = "next";
		public static const PREVIOUS:String = "previous";
		public static const SELECT:String = "select";

		
		public function SlideEvent(type:String, index:int = -1, slide:Slide = null)
		{
			super(type,false,false);

			_index = index;
			_slide = slide;
		}

		/**
		 * @private
		 */
		protected var _index:int;
		
		public function get index():int
		{
			return _index;
		}

		/**
		 * @private
		 */
		protected var _slide:Slide;
		
		public function get slide():Slide
		{
			return _slide;
		}

		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new SlideEvent(type, _index, _slide);
		}

		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("SlideEvent", "index", "slide");
		}
	}
}