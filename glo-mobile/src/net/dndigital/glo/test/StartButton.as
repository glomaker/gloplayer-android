package net.dndigital.glo.test
{
	import net.dndigital.core.Component;
	
	public final class StartButton extends Component
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(StartButton);
		
		
		override protected function resized(width:Number, height:Number):void
		{
			//log("resized()");
			super.resized(width, height);
			
			graphics.clear();
			graphics.beginFill(0xFF6600);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}