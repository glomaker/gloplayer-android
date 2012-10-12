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
	import org.glomaker.mobileplayer.mvcs.events.BusyIndicatorEvent;
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
			
			eventMap.mapListener(eventDispatcher, GloMenuEvent.ITEMS_LISTED, itemsListed);
			eventMap.mapListener(view, GloMenuEvent.SHOW_ITEM, dispatch);
			
			// Only re-scan the documents directory automatically the first time or when menu is empty
			// Other scan reuests must be started by the user manually
			if (view.items == null)
				dispatch(new GloMenuEvent(GloMenuEvent.LIST_ITEMS));
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(eventDispatcher, GloMenuEvent.ITEMS_LISTED, itemsListed);
			eventMap.unmapListener(view, GloMenuEvent.SHOW_ITEM, dispatch);
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
		protected function itemsListed(event:GloMenuEvent):void
		{
			view.items = event.items;
			dispatch(new BusyIndicatorEvent(BusyIndicatorEvent.HIDE));
		}
	}
}