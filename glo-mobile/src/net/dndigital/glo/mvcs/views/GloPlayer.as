package net.dndigital.glo.mvcs.views
{
	import flash.display.Sprite;
	
	public class GloPlayer extends Sprite
	{
		public function GloPlayer()
		{
			super();
			
			graphics.beginFill(0xFF6600);
			graphics.drawRect(0, 0, 50, 50);
			graphics.endFill();
		}
	}
}