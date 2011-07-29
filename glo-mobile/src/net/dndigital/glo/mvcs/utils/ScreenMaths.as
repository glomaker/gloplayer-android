package net.dndigital.glo.mvcs.utils
{
	import flash.system.Capabilities;

	/**
	 * Provides helper functions to calculate sizes based on screen resolution/dpi. 
	 */	
	public class ScreenMaths
	{
		
		/**
		 * Convert inches to pixels.
		 * @param inches
		 * @return 
		 */		
		public static function inchesToPixels(inches:Number):uint
		{
			return Math.round(Capabilities.screenDPI * inches);
		}
		
		/**
		 * Convert millimeters to pixels 
		 * @param cm
		 * @return 
		 */		
		public static function mmToPixels(mm:int):uint
		{
			return Math.round(Capabilities.screenDPI * (mm / 25.4));
		}
	}
}