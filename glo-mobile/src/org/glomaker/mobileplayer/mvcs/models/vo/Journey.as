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
package org.glomaker.mobileplayer.mvcs.models.vo
{
	import org.glomaker.mobileplayer.mvcs.events.JourneyEvent;

	[Event(name="listChanged", type="org.glomaker.mobileplayer.mvcs.events.JourneyEvent")]
	[Event(name="currentChanged", type="org.glomaker.mobileplayer.mvcs.events.JourneyEvent")]
	[Event(name="visitedChanged", type="org.glomaker.mobileplayer.mvcs.events.JourneyEvent")]
	
	/**
	 * Represents data about a journey.
	 * 
	 * @author haykel
	 */	
	public class Journey extends MenuItem
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		/**
		 * GLOs that belong to the journey indexed by their journey 'index' value.
		 * This array can have holes, so don't count on 'length' for number of elements.
		 */
		protected var glos:Array = [];
		
		/**
		 * Holds the journey indices of the GLOs in ascending order.
		 * We can use the 'length' of this property to get the number of elements.
		 */
		protected var indices:Vector.<uint> = new Vector.<uint>();
		
		/**
		 * Indices of visited journeys.
		 */
		protected var visited:Array = [];
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		/**
		 * Constructor.
		 */		
		public function Journey(displayName:String)
		{
			super(displayName);
		}
		
		//--------------------------------------------------
		// current
		//--------------------------------------------------
		
		private var _currentIndex:uint;

		/**
		 * Index of currently viewed Glo, either in the journey manager or in the player.
		 * 
		 * If an unkown index is assigned to this property, it is set to 0, which
		 * means that no Glo is currently selected.
		 */
		public function get currentIndex():uint
		{
			return indices.indexOf(_currentIndex) >= 0 ? _currentIndex : 0;
		}

		/**
		 * @private
		 */
		public function set currentIndex(value:uint):void
		{
			if (value == _currentIndex)
				return;
			
			_currentIndex = value;
			
			dispatchEvent(new JourneyEvent(JourneyEvent.CURRENT_CHANGED));
		}
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Clears the list of Glos. Other state information (currentIndex and visited) is preserved.
		 */
		public function clear():void
		{
			if (indices.length == 0)
				return;
			
			for each (var glo:Glo in glos)
			{
				glo.journey = null;
			}
			
			glos = [];
			indices.length = 0;
			dispatchEvent(new JourneyEvent(JourneyEvent.LIST_CHANGED));
		}
		
		/**
		 * Adds the specified Glo with the specified journey index.
		 */
		public function add(glo:Glo, index:uint):void
		{
			if (glo && index > 0)
			{
				var old:Glo = get(index);
				if (old != glo)
				{
					glo.journey = this;
					glos[index] = glo;
					
					if (indices.indexOf(index) < 0)
					{
						indices.push(index);
						indices.sort(function(a:uint, b:uint):int {
							if (a < b)
								return -1;
							else if (a > b)
								return 1;
							else
								return 0;
						});
					}
					
					dispatchEvent(new JourneyEvent(JourneyEvent.LIST_CHANGED));
				}
			}
		}
		
		/**
		 * Returns the Glo with the specified journey index or <code>null</code> if not found.
		 */
		public function get(index:uint):Glo
		{
			return glos.hasOwnProperty(index) ? glos[index] : null;
		}
		
		/**
		 * Returns the first Glo of the journey or <code>null</code> if the journey is empty.
		 */
		public function first():Glo
		{
			return indices.length > 0 ? glos[indices[0]] : null;
		}
		
		/**
		 * Returns the next Glo in the journey whose journey index comes after the specified index.
		 * Returns <code>null</code> if no corresponding journey could be found.
		 */
		public function next(currentIndex:uint):Glo
		{
			var nextIndex:uint = 0;
			
			if (indices.length > 0)
			{
				if (currentIndex < indices[0])
					nextIndex = indices[0];
				else if (currentIndex < indices[indices.length - 1])
				{
					for (var i:uint=0; i < indices.length; i++)
					{
						if (indices[i] > currentIndex)
						{
							nextIndex = indices[i];
							break;
						}
					}
				}
			}
			
			return (nextIndex > 0) ? glos[nextIndex] : null;
		}
		
		/**
		 * Sets the 'visited' state of the Glo with the specified index to the specified value.
		 */
		public function setVisited(index:uint, value:Boolean):void
		{
			var old:Boolean = isVisited(index);
			if (old != value)
			{
				if (value)
					visited.push(index);
				else
					visited.splice(visited.indexOf(index), 1);
				
				dispatchEvent(new JourneyEvent(JourneyEvent.VISITED_CHANGED));
			}
		}
		
		/**
		 * Returns the 'visited' state of the Glo with the specified index.
		 */
		public function isVisited(index:uint):Boolean
		{
			return visited.indexOf(index) >= 0;
		}
		
		/**
		 * Serializes the data that should be saved on persistent storage.
		 */
		public function serialize():Object
		{
			return {"name": displayName, "current": currentIndex, "visited": visited};
		}
		
		/**
		 * Applies data from persistent storage.
		 */
		public function unserialize(data:Object):void
		{
			displayName = data["name"];
			currentIndex = data["current"];
			visited = data["visited"];
			dispatchEvent(new JourneyEvent(JourneyEvent.VISITED_CHANGED));
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return "Journey Value Object - " + displayName;
		}
		
	}
}