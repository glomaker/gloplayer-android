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
package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;

	/**
	 * Viewer for the ImageMagnifier component.
	 * 
	 * @author haykel
	 * 
	 */
	public class ImageMagnifier extends GloComponent implements IFullscreenable
	{
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		/**
		 * Minimum allowed scale for the image.
		 */
		protected static const MIN_SCALE:Number = 0.05;
		
		/**
		 * Maximum allowed scale for the image.
		 */
		protected static const MAX_SCALE:Number = 5;
		
		/**
		 * Fullscreen button size.
		 */
		protected static const FS_SIZE:Number = ScreenMaths.mmToPixels(6);
		
		/**
		 * Space between fullscreen button and component edges.
		 */
		protected static const FS_PADDING:Number = ScreenMaths.mmToPixels(1);
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		/**
		 * Image loader.
		 */
		protected var image:Loader = new Loader();
		
		/**
		 * Holds the image and clips it to the component area.
		 */
		protected var imageContainer:Sprite = new Sprite();
		
		/**
		 * Mask to clip image to component area. We use a mask
		 * instead of the 'scrollRect' property for masking
		 * and scrolling because it is much easier to handle both
		 * when the image is bigger and smaller than the component.
		 */
		protected var imageMask:Shape = new Shape();
		
		/**
		 * Button for switching fullscreen mode.
		 */
		protected var fullscreenButton:VideoFullscreenButton = new VideoFullscreenButton();
		
		/**
		 * Info overlay (pinch gesture symbol).
		 */
		protected var infoOverlay:InfoOverlay = new InfoOverlay();
		
		/**
		 * Holds whether the image finished loading. This is required to know
		 * if image size can be accessed.
		 */
		protected var imageLoaded:Boolean;
		
		/**
		 * Holds the mouse position on stage for the last handled mouse event.
		 */
		protected var lastMouse:Point;
		
		/**
		 * Whether we are currently handling zoom gestures.
		 */
		protected var zooming:Boolean;
		
		//--------------------------------------------------
		// source
		//--------------------------------------------------
		
		private var _source:String;

		/**
		 * Image source (path relative to the project path).
		 */
		public function get source():String
		{
			return _source;
		}

		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			if (value == source)
				return;
			
			_source = value;
			
			imageLoaded = false;
			imageContainer.visible = false;
			if (source)
				image.load(new URLRequest(component.directory.resolvePath(source).url));
		}
		
		//--------------------------------------------------
		// isFullScreened (IFullscreenable)
		//--------------------------------------------------
		
		private var _isFullScreened:Boolean;
		
		/**
		 * @private
		 */
		public function get isFullScreened():Boolean
		{
			return _isFullScreened;
		}
		
		/**
		 * @see IFullscreenable
		 */		
		public function set isFullScreened(value:Boolean):void
		{
			if (value == isFullScreened)
				return;
			
			_isFullScreened = value;
			
			invalidateDisplay();
		}

		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Returns the correct image position based on its size and component's size.
		 * 
		 * The image is centered if it is smaller than the component otherwise snapped to the
		 * component's edges if required.
		 */
		protected function getCorrectImagePosition():Point
		{
			var position:Point = new Point(image.x, image.y);
			
			if (imageLoaded && width > 0 && height > 0)
			{
				if (image.width <= width)
				{
					position.x = (width - image.width) / 2;
				}
				else
				{
					if (image.x > 0)
						position.x = 0;
					else if (image.x + image.width < width)
						position.x = width - image.width;
				}
				
				if (image.height <= height)
				{
					position.y = (height - image.height) / 2;
				}
				else
				{
					if (image.y > 0)
						position.y = 0;
					else if (image.y + image.height < height)
						position.y = height - image.height;
				}
			}
			
			return position;
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			imageContainer.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
			imageContainer.addEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipeHandler);
			
			fullscreenButton.addEventListener(MouseEvent.CLICK, fullscreenButton_clickHandler);
			
			image.contentLoaderInfo.addEventListener(Event.COMPLETE, image_completeHandler);
			
			mapProperty("source");
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			
			imageContainer.addChild(image);
			imageContainer.addChild(imageMask);
			imageContainer.mask = imageMask;
			imageContainer.mouseChildren = false;
			imageContainer.visible = imageLoaded;
			addChild(imageContainer);
			
			fullscreenButton.width = FS_SIZE;
			fullscreenButton.height = FS_SIZE;
			fullscreenButton.visible = false;
			fullscreenButton.alpha = 0;
			addChild(fullscreenButton);
			
			infoOverlay.mouseEnabled = false;
			infoOverlay.mouseChildren = false;
			addChild(infoOverlay);
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function destroy():void
		{
			super.destroy();
			
			imageContainer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			imageContainer.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
			imageContainer.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipeHandler);
			
			fullscreenButton.removeEventListener(MouseEvent.CLICK, fullscreenButton_clickHandler);
			
			image.contentLoaderInfo.removeEventListener(Event.COMPLETE, image_completeHandler);
			image.unload();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// border
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(2, 0x000000);
			g.drawRect(0, 0, width, height);
			g.lineStyle();
			
			// image container
			g = imageContainer.graphics;
			g.clear();
			if (imageLoaded)
			{
				g.beginFill(0x000000);
				g.drawRect(0, 0, width, height);
				g.endFill();
			}
			
			// image mask
			g = imageMask.graphics;
			g.clear();
			g.beginFill(0xff0000);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			// image
			var position:Point = getCorrectImagePosition();
			image.x = position.x;
			image.y = position.y;
			
			// fullscreen button
			fullscreenButton.x = width - fullscreenButton.width - FS_PADDING;
			fullscreenButton.y = height - fullscreenButton.height - FS_PADDING;

			// overlay
			infoOverlay.redraw(width, height);
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handles added to stage events.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			fullscreenButton.visible = false;
			fullscreenButton.alpha = 0;
			
			infoOverlay.show();
		}
		
		/**
		 * Handle mouse down events.
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			lastMouse = new Point(event.stageX, event.stageY);
			infoOverlay.hide();
			fullscreenButton.visible = true;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		/**
		 * Handle stage mouse move events.
		 */
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var dx:Number = event.stageX - lastMouse.x;
			var dy:Number = event.stageY - lastMouse.y
			lastMouse = new Point(event.stageX, event.stageY);
			
			if (zooming)
				return;
			
			if ((dx > 0 && image.x >= 0) || (dx < 0 && (image.x + image.width) <= width))
				dx /= 2;
			
			if ((dy > 0 && image.y >= 0) || (dy < 0 && (image.y + image.height) <= height))
				dy /= 2;
			
			image.x += dx;
			image.y += dy;
			
			event.updateAfterEvent();
		}
		
		/**
		 * Handle stage mouse up events.
		 */
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			
			lastMouse = null;
			
			if (zooming)
				return;
			
			var position:Point = getCorrectImagePosition();
			if (position.x != image.x || position.y != image.y)
				TweenLite.to(image, 0.5, {"x": position.x, "y": position.y, "ease": Expo.easeOut});
		}
		
		/**
		 * Handle zoom gesture events.
		 */
		protected function gestureZoomHandler(event:TransformGestureEvent):void
		{
			if (!zooming && event.phase != GesturePhase.BEGIN)
				return;
			
			if (event.phase == GesturePhase.BEGIN)
			{
				// only accept gesture if the user has touched the component with the first finger
				if (lastMouse)
				{
					zooming = true;
					infoOverlay.hide();
					fullscreenButton.visible = true;
				}
			}
			else if (event.phase == GesturePhase.UPDATE)
			{
				var scale:Number = (event.scaleX + event.scaleY) / 2;
				scale = (scale < 1) ? Math.max(scale, MIN_SCALE / image.scaleX) : Math.min(scale, MAX_SCALE / image.scaleX);
				
				var matrix:Matrix = image.transform.matrix;
				var transformPoint:Point = matrix.transformPoint(image.globalToLocal(this.localToGlobal(new Point(width / 2, height / 2)))); // zoom around center of component
				matrix.translate(-transformPoint.x, -transformPoint.y);
				matrix.scale(scale, scale);
				matrix.translate(transformPoint.x, transformPoint.y);
				
				image.transform.matrix = matrix;
			}
			else if (event.phase == GesturePhase.END)
			{
				zooming = false;
				if (!lastMouse)
				{
					var position:Point = getCorrectImagePosition();
					if (position.x != image.x || position.y != image.y)
						TweenLite.to(image, 0.5, {"x": position.x, "y": position.y, "ease": Expo.easeOut});
				}
			}
		}
		
		/**
		 * Handle swipe gesture events.
		 */
		protected function gestureSwipeHandler(event:TransformGestureEvent):void
		{
			// Prevent player from changing the page
			event.stopImmediatePropagation();
		}
		
		/**
		 * Handles image load complete events.
		 */
		protected function image_completeHandler(event:Event):void
		{
			imageLoaded = true;
			image.scaleX = 1;
			image.scaleY = 1;
			
			var position:Point = getCorrectImagePosition();
			image.x = position.x;
			image.y = position.y;
			
			imageContainer.visible = true;
			
			invalidateDisplay();
		}
		
		/**
		 * Handles click events on fullscreen button.
		 */
		protected function fullscreenButton_clickHandler(event:MouseEvent):void
		{
			player.fullscreen(this);
		}
	}
}

