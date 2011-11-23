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
	import flash.filesystem.File;

	/**
	 * Value object
	 * Represents data about a GLO available in the file system.
	 * Not to be confused with Project which represent an actual loaded GLO.
	 * @author nilsmillahn
	 */	
	public class Glo
	{
		
		public var file:File;
		public var displayName:String;

		/**
		 * @constructor 
		 * @param file
		 * @param displayName
		 */		
		public function Glo( file:File, displayName:String )
		{
			this.file = file;
			this.displayName = displayName;
		}

		
		/**
		 * Returns a string containing some of instance's properties.
		 * @return	Class name and some of instance properties and values.
		 */
		public function toString():String
		{
			return "Glo Value Object - " + displayName;
		}
		
	}
}