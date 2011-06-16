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
		public function set htmlText(value:String):void { textField.htmlText = value || ""; }
		
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
			textField.defaultTextFormat = new TextFormat("Arial");
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
			
			textField.width = component.width;
			textField.height = component.height;
			textField.scaleX = cooficient;
			textField.scaleY = cooficient;
			
			if (redrawBorder) {
				redrawBorder = false;
				
				graphics.clear();
				if (_border) {
					//graphics.lineStyle(1, 0x000000);
					graphics.drawRect(0, 0, width, height);
				}
			}
		}
	}
}