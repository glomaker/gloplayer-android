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
	
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.models.vo.Project;
	
	public class LoadProjectEvent extends Event
	{
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		// operations
		public static const LOAD:String = "load"; //load only
		public static const SHOW:String = "show"; //load and show
		public static const CANCEL:String = "cancel";
		
		// results
		public static const COMPLETE:String = "complete"; //load complete as response to LOAD
		public static const READY:String = "ready"; //load complete as response to SHOW
		public static const CANCELED:String = "canceled";
		public static const VALIDATE_ERROR:String = "validateError";
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		/**
		 * The GLO associated with the event.
		 */
		public var glo:Glo;
		
		/**
		 * If the GLO was loaded and validated successfully, this property holds
		 * the created project.
		 */
		public var project:Project;
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function LoadProjectEvent(type:String, glo:Glo=null, project:Project=null)
		{
			super(type);
			
			this.glo = glo;
			this.project = project;
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new LoadProjectEvent(type, glo, project);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("LoadProjectEvent", "type", "glo", "project");
		}
	}
}