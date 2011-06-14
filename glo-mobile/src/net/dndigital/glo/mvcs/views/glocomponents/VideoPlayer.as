package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import net.dndigital.components.IGUIComponent;
	
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
			mapProperty("source");
			
			connection.connect(null);
			
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
			var stream:NetStream = new NetStream(connection);
				stream.client = new NetStreamClient;
				stream.play(component.directory.resolvePath(path).url);
				
			video.attachNetStream(stream);
			log("loadVideo({0})", component.directory.resolvePath(path).url);
		}
	}
}