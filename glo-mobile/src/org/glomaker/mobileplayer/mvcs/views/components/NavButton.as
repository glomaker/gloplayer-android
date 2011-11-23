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
	import eu.kiichigo.utils.log;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.describeType;
	
	import net.dndigital.components.Button;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.utils.DrawingUtils;
	
	import org.bytearray.display.ScaleBitmap;
	
	public final class NavButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(NavButton);
		
		//--------------------------------------------------------------------------
		//
		//  State Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public static const UP:String = "up";
		
		/**
		 * @private
		 */
		public static const DOWN:String = "down";
		
		/**
		 * @private
		 */
		public static const DISABLED:String = "disabled";
		
		public static const LEFT:String = "pointLeft";
		public static const RIGHT:String = "pointRight";
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Arrow shape
		 */
		protected const arrow:Shape = new Shape;
		protected const hit:Sprite = new Sprite;
		
		protected var _direction:String = RIGHT;
		
		protected var _arrowUpColour:uint = 0xffffff;
		protected var _arrowDownColour:uint = ColourPalette.HIGHLIGHT_BLUE;
		protected var _arrowDisabledColour:uint = ColourPalette.DISABLED_BLUE;
		protected var _colourChanged:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function set direction( value:String ):void
		{
			if( value != _direction )
			{
				_direction = value;
				invalidateDisplay();
			}
		}
		
		public function set arrowUpColour( value:uint ):void
		{
			if( value != _arrowUpColour )
			{
				_arrowUpColour = value;
				_colourChanged = true;
				invalidateData();
			}
		}
		
		public function set arrowDownColour( value:uint ):void
		{
			if( value != _arrowDownColour )
			{
				_arrowDownColour = value;
				_colourChanged = true;
				invalidateData();
			}
		}
		
		public function set arrowDisabledColour( value:uint ):void
		{
			if( value != _arrowDisabledColour )
			{
				_arrowDisabledColour = value;
				_colourChanged = true;
				invalidateData();
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
		override protected function createChildren():void
		{
			super.createChildren();
			
			// hit area
			addChild( hit );
			hitArea = hit;
			hit.visible = false;

			// arrow shape - always the same size, centred around origin
			arrow.graphics.clear();
			arrow.graphics.beginFill( 0xffffff, 1 );
			arrow.graphics.moveTo( -15, -10 );
			arrow.graphics.lineTo( 15, 0 );
			arrow.graphics.lineTo( -15, 10 );
			arrow.graphics.lineTo( -15, -10 );
			arrow.graphics.endFill();
			addChild(arrow);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(newState:String):void
		{
			super.stateChanged(newState);
			setArrowColour();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function commited():void
		{
			super.commited();
			setArrowColour();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// hit area
			hit.graphics.clear();
			hit.graphics.beginFill( 0xff0000, 1 );
			hit.graphics.drawRect( 0, 0, width, height );
			
			// gradient background
			DrawingUtils.drawStandardGradient( graphics, width, height );

			// rotate arrow
			_direction == LEFT ? arrow.scaleX = -1 : arrow.scaleX = 1;
			
			// centre arrow
			arrow.x = width / 2;
			arrow.y = height / 2;
		}
		
		
		/**
		 * Changes arrow colour. 
		 */		
		protected function setArrowColour():void
		{
			var t:ColorTransform = new ColorTransform();
			
			switch( state )
			{
				case DOWN:
					t.color = _arrowDownColour;
					break;
				
				case DISABLED:
					t.color = _arrowDisabledColour;
					break;
				
				default:
					t.color = _arrowUpColour;
					break;
			}

			// apply
			arrow.transform.colorTransform = t;
		}
	}
}