package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import net.dndigital.components.IGUIComponent;
	
	import org.bytearray.display.ScaleBitmap;

	/**
	 * Image component is capable of displaying non-animated bitmap images.
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.IGloComponent
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.GloComponent
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public final class Image extends GloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(Image);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Indicates Bitmap's original size which is used to calculate ratio and scaled size.
		 */
		protected const original:Point = new Point;
		/**
		 * @private
		 */
		protected const bitmap:ScaleBitmap = new ScaleBitmap;
		
		/**
		 * @private
		 * Flag indicates whether bitmap should be redrawn.
		 */
		protected var redraw:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _source:String;
		/**
		 * Property indicates path to a file.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get source():String { return _source; }
		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			if (_source == value || value.indexOf("FilePathProperty::NoUrlSet") >= 0)
				return;
			_source = value;
			
			load(value);
		}
		
		/**
		 * @private
		 */
		protected var _maintainRatio:Boolean;
		/**
		 * Property indicates whether aspect ratio should be maintained on resize.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get maintainRatio():Boolean { return _maintainRatio; }
		/**
		 * @private
		 */
		public function set maintainRatio(value:Boolean):void
		{
			if (_maintainRatio == value)
				return;
			_maintainRatio = value;
			redraw = true;
			invalidateDisplay();
		}
		
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
			mapProperty("source");
			mapProperty("maintainRatio");
			
			return super.initialize();
		}
		
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
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			if (bitmap && bitmap.bitmapData) {
				if (original.x != width || original.y != height) {
					if (maintainRatio) {
						// Calculate a cooficient.
						var c:Number = Math.min(width / original.x, height / original.y);
						// Apply size
						bitmap.setSize(original.x * c, original.y * c);
					} else {
						bitmap.setSize(width, height);
					}
				}
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			
			if (bitmap && bitmap.bitmapData)
				bitmap.bitmapData.dispose();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Handles image loading.
		 */
		protected function load(source:String):void
		{
			const fileStream:FileStream = new FileStream();
			try {
				fileStream.open(component.directory.resolvePath(source), FileMode.READ);
			} catch (e:Error) {
				//log("loadImage({0}) error={1} \n{2}", path, e.message, e.getStackTrace());
				return;
			}
			
			fileStream.position = 0;
			
			const bytes:ByteArray = new ByteArray;
			fileStream.readBytes(bytes, 0, fileStream.bytesAvailable);
			
			const loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);	
			loader.loadBytes(bytes);
		}
		
		/**
		 * @private
		 * Handles loader event complete, when image is loaded.
		 */
		protected function imageLoaded(event:Event):void
		{
			// Assign bitmap.
			bitmap.bitmapData = event.target.content.bitmapData;
			// Store original dimensions.
			original.x = bitmap.bitmapData.width;
			original.y = bitmap.bitmapData.height;
			// Invalidate
			redraw = true;
			invalidateDisplay();
		}
	}
}