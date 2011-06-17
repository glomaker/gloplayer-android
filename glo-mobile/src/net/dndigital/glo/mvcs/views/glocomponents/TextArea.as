package net.dndigital.glo.mvcs.views.glocomponents
{
	import com.adobe.serialization.json.JSON;
	
	import eu.kiichigo.utils.log;
	
	import flash.html.HTMLSWFCapability;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import net.dndigital.components.IGUIComponent;

	/**
	 * TextArea component renders formatted and not formatted text.
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
	public final class TextArea extends GloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(TextArea);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields.
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const textField:TextField = new TextField;
		
		/**
		 * @private
		 * Flag, indicates whether border should ber redrawn.
		 */
		protected var redrawBorder:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @copy	flash.display.TextField#htmlText
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get htmlText():String { return textField.htmlText; }
		/**
		 * @private
		 */
		public function set htmlText(value:String):void { textField.htmlText = enlarge(value) || ""; }
		
		/**
		 * @copy	flash.display.TextField#text
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get text():String { return textField.text; }
		/**
		 * @private
		 */
		public function set text(value:String):void { textField.text = value || ""; }
		
		/**
		 * @private
		 */
		protected var _border:Boolean;
		/**
		 * @copy	flash.display.TextField#border
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get border():Boolean { return border; }
		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			if (_border == value)
				return;
			_border = value;
			redrawBorder = true;
			invalidateDisplay();
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
			mapProperty("htmlText");
			mapProperty("text");
			mapProperty("borderStyle", "border");
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			textField.multiline = true;
			textField.defaultTextFormat = new TextFormat("Verdana", 14, 0x0B333C);
			textField.wordWrap = true;
			textField.border = true;
			addChild(textField)
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			const cooficient:Number = Math.min(width / component.width, height / component.height);
			
			textField.width = width;
			textField.height = height;//component.height;
			//textField.scaleX = cooficient;
			//textField.scaleY = cooficient;
			
			if (redrawBorder) {
				redrawBorder = false;
				
				graphics.clear();
				if (_border) {
					//graphics.lineStyle(1, 0x000000);
					graphics.drawRect(0, 0, width, height);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Method
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Processes the text, and enlarges it by parameter passed in <code>by</code>.
		 * 
		 * @param	text	HTML Formatted text to be enlarged.
		 * @param	by		Number of points to be enlarged by.
		 * 
		 * @return	Enlarged text.
		 */
		protected function enlarge(text:String, by:uint = 10):String
		{
			// Clean up string from special characters and break it into array using spaces.
			const items:Array = text.split("</").join(" ").
									 split("/>").join(" ").
									 split("<").join(" ").
									 split(">").join(" ").
									 split(" ");
			
			// Iterate array, and ignore all item that has no "SIZE=".
			// In future version other properrties can be modified to.
			for (var i:int = 0; i < items.length; i ++) {
				var string:String = items[i] as String;
				if (string.toUpperCase().indexOf("SIZE=") >= 0) {
					string = "SIZE=\"" + (int(string.toUpperCase().split("SIZE=").join("").
																split("\"").join("")) + by).toString() + "\"";
					text = text.split(items[i]).join(string);
					//log("replacing {0} with {1}", items[i], string);
				}
			}
			//log("enlarge={0}", text);
			return text;
		}
	}
}