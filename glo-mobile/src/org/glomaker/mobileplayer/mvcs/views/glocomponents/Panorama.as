/* 
* GLO Mobile Player: Copyright (c) 2011 LTRI, University of West London. An
* Open Source Release under the GPL v3 licence (see http://www.gnu.org/licenses/).
* Authors: DN Digital Ltd, Tom Boyle, Lyn Greaves, Carl Smith.

* This program is free software: you can redistribute it and/or modify it under the terms 
* of the GNU General Public License as published by the Free Software Foundation, 
* either version 3 of the License, or (at your option) any later version. This program
* is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* 
* For GNU Public licence see http://www.gnu.org/licenses/ or http://www.opensource.org/licenses/.
*
* External libraries used:
*
* Greensock Tweening Library (TweenLite), copyright Greensock Inc
* "NO CHARGE" NON-EXCLUSIVE SOFTWARE LICENSE AGREEMENT
* http://www.greensock.com/terms_of_use.html
*	
* A number of utility classes Copyright (c) 2008 David Sergey, published under the MIT license
*
* A number of utility classes Copyright (c) DN Digital Ltd, published under the MIT license
*
* The ScaleBitmap class, released open-source under the RPL license (http://www.opensource.org/licenses/rpl.php)
*/
package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import com.christiancantrell.extensions.Compass;
	import com.christiancantrell.extensions.CompassChangedEvent;
	import com.google.zxing.aztec.Point;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.components.Label;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;

	/**
	 * Viewer for the Panorama component.
	 * 
	 * @author haykel
	 * 
	 */
	public final class Panorama extends GloComponent
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var headingLabel:Label;
		protected var image1:Loader;
		protected var image2:Loader;
		
		protected var image1Size:Point;
		protected var image2Size:Point;
		protected var compass:Compass;
		protected var imageLoadQueue:Array;
		protected var lastIndex:int = -1;
		protected var lastHeading:Number;
		
		//--------------------------------------------------
		// images
		//--------------------------------------------------
		
		private var _images:Array;
		
		/**
		 * List of image files.
		 */
		public function get images():Array
		{
			return _images;
		}
		
		/**
		 * @private
		 */
		public function set images(value:Array):void
		{
			if (value == images)
				return;
			
			_images = value;
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Loads the image with the specified index.
		 */
		protected function loadImage( index:uint ):void
		{
			if (!images || index >= images.length)
				return;
			
			var url:String = component.directory.resolvePath(images[index]).url;
			
			// get next image loader from queue
			var next:Loader = imageLoadQueue.shift() as Loader;
			next.alpha = 0;
			next.visible = false;
			
			next.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageComplete );
			next.load( new URLRequest( url ));
			
			// top of display
			addChild( next );
			
			// back of queue
			imageLoadQueue.push( next );
		}
		
		/**
		 * Positions and scales the specified image to fit in the components area.
		 */
		protected function layoutImage(image:Loader):void
		{
			var size:Point = (image == image1 ? image1Size : image2Size);
			if (width == 0 || height == 0 || size == null)
				return;
			
			var w:Number = size.x;
			var h:Number = size.y;
			
			var a1:Number = w / h;
			var a2:Number = width / height;
			
			var scale:Number = 1;
			
			if (a1 <= a2)
			{
				scale = height / h;
				image.x = (width - (w * scale)) / 2;
				image.y = 0;
			}
			else
			{
				scale = width / w;
				image.x = 0;
				image.y = (height - (h * scale)) / 2;
			}
			
			image.scaleX = image.scaleY = scale;
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			mapProperty("images");
			
			if (Compass.isSupported())
			{
				compass = new Compass();
				compass.register();
				compass.addEventListener(CompassChangedEvent.MAGNETIC_FIELD_CHANGED, handleCompassUpdate);
			}
			
			return super.initialize();
		}
		
		
		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!compass && !headingLabel)
			{
				headingLabel = new Label();
				addChild( headingLabel );
				
				headingLabel.text = "No compass support";
				
				var tf2:TextFormat = new TextFormat();
				tf2.align = TextFormatAlign.LEFT;
				tf2.font = "_sans";
				tf2.size = 20;
				
				headingLabel.textFormat = tf2;
			}
			
			if( !image1 )
			{
				image1 = new Loader();
				addChild( image1 );
			}
			if( !image2 )
			{
				image2 = new Loader();
				addChild( image2 );
			}
			imageLoadQueue = [ image1, image2 ];
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function destroy():void
		{
			super.destroy();
			
			// cleanup
			if (compass)
			{
				compass.deregister();
				compass.removeEventListener(CompassChangedEvent.MAGNETIC_FIELD_CHANGED, handleCompassUpdate);
				compass = null;
			}
			if( headingLabel )
			{
				headingLabel = null;
			}
			if( image1 )
			{
				image1.contentLoaderInfo.removeEventListener( Event.COMPLETE, onImageComplete );
				image1.close();
				image1.unload();
				image1 = null;
			}
			if( image2 )
			{
				image2.contentLoaderInfo.removeEventListener( Event.COMPLETE, onImageComplete );
				image2.close();
				image2.unload();
				image2 = null;
			}
			imageLoadQueue = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// background
			graphics.clear();
			graphics.beginFill(0xcecece);
			graphics.drawRect( 0, 0, width, height);
			graphics.endFill();
			
			// 'No compass' label
			if( headingLabel )
			{
				headingLabel.x = 0;
				headingLabel.y = height - headingLabel.height - ScreenMaths.mmToPixels(5);
			}
			
			// images
			for each( var loader:Loader in imageLoadQueue )
			{
				if( loader )
				{
					layoutImage(loader);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function activate():void
		{
			super.activate();
			
			if (compass)
			{
				compass.register();
				compass.addEventListener(CompassChangedEvent.MAGNETIC_FIELD_CHANGED, handleCompassUpdate);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function deactivate():void
		{
			super.deactivate();
			
			if (compass)
			{
				compass.deregister();
				compass.removeEventListener(CompassChangedEvent.MAGNETIC_FIELD_CHANGED, handleCompassUpdate);
			}
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handle compass update event. Updates currently visible image.
		 */
		protected function handleCompassUpdate(event:CompassChangedEvent):void
		{
			if (initialized && images && images.length > 0)
			{
				var arc:Number = 360 / images.length;
				var arc2:Number = arc / 2;
				
				var h:Number = (360 + Math.round(event.azimuthVert)) % 360;
				lastHeading = h;
				
				var picIndex:int = -1;
				
				if (h >= 360-arc2 || h < arc2)
					picIndex = 0;
				else
				{
					for (var i:uint=1; i < images.length; i++)
					{
						var angle:Number = (arc * i) - arc2;
						if (h >= angle && h < angle+arc)
						{
							picIndex = i;
							break;
						}
					}
				}
				
				if (picIndex >= 0 && picIndex != lastIndex)
				{
					loadImage(picIndex);
					lastIndex = picIndex;
				}
			}
		}
		
		/**
		 * Handles image load complete event. Lays out the image and shows it with
		 * an alpha transition effect.
		 */
		protected function onImageComplete(e:Event):void
		{
			var image:Loader = LoaderInfo( e.currentTarget ).loader;
			image.contentLoaderInfo.removeEventListener( Event.COMPLETE, onImageComplete );
			
			if (image == image1)
				image1Size = new Point(image.contentLoaderInfo.width, image.contentLoaderInfo.height);
			else
				image2Size = new Point(image.contentLoaderInfo.width, image.contentLoaderInfo.height);
			
			layoutImage(image);
			image.alpha = 1;
			image.visible = true;
		}
	}
}