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
	import eu.kiichigo.utils.log;
	
	import flash.events.*;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.net.*;
	import flash.utils.Timer;
	
	import net.dndigital.components.IGUIComponent;
	import org.glomaker.mobileplayer.mvcs.events.NetStreamEvent;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.glocomponents.helpers.PlaybackProgress;

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
	public final class VideoPlayer extends GloComponent implements IFullscreenable
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
		
		protected static const DESIRED_PLAY_SIZE_MM:Number = 10;

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
		protected const playButton:VideoPlayButton = new VideoPlayButton;
		
		/**
		 * @private
		 */
		protected const fullscreenButton:VideoFullscreenButton = new VideoFullscreenButton;
		
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
		
		/**
		 * Stores state when video component is deactivated.
		 */
		protected var playOnActivate:Boolean = false;
		
		/**
		 * Is currently playing fullscreen? 
		 */		
		protected var isFullScreen:Boolean = false;
		
		
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
			invalidateDisplay();
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
			super.visible = _visible = value;
			if (!paused && loaded && !value)
				pause();
		}
		
		/**
		 * @see IFullscreenable
		 * @param value
		 */		
		public function set isFullScreened( value:Boolean ):void
		{
			isFullScreen = value; // picked up by next resized()
			invalidateDisplay();
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
			if (!loaded || netStream == null)
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
			playOnActivate = false;
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
			
			if( netStream )
			{
				netStream.seek(0);
			}
			
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
		
			//netStream.bufferTime = 0;
			client.addEventListener(NetStreamEvent.META_DATA, netStreamMetaData);
			
			// Setup Event Listeners.
			addEventListener(MouseEvent.CLICK, handleMouse);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
			
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
			playbackProgress.height = ScreenMaths.mmToPixels(0.5);
			addChild(playbackProgress);
			
			// Setup play button.
			playButton.width = playButton.height = ScreenMaths.mmToPixels(DESIRED_PLAY_SIZE_MM);
			playButton.visible = false;
			addChild(playButton);
			
			// Setup fullscreen button
			fullscreenButton.width = fullscreenButton.height = ScreenMaths.mmToPixels(6);
			fullscreenButton.visible = false;
			fullscreenButton.alpha = 0;
			addChild(fullscreenButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
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
					var mm:Number = ScreenMaths.mmToPixels(1);
					playButton.visible = paused;
					if (playButton.visible) {
						var desiredSize:int = Math.min( ScreenMaths.mmToPixels(DESIRED_PLAY_SIZE_MM), 0.8*video.width, 0.8*video.height);
						playButton.width = playButton.height = desiredSize;
						playButton.x = (width - playButton.width) / 2;
						playButton.y = (height - playButton.height) / 2;
					}
					
					// Fullscreen Button
					fullscreenButton.visible = !paused || isFullScreen;
					fullscreenButton.x = width - fullscreenButton.width - mm;
					fullscreenButton.y = height - fullscreenButton.height - mm;
					
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
		override public function activate():void
		{
			if( playOnActivate )
			{
				playOnActivate = false;
				play();
			}
		}

		
		/**
		 * @inheritDoc 
		 */		
		override public function deactivate():void
		{
			if( !paused )
			{
				playOnActivate = true;
				pause();
			}else{
				playOnActivate = false;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			
			if (netStream)
			{
				netStream.close();
				if (netStream.client)
				{
					// FIXME It's impossible to set netStream.client to empty object with empty handler, find a better solution.
					netStream.client = {onMetaData: function(info:Object):void {}};
				}
				netStream = null
			}
			
			progressTimer.stop();
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
			netStream.play(component.directory.resolvePath(source).url);
			paused = false;
			loaded = true;
			pause();
				
			video.attachNetStream(netStream);
		}
		
		/**
		 * @private
		 * Handles arrival of netstream meta data.
		 */
		protected function netStreamMetaData(event:NetStreamEvent):void
		{
			// sometimes the event will be zero but video.width / video.height will be correct
			// logical OR will convert 0 to false, by putting the event properties first they will be used if non-zero
			videoSize.x = ( event.width || video.width );
			videoSize.y = ( event.height || video.height );
			_duration = event.duration;
			
			invalidateDisplay();
		}
		
		/**
		 * @private
		 * Handles Mouse Events
		 */
		protected function handleMouse(event:MouseEvent):void
		{
			if (event.target == fullscreenButton)
				player.fullscreen(this);			// Fullscreen
			else
				toggle();							// Play-pause
		}
		
		/**
		 * @private
		 * Handles Event.REMOVED_FROM_STAGE which is caught when current instance of <code>VideoPlayer</code> is removed from stage.
		 */
		protected function removedFromStage(event:Event):void
		{
			rewind(); // also pauses
			playButton.validate(); // fix for GUIComponent issue with not validating if not on display list
			fullscreenButton.validate(); // fix for GUIComponent issue with not validating if not on display list
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
							invalidateDisplay();
							break;
						case "NetStream.Play.Start":
							player.invalidateDisplay();
							invalidateDisplay();
							break;
						default:
							break;
					}
					break;
				case "error":
					switch (event.info.code) {
						case "NetStream.Play.StreamNotFound":
							loaded = false;
							break;
					}
					break;
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		protected function updateProgress():void
		{
			if (playbackProgress && netStream)
				playbackProgress.percentage = netStream.time / duration;
		}
	}
}