package net.dndigital.glo.mvcs.views.controls
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.describeType;
	
	import net.dndigital.components.Button;
	
	public final class NavButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(NavButton);
		
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
		protected const bitmap:Bitmap = new Bitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Up Skin for <code>NavButton</code>
		 */
		public var upSkin:BitmapData;
		
		/**
		 * Down Skin for <code>NavButton</code>
		 */
		public var downSkin:BitmapData;
		
		/**
		 * Disabled Skin for <code>NavButton</code>
		 */
		public var disabledSkin:BitmapData;
		
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
			
			addChild(bitmap);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(state:String):void
		{
			super.stateChanged(state);
			
			bitmap.bitmapData = this[state + "Skin"];
			
			width = bitmap.width;
			height = bitmap.height;
			
			invalidateDisplay();
		}
	}
}