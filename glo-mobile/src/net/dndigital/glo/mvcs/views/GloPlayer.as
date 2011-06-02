package net.dndigital.glo.mvcs.views
{
	import flash.display.Sprite;
	
	import net.dndigital.core.Component;
	
	public class GloPlayer extends Component implements IGloView
	{
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.clear();
			graphics.beginFill(0xFF6600, 0.5);
			graphics.drawRect(0, 0, 50, 50);
			graphics.endFill();
		}
	}
}