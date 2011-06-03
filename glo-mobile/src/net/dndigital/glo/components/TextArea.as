package net.dndigital.glo.components
{
	import net.dndigital.core.IUIComponent;

	public final class TextArea extends Placeholder
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
			color = 0xFF0000;
			
			return super.initialize();
		}
	}
}