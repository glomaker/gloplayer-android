/**
 * Copyright DN Digital Ltd 2012.
**/
package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.sensors.Geolocation;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.components.Label;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	
	/**
	 * Displays a GPS-enabled compoennt. 
	 * @author Nils
	 * 
	 */	
	public class GPSComponent extends GloComponent
	{

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var geo:Geolocation;
		protected var headingLabel:Label;
		protected var image1:Loader;
		protected var image2:Loader;
		protected var imageLoadQueue:Array;
		protected var lastIndex:int = -1;
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @copy	net.dndigital.glo.mvcs.views.controls.IGloComponent#destroy
		 */ 
		override public function destroy():void
		{
			super.destroy();
			
			// cleanup
			if( geo )
			{
				geo.removeEventListener( GeolocationEvent.UPDATE, handleGeoUpdate );
				geo.removeEventListener( StatusEvent.STATUS, handleGeoStatus );
				geo = null;
			}
			if( headingLabel )
			{
				headingLabel = null;
			}
			if( image1 )
			{
				image1.contentLoaderInfo.removeEventListener( Event.COMPLETE, onImageComplete );
				image1 = null;
			}
			if( image2 )
			{
				image2.contentLoaderInfo.removeEventListener( Event.COMPLETE, onImageComplete );
				image2 = null;
			}
			imageLoadQueue = null;
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
			mapProperty("cornerRadius");
			mapProperty("bgcolour", "color");
			
			if( Geolocation.isSupported )
			{
				geo = new Geolocation();
				geo.setRequestedUpdateInterval( 500 );
				geo.addEventListener( GeolocationEvent.UPDATE, handleGeoUpdate );
				geo.addEventListener( StatusEvent.STATUS, handleGeoStatus );
			}
			
			return super.initialize();
		}

		
		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if( !headingLabel )
			{
				headingLabel = new Label();
				addChild( headingLabel );
				
				if( Geolocation.isSupported )
				{
					headingLabel.text = "Calculating...";
				}else{
					headingLabel.text = "No GPS";
				}
				
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
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			graphics.clear();
			graphics.beginFill(0xcecece);
			graphics.drawRect( 0, 0, width, height);
			graphics.endFill();
			
			if( headingLabel )
			{
				headingLabel.x = 0;
				headingLabel.y = height - headingLabel.height - ScreenMaths.mmToPixels(5);
			}
			
			// all images
			for each( var loader:Loader in imageLoadQueue )
			{
				if( loader )
				{
					loader.x = (width - loader.width)/2;
					loader.y = (height - loader.height)/2;
				}
			}
		}
		
		protected function loadImage( index:uint ):void
		{
			var url:String = File.applicationDirectory.resolvePath("assets/GPS/content/pic-" + index + ".jpg").url;
			
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
		
		protected function handleGeoUpdate(event:GeolocationEvent):void
		{
			if( headingLabel )
			{
				headingLabel.text = "" + Math.round( event.heading );
				
				var totalPics:uint = 8;
				var arc:Number = 360/totalPics; // 8 images to cover 360 degree view

				var h:Number = event.heading;
				var picIndex:uint;
				
				if( h >= 337.5 || h < 22.5 )
				{
					picIndex = 1;
				}else if( h >= 22.5 && h < 67.5 ){
					picIndex = 2;
				}else if( h >= 67.5 && h < 112.5 ){
					picIndex = 3
				}else if( h >= 112.5 && h < 157.5 ){
					picIndex = 4;
				}else if( h >= 157.5 && h < 202.5 ){
					picIndex = 5;
				}else if( h >= 202.5 && h < 247.5 ){
					picIndex = 6;
				}else if( h >= 247.5 && h < 292.5 ){
					picIndex = 7;
				}else{
					picIndex = 8;
				}
								
				if( picIndex != lastIndex )
				{
					loadImage( picIndex );
					lastIndex = picIndex;
				}
			}
			
		}
		
		protected function handleGeoStatus(event:StatusEvent):void
		{
			if( headingLabel )
			{
				if( geo && geo.muted )
				{
					headingLabel.text = "Inaccessible";
				}
			}
		}
		
		protected function onImageComplete(e:Event):void
		{
			var image:Loader = LoaderInfo( e.currentTarget ).loader;
			image.contentLoaderInfo.removeEventListener( Event.COMPLETE, onImageComplete );
			image.alpha = 0;
			image.visible = true;
			image.x = ( width - image.width ) / 2;
			image.y = ( height - image.height ) / 2;
			TweenLite.to( image, 0.5, { alpha: 1 } );
		}
	}
	
}