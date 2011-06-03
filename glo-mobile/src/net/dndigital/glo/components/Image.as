package net.dndigital.glo.components
{
	import net.dndigital.core.IUIComponent;

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
		override public function initialize():IUIComponent
		{	
			color = 0x00FF00;
			
			return super.initialize();
		}
	}
}