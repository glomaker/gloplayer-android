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

package org.glomaker.mobileplayer.mvcs.views.components
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import net.dndigital.components.ToggleButton;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;

	public class RadioButton extends ToggleButton
	{
		
		//--------------------------------------------------
		// Class constants
		//--------------------------------------------------
		
		/**
		 * Size (width/height) of the radio button in mm.
		 */
		protected static const RADIO_SIZE_MM:uint = 3;
		
		/**
		 * Gap between the radio button and the label in mm.
		 */
		protected static const GAP_MM:uint = 2;
		
		//--------------------------------------------------
		// Instance constants
		//--------------------------------------------------
		
		/**
		 * Shape for rendring the radio button.
		 */
		protected const radio:Shape = new Shape();
		
		/**
		 * Text field for the label.
		 */
		protected const labelDisplay:TextField = new TextField();
		
		/**
		 * Area to accept mouse interactions.
		 */
		protected const hit:Sprite = new Sprite();
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function RadioButton()
		{
			super();
		}
		
		//--------------------------------------------------
		// label
		//--------------------------------------------------
		
		private var _label:String = "";

		/**
		 * Label.
		 */
		public function get label():String
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			value = value ? value : "";
			if (value == label)
				return;
			
			_label = value;
			
			invalidateData();
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		protected function updateRadio():void
		{
			var g:Graphics = radio.graphics;
			var size:uint = ScreenMaths.mmToPixels(RADIO_SIZE_MM);
			
			g.clear();
			g.lineStyle(2, 0);
			g.drawEllipse(0, 0, size, size);
			
			if (state == STATE_DOWN || state == STATE_SELECTED_UP)
			{
				var pos:uint = Math.ceil(size/4);
				size = size - pos - pos;
				
				g.beginFill(0);
				g.drawEllipse(pos, pos, size, size);
				g.endFill();
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
			
			addChild(radio);
			
			labelDisplay.defaultTextFormat = new TextFormat("Verdana", 14, 0x0B333C);
			labelDisplay.multiline = false;
			labelDisplay.border = false;
			labelDisplay.mouseEnabled = false;
			addChild(labelDisplay);
			
			hitArea = hit;
			hit.mouseEnabled = false;
			addChild(hit);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(newState:String):void
		{
			super.stateChanged(newState);
			
			updateRadio();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			labelDisplay.text = label;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			var gap:uint = ScreenMaths.mmToPixels(GAP_MM);
			var lm:TextLineMetrics = labelDisplay.getLineMetrics(0);
			
			radio.x = 0;
			radio.y = Math.floor((height - radio.height) / 2);
			
			labelDisplay.x = radio.x + radio.width + gap;
			labelDisplay.width = width - labelDisplay.x;
			
			labelDisplay.height = Math.ceil(lm.height + lm.descent);
			labelDisplay.y = Math.floor((height - labelDisplay.height) / 2);
			
			hit.graphics.clear();
			hit.graphics.beginFill(0xFF0000, 0);
			hit.graphics.drawRect(0, 0, width, height);
			hit.graphics.endFill();
		}
	}
}