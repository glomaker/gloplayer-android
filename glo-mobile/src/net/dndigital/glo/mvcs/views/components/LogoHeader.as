package net.dndigital.glo.mvcs.views.components
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
	import net.dndigital.glo.mvcs.utils.DrawingUtils;
	
	/**
	 * View component to display the GLOMaker logo. 
	 * @author nilsmillahn
	 */	
	public class LogoHeader extends GUIComponent
	{
		
		[Embed(source="../assets/glomaker-logo.png")]
		protected static const LogoAsset:Class;
		
		[Embed(source="../assets/glomaker-swoosh.png")]
		protected static const SwooshAsset:Class;

		protected var logo:Bitmap;
		protected var swoosh:Bitmap;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if( !swoosh )
			{
				swoosh = new SwooshAsset();
				addChild( swoosh );
			}

			if( !logo )
			{
				logo = new LogoAsset();
				addChild( logo );
			}
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// vertical positioning
			logo.y = ( height - logo.height ) / 2;
			swoosh.y = height - swoosh.height;
			
			// horizontal positioning
			logo.x = 10;
			swoosh.x = width - swoosh.width + 10;
			
			// gradient background
			DrawingUtils.drawStandardGradient( graphics, width, height );
			
			// white line for bottom border
			graphics.lineStyle( 1, 0xffffff, 1, true );
			graphics.moveTo( 0, height );
			graphics.lineTo(width, height);
			
		}
		
	}
}