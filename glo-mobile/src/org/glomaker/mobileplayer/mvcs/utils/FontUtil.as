package org.glomaker.mobileplayer.mvcs.utils
{
	import flash.text.Font;
	
	import org.glomaker.mobileplayer.assets.RobotoBold;
	import org.glomaker.mobileplayer.assets.RobotoRegular;

	public class FontUtil
	{
		public static const FONT_REGULAR:String = "Roboto Regular";
		public static const FONT_BOLD:String = "Roboto Bold";
		
		public static function init():void
		{
			Font.registerFont(RobotoRegular);
			Font.registerFont(RobotoBold);
		}
	}
}