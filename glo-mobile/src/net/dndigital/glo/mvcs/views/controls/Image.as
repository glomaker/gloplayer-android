package net.dndigital.glo.mvcs.views.controls
{
	import net.dndigital.components.IGUIComponent;

	public final class Image extends Placeholder
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
			color = 0x00FF00;
			
			return super.initialize();
		}
	}
}