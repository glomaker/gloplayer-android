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
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.views.components.ConfirmationDialog;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class QRCodeReaderMediator extends Mediator implements IMediator
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
		protected static var log:Function = eu.kiichigo.utils.log(QRCodeReaderMediator);
		
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
		public var view:QRCodeReader;
		
		/**
		 * Glo whose QR code has been scanned.
		 */
		protected var glo:Glo

		/**
		 * Save a reference to stage on registration to reset its orientation settings back on remove
		 * where the stage is not available through the view anymore.
		 */
		protected var stage:Stage;
		
		/**
		 * Save value of autoOrients to reset it when the view is closed.
		 */
		protected var autoOrients:Boolean;
		
		/**
		 * Save systemIdleMode setting to reset it when the view is closed.
		 */
		protected var systemIdleMode:String;
		
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
			eventMap.mapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate, ApplicationEvent);
			eventMap.mapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate, ApplicationEvent);
			
			eventMap.mapListener(view, ApplicationEvent.HIDE_QR_CODE_READER, dispatch, ApplicationEvent);
			eventMap.mapListener(view, DataEvent.DATA, handleViewData, DataEvent);
			
			stage = view.stage;
			autoOrients = stage.autoOrients;
			systemIdleMode = NativeApplication.nativeApplication.systemIdleMode;
			
			stage.autoOrients = false;
			stage.setOrientation(StageOrientation.DEFAULT);
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			dispatch(ApplicationEvent.ENTER_FULL_SCREEN_EVENT);
			
			view.start();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			glo = null;
			view.stop();
			view.dispose();
			
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.ACTIVATE, handleActivate, ApplicationEvent);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.DEACTIVATE, handleDeactivate, ApplicationEvent);
			
			eventMap.unmapListener(view, ApplicationEvent.HIDE_QR_CODE_READER, dispatch, ApplicationEvent);
			eventMap.unmapListener(view, DataEvent.DATA, handleViewData, DataEvent);
			
			stage.autoOrients = autoOrients;
			NativeApplication.nativeApplication.systemIdleMode = systemIdleMode;
			stage = null;
			
			dispatch(ApplicationEvent.LEAVE_FULL_SCREEN_EVENT);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler - application activated.
		 */
		protected function handleActivate(event:ApplicationEvent):void
		{
			view.start();
		}
		
		/**
		 * Event handler - application deactivated.
		 */
		protected function handleDeactivate(event:ApplicationEvent):void
		{
			view.stop();
		}
		
		/**
		 * Event handler - reader detected a QR code.
		 */
		protected function handleViewData(event:DataEvent):void
		{
			glo = model.qrCodes.get(event.data);
			if (glo)
			{
				var message:String = "Open the following GLO?\n";
				if (glo.journeySettings.location)
					message += "Name: " + glo.journeySettings.location + "\n";
				message += "Journey: " + glo.journeySettings.name + "\n";
				message += "Step: " + glo.journeySettings.index + "\n";
				
				view.mouseEnabled = false;
				view.mouseChildren = false;
				view.filters = [ new BlurFilter(3, 3) ];
				
				var dialog:ConfirmationDialog = new ConfirmationDialog();
				dialog.text = message;
				dialog.addEventListener(Event.CLOSE, dialog_closeHandler);
				view.stage.addChild(dialog);
			}
			else
			{
				dispatch(new NotificationEvent(NotificationEvent.NOTIFICATION, "Unkown QR Code."));
				
				view.resume();
			}
		}
		
		protected function dialog_closeHandler(event:Event):void
		{
			var dialog:ConfirmationDialog = event.target as ConfirmationDialog;
			dialog.removeEventListener(Event.CLOSE, dialog_closeHandler);
			
			view.mouseEnabled = true;
			view.mouseChildren = true;
			view.filters = null;
			
			if (dialog.response)
			{
				view.stop();
				dispatch(new LoadProjectEvent(LoadProjectEvent.SHOW, glo));
				dispatch(ApplicationEvent.HIDE_QR_CODE_READER_EVENT);
			}
			else
			{
				view.resume();
			}
		}
	}
}