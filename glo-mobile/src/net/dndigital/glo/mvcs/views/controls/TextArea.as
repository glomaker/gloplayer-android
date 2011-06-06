package net.dndigital.glo.mvcs.views.controls
{
	import net.dndigital.components.IUIComponent;

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