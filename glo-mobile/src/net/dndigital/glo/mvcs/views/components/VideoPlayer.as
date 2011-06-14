package net.dndigital.glo.mvcs.views.components
{
	import net.dndigital.components.IGUIComponent;

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
		override public function initialize():IGUIComponent
		{
			color = 0x0000FF;
			
			return super.initialize();
		}
	}
}