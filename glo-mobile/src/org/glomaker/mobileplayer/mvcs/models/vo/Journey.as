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
		protected var visited:Vector.<uint> = new Vector.<uint>();
		
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
			return _currentIndex;
		}

		/**
		 * @private
		 */
		public function set currentIndex(value:uint):void
		{
			_currentIndex = indices.indexOf(value) >= 0 ? value : 0;
		}
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Clears the list of Glos.
		 */
		public function clear():void
		{
			for each (var glo:Glo in glos)
			{
				glo.journey = null;
			}
			
			glos = [];
			indices.length = 0;
			visited.length = 0;
			currentIndex = 0;
		}
		
		/**
		 * Adds the specified Glo with the specified journey index.
		 */
		public function add(glo:Glo, index:uint, visited:Boolean=false):void
		{
			if (glo && index > 0)
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
				
				setVisited(index, visited);
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
		public function setVisited(index:uint, visited:Boolean):void
		{
			if (indices.indexOf(index) >= 0)
			{
				var i:int = this.visited.indexOf(index);
				
				if (visited && i < 0)
					this.visited.push(index);
				else if (!visited && i >= 0)
					this.visited.splice(i, 1);
			}
		}
		
		/**
		 * Returns the 'visited' state of the Glo with the specified index.
		 */
		public function isVisited(index:uint):Boolean
		{
			return visited.indexOf(index) >= 0;
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