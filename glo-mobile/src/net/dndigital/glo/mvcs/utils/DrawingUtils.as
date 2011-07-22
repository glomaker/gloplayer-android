package net.dndigital.glo.mvcs.utils
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;

	/**
	 * Utility functions for drawing things. 
	 * @author nilsmillahn
	 */	
	public class DrawingUtils
	{
		/**
		 * Matrix for gradient fills.
		 * Single instance reused - better for mobile devices. 
		 */		
		protected static const GRADIENT_MATRIX:Matrix = new Matrix;
		

		/**
		 * Draw a standard gradient fill, vertical, lighter to darker.
		 * Colours will be taken from the ColourPalette class. 
		 * @param g
		 * @param w
		 * @param h
		 */		
		public static function drawStandardGradient( g:Graphics, w:Number, h:Number, x:Number = 0, y:Number = 0, clearFirst:Boolean = true ):void
		{
			if( clearFirst )
			{
				g.clear();
			}
			
			var m:Matrix = GRADIENT_MATRIX;
			m.createGradientBox(w, h, Math.PI/2);
			
			g.beginGradientFill( GradientType.LINEAR, [ ColourPalette.GRADIENT_START, ColourPalette.GRADIENT_END ], [1, 1], [0, 255], m );
			g.drawRect(x, y, w, h);
			g.endFill();
		}
	}
}