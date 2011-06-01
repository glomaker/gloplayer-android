package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.models.vo.Node;

	public class NodeEvent extends Event
	{
		public static const NEXT:String = "next";
		public static const PREVIOUS:String = "previous";
		public static const SELECT:String = "select";

		
		public function NodeEvent(type:String, index:int = -1, slide:Node = null)
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
		protected var _slide:Node;
		
		public function get slide():Node
		{
			return _slide;
		}

		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new NodeEvent(type, _index, _slide);
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