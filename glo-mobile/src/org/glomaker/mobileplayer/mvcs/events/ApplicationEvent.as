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

	public final class ApplicationEvent extends Event
	{
		// Cached pre-allocated events.
		public static const ACTIVATE_EVENT:ApplicationEvent = new ApplicationEvent(ACTIVATE);
		public static const DEACTIVATE_EVENT:ApplicationEvent = new ApplicationEvent(DEACTIVATE);
		public static const SHOW_MENU_EVENT:ApplicationEvent = new ApplicationEvent(SHOW_MENU);
		public static const SHOW_PLAYER_EVENT:ApplicationEvent = new ApplicationEvent(SHOW_PLAYER);
		public static const SHOW_JOURNEY_MANAGER_EVENT:ApplicationEvent = new ApplicationEvent(SHOW_JOURNEY_MANAGER);
		public static const SHOW_QR_CODE_READER_EVENT:ApplicationEvent = new ApplicationEvent(SHOW_QR_CODE_READER);
		public static const HIDE_QR_CODE_READER_EVENT:ApplicationEvent = new ApplicationEvent(HIDE_QR_CODE_READER);
		public static const ENTER_FULL_SCREEN_EVENT:ApplicationEvent = new ApplicationEvent(ENTER_FULL_SCREEN);
		public static const LEAVE_FULL_SCREEN_EVENT:ApplicationEvent = new ApplicationEvent(LEAVE_FULL_SCREEN);

		// Event constants, per ActionScript Event Model best practices
		public static const ACTIVATE:String = "ApplicationEvent.Activate";
		public static const DEACTIVATE:String = "ApplicationEvent.Deactivate";
		public static const SHOW_MENU:String = "showMenu";
		public static const SHOW_PLAYER:String = "showPlayer";
		public static const SHOW_JOURNEY_MANAGER:String = "showJourneyManager";
		public static const SHOW_QR_CODE_READER:String = "showQRCodeReader";
		public static const HIDE_QR_CODE_READER:String = "hideQRCodeReader";
		public static const ENTER_FULL_SCREEN:String = "enterFullScreen";
		public static const LEAVE_FULL_SCREEN:String = "leaveFullScreen";
		
		public static const INITIALIZED:String = "initialized";

		
		/**
		 * @Constructor 
		 * @param type
		 */		
		public function ApplicationEvent(type:String)
		{
			super(type);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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
			return new ApplicationEvent(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("ApplicationEvent");
		}
	}
}