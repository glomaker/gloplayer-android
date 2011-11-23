/* 
* GLO Mobile Player: Copyright (c) 2011 LTRI, University of West London. An
* Open Source Release under the GPL v3 licence (see http://www.gnu.org/licenses/).
* Authors: DN Digital Ltd, Tom Boyle, Lyn Greaves, Carl Smith.

* This program is free software: you can redistribute it and/or modify it under the terms 
* of the GNU General Public License as published by the Free Software Foundation, 
* either version 3 of the License, or (at your option) any later version. This program
* is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* 
* For GNU Public licence see http://www.gnu.org/licenses/ or http://www.opensource.org/licenses/.
*
* External libraries used:
*
* Greensock Tweening Library (TweenLite), copyright Greensock Inc
* "NO CHARGE" NON-EXCLUSIVE SOFTWARE LICENSE AGREEMENT
* http://www.greensock.com/terms_of_use.html
*	
* A number of utility classes Copyright (c) 2008 David Sergey, published under the MIT license
*
* A number of utility classes Copyright (c) DN Digital Ltd, published under the MIT license
*
* The ScaleBitmap class, released open-source under the RPL license (http://www.opensource.org/licenses/rpl.php)
*/
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