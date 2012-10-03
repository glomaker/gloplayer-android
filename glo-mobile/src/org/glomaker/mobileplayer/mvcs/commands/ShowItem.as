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
package org.glomaker.mobileplayer.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.models.vo.Journey;
	import org.glomaker.mobileplayer.mvcs.models.vo.MenuItem;
	import org.robotlegs.mvcs.Command;
	
	public final class ShowItem extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(ShowItem);
		
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 * GloMenuEvent event, containing reference to received instance of <code>MenuItem</code>.
		 */
		public var event:GloMenuEvent;
		
		[Inject]
		/**
		 * @private
		 * Reference to the Model.
		 */
		public var model:GloModel;
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			var item:MenuItem = (event.items && event.items.length > 0) ? event.items[0] : null;
			if (!item)
				return;
			
			if (item is Glo)
			{
				dispatch(new LoadProjectEvent(LoadProjectEvent.SHOW, item as Glo));
			}
			else if (item is Journey)
			{
				var journey:Journey = item as Journey;
				
				// either show the journey manager if it has a current GLO, or launch the first GLO of the journey
				model.glo = journey.get(journey.currentIndex);
				if (model.glo)
					dispatch(ApplicationEvent.SHOW_JOURNEY_MANAGER_EVENT);
				else
					dispatch(new LoadProjectEvent(LoadProjectEvent.SHOW, journey.first()));
			}
		}
	}
}