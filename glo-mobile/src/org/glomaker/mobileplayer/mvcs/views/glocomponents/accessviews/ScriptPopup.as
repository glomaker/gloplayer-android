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
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.TextArea;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	
	/**
	 * Dispatched when the user clicks the 'close' button.
	 */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Popup that displays the script of a speaker.
	 * 
	 * @author haykel
	 * 
	 */
	public class ScriptPopup extends GUIComponent
	{
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var closeButton:CloseButton = new CloseButton();
		protected var scriptDisplay:TextArea = new TextArea();
		
		//--------------------------------------------------
		// file
		//--------------------------------------------------
		
		private var _file:String;
		private var fileChanged:Boolean;

		/**
		 * Path of the script file.
		 */
		public function get file():String
		{
			return _file;
		}

		/**
		 * @private
		 */
		public function set file(value:String):void
		{
			if (value == file)
				return;
			
			_file = value;
			
			fileChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var buttonSize:uint = ScreenMaths.mmToPixels(12);
			closeButton.width = buttonSize;
			closeButton.height = buttonSize;
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			addChild(closeButton);
			
			addChild(scriptDisplay);
		}
		
		override protected function commited():void
		{
			super.commited();
			
			if (fileChanged)
			{
				fileChanged = false;
				
				var text:String;
				
				if (file)
				{
					var stream:FileStream = new FileStream();
					try {
						stream.open(new File(file), FileMode.READ);
						text = stream.readUTFBytes(stream.bytesAvailable);
					} catch(e:Error) {
						text = null;
					}
				}
				
				scriptDisplay.htmlText = text ? ("<font size='20'>" + text + "</font>") : text;
			}
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			const padding:uint = ScreenMaths.mmToPixels(2);
			const scrollIndicatorWidth:uint = 9;
			
			// prepare drawing
			var g:Graphics = graphics;
			g.clear();
			
			// background
			g.beginFill(0, 0.9);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			//close button
			closeButton.x = width - padding - closeButton.width;
			closeButton.y = padding;
			
			//text area
			scriptDisplay.x = padding;
			scriptDisplay.y = closeButton.y + closeButton.height + padding;
			scriptDisplay.width = width - padding - padding - scrollIndicatorWidth;
			scriptDisplay.height = height - padding - scriptDisplay.y;
			
			// text area bg
			g.beginFill(0xFFFFFF);
			g.drawRect(scriptDisplay.x, scriptDisplay.y, scriptDisplay.width + scrollIndicatorWidth, scriptDisplay.height);
			g.endFill();
			
			// scroll indicator separation
			g.lineStyle(1, 0xb7babc);
			g.moveTo(scriptDisplay.x + scriptDisplay.width, scriptDisplay.y);
			g.lineTo(scriptDisplay.x + scriptDisplay.width, scriptDisplay.y + scriptDisplay.height);
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		protected function closeButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}