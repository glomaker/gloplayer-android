package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.events.MouseEvent;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.BackToMenuButton;
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
		 * Text field for menu link.  
		 */		
		protected const menuLink:BackToMenuButton = new BackToMenuButton;
		

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
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
	
			add( menuLink );
			
			next.direction = NavButton.RIGHT;
			add(next);

			prev.direction = NavButton.LEFT;
			add(prev);

			// force redraw
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
				
				// background
				graphics.beginFill( 0x000000, 1 );
				graphics.drawRect( 0, 0, width, height );
				graphics.endFill();
			}

			// square nav buttons with menu button and two gaps in between
			var gap:Number = ScreenMaths.mmToPixels( 2 );

			prev.height = height;
			next.height = height;
			menuLink.height = height;
			
			prev.width = height;
			next.width = height;
			menuLink.width = width - 2*height - 2*gap;

			// positioning
			next.x = width - next.width;
			menuLink.x = ( width - menuLink.width ) / 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			invalidateDisplay();
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
			else if(event.target == menuLink)
				dispatchEvent(ProjectEvent.MENU_EVENT);
		}
	}
}