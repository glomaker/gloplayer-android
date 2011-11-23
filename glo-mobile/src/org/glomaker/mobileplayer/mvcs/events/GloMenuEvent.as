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
package org.glomaker.mobileplayer.mvcs.events
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;

	public class GloMenuEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Cached Events
		//
		//--------------------------------------------------------------------------
		
		public static const LIST_FILES_EVENT:GloMenuEvent = new GloMenuEvent(GloMenuEvent.LIST_FILES);
		
		//--------------------------------------------------------------------------
		//
		//  Event Types Constants
		//
		//--------------------------------------------------------------------------
		
		public static const LIST_FILES:String = "listFiles";
		public static const DIRECTORY_LISTED:String = "directoryListed";
		public static const LOAD_FILE:String = "loadFile";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function GloMenuEvent(type:String, file:File = null, files:Vector.<Glo> = null)
		{
			super(type);

			_file = file;
			_files = files;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _file:File;
		/**
		 * File selected via <code>GloMenu</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.view.GloMenu
		 */
		public function get file():File { return _file }
		
		/**
		 * @private
		 */
		protected var _files:Vector.<Glo>;
		/**
		 * Collection of files.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get files():Vector.<Glo> { return _files; }
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new GloMenuEvent(type, _file, _files);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("GloMenuEvent", "file", "files");
		}
	}
}