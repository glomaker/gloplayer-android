package
{
	import com.greensock.TweenLite;
	
	import eu.kiichigo.utils.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.GloContext;
	import net.dndigital.glo.mvcs.views.components.MenuButton;
	
	import org.robotlegs.mvcs.Context;
	
	public class Main extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
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
			
			stage.frameRate = 31;
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// RobotLegs bootstrap
			gloContext = new GloContext(this);
			
			// Multitouch Gestures
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			log("Welcome to GloPlayer, Multitouch(supports:{0} gestures:{1})", Multitouch.supportsGestureEvents, Multitouch.supportedGestures);
		}
	}
}