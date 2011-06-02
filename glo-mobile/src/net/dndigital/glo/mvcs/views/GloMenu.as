package net.dndigital.glo.mvcs.views
{
	import net.dndigital.core.Component;
	import net.dndigital.core.Container;
	import net.dndigital.glo.test.StartButton;
	
	public class GloMenu extends Container implements IGloView
	{
		protected var startButton:StartButton;
		
		/**
		 * @ineritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			startButton = new StartButton
			startButton.width = 120;
			startButton.height = 22;
			add(startButton);
		}
	}
}