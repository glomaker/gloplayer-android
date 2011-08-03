/*
Copyright (c) 2011 DN Digital Ltd (http://dndigital.net)

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

package net.dndigital.components
{
	import eu.kiichigo.utils.log;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(Label);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * TextField component that renders actual label.
		 */
		protected const textField:TextField = new TextField;
		
		/**
		 * @private
		 * Flag, indicates whether textfield is about to be changed.
		 */
		protected var textChanged:Boolean = false;
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _textFormat:TextFormat = new TextFormat("Verdana", 14);
		/**
		 * textFormat.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get textFormat():TextFormat { return _textFormat; }
		/**
		 * @private
		 */
		public function set textFormat(value:TextFormat):void
		{
			if (_textFormat == value)
				return;
			_textFormat = value;
			textChanged = true;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _autoSize:String = TextFieldAutoSize.LEFT;
		/**
		 * autoSize.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get autoSize():String { return _autoSize; }
		/**
		 * @private
		 */
		public function set autoSize(value:String):void
		{
			if (_autoSize == value)
				return;
			_autoSize = value;
			textChanged = true;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _selectable:Boolean;
		/**
		 * Indicates whether text should be selectable or not.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get selectable():Boolean { return _selectable; }
		/**
		 * @private
		 */
		public function set selectable(value:Boolean):void
		{
			if (_selectable == value)
				return;
			_selectable = value;
			textChanged = true;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _text:String = "";
		/**
		 * text.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get text():String { return _text; }
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if (_text == value)
				return;
			_text = value;
			textChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(textField);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (textChanged) {
				textField.defaultTextFormat = _textFormat;
				textField.autoSize 			= _autoSize;
				textField.text 				= _text;
				textField.selectable 		= _selectable;
				width = textField.width;
				height = textField.height;
				textChanged = false;
			}
		}
	}
}