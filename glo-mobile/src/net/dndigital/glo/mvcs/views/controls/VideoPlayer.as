package net.dndigital.glo.mvcs.views.controls
{
	import net.dndigital.core.IUIComponent;

	public final class VideoPlayer extends Placeholder
	{
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IUIComponent
		{
			color = 0x0000FF;
			
			return super.initialize();
		}
	}
}