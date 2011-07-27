package net.dndigital.glo.mvcs.views.glocomponents
{
	import flash.display.Graphics;
	
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
	import net.dndigital.glo.mvcs.views.components.AnimatedButton;

	/**
	 * Play button for the video component. 
	 * @author nilsmillahn
	 */	
	public class VideoPlayButton extends AnimatedButton
	{
		
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// prepare drawing
			var g:Graphics = graphics;
			g.clear();
			
			// background
			g.beginFill( ColourPalette.SLATE_BLUE, 0.5 );
			g.drawRoundRectComplex(0, 0, width, height, 20, 20, 20, 20);
			g.endFill();
			
			// triangle, half-size of button
			g.beginFill( 0xffffff, 0.8 );
			g.moveTo( width/2 + width/5, height/2 );
			g.lineTo( width/2 - width/5, height/2 + height/4 );
			g.lineTo( width/2 - width/5, height/2 - height/4 );
			g.lineTo( width/2 + width/5, height/2 );
			g.endFill();
		}
		
		
		
	}
}