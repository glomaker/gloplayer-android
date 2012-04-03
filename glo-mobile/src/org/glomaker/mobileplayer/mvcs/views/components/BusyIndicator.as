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
package org.glomaker.mobileplayer.mvcs.views.components
{
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	import net.dndigital.components.Application;
	import net.dndigital.components.GUIComponent;
	
	/**
	 * Displays an animation to indicate that a long-term operation is in progress.
	 * 
	 * @author Haykel
	 * 
	 */
	public class BusyIndicator extends GUIComponent
	{
		
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		protected static const SPINNER_WIDTH:Number = 30;
		protected static const SPOKES_COUNT:Number = 12;
		
		protected const blur:BlurFilter = new BlurFilter(3, 3);
		
		protected const spokes:Vector.<Line> = new Vector.<Line>();
		protected const alphaDec:Number = 1 / SPOKES_COUNT;
		
		protected const center:Point = new Point();
		
		//--------------------------------------------------
		// Protected properties
		//--------------------------------------------------
		
		protected var step:uint = 0;
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function BusyIndicator()
		{
			var angleStep:Number = 2 * Math.PI / SPOKES_COUNT;
			
			for (var i:uint=0; i < SPOKES_COUNT; i++)
			{
				var angle:Number = i * angleStep;
				var vect:Point = new Point(SPINNER_WIDTH * Math.cos(angle), SPINNER_WIDTH * Math.sin(angle));
				spokes.push(new Line(vect.x * 0.5, vect.y * 0.5, vect.x, vect.y, 0));
			}
			
			spokes.fixed = true;
			
			if (visible)
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		//--------------------------------------------------
		// application
		//--------------------------------------------------
		
		private var _application:Application;

		/**
		 * Application instance. The application size is used for sizing the busy indicator
		 * and it will be blured when the busy indicator is visible.
		 */
		public function get application():Application
		{
			return _application;
		}

		/**
		 * @private
		 */
		public function set application(value:Application):void
		{
			if (value == application)
				return;
			
			if (application)
			{
				application.filters = null;
				application.removeEventListener(Event.RESIZE, application_resizeHandler);
			}
			
			_application = value;
			
			if (application)
			{
				width = application.width;
				height = application.height;
				
				if (visible)
					application.filters = [ blur ];
				
				application.addEventListener(Event.RESIZE, application_resizeHandler);
			}
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Draws the spinner based on the current alpha values. 
		 * 
		 */
		protected function drawSpinner():void
		{
			//background
			graphics.clear();
			graphics.beginFill(0, 0.5);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			//spinner
			for (var i:uint=0; i < SPOKES_COUNT; i++)
			{
				var spoke:Line = spokes[i];
				
				graphics.lineStyle(2, 0xFFFFFF, spoke.alpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
				graphics.moveTo(center.x + spoke.x1, center.y + spoke.y1);
				graphics.lineTo(center.x + spoke.x2, center.y + spoke.y2);
			}
		}

		//--------------------------------------------------
		// Overridden functions
		//--------------------------------------------------
		
		/**
		 * Overridden to start/stop the animation to prevent it from using resources when
		 * the busy indicator is not visible.
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if (value == visible)
				return;
			
			super.visible = value;
			
			if (application)
			{
				width = application.width;
				height = application.height;
				application.filters = visible ? [ blur ] : null;
			}
			
			if (visible)
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			else
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			center.x = width / 2;
			center.y = height / 2;
			
			drawSpinner();
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handle enter frame event.
		 */
		protected function enterFrameHandler(event:Event):void
		{
			step = (step + 1) % SPOKES_COUNT;
			for (var i:uint=0; i < SPOKES_COUNT; i++)
			{
				if (i == step)
					spokes[i].alpha = 1;
				else
					spokes[i].alpha = Math.max(0, spokes[i].alpha - alphaDec);
			}
			
			drawSpinner();
		}
		
		/**
		 * Handle application resize event.
		 */
		protected function application_resizeHandler(event:Event):void
		{
			width = application.width;
			height = application.height;
		}
	}
}

//--------------------------------------------------
// Helper classes
//--------------------------------------------------

final class Line
{
	public var x1:Number;
	public var y1:Number;
	public var x2:Number;
	public var y2:Number;
	public var alpha:Number;
	
	public function Line(x1:Number, y1:Number, x2:Number, y2:Number, alpha:Number)
	{
		this.x1 = x1;
		this.y1 = y1;
		this.x2 = x2;
		this.y2 = y2;
		this.alpha = alpha;
	}
}