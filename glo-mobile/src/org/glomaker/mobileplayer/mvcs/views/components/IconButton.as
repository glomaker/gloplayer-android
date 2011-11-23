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
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.utils.describeType;
	
	import net.dndigital.components.Button;
	
	import org.bytearray.display.ScaleBitmap;
	
	public class IconButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(IconButton);
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * An instance of Bitmap that will hold current graphical asset.
		 */
		protected const bitmap:ScaleBitmap = new ScaleBitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Up Skin for <code>NavButton</code>
		 */
		public var upSkin:Object = null;
		
		/**
		 * Down Skin for <code>NavButton</code>
		 */
		public var downSkin:Object = null;
		
		/**
		 * Disabled Skin for <code>NavButton</code>
		 */
		public var disabledSkin:Object = null;
		
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
			
			bitmap.smoothing = true;
			addChild(bitmap);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(state:String):void
		{
			super.stateChanged(state);
			
			if (this[state + "Skin"] != null)
				bitmap.bitmapData = snapshot(this[state + "Skin"]);
			
			invalidateDisplay();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			bitmap.setSize(width, height);
			// FIXME make it proper within component framework.
			if(owner)
			   owner.invalidateDisplay();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Takes snapshot of DisplayObject if needed.
		 */
		protected function snapshot(source:IBitmapDrawable):BitmapData
		{
			if (source is BitmapData)
				return source as BitmapData;
			else if ((source as Object).hasOwnProperty("bitmapData"))
				return (source as Object).bitmapData as BitmapData
			else {
				const bitmapData:BitmapData = new BitmapData((source as Object).width, (source as Object).height);
					  bitmapData.draw(source);
				return bitmapData;
			}
		}
	}
}