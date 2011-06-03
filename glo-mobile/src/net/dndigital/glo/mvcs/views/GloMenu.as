package net.dndigital.glo.mvcs.views
{
	import flash.events.MouseEvent;
	
	import net.dndigital.core.UIComponent;
	import net.dndigital.core.Container;
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.test.StartButton;
	
	public class GloMenu extends Container implements IGloView
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
		protected static var log:Function = eu.kiichigo.utils.log(GloMenu);
		
		
		protected var startButton:StartButton;
		
		/**
		 * @ineritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			startButton = new StartButton;
			startButton.width = 120;
			startButton.height = 22;
			startButton.addEventListener(MouseEvent.CLICK, handleMenu);
			add(startButton);
		}
		
		/**
		 * @iheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			startButton.x = (width - startButton.width) / 2;
			//startButton.y = (height - startButton.height) / 2 + 10;
		}
		
		/**
		 * @private
		 * Handles menu buttons clicks.
		 */
		protected function handleMenu(event:MouseEvent):void
		{
			// Right now it just handles single button.
			
			dispatchEvent(GloMenuEvent.SELECT_FILE_EVENT);
		}
	}
}