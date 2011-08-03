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
	import org.glomaker.mobileplayer.mvcs.GloContext;
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.views.components.MenuButton;
	
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
		protected static const log:Function = eu.kiichigo.utils.log(Main);
		
		
		/**
		 * @private
		 */
		protected var gloContext:GloContext;
		
		public function Main()
		{
			super();
			
			stage.frameRate = 24;
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// RobotLegs bootstrap
			gloContext = new GloContext(this);

			// mobile lifecycle events
			addEventListener( Event.ACTIVATE, handleActivate );
			addEventListener( Event.DEACTIVATE, handleDeactivate );
			
			// Multitouch Gestures
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
		}

		/**
		 * Event handler - mobile app activated. 
		 * @param e
		 */		
		protected function handleActivate( e:Event ):void
		{
			stage.frameRate = 24;
			gloContext.dispatchEvent( ApplicationEvent.ACTIVATE_EVENT );
		}
		
		/**
		 * Event handler - mobile app deactivated. 
		 * @param e
		 */		
		protected function handleDeactivate( e:Event ):void
		{
			stage.frameRate = 0.1;
			gloContext.dispatchEvent( ApplicationEvent.DEACTIVATE_EVENT );
		}
	}
}