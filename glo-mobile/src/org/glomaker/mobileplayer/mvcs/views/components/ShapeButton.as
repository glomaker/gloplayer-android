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
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import net.dndigital.components.Button;
	
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.utils.DrawingUtils;
	
	/**
	 * Base class for buttons that use a shape to draw their icons through actionscript.
	 * 
	 * @author haykel
	 */
	public class ShapeButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(ShapeButton);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Shape
		 */
		protected const shape:Shape = new Shape;
		protected const hit:Sprite = new Sprite;
		
		protected var downColour:uint = ColourPalette.HIGHLIGHT_BLUE;
		protected var disabledColour:uint = ColourPalette.DISABLED_BLUE;
		
		//--------------------------------------------------------------------------
		//
		//  Protected Functions
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Draw shape. Override by subclasses.
		 */
		protected function drawShape():void
		{
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

			// shape shape - always the same size, centred around origin
			drawShape();
			addChild(shape);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(newState:String):void
		{
			super.stateChanged(newState);
			setShapeColour();
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
			
			// centre shape
			shape.x = width / 2;
			shape.y = height / 2;
		}
		
		/**
		 * Changes shape colour. 
		 */		
		protected function setShapeColour():void
		{
			var t:ColorTransform = new ColorTransform();
			
			switch( state )
			{
				case DOWN:
					t.color = downColour;
					break;
				
				case DISABLED:
					t.color = disabledColour;
					break;
				
				default: // UP : no color transfoms
					break;
			}

			// apply
			shape.transform.colorTransform = t;
		}
	}
}