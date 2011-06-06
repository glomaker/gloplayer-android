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
		//  Assets
		//
		//--------------------------------------------------------------------------
		
		[Embed(source="assets/arrow.up.png")]
		/**
		 * @private
		 * Asset for Up (normal) button state.
		 */
		protected static const UP_ASSET:Class;
		
		[Embed(source="assets/arrow.down.png")]
		/**
		 * @private
		 * Asset for Down button state.
		 */
		protected static const DOWN_ASSET:Class;
		
		[Embed(source="assets/arrow.disabled.png")]
		/**
		 * @private
		 * Asset for diabled button state.
		 */
		protected static const DISABLED_ASSET:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const up:BitmapData = new UP_ASSET().bitmapData;
		
		/**
		 * @private
		 */
		protected const down:BitmapData = new DOWN_ASSET().bitmapData;
		
		/**
		 * @private
		 */
		protected const disabled:BitmapData = new DISABLED_ASSET().bitmapData;
		
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
		 * @private
		 */
		protected var _enabled:Boolean = true;
		/**
		 * enabled.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get enabled():Boolean { return _enabled; }
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			_enabled = value;
			invalidateData();
		}
		
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
			
			bitmap.bitmapData = this[state];
			
			width = bitmap.width;
			height = bitmap.height;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if(_state == DISABLED && _enabled == true)
				state = UP;
			else if(_state != DISABLED && _enabled == false)
				state = DISABLED;
		}
	}
}