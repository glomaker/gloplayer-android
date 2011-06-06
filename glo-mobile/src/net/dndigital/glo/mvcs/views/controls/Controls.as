package net.dndigital.glo.mvcs.views.controls
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.core.UIComponent;
	
	public class Controls extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Assets
		//
		//--------------------------------------------------------------------------
		
		[Embed(source="assets/arrow.up.png")]
		/**
		 * @private
		 * Asset for Up (normal) button state.
		 */
		protected static const UP:Class;
		
		[Embed(source="assets/arrow.down.png")]
		/**
		 * @private
		 * Asset for Down button state.
		 */
		protected static const DOWN:Class;
		
		[Embed(source="assets/arrow.disabled.png")]
		/**
		 * @private
		 * Asset for diabled button state.
		 */
		protected static const DISABLED:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(Controls);
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
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
			
			graphics.clear();
			graphics.beginFill(0x494949);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}