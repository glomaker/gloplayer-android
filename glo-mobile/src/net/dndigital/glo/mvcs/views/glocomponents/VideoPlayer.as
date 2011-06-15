package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.events.NetStreamEvent;
	
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
			//addEventListener(t
			
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
					//	video.videoWidth * c, video.videoHeight * c);
				}
				log("resized({0}, {1}) video({2}, {3})", width, height, video.videoWidth, video.videoHeight);
			}
			super.resized(width, height);
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
				
			video.attachNetStream(netStream);
		}
		
		/**
		 * @private
		 * Handles arrival of netstream meta data.
		 */
		protected function netStreamMetaData(event:NetStreamEvent):void
		{
			log("netStreamMetaData({0})", event);
			
			video.width = event.width;
			video.height = event.height;
			
			invalidateDisplay();
		}
	}
}