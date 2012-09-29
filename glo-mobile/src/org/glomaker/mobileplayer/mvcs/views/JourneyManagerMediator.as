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
	import org.glomaker.mobileplayer.mvcs.events.GloModelEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.robotlegs.mvcs.Mediator;
	
	public class JourneyManagerMediator extends Mediator
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var view:JourneyManager;
		
		[Inject]
		/**
		 * @private
		 */
		public var model:GloModel;
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			
			applyJourney();
			
			eventMap.mapListener(view, LoadProjectEvent.SHOW, dispatch, LoadProjectEvent);
			
			eventMap.mapListener(eventDispatcher, GloModelEvent.JOURNEY_CHANGED, applyJourney, GloModelEvent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(view, LoadProjectEvent.SHOW, dispatch, LoadProjectEvent);
			
			eventMap.unmapListener(eventDispatcher, GloModelEvent.JOURNEY_CHANGED, applyJourney, GloModelEvent);
		}
		
		//--------------------------------------------------
		// Protected methods
		//--------------------------------------------------
		
		protected function applyJourney(event:GloModelEvent=null):void
		{
			view.journey = model.journey;
		}
		
	}
}