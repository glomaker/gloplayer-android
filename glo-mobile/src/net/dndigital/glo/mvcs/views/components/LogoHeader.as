package net.dndigital.glo.mvcs.views.components
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import net.dndigital.components.GUIComponent;
	
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
			swoosh.y = ( height - swoosh.height ) / 2;
			
			// horizontal positioning
			logo.x = 10;
			swoosh.x = width - swoosh.width + 10;
			
			// gradient background
			graphics.clear();
	
			var m:Matrix = new Matrix();
			m.createGradientBox(width, height, Math.PI/2);
			
			graphics.beginGradientFill( GradientType.LINEAR, [ 0x424449, 0x0b0c0d ], [1, 1], [0, 255], m );
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
	}
}