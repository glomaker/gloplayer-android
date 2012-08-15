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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import net.dndigital.components.IGUIComponent;
	
	import org.bytearray.display.ScaleBitmap;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.RadioButton;
	import org.glomaker.mobileplayer.mvcs.views.glocomponents.GloComponent;
	
	public class AccessViews extends GloComponent
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		[Embed(source="files/noface.png")]
		protected var noface:Class;

		protected var instructionsDisplay:TextField = new TextField();
		protected var speakers:Vector.<Sprite> = new Vector.<Sprite>();
		protected var topics:Vector.<RadioButton> = new Vector.<RadioButton>();
		
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
		
		protected function updateUI():void
		{
			var speaker:SpeakerData;
			var speakerDisplay:Sprite;
			
			var topic:TopicData;
			var topicDisplay:RadioButton;
			
			for each (speakerDisplay in speakers)
			{
				removeChild(speakerDisplay);
			}
			
			for each (topicDisplay in topics)
			{
				removeChild(topicDisplay);
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
					speakerDisplay = new Sprite();
					speakerDisplay.addChild(new ScaleBitmap(nofaceBmp.bitmapData));
					//TODO load image
					
					speakers.push(speakerDisplay);
					addChild(speakerDisplay);
				}
				
				for each (topic in accessVDP.topics)
				{
					topicDisplay = new RadioButton();
					topicDisplay.label = topic.data;
					topicDisplay.addEventListener(Event.CHANGE, topicDisplay_changeHandler);
					
					topics.push(topicDisplay);
					addChild(topicDisplay);
				}
			}
			
			invalidateDisplay();
		}
		
		protected function topicDisplay_changeHandler(event:Event):void
		{
			if (selectedTopic >= 0)
				topics[selectedTopic].selected = false;
			
			selectedTopic = topics.indexOf(event.currentTarget);
			topics[selectedTopic].selected = true;
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		override public function initialize():IGUIComponent
		{
			mapProperty("instructions");
			mapProperty("DividerWidth", "dividerWidth");
			
			return super.initialize();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			instructionsDisplay.multiline = true;
			instructionsDisplay.wordWrap = true;
			instructionsDisplay.autoSize = TextFieldAutoSize.LEFT;
			addChild(instructionsDisplay);
		}
		
		override protected function dataUpdated(data:Object):void
		{
			super.dataUpdated(data);
			
			var vdp:AccessViewsDataProperty = new AccessViewsDataProperty();
			var xml:XMLList = component.rawXML.child("AccessVDP");
			if (xml.length() > 0)
				vdp.deserialiseFromXML(xml[0], component.directory);
			
			accessVDP = vdp;
		}
		
		override protected function commited():void
		{
			super.commited();
			
			if (instructionsDisplay.htmlText != instructions)
			{
				instructionsDisplay.htmlText = instructions;
				invalidateDisplay();
			}
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			var x:Number;
			var y:Number;
			
			super.resized(width, height);
			
			//instructions
			instructionsDisplay.width = width;
			
			//speakers
			if (speakers.length > 0)
			{
				var speakerGap:uint = ScreenMaths.mmToPixels(1);
				var speakerSize:Number = (width - (speakerGap * (speakers.length + 1))) / speakers.length;
				speakerSize = Math.min(speakerSize, 145);
				speakerGap = Math.floor((width - Math.ceil(speakerSize * speakers.length)) / (speakers.length + 1));
				x = speakerGap;
				y = instructionsDisplay.height + Math.floor((145 - speakerSize) / 2);
				for each (var speaker:Sprite in speakers)
				{
					var image:ScaleBitmap = speaker.getChildAt(0) as ScaleBitmap;
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
				y = instructionsDisplay.height + 145;
				var topicHeight:Number = (height - y) / topics.length;
				for each (var topic:RadioButton in topics)
				{
					topic.x = dividerWidth;
					topic.y = y;
					topic.width = width - topic.x;
					topic.height = topicHeight;
					
					y += topicHeight;
				}
			}
		}
	}
}