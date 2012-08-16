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
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.components.Image;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.RadioButton;
	import org.glomaker.mobileplayer.mvcs.views.glocomponents.GloComponent;
	
	/**
	 * AccessViews component.
	 * 
	 * @author haykel
	 * 
	 */
	public class AccessViews extends GloComponent
	{
		//--------------------------------------------------
		// Instance constants
		//--------------------------------------------------
		
		protected static const SPEAKERS_HEIGHT:uint = 145;
		protected static const DEFAULT_GAP:uint = ScreenMaths.mmToPixels(1);

		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		[Embed(source="files/noface.png")]
		protected var noface:Class;

		//container to hold components with otiginal size then scaled
		//based on coeficient between orginal and current component size.
		protected var container:Sprite = new Sprite();
		
		protected var instructionsDisplay:TextField = new TextField();
		protected var speakers:Vector.<Sprite> = new Vector.<Sprite>();
		protected var topics:Vector.<RadioButton> = new Vector.<RadioButton>();
		protected var speakerPopup:SpeakerPopup = new SpeakerPopup();
		
		protected var selectedTopic:int = -1;
		
		//--------------------------------------------------
		// instructions
		//--------------------------------------------------
		
		private var _instructions:String = "";

		/**
		 * Component property 'instructions'.
		 */
		public function get instructions():String
		{
			return _instructions;
		}

		/**
		 * @private
		 */
		public function set instructions(value:String):void
		{
			value = value ? value : "";
			if (value == instructions)
				return;
			
			_instructions = value;
			
			invalidateData();
		}
		
		//--------------------------------------------------
		// dividerWidth
		//--------------------------------------------------
		
		private var _dividerWidth:uint;

		/**
		 * Component property 'DividerWidth'.
		 */
		public function get dividerWidth():uint
		{
			return _dividerWidth;
		}

		/**
		 * @private
		 */
		public function set dividerWidth(value:uint):void
		{
			if (value == dividerWidth)
				return;
			
			_dividerWidth = value;
			
			invalidateDisplay();
		}
		
		//--------------------------------------------------
		// accessVDP
		//--------------------------------------------------
		
		private var _accessVDP:AccessViewsDataProperty;

		/**
		 * Component property 'AccessVDP'.
		 */
		public function get accessVDP():AccessViewsDataProperty
		{
			return _accessVDP;
		}

		/**
		 * @private
		 */
		public function set accessVDP(value:AccessViewsDataProperty):void
		{
			if (value == accessVDP)
				return;
			
			_accessVDP = value;
			
			updateUI();
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Recreates UI elements (topics, speakers) based on current content of 'accessVDP'.
		 */
		protected function updateUI():void
		{
			var speaker:SpeakerData;
			var speakerDisplay:Sprite;
			
			var topic:TopicData;
			var topicDisplay:RadioButton;
			
			for each (speakerDisplay in speakers)
			{
				container.removeChild(speakerDisplay);
				speakerDisplay.removeEventListener(MouseEvent.CLICK, speakerDisplay_clickHandler);
			}
			
			for each (topicDisplay in topics)
			{
				container.removeChild(topicDisplay);
				topicDisplay.removeEventListener(Event.CHANGE, topicDisplay_changeHandler);
			}
			
			selectedTopic = -1;
			speakers.length = 0;
			topics.length = 0;
			
			if (accessVDP)
			{
				var nofaceBmp:Bitmap = new noface();
				for each (speaker in accessVDP.speakers)
				{
					var img:Image = new Image();
					img.maintainRatio = false;
					if (speaker.imageSource)
						img.source = speaker.imageSource;
					else
						img.bitmapData = nofaceBmp.bitmapData;
					
					speakerDisplay = new Sprite();
					speakerDisplay.addChild(img);
					speakerDisplay.addEventListener(MouseEvent.CLICK, speakerDisplay_clickHandler);
					
					speakers.push(speakerDisplay);
					container.addChild(speakerDisplay);
				}
				
				for each (topic in accessVDP.topics)
				{
					topicDisplay = new RadioButton();
					topicDisplay.label = topic.data;
					topicDisplay.addEventListener(Event.CHANGE, topicDisplay_changeHandler);
					
					topics.push(topicDisplay);
					container.addChild(topicDisplay);
				}
			}
			
			//put speaker popup on top
			if (speakerPopup.parent == container)
				container.setChildIndex(speakerPopup, container.numChildren - 1);
			
			invalidateDisplay();
		}
		
		/**
		 * Shows the speaker popup if not visible.
		 */
		protected function showSpeakerPopup():void
		{
			if (!speakerPopup.visible)
			{
				speakerPopup.visible = true;
				speakerPopup.addEventListener(Event.CLOSE, speakerPopup_closeHandler);
			}
		}
		

		/**
		 * Hides the speaker popup if visible.
		 */
		protected function hideSpeakerPopup():void
		{
			if (speakerPopup.visible)
			{
				speakerPopup.stop();
				speakerPopup.visible = false;
				speakerPopup.removeEventListener(Event.CLOSE, speakerPopup_closeHandler);
			}
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			mapProperty("instructions");
			mapProperty("DividerWidth", "dividerWidth");
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function deactivate():void
		{
			super.deactivate();
			
			speakerPopup.stop();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			
			speakerPopup.topic = null;
			speakerPopup.speaker = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			instructionsDisplay.multiline = true;
			instructionsDisplay.wordWrap = true;
			instructionsDisplay.autoSize = TextFieldAutoSize.LEFT;
			container.addChild(instructionsDisplay);
			
			speakerPopup.visible = false;
			container.addChild(speakerPopup);
			
			addChild(container);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataUpdated(data:Object):void
		{
			super.dataUpdated(data);
			
			var vdp:AccessViewsDataProperty = new AccessViewsDataProperty();
			var xml:XMLList = component.rawXML.child("AccessVDP");
			if (xml.length() > 0)
				vdp.deserialiseFromXML(xml[0], component.directory);
			
			accessVDP = vdp;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (instructionsDisplay.htmlText != instructions)
			{
				instructionsDisplay.htmlText = instructions;
				invalidateDisplay();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			// use original component size for laying out the items in 'container',
			// then scale 'container' based on coeficient between orginal and current component size.
			
			super.resized(width, height);
			
			const w:Number = component.width;
			const h:Number = component.height;
			
			var x:Number;
			var y:Number;
			
			//instructions
			instructionsDisplay.width = w;
			
			//speakers
			if (speakers.length > 0)
			{
				var speakerSize:Number = (w - (DEFAULT_GAP * (speakers.length + 1))) / speakers.length;
				speakerSize = Math.min(speakerSize, SPEAKERS_HEIGHT);
				var speakerGap:uint = Math.floor((w - Math.ceil(speakerSize * speakers.length)) / (speakers.length + 1));
				x = speakerGap;
				y = instructionsDisplay.height + Math.floor((SPEAKERS_HEIGHT - speakerSize) / 2);
				for each (var speaker:Sprite in speakers)
				{
					var image:Image = speaker.getChildAt(0) as Image;
					image.width = speakerSize;
					image.height = speakerSize;
					
					speaker.x = x;
					speaker.y = y;
					
					x += speakerSize + speakerGap;
				}
			}
			
			//topics
			if (topics.length > 0)
			{
				x = dividerWidth + DEFAULT_GAP;
				y = instructionsDisplay.height + SPEAKERS_HEIGHT;
				var topicWidth:Number = w - x;
				var topicHeight:Number = (h - y) / topics.length;
				for each (var topic:RadioButton in topics)
				{
					topic.x = x;
					topic.y = y;
					topic.width = topicWidth;
					topic.height = topicHeight;
					
					y += topicHeight;
				}
			}
			
			//speaker popup
			speakerPopup.y = instructionsDisplay.height;
			speakerPopup.width = w;
			speakerPopup.height = SPEAKERS_HEIGHT;
			
			//scale container
			container.scaleX = width / w;
			container.scaleY = height / h;
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handler for REMOVED_FROM_STAGE event. Hide speaker popup.
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			hideSpeakerPopup();
		}

		/**
		 * Handler for topic change event.
		 */
		protected function topicDisplay_changeHandler(event:Event):void
		{
			if (selectedTopic >= 0)
				topics[selectedTopic].selected = false;
			
			selectedTopic = topics.indexOf(event.currentTarget);
			speakerPopup.topic = accessVDP.topics[selectedTopic];
			topics[selectedTopic].selected = true;
		}
		
		/**
		 * Handler for speaker click event.
		 */
		protected function speakerDisplay_clickHandler(event:MouseEvent):void
		{
			if (selectedTopic < 0)
				return;
			
			var selectedSpeaker:int = speakers.indexOf(event.currentTarget);
			speakerPopup.speaker = accessVDP.speakers[selectedSpeaker];
			showSpeakerPopup();
		}
		
		/**
		 * Handler for speaker popup close event.
		 */
		protected function speakerPopup_closeHandler(event:Event):void
		{
			hideSpeakerPopup();
		}
	}
}