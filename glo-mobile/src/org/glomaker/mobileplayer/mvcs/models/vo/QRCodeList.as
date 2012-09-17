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
	import flash.utils.Dictionary;

	/**
	 * Manages a collection of QR codes and their corresponding GLOs.
	 * 
	 * @author haykel
	 * 
	 */
	public class QRCodeList
	{
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		/**
		 * Disctionary of QR Code -> GLO.
		 */
		protected var dict:Dictionary = new Dictionary();
		
		//--------------------------------------------------
		// length
		//--------------------------------------------------
		
		/**
		 * @private
		 */
		private var _length:uint = 0;
		
		/**
		 * Returns the number of elements in the list.
		 */
		public function get length():uint
		{
			return _length;
		}
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Removes all elements from the list.
		 */
		public function clear():void
		{
			dict = new Dictionary();
			_length = 0;
		}
		
		/**
		 * Adds an element to the list. Entries with the same qrCode are replaced.
		 */
		public function add(qrCode:String, glo:Glo):void
		{
			if (qrCode && glo)
			{
				if (dict[qrCode] == undefined)
					_length++;
				
				dict[qrCode] = glo;
			}
		}
		
		/**
		 * Returns the GLO associated with the specified QR code if found, <code>null</null> otherwise.
		 */
		public function get(qrCode:String):Glo
		{
			return qrCode ? (dict[qrCode] as Glo) : null;
		}
	}
}