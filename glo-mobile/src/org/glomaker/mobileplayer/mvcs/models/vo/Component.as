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
package org.glomaker.mobileplayer.mvcs.models.vo
{
	import eu.kiichigo.utils.formatToString;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	/**
	 * ValueObject. Represents data for Component.
	 * 
	 * @see		net.dndigital.glo.mvcs.models.vo.Node
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Component
	{
		/**
		 * @private
		 */
		protected var _id:String;
		/**
		 * Component's Id.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get id():String { return _id; }
		/**
		 * @private
		 */
		public function set id(value:String):void
		{
			if (_id == value)
				return;
			_id = value;
		}
		
		/**
		 * @private
		 */
		protected var _x:Number;
		/**
		 * Indicates position along horizontal axis of a Component.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get x():Number { return _x; }
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			if (_x == value)
				return;
			_x = value;
		}
		
		/**
		 * @private
		 */
		protected var _y:Number;
		/**
		 * Indicates position along vertical axis of a Component.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get y():Number { return _y; }
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			if (_y == value)
				return;
			_y = value;
		}
		
		/**
		 * @private
		 */
		protected var _width:Number;
		/**
		 * Indicates component's width.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get width():Number { return _width; }
		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			if (_width == value)
				return;
			_width = value;
		}
		
		/**
		 * @private
		 */
		protected var _height:Number;
		/**
		 * Indicates component's height.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get height():Number { return _height; }
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			if (_height == value)
				return;
			_height = value;
		}
		
		/**
		 * @private
		 */
		protected var _data:Object;
		/**
		 * Data structure to hold any additional/extra properties for current component.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get data():Object { return _data; }
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if (_data == value)
				return;
			_data = value;
		}
		
		/**
		 * @private
		 */
		protected var _directory:File;
		/**
		 * Directory of the project.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get directory():File { return _directory; }
		/**
		 * @private
		 */
		public function set directory(value:File):void
		{
			if (_directory == value)
				return;
			_directory = value;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  toString
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns a string containing some of instance's properties.
		 * 
		 * @return	Class name and some of instance properties and values.
		 */
		public function toString():String
		{
			return eu.kiichigo.utils.formatToString(this, "id", "x", "y", "width", "height", "data", "directory");
		}
	}
}