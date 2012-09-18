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
package org.glomaker.mobileplayer.mvcs.models
{
	import eu.kiichigo.utils.formatToString;
	
	import flash.events.Event;
	
	import org.glomaker.mobileplayer.mvcs.events.GloModelEvent;
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Journey;
	import org.glomaker.mobileplayer.mvcs.models.vo.Page;
	import org.glomaker.mobileplayer.mvcs.models.vo.Project;
	import org.glomaker.mobileplayer.mvcs.models.vo.QRCodeList;
	import org.robotlegs.mvcs.Actor;

	public class GloModel extends Actor
	{
		/**
		 * @private
		 */
		protected var _index:int = -1;
		/**
		 * index.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get index():int { return _index; }
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			if (_index == value)
				return;
			_index = value;
			dispatch(new ProjectEvent(ProjectEvent.PAGE, null, _index));
		}
		
		/**
		 * @private
		 */
		protected var _length:int = -1;
		/**
		 * length.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get length():int { return _length; }
		/**
		 * @private
		 */
		public function set length(value:int):void
		{
			if (_length == value)
				return;
			_length = value;
		}
		
		/**
		 * @private
		 */
		private var _qrCodes:QRCodeList;
		/**
		 * List of available QR codes.
		 */
		public function get qrCodes():QRCodeList
		{
			return _qrCodes;
		}
		/**
		 * @private
		 */
		public function set qrCodes(value:QRCodeList):void
		{
			if (value == _qrCodes)
				return
				
			_qrCodes = value;
			
			dispatch(new GloModelEvent(GloModelEvent.QR_CODES_LISTED));
		}

		/**
		 * @private
		 */
		private var _journey:Journey;
		/**
		 * Current journey. Can be either the journey currently managed by the
		 * journey manager or a journey to which belongs the currently displayed GLO.
		 */
		public function get journey():Journey
		{
			return _journey;
		}
		/**
		 * @private
		 */
		public function set journey(value:Journey):void
		{
			if (value == _journey)
				return;
			
			_journey = value;
			
			dispatch(new GloModelEvent(GloModelEvent.JOURNEY_CHANGED));
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
			return eu.kiichigo.utils.formatToString(this, "index", "length");
		}
	}
}