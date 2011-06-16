package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.NetStreamEvent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.IconButton;
	import net.dndigital.glo.mvcs.views.components.PlayButton;
	import net.dndigital.glo.mvcs.views.glocomponents.helpers.PlaybackProgress;
	
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
	public final class VideoPlayer extends GloComponent
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

		[Embed(source="assets/video.player.play.button.png")]
		/**
		 * @private
		 * Play Button asset.
		 */
		protected static const playButtonAsset:Class;
		
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
		 */
		protected const playButton:PlayButton = new PlayButton;
		
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
		
		/**
		 * @private
		 * Size of video.
		 */
		protected const videoSize:Point = new Point;
		
		/**
		 * @private
		 * Flag indicates whether video should be loaded.
		 */
		protected var loadVideo:Boolean = false;
		
		/**
		 * @private
		 * Progress component.
		 */
		protected const playbackProgress:PlaybackProgress = new PlaybackProgress;
		/**
		 * @private
		 * Timer, handles progress changes.
		 */
		protected const progressTimer:Timer = new Timer(75);
		
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
			load(_source);
		}
		
		/**
		 * @private
		 */
		protected var _visible:Boolean;
		/**
		 * visible.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		override public function get visible():Boolean { return _visible; }
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if (_visible == value)
				return;
			_visible = value;
			if (!paused && loaded && !value)
				pause();
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
			
			if (!paused) {
				netStream.pause();
				progressTimer.stop();
			}
			paused = true;
			invalidateDisplay();
			updateProgress();
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
			
			if (paused) {
				netStream.resume();
				progressTimer.start();
			}
			paused = false;
			invalidateDisplay();
			updateProgress();
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
		
		/**
		 * Rewinds video to it's initial position and pauses it.
		 *  
		 * @return Current instance of <code>VideoPlayer</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function rewind():VideoPlayer
		{
			if(!loaded)
				return this;
			
			netStream.seek(0);
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
			
			// Prepare progress timer.
			progressTimer.addEventListener(TimerEvent.TIMER, progressTick);
			// Prepare NetConnection and NetStream instances for video.
			connection.connect(null);
			netStream = new NetStream(connection);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			netStream.client = client;
			
			client.addEventListener(NetStreamEvent.META_DATA, netStreamMetaData);
			
			// Setup Event Listeners.
			addEventListener(MouseEvent.CLICK, handleMouse);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
			return super.initialize();
		}

		
		
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// Setup video.
			
			video.smoothing = true;
			addChild(video);
			
			// Setup progress
			playbackProgress.height = Math.floor(Capabilities.screenDPI * (40 / 25.4)) / 100;
			addChild(playbackProgress);
			
			// Setup button.
			playButton.upSkin = new playButtonAsset().bitmapData;
			playButton.width = playButton.height = 2;
			playButton.visible = false;
			addChild(playButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			// [t:43](LG Bug). Take value which is not zero, attempt to use video.videoWidth, but use cached videoSize if first not available.
			const vw:int = video.videoWidth || videoSize.x;
			const vh:int = video.videoHeight || videoSize.y;
			if (vw > 0 && vh > 0) {
				if (vw != width || vh != height) {
					// Calculate a cooficient.
					var c:Number = Math.min(width / vw, height / vh);
					// Apply size
					video.width = vw * c;
					video.height = vh * c;
					
					video.x = (width - video.width) / 2;
					video.y = (height - video.height) / 2;
					
					// Play Button
					playButton.visible = paused;
					if (playButton.visible) {
						var desiredSize:int = ScreenMaths.mmToPixels(50);
						if (desiredSize > video.width || desiredSize > video.height)
							desiredSize = Math.min(video.width, video.height);
						playButton.width = playButton.height = desiredSize;
						playButton.x = (width - playButton.width) / 2;
						playButton.y = (height - playButton.height) / 2;
					}
					
					// Playback progress
					playbackProgress.visible = !paused;
					if (playbackProgress) {
						playbackProgress.x = video.x;
						playbackProgress.y = video.y + video.height - playbackProgress.height;
						playbackProgress.width = video.width;
					}
				}
			}
			super.resized(width, height);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			
			if (netStream) {
				netStream.close();
				if (netStream.client)
					// FIXME It's impossible to set netStream to empty object with empty handler, find a better solution.
					netStream.client = {onMetaData: function(info:Object):void {}};
				netStream = null
			}
			
			progressTimer.removeEventListener(TimerEvent.TIMER, progressTick);
			video.clear();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Handles timer update.
		 */
		protected function progressTick(event:TimerEvent):void
		{
			if (netStream == null) {
				progressTimer.removeEventListener(TimerEvent.TIMER, progressTick);
				progressTimer.stop();
			}
			
			updateProgress();
			event.updateAfterEvent();
		}
		
		/**
		 * Loads source.
		 */
		protected function load(source:String):void
		{
			//log("load({0})", source);
			netStream.play(component.directory.resolvePath(source).url);
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
			videoSize.x = video.width = event.width;
			videoSize.y = video.height = event.height;
			_duration = event.duration;
			
			invalidateDisplay();
		}
		
		/**
		 * @private
		 * Handles Mouse Events
		 */
		protected function handleMouse(event:MouseEvent):void
		{
			toggle();
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
		 */
		protected function handleNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.level) {
				case "status":
					switch (event.info.code) {
						case "NetStream.Play.Stop":
							rewind();
							break;
						case "NetStream.Play.Start":
							player.invalidateDisplay();
							invalidateDisplay();
							break;
					}
					break;
				default:;
					log("handleNetStatus({0*})", event.info);
			}
		}
		
		/**
		 * @private
		 */
		protected function updateProgress():void
		{
			playbackProgress.percentage = netStream.time / duration;
		}
	}
}