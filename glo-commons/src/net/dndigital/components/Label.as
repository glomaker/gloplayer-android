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