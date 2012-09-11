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

package org.glomaker.mobileplayer.mvcs.services
{
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Prepares the GLOs scanned from the application/documents directories before they
	 * are displayed in the menu.
	 * 
	 * @author haykel
	 * 
	 */
	public class PrepareGLOsService extends Actor
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var currentIndex:int = -1;
		
		//--------------------------------------------------
		// glos
		//--------------------------------------------------
		
		private var _glos:Vector.<Glo>;

		/**
		 * The scanned GLOs to be processed.
		 */
		public function get glos():Vector.<Glo>
		{
			return _glos;
		}

		/**
		 * @private
		 */
		public function set glos(value:Vector.<Glo>):void
		{
			if (value == glos)
				return;
			
			_glos = value;
			
			start();
		}
		
		//--------------------------------------------------
		// result
		//--------------------------------------------------
		
		private var _result:Vector.<Glo>;

		/**
		 * The result of the processing. Contains the GLOs to display in the menu.
		 */
		public function get result():Vector.<Glo>
		{
			return _result;
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Starts the preparation process.
		 */
		protected function start():void
		{
			_result = new Vector.<Glo>();
			currentIndex = -1;
			
			eventMap.mapListener(eventDispatcher, ProjectEvent.PROJECT, projectHandler, ProjectEvent);
			loadNext();
		}
		
		/**
		 * Loads the next GLO in the list.
		 */
		protected function loadNext():void
		{
			if (!glos || (currentIndex + 1) >= glos.length)
			{
				eventMap.unmapListener(eventDispatcher, ProjectEvent.PROJECT, projectHandler, ProjectEvent);
				
				// alphabetical sort
				_result.sort( sortF ); 
				
				// pass on to application
				dispatch(new GloMenuEvent(GloMenuEvent.DIRECTORY_LISTED, null, _result));
				
				// force app to show menu as dispatched ProjectEvent.PROJECT events make the app clear
				// the screen and prepare for displaying a GLO
				dispatch(ApplicationEvent.SHOW_MENU_EVENT);
				
				return;
			}
			
			currentIndex++;
			dispatch(new GloMenuEvent(GloMenuEvent.LOAD_FILE, glos[currentIndex].file));
		}
		
		/**
		 * Sort function to carry out an alphabetical comparison.
		 * @param g1
		 * @param g2
		 * @return 0 if equal, 1 if g1 > g2, -1 if g2 < g1
		 */		
		protected function sortF( g1:Glo, g2:Glo ):int
		{
			var n1:String = g1.displayName.toLowerCase();
			var n2:String = g2.displayName.toLowerCase();
			
			if( n1 > n2 )
			{
				return 1;
			}else if( n1 < n2 ){
				return -1;
			}
			
			return 0;
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Called when a project is loaded.
		 */
		protected function projectHandler(event:ProjectEvent):void
		{
			_result.push(glos[currentIndex]);
			
			loadNext();
		}
	}
}