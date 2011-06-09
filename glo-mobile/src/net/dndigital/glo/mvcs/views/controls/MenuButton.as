package net.dndigital.glo.mvcs.views.controls
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	
	public final class MenuButton extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(MenuButton);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const textField:TextField = new TextField;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _label:String = "Label";
		/**
		 * label.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get label():String { return _label; }
		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			if (_label == value)
				return;
			_label = value;
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
		override public function initialize():IGUIComponent
		{
			mouseChildren = false;
			useHandCursor = buttonMode = mouseEnabled = true;
			
			width = 120;
			height = ScreenMaths.mmToPixels(7.5);
			return super.initialize();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(textField);
			textField.defaultTextFormat = new TextFormat("Verdana");
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.clear();
			graphics.beginFill(0xFF6600);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			textField.x = (width - textField.width) /2;
			textField.y = (height - textField.height) / 2;
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if(_label != textField.text) {
				textField.text = _label;
				invalidateDisplay();
			}
		}
	}
}