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
	
	public class FileServiceEvent extends Event
	{

		public static const APPDIR_SCAN_COMPLETED_EVENT:FileServiceEvent = new FileServiceEvent( FileServiceEvent.APPDIR_SCAN_COMPLETED );
		public static const DOCUMENTS_SCAN_COMPLETED_EVENT:FileServiceEvent = new FileServiceEvent( FileServiceEvent.DOCUMENTS_SCAN_COMPLETED );
		
		public static const APPDIR_SCAN_COMPLETED:String = "AppDirScanCompleted";
		public static const DOCUMENTS_SCAN_COMPLETED:String = "DocumentScanCompleted";
		
		
		/**
		 * @constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function FileServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc 
		 */		
		override public function clone():Event
		{
			return new FileServiceEvent( type, bubbles, cancelable );
		}
	}
}