package net.dndigital.glo.mvcs.views.glocomponents
{
	import flash.media.Video;
	
	import net.dndigital.components.IGUIComponent;
	
	import org.bytearray.display.ScaleBitmap;

	public final class VideoPlayer extends Placeholder
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const video:Video = new Video
		
		/**
		 * @private
		 */
		protected const snapshot:ScaleBitmap = new ScaleBitmap;
		
		//--------------------------------------------------------------------------
		//
		//  
		//
		//--------------------------------------------------------------------------
		
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
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
		}
	}
}