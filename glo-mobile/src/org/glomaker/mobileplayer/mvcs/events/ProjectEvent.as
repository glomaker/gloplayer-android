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
	
	import org.glomaker.mobileplayer.mvcs.models.vo.Project;

	public final class ProjectEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Cached Events
		//
		//--------------------------------------------------------------------------
		
		public static const NEXT_PAGE_EVENT:ProjectEvent = new ProjectEvent(ProjectEvent.NEXT_PAGE);
		public static const PREV_PAGE_EVENT:ProjectEvent = new ProjectEvent(ProjectEvent.PREV_PAGE);
		public static const MENU_EVENT:ProjectEvent = new ProjectEvent(ProjectEvent.MENU);

		//--------------------------------------------------------------------------
		//
		//  Event Types Constants
		//
		//--------------------------------------------------------------------------
		
		public static const PROJECT:String = "project";
		public static const PAGE:String = "page";
		public static const PAGE_CHANGED:String = "pageChanged";
		public static const NEXT_PAGE:String = "nextPage";
		public static const PREV_PAGE:String = "prevPage";
		public static const MENU:String = "menu";
		public static const GLO_VALIDATE_ERROR:String = "glovalidateerror";
		

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProjectEvent(type:String, project:Project = null, index:int = -1)
		{
			super(type);

			_project = project;
			_index = index;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _project:Project;
		/**
		 * Reference to an instance of <code>Project</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Project
		 */
		public function get project():Project { return _project }
		
		/**
		 * @private
		 */
		protected var _index:int = -1;
		/**
		 * Index of a page to switch to.
		 */
		public function get index():int { return _index; }

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
			return new ProjectEvent(type, _project, _index);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("ProjectEvent", "project", "index");
		}
	}
}