package net.dndigital.glo.mvcs.views.controls
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.UIComponent;
	
	public class Controls extends Container
	{		
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(Controls);
		
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
			
			add(next);
			add(prev);
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
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			
			log("measure()");
		}
	}
}