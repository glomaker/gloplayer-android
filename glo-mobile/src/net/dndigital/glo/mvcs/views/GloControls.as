package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.views.controls.NavButton;
	
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
		 * Background (Sprite so it remains interactive)
		 */
		public const bg:GUIComponent = new GUIComponent();
		
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
		override protected function createChildren():void
		{
			super.createChildren();

			add(bg);
			
			[Embed(source="assets/next.up.png")]
			const nextUpAsset:Class;
			
			[Embed(source="assets/next.down.png")]
			const nextDownAsset:Class;
			
			[Embed(source="assets/next.disabled.png")]
			const nextDisabledAsset:Class;
			
			next.upSkin = new nextUpAsset().bitmapData;
			next.downSkin = new nextDownAsset().bitmapData;
			next.disabledSkin = new nextDisabledAsset().bitmapData;
			next.addEventListener(MouseEvent.CLICK, handleClick);
			
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
			prev.addEventListener(MouseEvent.CLICK, handleClick);
			
			add(prev);
			
			invalidateDisplay();
		}

		protected function handleClick(event:MouseEvent):void
		{
			if(event.target == next)
				dispatchEvent(ProjectEvent.NEXT_PAGE_EVENT);
			else
				dispatchEvent(ProjectEvent.PREV_PAGE_EVENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);

			if (!isNaN(width+height)) {
				with (bg.graphics)
				{
					clear();
					beginFill(0x494949);
					drawRect(0, 0, width, height);
					endFill();
				}
			}
			
			//log("width={0} next.width={1}");
			next.x = width - next.width - 10;
			next.y = (height - next.height) / 2;
			
			prev.x = 10;
			prev.y = (height - prev.height) / 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			invalidateDisplay()
		}
	}
}