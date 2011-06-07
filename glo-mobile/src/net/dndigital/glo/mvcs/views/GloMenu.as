package net.dndigital.glo.mvcs.views
{
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.UIComponent;
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
		protected var loadDirectButton:StartButton;
		
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
			
			loadDirectButton = new StartButton();
			loadDirectButton.width = 120;
			loadDirectButton.height = 22;
			loadDirectButton.y = startButton.y + startButton.height + 20;
			loadDirectButton.addEventListener(MouseEvent.CLICK, handleMenu);
			add( loadDirectButton );
		}
		
		/**
		 * @iheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			startButton.x = (width - startButton.width) / 2;
			loadDirectButton.x = (width - loadDirectButton.width) / 2;
			//startButton.y = (height - startButton.height) / 2 + 10;
		}
		
		/**
		 * @private
		 * Handles menu buttons clicks.
		 */
		protected function handleMenu(event:MouseEvent):void
		{
			// Right now it just handles single button.
			switch( event.target )
			{
				case startButton:
					dispatchEvent(GloMenuEvent.SELECT_FILE_EVENT);
					break;
				
				case loadDirectButton:
					dispatchEvent(GloMenuEvent.LOAD_GLO_1_EVENT);
					break;
			}
		}
	}
}