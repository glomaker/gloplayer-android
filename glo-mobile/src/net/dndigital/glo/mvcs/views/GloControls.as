package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.components.Label;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
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
		 * Text field for menu link.  
		 */		
		protected const menuLink:Label = new Label;
		
		/**
		 * @private
		 * Matrix used for background gradient fill 
		 */		
		protected const fillGradientMatrix:Matrix = new Matrix;
		

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
	
			next.direction = NavButton.RIGHT;
			next.buttonMode = true;
			add(next);

			prev.direction = NavButton.LEFT;
			prev.buttonMode = true;
			add(prev);

			// menu link
			menuLink.text = "MENU";
			menuLink.selectable = false;
			menuLink.textFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
			add(menuLink);
			
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
				
				// gradient background
				fillGradientMatrix.createGradientBox(width, height, Math.PI/2);
				graphics.beginGradientFill( GradientType.LINEAR, [ ColourPalette.GRADIENT_START, ColourPalette.GRADIENT_END ], [1, 1], [0, 255], fillGradientMatrix );
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
				
				// two black strips
				var sw:Number = ScreenMaths.mmToPixels( 2 );
				graphics.beginFill( 0, 1 );
				graphics.drawRect( height, 0, sw, height );
				graphics.drawRect( width - height - sw, 0, sw, height );
				graphics.endFill();
			}
			
			prev.width = prev.height = height;
			next.width = next.height = height;

			next.x = width - next.width;
			next.y = 0;
			
			menuLink.x = ( width - menuLink.width ) / 2;
			menuLink.y = ( height - menuLink.height )/2;    
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
			else
				dispatchEvent(ProjectEvent.MENU_EVENT);
		}
	}
}