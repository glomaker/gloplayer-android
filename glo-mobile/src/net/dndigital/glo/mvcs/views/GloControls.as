package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.components.Label;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.NavButton;
	
	/**
	 * View controls flow and playback of the <code>GloPlayer</code> view, and handles page swaping.
	 * 
	 * @see		net.dndigital.components.UIComponent
	 * @see		net.dndigital.components.Container
	 * @see		net.dndigital.glo.mvcs.views.GloPlayer
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloControls extends Container implements IGloView
	{		
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloControls);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Next navigation button.
		 */
		protected const next:NavButton = new NavButton;
		
		/**
		 * @private
		 * Previous navigation button.
		 */
		protected const prev:NavButton = new NavButton;
		
		/**
		 * @private
		 * Text Field indicates slide progress.
		 */
		protected const progress:Label = new Label;
		
		/**
		 * @private
		 * Flag, indicates whether <code>progress</code> text field should be redrawn or not.
		 */
		protected var progressChanged:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _currentPage:int = -1;
		/**
		 * currentPage.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get currentPage():int { return _currentPage; }
		/**
		 * @private
		 */
		public function set currentPage(value:int):void
		{
			if (_currentPage == value)
				return;
			_currentPage = value;
			progressChanged = true;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _totalPages:int = -1;
		/**
		 * totalPages.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get totalPages():int { return _totalPages; }
		/**
		 * @private
		 */
		public function set totalPages(value:int):void
		{
			if (_totalPages == value)
				return;
			_totalPages = value;
			progressChanged = true;
			invalidateData();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Locks and unlocks navigation buttons.
		 * 
		 * @param	prev	Indicates whether previous navigation control should be disabled or not.
		 * @param	next	Indicates whether next navigation control should be disabled or not.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function lock(prev:Boolean = false, next:Boolean = false):void
		{
			this.prev.enabled = !prev;
			this.next.enabled = !next;
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
			addEventListener(MouseEvent.CLICK, handleClick);
			
			return super.initialize();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			[Embed(source="assets/next.up.png")]
			const nextUpAsset:Class;
			
			[Embed(source="assets/next.down.png")]
			const nextDownAsset:Class;
			
			[Embed(source="assets/next.disabled.png")]
			const nextDisabledAsset:Class;
			
			next.upSkin = new nextUpAsset().bitmapData;
			next.downSkin = new nextDownAsset().bitmapData;
			next.disabledSkin = new nextDisabledAsset().bitmapData;
			
			add(next);

			[Embed(source="assets/prev.up.png")]
			const prevUpAsset:Class;
			
			[Embed(source="assets/prev.down.png")]
			const prevDownAsset:Class;
			
			[Embed(source="assets/prev.disabled.png")]
			const prevDisabledAsset:Class;
			
			prev.upSkin = new prevUpAsset().bitmapData;
			prev.downSkin = new prevDownAsset().bitmapData;
			prev.disabledSkin = new prevDisabledAsset().bitmapData;
			
			add(prev);
			
			// Size component according to screen dpi
			next.width = next.height = prev.width = prev.height = ScreenMaths.mmToPixels(9.5);
			
			progress.selectable = false;
			progress.textFormat = new TextFormat("Verdana", 18, 0xBBBBBB);
			add(progress);
			
			invalidateDisplay();
		}

		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);

			if (!isNaN(width+height)) {
				graphics.clear();
				graphics.beginFill(0x494949);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
			
			next.x = width - next.width - 10;
			next.y = (height - next.height) / 2;
			
			prev.x = 10;
			prev.y = (height - prev.height) / 2;
			
			progress.x = (width - progress.width) / 2;
			progress.y = (height - progress.height) / 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			invalidateDisplay();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (progressChanged) {
				progress.visible = _currentPage != -1 && _totalPages != -1;
				progress.text = "Slide " + ( _currentPage + 1).toString() + " of " + _totalPages.toString();
				invalidateDisplay();
				progressChanged = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handles mouse events generated by <code>GloControl</code>
		 */
		protected function handleClick(event:MouseEvent):void
		{
			if (event.target == next)
				dispatchEvent(ProjectEvent.NEXT_PAGE_EVENT);
			else if(event.target == prev)
				dispatchEvent(ProjectEvent.PREV_PAGE_EVENT);
			else if(event.stageX > 100 && event.stageX < stage.stageWidth - 100)
				dispatchEvent(ProjectEvent.MENU_EVENT);
		}
	}
}