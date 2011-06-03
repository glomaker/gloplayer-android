package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Sprite;
	
	import net.dndigital.core.Component;
	import net.dndigital.glo.mvcs.models.vo.Project;
	
	/**
	 * 
	 *
	 * @see		net.dndigital.glo.mvcs.models.vo.Project
	 * @see 	net.dndigital.core.Component
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloPlayer extends Component implements IGloView
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloPlayer);
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _project:Project;
		/**
		 * Reference to Pro
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get project():Project { return _project; }
		/**
		 * @private
		 */
		public function set project(value:Project):void
		{
			if (_project == value)
				return;
			_project = value;
			log("project({0})", value);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.clear();
			graphics.beginFill(0xFF6600, 0.5);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}