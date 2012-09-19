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
	import eu.kiichigo.utils.log;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloModelEvent;
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.robotlegs.mvcs.Mediator;
	
	public final class GloControlsMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloControlsMediator);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 */
		public var model:GloModel;
		
		[Inject]
		/**
		 * @private
		 */
		public var view:GloControls;
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE, handlePage);
			eventMap.mapListener(eventDispatcher, GloModelEvent.QR_CODES_LISTED, handleQrCodesListed);
			eventMap.mapListener(eventDispatcher, GloModelEvent.JOURNEY_CHANGED, handleJourneyChanged);
			
			eventMap.mapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.mapListener(view, ProjectEvent.MENU, handleMenuClick);
			
			eventMap.mapListener(view, ApplicationEvent.SHOW_QR_CODE_READER, dispatch);
			
			eventMap.mapListener(view, GloMenuEvent.LIST_ITEMS, dispatch);
			
			handleQrCodesListed();
			handleJourneyChanged();
		}

		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			eventMap.unmapListener(eventDispatcher, ProjectEvent.PAGE, handlePage);
			eventMap.unmapListener(eventDispatcher, GloModelEvent.QR_CODES_LISTED, handleQrCodesListed);
			eventMap.unmapListener(eventDispatcher, GloModelEvent.JOURNEY_CHANGED, handleJourneyChanged);
			
			eventMap.unmapListener(view, ProjectEvent.NEXT_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.PREV_PAGE, dispatch);
			eventMap.unmapListener(view, ProjectEvent.MENU, handleMenuClick);
			
			eventMap.unmapListener(view, ApplicationEvent.SHOW_QR_CODE_READER, dispatch);
			
			eventMap.unmapListener(view, GloMenuEvent.LIST_ITEMS, dispatch);
		}
		
		/**
		 * Event handler - controls background was clicked. 
		 * @param e
		 */		
		protected function handleMenuClick(event:ProjectEvent):void
		{
			dispatch(ApplicationEvent.SHOW_MENU_EVENT);
		}
		
		/**
		 * Event handler - current page has changed.
		 */
		protected function handlePage(event:ProjectEvent):void
		{
			view.lock(model.index == 0, model.index >= model.length - 1);
		}
		
		/**
		 * Event handler - list of QR Codes was updated.
		 */
		protected function handleQrCodesListed(event:GloModelEvent=null):void
		{
			view.qrCodeEnabled = (QRCodeReader.isSupported && model.qrCodes && model.qrCodes.length > 0);
		}
		
		/**
		 * Event handler - current journey changed.
		 */
		protected function handleJourneyChanged(event:GloModelEvent=null):void
		{
			view.journeyManagerEnabled = model.journey != null;
		}
	}
}