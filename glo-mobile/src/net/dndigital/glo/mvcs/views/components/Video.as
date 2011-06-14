package net.dndigital.glo.mvcs.views.components
{
	import flash.display.Bitmap;
	import flash.media.Video;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	
	import org.bytearray.display.ScaleBitmap;
	
	public final class Video extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const video:flash.media.Video = new flash.media.Video;
		
		/**
		 * @private
		 */
		protected const snapshot:ScaleBitmap = new ScaleBitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
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