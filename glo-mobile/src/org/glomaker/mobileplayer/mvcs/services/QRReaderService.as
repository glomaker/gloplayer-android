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
	import net.dndigital.ane.gloqrreader.GLOQRReader;
	import net.dndigital.ane.gloqrreader.QRReaderEvent;
	
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * Manages the display of and communication with the QR code reader that is implemented as an ANE.
	 * 
	 * @author haykel
	 */
	public class QRReaderService extends Actor
	{
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		[Inject]
		public var model:GloModel;
		
		/**
		 * QR code reader instance.
		 */
		protected var reader:GLOQRReader;
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Shows the reader.
		 */
		public function show():void
		{
			if (reader == null)
			{
				reader = new GLOQRReader();
				reader.addEventListener(QRReaderEvent.SCAN, reader_scanHandler);
				reader.addEventListener(QRReaderEvent.CLOSE, reader_closeHandler);
				reader.addEventListener(QRReaderEvent.LAUNCH, reader_launchHandler);
			}
			
			reader.scan();
		}
		
		/**
		 * Hides the reader and cleans its resources.
		 */
		public function hide():void
		{
			if (reader != null)
			{
				reader.removeEventListener(QRReaderEvent.SCAN, reader_scanHandler);
				reader.removeEventListener(QRReaderEvent.CLOSE, reader_closeHandler);
				reader.removeEventListener(QRReaderEvent.LAUNCH, reader_launchHandler);
				reader.dispose();
				reader = null;
			}
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handles scan events from reader.
		 */
		protected function reader_scanHandler(event:QRReaderEvent):void
		{
			var glo:Glo = model.qrCodes.get(event.latestCode);
			if (glo)
			{
				var message:String = "";
				if (glo.journeySettings.location)
					message += "Name: " + glo.journeySettings.location + "\n";
				message += "Journey: " + glo.journeySettings.name + "\n";
				message += "Step: " + glo.journeySettings.index + "\n";
				
				reader.showLaunchDialog("Launch Content?", message, "Launch", "Cancel");
			}
			else
			{
				reader.showInvalidQRMessage("This QR-code hasn't been recognised.");
			}
		}
		
		/**
		 * Handles close events from reader.
		 */
		protected function reader_closeHandler(event:QRReaderEvent):void
		{
			hide();
		}
		
		/**
		 * Handles GLO launch events from reader.
		 */
		protected function reader_launchHandler(event:QRReaderEvent):void
		{
			dispatch(new LoadProjectEvent(LoadProjectEvent.SHOW, model.qrCodes.get(event.latestCode)));
			hide();
		}
	}
}