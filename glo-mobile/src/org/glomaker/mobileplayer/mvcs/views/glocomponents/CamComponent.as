package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;

	public class CamComponent extends GloComponent
	{
		
		protected var cam:Camera;
		protected var vid:Video;
		
		override public function initialize():IGUIComponent
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
			
			if( Camera.isSupported )
			{
				cam = Camera.getCamera();
				cam.addEventListener( ActivityEvent.ACTIVITY, onCamActivity);
			}
			
			return super.initialize();
		}
		
		protected function onCamActivity(event:ActivityEvent):void
		{
			resizeVid();
			cam.removeEventListener( ActivityEvent.ACTIVITY, onCamActivity);
		}
		
		override public function activate():void
		{
			trace("act");
		}
		
		override public function deactivate():void
		{
			trace("deac");
		}
		
		override public function destroy():void
		{
			super.destroy();
			removeEventListener( Event.REMOVED_FROM_STAGE, removedFromStage );
			
			if( vid )
			{
				vid.attachCamera( null );
				vid = null;
			}
			if( cam )
			{
				cam.removeEventListener( ActivityEvent.ACTIVITY, onCamActivity );
				cam = null;
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if( !vid && cam && !cam.muted )
			{
				vid = new Video(cam.width, cam.height);
				vid.smoothing = true;
				addChild( vid );
				vid.attachCamera( cam );
			}
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// background
			graphics.clear();
			graphics.beginFill( 0xcecece, 1 );
			graphics.drawRect(0,0,width,height);
			
			// video
			resizeVid();
		}
		
		protected function resizeVid():void
		{
			if( stage && vid && vid.videoWidth != 0 && vid.videoHeight != 0 )
			{
				// back to normal
				vid.rotation = 0;
				vid.scaleX = vid.scaleY = 1;
				vid.width = vid.videoWidth;
				vid.height = vid.videoHeight;
				
				// maintain aspect ratio
				var scale:Number;
				var useHeight:Number = height; // - ScreenMaths.mmToPixels( 10 );
				
				// certain iOS rotations incorrectly rotate the camera view
				if( stage.stageWidth < stage.stageHeight )
				{
					vid.rotation = 90;
					vid.scaleX = Math.min( width/vid.videoWidth, useHeight/vid.videoHeight);
					vid.scaleY = vid.scaleX;
					vid.x = vid.width + (width-vid.width)/2;
					vid.y = 0;
					
				}else{
					vid.rotation = 0;
					vid.scaleX = Math.min( useHeight / vid.videoHeight, width / vid.videoWidth );
					vid.scaleY = vid.scaleX;
					vid.x = (width - vid.width)/2;
					vid.y = (height - vid.height)/2;
				}

			}
		}
		
		/**
		 * @private
		 * Handles Event.REMOVED_FROM_STAGE which is caught when current instance of <code>VideoPlayer</code> is removed from stage.
		 */
		protected function removedFromStage(event:Event):void
		{
			// stop the camera
			if( vid )
			{
				vid.attachCamera( null );
			}
			if( cam )
			{
				cam.removeEventListener( ActivityEvent.ACTIVITY, onCamActivity );
				cam = null;
			}
		}
		
		
	}
}