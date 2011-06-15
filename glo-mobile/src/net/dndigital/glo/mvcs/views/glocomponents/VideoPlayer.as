package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.NetStreamEvent;
	
	import org.bytearray.display.ScaleBitmap;

	/**
	 * VideoPlayer component is capable of rendering video on <code>GloPlayer</code>'s pages.
	 * 
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
	public final class VideoPlayer extends Placeholder
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(VideoPlayer);
		
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const connection:NetConnection = new NetConnection;
		
		/**
		 * @private
		 */
		protected var netStream:NetStream;
		
		/**
		 * @private
		 * NetStreamClient instance that monitors netstream related events.
		 */
		protected const client:NetStreamClient = new NetStreamClient;
		
		/**
		 * @private
		 */
		protected const video:Video = new Video;
		
		/**
		 * @private
		 */
		protected const snapshot:ScaleBitmap = new ScaleBitmap;
		
		/**
		 * @private
		 * Flag, indicates whether movie is paused or not.
		 */
		protected var paused:Boolean = false;
		
		/**
		 * @private
		 * Flag, indicates whether movie is loaded or not.
		 */
		protected var loaded:Boolean = false;

		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	
		/**
		 * @private
		 */
		protected var _duration:Number;
		/**
		 * Duration of a movie in seconds.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get duration():Number { return _duration; }
		
		/**
		 * @private
		 */
		protected var _source:String;
		/**
		 * source.
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
			if (_source == value)
				return;
			_source = value;
			loadVideo(value);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Pauses an instance of <code>VideoPlayer</code>.
		 *  
		 * @return Current instance of <code>VideoPlayer</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function pause():VideoPlayer
		{
			if (!loaded)
				return this;
			
			if (!paused)
				netStream.pause();
			paused = true;
			return this;
		}
		
		/**
		 * Plays or Resumes an instance of <code>VideoPlayer</code>.
		 *  
		 * @return Current instance of <code>VideoPlayer</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function play():VideoPlayer
		{
			if (!loaded)
				return this;
			
			if (paused)
				netStream.resume();
			paused = false;
			return this;
		}
		
		/**
		 * Toggles <code>VideoPlayer</code> to play or resume.
		 *  
		 * @return Current instance of <code>VideoPlayer</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function toggle():VideoPlayer
		{
			if(!loaded)
				return this;
			
			if (paused)
				return play();
			else
				return pause();
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
			// Map Properties
			mapProperty("source");
			
			// Prepare NetConnection and NetStream instances for video.
			connection.connect(null);
			netStream = new NetStream(connection);
			netStream.client = client;
			
			client.addEventListener(NetStreamEvent.META_DATA, netStreamMetaData);
			
			// Setup Event Listeners.
			addEventListener(MouseEvent.CLICK, handleMouse);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			addEventListener(TransformGestureEvent.GESTURE_ZOOM, handleZoom);
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			//video.smoothing = true;
			addChild(video);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			if (video.videoWidth > 0 && video.videoWidth > 0) {
				if (video.videoWidth != width || video.videoHeight != height) {
					// Calculate a cooficient.
					var c:Number = Math.min(width / video.videoWidth, height / video.videoHeight);
					// Apply size
					video.width = video.videoWidth * c;
					video.height = video.videoHeight * c;
					
					video.x = (width - video.width) / 2;
					video.y = (height - video.height) / 2;
				}
			}
			super.resized(width, height);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function destroy(event:Event = null):void
		{
			super.destroy(event);
			
			if (netStream)
				netStream.close();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 */
		protected function loadVideo(path:String):void
		{
			netStream.play(component.directory.resolvePath(path).url);
			paused = false;
			loaded = true;
			createSnapshot(video, netStream);
			pause();
				
			video.attachNetStream(netStream);
		}
		
		/**
		 * @private
		 * Handles arrival of netstream meta data.
		 */
		protected function netStreamMetaData(event:NetStreamEvent):void
		{
			video.width = event.width;
			video.height = event.height;
			_duration = event.duration;
			
			invalidateDisplay();
		}
		
		/**
		 * @private
		 * Handles Mouse Events
		 */
		protected function handleMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.CLICK)
				toggle(), log("handleMouse(click)");
		}
		
		/**
		 * @private
		 * Creates a snapshot of a video.
		 */
		protected function createSnapshot(video:Video, netStream:NetStream):BitmapData
		{
			var time:Number = netStream.time;
			
			if (_duration < 5 )
				netStream.seek(_duration / 2);
			else
				netStream.seek(5);
			
			var bitmapData:BitmapData = new BitmapData(video.width, video.height, true, 0x00000000);
				bitmapData.draw(video);
				
			return bitmapData;
		}
		
		/**
		 * @private
		 * Handles Event.REMOVED_FROM_STAGE which is caught when current instance of <code>VideoPlayer</code> is removed from stage.
		 */
		protected function removedFromStage(event:Event):void
		{
			pause();
		}
		
		/**
		 * @private
		 * Handles Gesture Zoom.
		 */
		protected function handleZoom(event:TransformGestureEvent):void
		{
			log("handleZoom() x={0} y={1}", event.offsetX, event.offsetY);
			event.preventDefault();
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
	}
}