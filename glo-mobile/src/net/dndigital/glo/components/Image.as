package net.dndigital.glo.components
{
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
		override public function initialize():void
		{
			super.initialize();
			
			color = 0x00FF00;
		}
	}
}