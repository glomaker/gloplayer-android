package net.dndigital.glo.mvcs.views.components
{
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.utils.drawRectangle;
	
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
		protected var fileChanged:Boolean = false;
		/**
		 * @private
		 */
		protected var _file:File;
		/**
		 * file.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get file():File { return _file; }
		/**
		 * @private
		 */
		public function set file(value:File):void
		{
			if (_file == value)
				return;
			_file = value;
			fileChanged = true;
			invalidateData()
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
			
			width = 150;
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
			textField.defaultTextFormat = new TextFormat("Verdana", 16);
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			drawRectangle(this, 0x666666, width, height, .75, 5);
			
			textField.x = (width - textField.width) /2;
			textField.y = (height - textField.height) / 2;
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (fileChanged) {
				var name:String = file.name.split(".glo").join("");
				if (name.toUpperCase() == "PROJECT") {
					if (file.url.indexOf("Glos") >= 0)
						name = file.url.split("Glos")[1];
					else
						name = file.url.split("app:/assets/")[1];
				}
				
				name = name.split("/").join("").
							split("\"").join("").
							split("project.glo").join("");
				
				textField.text = name;
				
				invalidateDisplay();
				
				fileChanged = false;
			}
		}
	}
}