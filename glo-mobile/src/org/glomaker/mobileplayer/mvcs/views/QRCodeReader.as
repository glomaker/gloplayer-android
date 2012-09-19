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
	import com.google.zxing.BarcodeFormat;
	import com.google.zxing.BinaryBitmap;
	import com.google.zxing.BufferedImageLuminanceSource;
	import com.google.zxing.DecodeHintType;
	import com.google.zxing.Result;
	import com.google.zxing.client.result.ParsedResult;
	import com.google.zxing.client.result.ResultParser;
	import com.google.zxing.common.GlobalHistogramBinarizer;
	import com.google.zxing.common.flexdatatypes.HashTable;
	import com.google.zxing.qrcode.QRCodeReader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.System;
	import flash.utils.Timer;
	
	import net.dndigital.components.Button;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.NotificationEvent;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.TextButton;
	
	/**
	 * View component for launching a GLO through its QR Code.
	 * 
	 * @author haykel
	 * 
	 */
	public class QRCodeReader extends GUIComponent implements IGloView
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
		protected static var log:Function = eu.kiichigo.utils.log(QRCodeReader);
		
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		public static const SNAP_SIZE:uint = 250;
		
		//--------------------------------------------------
		// Static functions
		//--------------------------------------------------
		
		/**
		 * Returns whther the QR Coder is supported by the device.
		 */
		public static function get isSupported():Boolean
		{
			return Camera.isSupported;
		}
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var reader:com.google.zxing.qrcode.QRCodeReader;
		protected var hints:HashTable;
		
		protected var snapRect:Rectangle;
		protected var snapTimer:Timer;
		
		protected var camera:Camera;
		protected var videoDisplay:Video;
		protected var videoBitmap:Bitmap;
		protected var videoContainer:Sprite;
		protected var snapRegion:Shape;
		protected var closeButton:TextButton;
		
		//--------------------------------------------------
		// Public functions
		//--------------------------------------------------
		
		/**
		 * Starts scanning.
		 */
		public function start():void
		{
			if (camera)
				return;
			
			dispose();
			
			camera = Camera.getCamera();
			
			snapTimer = new Timer(1000);
			snapTimer.addEventListener(TimerEvent.TIMER, snapTimer_timerHandler);
			snapTimer.start();
			
			invalidateDisplay();
		}
		
		/**
		 * Stops scanning.
		 */
		public function stop():void
		{
			if (!camera)
				return;
			
			snapTimer.stop();
			snapTimer.removeEventListener(TimerEvent.TIMER, snapTimer_timerHandler);
			snapTimer = null;
			
			camera = null;
			snapRect = null;
			
			if (videoDisplay)
			{
				videoContainer.removeChild(videoDisplay);
				videoDisplay.attachCamera(null);
				videoDisplay = null;
			}
			
			System.gc();
		}
		
		/**
		 * Frees memory that is used by the video bitmap data.
		 */
		public function dispose():void
		{
			if (videoBitmap && videoBitmap.bitmapData)
			{
				videoBitmap.bitmapData.dispose();
				videoBitmap.bitmapData = null;
			}
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		protected function decodeSnapshot():void
		{
			if (!snapRect)
				return;
			
			var bmpd:BitmapData = new BitmapData(videoContainer.width, videoContainer.height);
			bmpd.draw(videoContainer, null, null, null, null, true);
			
			var snapBmpd:BitmapData = new BitmapData(SNAP_SIZE, SNAP_SIZE);
			snapBmpd.copyPixels(bmpd, snapRect, new Point());
			
			var lsource:BufferedImageLuminanceSource = new BufferedImageLuminanceSource(snapBmpd);
			var bitmap:BinaryBitmap = new BinaryBitmap(new GlobalHistogramBinarizer(lsource));
			var res:Result = null;
			
			try
			{
				res = reader.decode(bitmap, hints);
			}
			catch (event:Error)
			{
				// no QR code found...
			}
			
			if (res != null)
			{
				var parsedResult:ParsedResult = ResultParser.parseResult(res);
				var code:String = parsedResult.getDisplayResult();
				
				videoBitmap.bitmapData = bmpd;
				dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFICATION, code));
			}
			
			snapBmpd.dispose();
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			if (isSupported)
			{
				reader = new com.google.zxing.qrcode.QRCodeReader();
				
				hints = new HashTable();
				hints.Add(DecodeHintType.POSSIBLE_FORMATS, BarcodeFormat.QR_CODE);
			}
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (isSupported)
			{
				videoBitmap = new Bitmap();
				addChild(videoBitmap);
				
				videoContainer = new Sprite();
				addChild(videoContainer);
			}
			
			snapRegion = new Shape();
			snapRegion.graphics.clear();
			snapRegion.graphics.lineStyle(10, 0xffffff, 0.5);
			snapRegion.graphics.drawRoundRect(5, 5, SNAP_SIZE + 10, SNAP_SIZE + 10, 3, 3);
			snapRegion.graphics.lineStyle();
			addChild(snapRegion);
			
			closeButton = new TextButton();
			closeButton.label = "CLOSE";
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			addChild(closeButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// background
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			// UI elements
			snapRegion.x = (width - snapRegion.width) / 2;
			snapRegion.y = (height - snapRegion.height) / 2;
			
			closeButton.height = ScreenMaths.mmToPixels(10);
			closeButton.width = width - 2*closeButton.height;
			closeButton.x = closeButton.height;
			closeButton.y = height - 2*closeButton.height;
			
			// camera
			if (camera)
			{
				if (videoDisplay)
				{
					videoDisplay.attachCamera(null);
					videoContainer.removeChild(videoDisplay);
				}
				
				camera.setMode(height, width, 24);
				
				videoDisplay = new Video();
				videoDisplay.width = height;
				videoDisplay.height = width;
				videoDisplay.x = width;
				videoDisplay.rotation = 90;
				videoDisplay.attachCamera(camera);
				videoContainer.addChild(videoDisplay);
				
				snapRect = new Rectangle((width - SNAP_SIZE) / 2, (height - SNAP_SIZE) / 2, SNAP_SIZE, SNAP_SIZE);
			}
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * @private
		 */
		protected function snapTimer_timerHandler(event:TimerEvent):void
		{
			decodeSnapshot();
		}
		
		/**
		 * @private
		 */
		protected function closeButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(ApplicationEvent.HIDE_QR_CODE_READER_EVENT);
		}
	}
}
