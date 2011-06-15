package net.dndigital.glo.mvcs.views.components
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.utils.describeType;
	
	import net.dndigital.components.Button;
	
	import org.bytearray.display.ScaleBitmap;
	
	public class IconButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(IconButton);
		
		//--------------------------------------------------------------------------
		//
		//  State Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public static const UP:String = "up";
		
		/**
		 * @private
		 */
		public static const DOWN:String = "down";
		
		/**
		 * @private
		 */
		public static const DISABLED:String = "disabled";
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * An instance of Bitmap that will hold current graphical asset.
		 */
		protected const bitmap:ScaleBitmap = new ScaleBitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Up Skin for <code>NavButton</code>
		 */
		public var upSkin:Object = null;
		
		/**
		 * Down Skin for <code>NavButton</code>
		 */
		public var downSkin:Object = null;
		
		/**
		 * Disabled Skin for <code>NavButton</code>
		 */
		public var disabledSkin:Object = null;
		
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
			
			bitmap.smoothing = true;
			addChild(bitmap);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(state:String):void
		{
			super.stateChanged(state);
			
			if (this[state + "Skin"] != null)
				bitmap.bitmapData = snapshot(this[state + "Skin"]);
			
			invalidateDisplay();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			bitmap.setSize(width, height);
			// FIXME make it proper within component framework.
			if(owner)
			   owner.invalidateDisplay();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Takes snapshot of DisplayObject if needed.
		 */
		protected function snapshot(source:IBitmapDrawable):BitmapData
		{
			if (source is BitmapData)
				return source as BitmapData;
			else if ((source as Object).hasOwnProperty("bitmapData"))
				return (source as Object).bitmapData as BitmapData
			else {
				const bitmapData:BitmapData = new BitmapData((source as Object).width, (source as Object).height);
					  bitmapData.draw(source);
				return bitmapData;
			}
		}
	}
}