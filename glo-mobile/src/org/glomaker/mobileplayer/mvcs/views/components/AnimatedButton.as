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
	import com.greensock.TweenLite;
	
	import eu.kiichigo.utils.log;
	
	import flash.display.BlendMode;

	public class AnimatedButton extends IconButton
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(AnimatedButton);

		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */		
		public function AnimatedButton()
		{
			blendMode = BlendMode.LAYER;
			cacheAsBitmap = true;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var visibilityChanged:Boolean = false;
		/**
		 * @private
		 */
		protected var _visible:Boolean = true;
		/**
		 * @copy	flash.display.DisplayObject#visible
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		override public function get visible():Boolean { return _visible; }
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if (_visible == value)
				return;
			_visible = value;
			visibilityChanged = true;
			invalidateData();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (visibilityChanged) {
				const alpha:Number = _visible ? 1 : 0;
				TweenLite.to(this, .5, {alpha: alpha, onStart: animationStart, onComplete: animationComplete});
				visibilityChanged = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Handles Start of Visibility animation.
		 */
		protected function animationStart():void
		{
			super.visible = true;
		}
		
		/**
		 * @private
		 * Handles End of Visibility animation.
		 */
		protected function animationComplete():void
		{
			super.visible = _visible;
		}
	}
}