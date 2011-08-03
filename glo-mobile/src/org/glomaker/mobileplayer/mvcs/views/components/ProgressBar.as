package org.glomaker.mobileplayer.mvcs.views.components
{
	import flash.display.Graphics;
	import net.dndigital.components.GUIComponent;
	
	/**
	 * Displays progress through the slides as a graphical bar. 
	 * @author nilsmillahn
	 */	
	public class ProgressBar extends GUIComponent
	{

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _percent:Number = 0;
		protected var _bgColour:uint = 0x000000;
		protected var _barColour:uint = 0xffffff;
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Set current progress percentage (0 to 1) 
		 * @param value
		 */		
		public function set percent( value:Number ):void
		{
			if( value != _percent )
			{
				_percent = Math.max( 0, Math.min( 1, value ) );
				invalidateDisplay();
			}
		}

		/**
		 * Set colour to use for the progress bar background. 
		 * @param value
		 */		
		public function set bgColour( value:uint ):void
		{
			if( value != _bgColour )
			{
				_bgColour = value;
				invalidateDisplay();
			}
		}

		/**
		 * Set colour to use for the progress bar indicator strip. 
		 * @param value
		 */		
		public function set barColour( value:uint ):void
		{
			if( value != _barColour )
			{
				_barColour = value;
				invalidateDisplay();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  GUIComponent Lifecycle methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc 
		 * @param width
		 * @param height
		 */		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// clear
			var g:Graphics = graphics;
			g.clear();
			
			// background
			g.beginFill( _bgColour, 1 );
			g.drawRect( 0, 0, width, height );
			g.endFill();
			
			// progress indicator
			g.beginFill( _barColour, 1 );
			g.drawRect( 0, 0, width * _percent, height );
		}
		
	}
}