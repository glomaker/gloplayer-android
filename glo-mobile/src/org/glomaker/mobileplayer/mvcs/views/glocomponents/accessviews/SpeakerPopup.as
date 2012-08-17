/*
Copyright (c) 2012 DN Digital Ltd (http://dndigital.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package org.glomaker.mobileplayer.mvcs.views.glocomponents.accessviews
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import net.dndigital.components.GUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	
	/**
	 * Dispatched when the user clicks the 'close' button.
	 */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Popup that displays buttons for playing the aduio and displaying the script
	 * of a speaker.
	 * 
	 * @author haykel
	 * 
	 */
	public class SpeakerPopup extends GUIComponent
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var audio:String;
		protected var script:String;
		
		protected var mp3Player:Mp3Player = new Mp3Player();
		
		protected var titleDisplay:TextField = new TextField();
		protected var playButton:PlayButton = new PlayButton();
		protected var stopButton:StopButton = new StopButton();
		protected var scriptButton:ScriptButton = new ScriptButton();
		protected var closeButton:CloseButton = new CloseButton();
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function SpeakerPopup()
		{
			playButton.addEventListener(MouseEvent.CLICK, button_clickHandler);
			stopButton.addEventListener(MouseEvent.CLICK, button_clickHandler);
			scriptButton.addEventListener(MouseEvent.CLICK, button_clickHandler);
			closeButton.addEventListener(MouseEvent.CLICK, button_clickHandler);
		}
		
		//--------------------------------------------------
		// topic
		//--------------------------------------------------
		
		private var _topic:TopicData;

		/**
		 * Selected topic.
		 */
		public function get topic():TopicData
		{
			return _topic;
		}

		/**
		 * @private
		 */
		public function set topic(value:TopicData):void
		{
			if (value == topic)
				return;
			
			_topic = value;
			
			invalidateData();
		}
		
		//--------------------------------------------------
		// speaker
		//--------------------------------------------------
		
		private var _speaker:SpeakerData;

		/**
		 * Selected speaker.
		 */
		public function get speaker():SpeakerData
		{
			return _speaker;
		}

		/**
		 * @private
		 */
		public function set speaker(value:SpeakerData):void
		{
			if (value == speaker)
				return;
			
			_speaker = value;
			
			invalidateData();
		}
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Play current sound if available.
		 */
		public function play():void
		{
			if (!mp3Player.isPlaying())
			{
				mp3Player.playPause();
				
				playButton.visible = false;
				stopButton.visible = true;
			}
		}
		
		/**
		 * Stop current sound if playing.
		 */
		public function stop():void
		{
			if (mp3Player.isPlaying())
			{
				mp3Player.stop();
				
				playButton.visible = true;
				stopButton.visible = false;
			}
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			titleDisplay.defaultTextFormat = new TextFormat("Verdana", 26, 0x0B333C);
			titleDisplay.multiline = true;
			titleDisplay.wordWrap = true;
			titleDisplay.autoSize = TextFieldAutoSize.LEFT;
			addChild(titleDisplay);
			
			playButton.visible = false;
			addChild(playButton);
			
			stopButton.visible = false;
			addChild(stopButton);
			
			scriptButton.visible = false;
			addChild(scriptButton);
			
			addChild(closeButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			audio = null;
			script = null;
			
			stop();
			
			if (topic && topic.id && speaker)
			{
				audio = speaker.sounds[topic.id] !== undefined ? speaker.sounds[topic.id] : null;
				script = speaker.scripts[topic.id] !== undefined ? speaker.scripts[topic.id] : null;
			}
			
			titleDisplay.text = speaker ? speaker.title : "";
			playButton.visible = audio != null && audio.length > 0;
			scriptButton.visible = script != null && script.length > 0;
			
			mp3Player.loadSound(audio);
			
			invalidateDisplay();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			const padding:uint = 0; //ScreenMaths.mmToPixels(1);
			const buttonGap:uint = ScreenMaths.mmToPixels(3);
			
			// prepare drawing
			var g:Graphics = graphics;
			g.clear();
			
			// background
			g.beginFill(0xFFFFFF, 0.8);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			//title
			titleDisplay.x = padding;
			titleDisplay.y = padding;
			titleDisplay.width = width - padding - padding;
			
			//buttons
			var tm:TextLineMetrics = titleDisplay.getLineMetrics(0);
			var buttonSize:uint = Math.min(ScreenMaths.mmToPixels(12), height - (tm.height + tm.descent + 4));
			
			playButton.x = padding;
			playButton.y = height - padding - buttonSize;
			playButton.width = buttonSize;
			playButton.height = buttonSize;
			
			stopButton.x = playButton.x;
			stopButton.y = playButton.y;
			stopButton.width = buttonSize;
			stopButton.height = buttonSize;
			
			scriptButton.x = playButton.x + buttonSize + buttonGap;
			scriptButton.y = playButton.y;
			scriptButton.width = buttonSize;
			scriptButton.height = buttonSize;
			
			closeButton.x = width - padding - buttonSize;
			closeButton.y = playButton.y;
			closeButton.width = buttonSize;
			closeButton.height = buttonSize;
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Event handler for play, stop and close buttons.
		 */
		protected function button_clickHandler(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case playButton:
					play();
					break;
				
				case stopButton:
					stop();
					break;
				
				case scriptButton:
					break;
				
				case closeButton:
					stop();
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
	}
}