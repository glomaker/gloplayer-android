package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import net.dndigital.glo.mvcs.GloContext;
	
	import org.robotlegs.mvcs.Context;
	
	public class Main extends Sprite
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
		protected static var log:Function = eu.kiichigo.utils.log(Main);
		
		
		/**
		 * @private
		 */
		protected var gloContext:GloContext;
		
		public function Main()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// RobotLegs bootstrap
			gloContext = new GloContext(this);
		}
	}
}