// Helper classes

import com.greensock.TweenLite;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;

import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;

/**
 * Pinch gesture image with a white background to be displayed on top
 * of the component when displayed the first time.
 * 
 * @author haykel
 * 
 */
class InfoOverlay extends Sprite
{
	[Embed(source="files/pinch.png")]
	protected var PinchIcon:Class;
	protected var pinchIcon:Bitmap;
	protected var bg:Shape;
	
	public function InfoOverlay()
	{
		bg = new Shape();
		bg.alpha = 0.8;
		addChild( bg );
		
		pinchIcon = new PinchIcon();
		addChild(pinchIcon);

		show();
	}
	
	public function redraw(width:Number, height:Number):void
	{
		// reset scale for correct maths
		pinchIcon.scaleX = pinchIcon.scaleY = 1;
		
		// icon
		var iconMargin:Number = ScreenMaths.mmToPixels( 4 );
		var scale:Number = Math.min((width - iconMargin) / pinchIcon.width, (height - iconMargin) / pinchIcon.height);
		pinchIcon.scaleX = Math.min(1, scale);
		pinchIcon.scaleY = pinchIcon.scaleX;
		pinchIcon.x = (width - pinchIcon.width) / 2;
		pinchIcon.y = (height - pinchIcon.height) / 2;

		// background
		var margin:Number = ScreenMaths.mmToPixels( 2 );
		var bgWidth:Number = pinchIcon.width + margin;
		var bgHeight:Number = pinchIcon.height + margin;
		var left:Number = (width - bgWidth)/2;
		var top:Number = (height - bgHeight)/2;
		
		bg.graphics.clear();
		bg.graphics.beginFill(0xffffff);
		bg.graphics.drawRect( left, top, bgWidth, bgHeight);
		bg.graphics.endFill();
	}
	
	public function show():void
	{
		alpha = 1;
	}
	
	public function hide():void
	{
		if (alpha > 0)
			TweenLite.to(this, 0.1, {"alpha": 0});
	}
}