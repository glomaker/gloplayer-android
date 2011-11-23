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

	/**
	 * ValueObject. Represents data about Glo Project.
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
	public class Project
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _width:uint;
		
		/**
		 * Glo Project's width.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get width():uint { return _width; }
		/**
		 * @private
		 */
		public function set width(value:uint):void
		{
			if (_width == value)
				return;
			_width = value;
		}
		
		
		/**
		 * @private
		 */
		private var _height:uint;
		
		/**
		 * Glo Project's height.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get height():uint { return _height; }
		/**
		 * @private
		 */
		public function set height(value:uint):void
		{
			if (_height == value)
				return;
			_height = value;
		}
		
		
		/**
		 * @private
		 */
		private var _background:uint = 16777215;
		
		/**
		 * Background. Default value is white ( #FFFFFF, 16777215 ).
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get background():uint { return _background; }
		/**
		 * @private
		 */
		public function set background(value:uint):void
		{
			if ( _background == value )
				return;
			_background = value;
		}
		
		/**
		 * @private
		 */
		protected var _directory:File;
		/**
		 * Indicates <code>Project</code>'s home directory for it's local path resolving.
		 * 
		 * @see		flash.filesystem.File
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
		
		
		/**
		 * @private
		 */
		private var _hasFullPaths:Boolean;
		
		/**
		 * Indicates whether file path are absolute (full) or relative.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get hasFullPaths():Boolean { return _hasFullPaths; }
		/**
		 * @private
		 */
		public function set hasFullPaths(value:Boolean):void
		{
			if (_hasFullPaths == value)
				return;
			_hasFullPaths = value;
		}
		
		
		/**
		 * @private
		 */
		private var _pages:Vector.<Page>;
		
		/**
		 * Collection of nodes that belong to current Glo Project
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get pages():Vector.<Page> { return _pages; }
		/**
		 * @private
		 */
		public function set pages(value:Vector.<Page>):void
		{
			if (_pages == value)
				return;
			_pages = value;
		}
		
		/**
		 * @private
		 */
		protected var _length:int;
		/**
		 * Length of the Project in number of pages.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get length():int{ return int(_pages) || _pages.length; }
		
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
			return eu.kiichigo.utils.formatToString(this, "width", "height", "background", "hasFullPaths", "length", "pages", "directory");
		}
	}
}