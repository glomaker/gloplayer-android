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
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import net.dndigital.utils.drawRectangle;
	
	public final class MenuButton extends GUIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(MenuButton);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const textField:TextField = new TextField;
		
		/**
		 * @private
		 */
		protected const background:Shape = new Shape;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var fileChanged:Boolean = false;
		/**
		 * @private
		 */
		protected var _file:File;
		/**
		 * file.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get file():File { return _file; }
		/**
		 * @private
		 */
		public function set file(value:File):void
		{
			if (_file == value)
				return;
			_file = value;
			fileChanged = true;
			invalidateData()
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
			mouseChildren = false;
			useHandCursor = buttonMode = mouseEnabled = true;
			
			width = 150;
			height = ScreenMaths.mmToPixels(7.5);
			return super.initialize();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			//background.blendMode = BlendMode.SUBTRACT;
			addChild(background);
			
			addChild(textField);
			textField.defaultTextFormat = new TextFormat("Verdana", 16, 0xFAFAFA);
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			background.graphics.clear();
			background.graphics.beginFill(0x000000, .75);
			background.graphics.drawRoundRect(0, 0, width, height, 25, 25);
			background.graphics.endFill();
			
			textField.x = (width - textField.width) /2;
			textField.y = (height - textField.height) / 2;
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (fileChanged) {
				var name:String = file.name.split(".glo").join("");
				if (name.toUpperCase() == "PROJECT") {
					if (file.url.indexOf("Glos") >= 0)
						name = file.url.split("Glos")[1];
					else
						name = file.url.split("app:/assets/")[1];
				}
				
				name = name.split("/").join("").
							split("\"").join("").
							split("project.glo").join("");
				
				textField.text = name;
				
				invalidateDisplay();
				
				fileChanged = false;
			}
		}
	}
}