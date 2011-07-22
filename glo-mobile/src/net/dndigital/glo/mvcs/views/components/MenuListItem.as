package net.dndigital.glo.mvcs.views.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
	
	import thanksmister.touchlist.events.ListItemEvent;
	import thanksmister.touchlist.renderers.ITouchListItemRenderer;

	/**
	 * List item for the menu list.
	 * This is a copy of the TouchListItemRenderer from thanksmister with some tweaks.
	 * @author nilsmillahn
	 */	
	public class MenuListItem extends Sprite implements ITouchListItemRenderer
	{
		protected var _data:Object;
		protected var _index:Number = 0;
		protected var _itemWidth:Number = 0;
		protected var _itemHeight:Number = 0;
		
		protected var initialized:Boolean = false;
		protected var textField:TextField;
		protected var shadowFilter:DropShadowFilter;
		
		//-------- properites -----------
		
		public function get itemWidth():Number
		{
			return _itemWidth;
		}
		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
			draw();
		}
		
		public function get itemHeight():Number
		{
			return _itemHeight;
		}
		public function set itemHeight(value:Number):void
		{
			_itemHeight = value;
			draw();
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
			draw();
		}
		
		public function get index():Number
		{
			return _index;
		}
		public function set index(value:Number):void
		{
			_index = value;
		}
		
		public function MenuListItem()
		{
			addEventListener(Event.REMOVED, destroy);
			addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			
			createChildren();
		}
		
		//-------- public methods -----------
		
		/**
		 * Show our item in default state.
		 * */
		public function unselectItem():void
		{
			removeEventListener(MouseEvent.MOUSE_UP, selectHandler);
			draw();
		}
		
		/**
		 * Show our item selected.
		 * */
		public function selectItem():void
		{
			addEventListener(MouseEvent.MOUSE_UP, selectHandler);
			
			this.graphics.clear();
			
			this.graphics.beginFill( ColourPalette.HIGHLIGHT_BLUE, .9);
			this.graphics.drawRect(0, 0, itemWidth, itemHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xEAEAEA, .5);
			this.graphics.drawRect(0, _itemHeight - 1, itemWidth, .5);
			this.graphics.endFill();
			
			this.filters = [shadowFilter];
		}
		
		//-------- protected methods -----------
		
		/**
		 * Install the DroidSans front from Google:
		 * http://code.google.com/webfonts/family?family=Droid+Sans
		 * */
		protected function createChildren():void
		{
			if(!textField) {
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = 0xEAEAEA;
				textFormat.size = 24;
				textFormat.font = "Arial";
				
				textField = new TextField();
				textField.mouseEnabled = false;
				textField.defaultTextFormat = textFormat;
				
				this.addChild(textField);
			}
			
			initialized = true;
			
			draw();
			
			shadowFilter = new DropShadowFilter(3, 90, 0x000000, .6, 8, 8, 1, 2, true);
		}
		
		protected function draw():void
		{
			if(!initialized) return 
				
			textField.x = 5;
			textField.text = String(data);
			
			var lm:TextLineMetrics = textField.getLineMetrics(0);
			textField.height = lm.height + lm.descent;
			
			textField.width = itemWidth - 10;
			textField.y = ( itemHeight - textField.height )/2;
			
			this.graphics.clear();
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, itemWidth, itemHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xEAEAEA, .5);
			this.graphics.drawRect(0, itemHeight - 1, itemWidth, .5);
			this.graphics.endFill();
			
			this.filters = [];
		}
		
		/**
		 * Clean up item when removed from stage.
		 * */
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED, destroy);
			removeEventListener(MouseEvent.MOUSE_UP, selectHandler);
			
			this.removeChild(textField);
			
			this.graphics.clear();
			this.filters = [];
			
			textField = null;
			shadowFilter = null;
			_data = null;
			
			initialized = false;
		}
		
		// ----- event handlers --------
		
		/**
		 * Dispatched when item is first pressed on tap or mouse down.
		 * */
		protected function pressHandler(e:Event):void
		{
			this.dispatchEvent( new ListItemEvent(ListItemEvent.ITEM_PRESS, this, true) );
		}
		
		/**
		 * Dispatched when item is selected, usually on touch end or mouse up.
		 * */
		protected function selectHandler(e:Event):void
		{
			this.dispatchEvent( new ListItemEvent(ListItemEvent.ITEM_SELECTED, this, true) );
		}
	}
}