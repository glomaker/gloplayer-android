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
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.models.vo.Journey;
	import org.glomaker.mobileplayer.mvcs.models.vo.MenuItem;
	import org.glomaker.mobileplayer.mvcs.models.vo.QRCodeList;
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
		
		[Inject]
		public var model:GloModel;
		
		protected var currentIndex:int = -1;
		protected var journeys:Dictionary;
		protected var qrCodes:QRCodeList;
		
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
		
		private var _result:Vector.<MenuItem>;

		/**
		 * The result of the processing. Contains the items to display in the menu.
		 */
		public function get result():Vector.<MenuItem>
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
			_result = new Vector.<MenuItem>();
			currentIndex = -1;
			journeys = new Dictionary();
			qrCodes = new QRCodeList();
			
			eventMap.mapListener(eventDispatcher, LoadProjectEvent.COMPLETE, completeHandler, LoadProjectEvent);
			loadNext();
		}
		
		/**
		 * Loads the next GLO in the list.
		 */
		protected function loadNext():void
		{
			if (!glos || (currentIndex + 1) >= glos.length)
			{
				eventMap.unmapListener(eventDispatcher, LoadProjectEvent.COMPLETE, completeHandler, LoadProjectEvent);
				
				// alphabetical sort
				_result.sort( sortF ); 
				
				// pass on to application
				dispatch(new GloMenuEvent(GloMenuEvent.ITEMS_LISTED, _result));
				model.qrCodes = qrCodes;
				
				journeys = null;
				qrCodes = null;
				
				return;
			}
			
			currentIndex++;
			dispatch(new LoadProjectEvent(LoadProjectEvent.LOAD, glos[currentIndex]));
		}
		
		/**
		 * Sort function to carry out an alphabetical comparison.
		 * @param g1
		 * @param g2
		 * @return 0 if equal, 1 if g1 > g2, -1 if g2 < g1
		 */		
		protected function sortF( g1:MenuItem, g2:MenuItem ):int
		{
			var n1:String = g1.displayName.toLowerCase();
			var n2:String = g2.displayName.toLowerCase();
			
			if (n1 > n2)
				return 1;
			else if (n1 < n2)
				return -1;
			else
				return 0;
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Called when a project is loaded.
		 */
		protected function completeHandler(event:LoadProjectEvent):void
		{
			if (event.glo != glos[currentIndex])
				return;
			
			var menuItem:MenuItem;
			var journeyName:String = event.project.journey ? StringUtil.trim(event.project.journey.name) : null;
			var journeyIndex:uint = event.project.journey ? event.project.journey.index : 0;
			
			if (event.project.journey)
			{
				journeyName = StringUtil.trim(event.project.journey.name);
				journeyIndex = event.project.journey.index;
				if (event.project.journey.qrEnabled)
					qrCodes.add(event.project.journey.qrCode, event.glo);
			}
			
			if (journeyName && journeyIndex > 0)
			{
				var journey:Journey = journeys[journeyName];
				if (!journey)
				{
					journey = new Journey(journeyName);
					journeys[journeyName] = journey;
					menuItem = journey;
				}
				
				journey.add(event.glo, journeyIndex);
			}
			else
			{
				menuItem = event.glo;
			}
			
			if (menuItem)
				_result.push(menuItem);
			
			loadNext();
		}
	}
}