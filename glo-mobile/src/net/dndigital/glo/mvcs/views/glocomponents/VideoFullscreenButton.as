package net.dndigital.glo.mvcs.views.glocomponents
{
	import flash.display.Graphics;
	
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
	import net.dndigital.glo.mvcs.views.components.AnimatedButton;

	/**
	 * Fullscreen button for the video component. 
	 * @author nilsmillahn
	 */	
	public class VideoFullscreenButton extends AnimatedButton
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
			
			// icon - inner box, fifth of button width
			var w2:Number = width/2;
			var w6:Number = width/6;
			var h2:Number = height/2;
			var h6:Number = height/6;
			
			g.beginFill( 0xffffff, 0.8 );
			g.moveTo( w2 - w6, h2 - h6 );
			g.lineTo( w2 + w6, h2 - h6 );
			g.lineTo( w2 + w6, h2 + h6 );
			g.lineTo( w2 - w6, h2 + h6 );
			g.lineTo( w2 - w6, h2 - h6 );
			g.endFill();
			
			// icon - outer box outline
			g.lineStyle( 1, 0xffffff, 1, true );
			g.drawRect( w2 - width/4, h2 - height/4, width/2, height/2 );
		}
		
		
		
	}
}