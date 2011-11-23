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
package org.glomaker.mobileplayer.mvcs.views
{
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GloMenuMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloMenuMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 * An instance of GloMenu view.
		 */
		public var view:GloMenu;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{	
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, GloMenuEvent.DIRECTORY_LISTED, directoryListed);
			eventMap.mapListener(view, GloMenuEvent.LOAD_FILE, dispatch);
			
			dispatch(new GloMenuEvent(GloMenuEvent.LIST_FILES));
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(eventDispatcher, GloMenuEvent.DIRECTORY_LISTED, directoryListed);
			eventMap.unmapListener(view, GloMenuEvent.LOAD_FILE, dispatch);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * 
		 */
		protected function directoryListed(event:GloMenuEvent):void
		{
			// each time the app switches to the menu, the system re-scans the documents directory
			// that in turn results in an update call here and when the menu is updated, the scroll position is lost
			// to avoid this, we only update if the length of the files list has changed - so you can still test by adding new GLOs but don't lose out during normal use
			// it would of course be more correct to check if there are any new files but that would be too expensive
			if( view.files == null || event.files.length != view.files.length )
			{
				view.files = event.files;
			}
		}
	}
}