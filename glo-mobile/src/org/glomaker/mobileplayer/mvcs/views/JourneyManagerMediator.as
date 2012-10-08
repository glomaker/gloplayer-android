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
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.events.Event;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloModelEvent;
	import org.glomaker.mobileplayer.mvcs.events.JourneyManagerEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.views.components.ConfirmationDialog;
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
		public var model:GloModel;
		
		[Inject]
		/**
		 * @private
		 */
		public var view:JourneyManager;
		
		/**
		 * Save a reference to stage on registration to reset its orientation settings back on remove
		 * where the stage is not available through the view anymore.
		 */
		protected var stage:Stage;
		
		/**
		 * Save value of autoOrients to reset it when the view is closed.
		 */
		protected var autoOrients:Boolean;
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(view, LoadProjectEvent.SHOW, dispatch, LoadProjectEvent);
			eventMap.mapListener(view, JourneyManagerEvent.STEP_CLICKED, handleStepClicked, JourneyManagerEvent);
			eventMap.mapListener(view, JourneyManagerEvent.STEP_REACHED, handleStepReached, JourneyManagerEvent);
			
			eventMap.mapListener(eventDispatcher, GloModelEvent.GLO_CHANGED, handleGloChanged, GloModelEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate, ApplicationEvent);
			
			stage = view.stage;
			autoOrients = stage.autoOrients;
			
			stage.autoOrients = false;
			stage.setOrientation(StageOrientation.DEFAULT);
			
			view.trackGPS = true;
			handleGloChanged();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(view, LoadProjectEvent.SHOW, dispatch, LoadProjectEvent);
			eventMap.unmapListener(view, JourneyManagerEvent.STEP_CLICKED, handleStepClicked, JourneyManagerEvent);
			eventMap.unmapListener(view, JourneyManagerEvent.STEP_REACHED, handleStepReached, JourneyManagerEvent);
			
			eventMap.unmapListener(eventDispatcher, GloModelEvent.GLO_CHANGED, handleGloChanged, GloModelEvent);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate, ApplicationEvent);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate, ApplicationEvent);
			
			view.trackGPS = false;
			
			stage.autoOrients = autoOrients;
			stage = null;
		}
		
		//--------------------------------------------------
		// Protected methods
		//--------------------------------------------------
		
		/**
		 * Handle Glo changed.
		 */
		protected function handleGloChanged(event:GloModelEvent=null):void
		{
			view.glo = model.glo;
		}
		
		/**
		 * Handle application activated.
		 */
		protected function handleActivate(event:ApplicationEvent):void
		{
			view.trackGPS = true;
		}
		
		/**
		 * Handle application deactivated.
		 */
		protected function handleDeactivate(event:ApplicationEvent):void
		{
			view.trackGPS = false;
		}

		/**
		 * Handle step click event.
		 */
		protected function handleStepClicked(event:JourneyManagerEvent):void
		{
			var glo:Glo = model.glo.journey.get(event.stepIndex);
			if (glo)
				model.glo = glo;
		}
		
		/**
		 * Handle step reached event.
		 */
		protected function handleStepReached(event:JourneyManagerEvent):void
		{
			var message:String = "Open the following GLO?\n";
			if (model.glo.journeySettings.location)
				message += "Name: " + model.glo.journeySettings.location + "\n";
			message += "Journey: " + model.glo.journeySettings.name + "\n";
			message += "Step: " + model.glo.journeySettings.index + "\n";
			
			var dialog:ConfirmationDialog = new ConfirmationDialog();
			dialog.text = message;
			dialog.addEventListener(Event.CLOSE, dialog_closeHandler);
			
			dispatch(new NotificationEvent(NotificationEvent.NOTIFICATION, null, dialog, true));
			dispatch(new NotificationEvent(NotificationEvent.NATIVE_NOTIFICATION, "Journey step location reached."));
		}
		
		protected function dialog_closeHandler(event:Event):void
		{
			var dialog:ConfirmationDialog = event.target as ConfirmationDialog;
			dialog.removeEventListener(Event.CLOSE, dialog_closeHandler);
			
			if (dialog.response)
				dispatch(new LoadProjectEvent(LoadProjectEvent.SHOW, model.glo));
			
			dispatch(new NotificationEvent(NotificationEvent.CANCEL_NATIVE_NOTIFICATION));
		}
	}
}