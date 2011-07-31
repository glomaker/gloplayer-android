package net.dndigital.glo.mvcs.views.components
{
	import com.greensock.TweenLite;
	
	import eu.kiichigo.utils.log;
	
	import flash.display.BlendMode;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.dndigital.components.*;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.utils.drawRectangle;
	
	/**
	 * Notifications are used by Application to notify user.
	 * 
	 * @see		net.dndigital.glo.mvcs.views.glocomponents.GloComponent
	 * @see		net.dndigital.glo.mvcs.views.GloApplication
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Notification extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(Notification);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const textField:TextField = new TextField;
		
		/**
		 * @private
		 * Timeout Id.
		 */
		protected var timeoutId:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _text:String;
		/**
		 * Text that will be shown in notification.
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
			invalidateData();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Method runs an animation and disables notification.
		 * 
		 * @param	completed	<code>Function</code> closure that will be called once animation is finished.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function remove(completed:Function):void
		{
			TweenLite.to(this, 0.5, {alpha: 0, onComplete: completed});
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
			height = ScreenMaths.mmToPixels(14);
			
			stage.addEventListener(Event.RESIZE, destroy);
			stage.addEventListener(MouseEvent.CLICK, destroy);
			
			timeoutId = setTimeout(destroy, 10000);
			
			blendMode = BlendMode.LAYER;
			filters = [ new DropShadowFilter(3, 90, 0x000000, .6, 8, 8, 1, 2) ];
			
			return super.initialize();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			textField.defaultTextFormat = new TextFormat("Verdana", 16, 0xEAEAEA, true);
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			addChild(textField);
			
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (textField.text != _text) {
				textField.text = _text;
				width = textField.width + 15; // 30 is 15 pixel padding.
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			graphics.lineStyle( 1, 0xffffff, 1, true, LineScaleMode.NONE );
			drawRectangle(this, 0x000000, width, height, .75, 25);
			
			x = (stage.fullScreenWidth - width) / 2;
			y = (stage.fullScreenHeight - height) / 2;
			textField.x = (width - textField.width) / 2;
			textField.y = (height - textField.height) / 2;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Removes notification from screen.
		 */
		protected function destroy(event:Event = null):void
		{
			clearTimeout(timeoutId);
			
			invalidateDisplay();
			validateDisplay();
			
			TweenLite.to(this, 0.5, {alpha: 0, onComplete: completed});
		}
		
		/**
		 * @private
		 */
		protected function completed():void
		{
			stage.removeEventListener(Event.RESIZE, destroy);
			stage.removeEventListener(MouseEvent.CLICK, destroy);
			
			if (parent)
				parent.removeChild(this);
		}
	}
}