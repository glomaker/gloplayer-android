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
package org.glomaker.mobileplayer.mvcs.utils
{
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import org.glomaker.mobileplayer.mvcs.events.JourneyEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Journey;
	
	/**
	 * Manages data persistence for the GLO Player.
	 * 
	 * @author haykel
	 * 
	 */
	public class PersistenceManager
	{
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		private static const SHARED_OBJECT_NAME:String = "GLOPlayerCache";
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		/**
		 *  The shared object used by the persistence manager.
		 */ 
		private var so:SharedObject;
		
		/**
		 * Persisted journeys.
		 */
		private var journeys:Dictionary = new Dictionary();
		
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Loads the data from persistent storage.
		 */ 
		public function load():Boolean
		{
			journeys = new Dictionary();
			
			try
			{
				so = SharedObject.getLocal(SHARED_OBJECT_NAME);
				
				var soJourneys:Array = JSON.parse(so.data["journeys"] as String) as Array;
				if (soJourneys)
				{
					for each (var data:Object in soJourneys)
					{
						var journey:Journey = new Journey(null);
						journey.unserialize(data);
						if (journey.displayName)
						{
							journeys[journey.displayName] = journey;
							journey.addEventListener(JourneyEvent.CURRENT_CHANGED, data_updatedHandler);
							journey.addEventListener(JourneyEvent.VISITED_CHANGED, data_updatedHandler);
						}
					}
				}
			}
			catch (e:Error)
			{
				// Fail silently
				return false;
			}
			
			return true;
		}
		
		/**
		 * Saves the data to persistent storage;
		 */ 
		public function save():Boolean
		{
			var soJourneys:Array = [];
			for each (var journey:Journey in journeys)
			{
				soJourneys.push(journey.serialize());
			}
			
			try
			{
				so.data["journeys"] = JSON.stringify(soJourneys);
				
				// We assume the flush suceeded and don't check the flush status
				so.flush();
			}
			catch (e:Error)
			{
				// Fail silently
				return false;
			}
			
			return true;
		}
		
		/**
		 * Returns the journey with the given name if available, null otherwise.
		 */
		public function getJourney(name:String):Journey
		{
			return name ? journeys[name] as Journey : null;
		}
		
		/**
		 * Adds the specified journey to the list of managed journeys. If a journey
		 * with the same name already exists, it is replaced.
		 * 
		 * The data is automatially saved if the journey is added.
		 * 
		 * Added journeys are monitored for changes of current index and visited
		 * GLOs, and on change, the data is saved.
		 */
		public function addJourney(journey:Journey):void
		{
			if (journey && journey.displayName)
			{
				var old:Journey = getJourney(journey.displayName);
				if (journey != old)
				{
					if (old)
					{
						old.removeEventListener(JourneyEvent.CURRENT_CHANGED, data_updatedHandler);
						old.removeEventListener(JourneyEvent.VISITED_CHANGED, data_updatedHandler);
					}
					
					journey.addEventListener(JourneyEvent.CURRENT_CHANGED, data_updatedHandler);
					journey.addEventListener(JourneyEvent.VISITED_CHANGED, data_updatedHandler);
					
					journeys[journey.displayName] = journey;
					
					save();
				}
			}
		}
		
		/**
		 * Resets journeys by clearing their lists of GLOs.
		 */
		public function resetJourneys():void
		{
			for each (var journey:Journey in journeys)
			{
				journey.clear();
			}
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		
		/**
		 * Handles data change events. Saves the data.
		 */
		private function data_updatedHandler(event:Event):void
		{
			save();
		}
	}
}