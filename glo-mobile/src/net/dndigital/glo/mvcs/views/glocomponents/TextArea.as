package net.dndigital.glo.mvcs.views.glocomponents
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.layout.ScaleMode;
	
	import eu.kiichigo.utils.log;
	
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.html.HTMLSWFCapability;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;

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
		
		/**
		 * @private 
		 */		
		protected var scrollIndicator:Shape = new Shape;
		
		
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
		public function set htmlText(value:String):void { 
			textField.htmlText = value;
			invalidateDisplay();
		}
		
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
		public function set text(value:String):void {
			textField.text = value || "";
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _border:Boolean = false;
		/**
		 * @copy	flash.display.TextField#border
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get border():Boolean { return _border; }
		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			if( value != _border )
			{
				_border = value;
				invalidateDisplay();
			}
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
		
		override public function destroy():void
		{
			super.destroy();
			
			if( textField )
			{
				textField.removeEventListener( Event.SCROLL, updateScrollbarPosition );
			}
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
			textField.border = false;
			addChild(textField);
			
			scrollIndicator.visible = false;
			scrollIndicator.cacheAsBitmap = true;
			addChild( scrollIndicator );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// size textfield proportionally
			const coefficient:Number = Math.min(width / component.width, height / component.height);
			
			textField.width = component.width;
			textField.height = component.height;
			textField.scaleX = coefficient;
			textField.scaleY = coefficient;
			
			//
			scrollIndicator.x = width + 2;
			
			// scrollbar needs redrawing to reflect available scroll area
			if( textField.maxScrollV > 1 )
			{
				scrollIndicator.visible = true;
				textField.addEventListener( Event.SCROLL, updateScrollbarPosition, false, 0, true );
				
				var visibleLines:uint = textField.bottomScrollV - ( textField.scrollV - 1 );
				var scrollH:Number = height * visibleLines / textField.numLines;
				
				var g:Graphics = scrollIndicator.graphics;
				g.clear();
				g.beginFill( ColourPalette.SLATE_BLUE, 0.3 );
				g.drawRoundRectComplex( 0, 0, 5, scrollH, 3, 3, 3, 3  );
				
				updateScrollbarPosition();
				
			}else{
				
				scrollIndicator.visible = false;
				textField.removeEventListener( Event.SCROLL, updateScrollbarPosition );
				
			}
			
			// draw border
			graphics.clear();
			if (_border) {
				graphics.lineStyle(1, 0xb7babc, 1, true, LineScaleMode.NONE);
				graphics.drawRect(0, 0, width, height);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler - text field has been scrolled.
		 * Can also be called as a normal function. 
		 * @param e
		 */		
		protected function updateScrollbarPosition( e:Event = null ):void
		{
			// NB: scrollV and maxScrollV are 1-based indices
			scrollIndicator.y = ( ( textField.scrollV - 1 ) / ( textField.maxScrollV - 1 ) ) * ( textField.height - scrollIndicator.height );
		}
		
		
		/**
		 * Processes the text, and enlarges it by parameter passed in <code>by</code>.
		 * Functionality now shelved but method kept for potential future development.
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
			// In future version other properties can be modified to.
			for (var i:int = 0; i < items.length; i ++) {
				var string:String = items[i] as String;
				if (string.toUpperCase().indexOf("SIZE=") >= 0) {
					string = "SIZE=\"" + (int(string.toUpperCase().split("SIZE=").join("").
																split("\"").join("")) + by).toString() + "\"";
					text = text.split(items[i]).join(string);
				}
			}
			return text;
		}
	}
}