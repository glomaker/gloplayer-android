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
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import net.dndigital.components.GUIComponent;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.utils.DrawingUtils;
	
	/**
	 * View component to display the GLOMaker logo. 
	 * @author nilsmillahn
	 */	
	public class LogoHeader extends GUIComponent
	{
		
		[Embed(source="../assets/glomaker-logo.png")]
		protected static const LogoAsset:Class;
		
		[Embed(source="../assets/glomaker-swoosh.png")]
		protected static const SwooshAsset:Class;

		protected var logo:Bitmap;
		protected var swoosh:Bitmap;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if( !swoosh )
			{
				swoosh = new SwooshAsset();
				addChild( swoosh );
			}

			if( !logo )
			{
				logo = new LogoAsset();
				addChild( logo );
			}
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// vertical positioning
			logo.y = ( height - logo.height ) / 2;
			swoosh.y = height - swoosh.height;
			
			// horizontal positioning
			logo.x = 10;
			swoosh.x = width - swoosh.width + 10;
			
			// gradient background
			DrawingUtils.drawStandardGradient( graphics, width, height );
			
			// white line for bottom border
			graphics.lineStyle( 1, 0xffffff, 1, true );
			graphics.moveTo( 0, height );
			graphics.lineTo(width, height);
			
		}
		
	}
}