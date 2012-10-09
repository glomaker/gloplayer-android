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
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.GraphicsPathCommand;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.events.JourneyEvent;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.models.vo.Journey;
	import org.glomaker.mobileplayer.mvcs.utils.FontUtil;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	
	/**
	 * Displays the steps of a journey and their states.
	 * 
	 * @author haykel
	 * 
	 */
	public class JourneyRoute extends GUIComponent
	{
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		public static const HEIGHT:uint = ScreenMaths.mmToPixels(10);
		
		protected static const STEP_SIZE:uint = ScreenMaths.mmToPixels(5);
		protected static const STEP_STEP:uint = STEP_SIZE + ScreenMaths.mmToPixels(1);
		
		protected static const H_PADDING:uint = ScreenMaths.mmToPixels(3);
		protected static const V_PADDING:uint = ScreenMaths.mmToPixels(1);
		
		protected static const TITLE_PADDING:uint = ScreenMaths.mmToPixels(1);
		
		/**
		 * Maximum number of pixels of mouse movement before a tap becomes a drag. 
		 */		
		protected static const MOVE_THRESHOLD:Number = 3;
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var container:Container = new Container();
		protected var titleDisplay:TextField = new TextField();
		
		protected var steps:Vector.<JourneyStep> = new Vector.<JourneyStep>();
		protected var containerScrollRect:Rectangle = new Rectangle();
		protected var containerWidth:uint;
		
		protected var mouseDownX:Number;
		protected var lastMouseX:Number;
		protected var cancelClick:Boolean;
		
		//--------------------------------------------------
		// journey
		//--------------------------------------------------
		
		private var _journey:Journey;
		private var journeyChanged:Boolean;

		/**
		 * Journey for which to display the route.
		 */
		public function get journey():Journey
		{
			return _journey;
		}

		/**
		 * @private
		 */
		public function set journey(value:Journey):void
		{
			if (value == journey)
				return;
			
			if (journey)
			{
				journey.removeEventListener(JourneyEvent.LIST_CHANGED, journey_eventHandler);
				journey.removeEventListener(JourneyEvent.CURRENT_CHANGED, journey_eventHandler);
				journey.removeEventListener(JourneyEvent.VISITED_CHANGED, journey_eventHandler);
			}
			
			_journey = value;
			
			if (journey)
			{
				journey.addEventListener(JourneyEvent.LIST_CHANGED, journey_eventHandler);
				journey.addEventListener(JourneyEvent.CURRENT_CHANGED, journey_eventHandler);
				journey.addEventListener(JourneyEvent.VISITED_CHANGED, journey_eventHandler);
			}
			
			journeyChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Creates the route steps.
		 */
		protected function createSteps():void
		{
			steps.length = 0;
			container.removeAll();
			
			containerWidth = 0;
			containerScrollRect.x = 0;
			containerScrollRect.y = 0;
			container.scrollRect = containerScrollRect;
			
			if (journey)
			{
				var glo:Glo = journey.first();
				var i:uint = 0;
				var x:uint = H_PADDING;
				var y:Array = [HEIGHT - V_PADDING - STEP_SIZE, V_PADDING];
				
				var size2:Number = STEP_SIZE / 2;
				var pathCommands:Vector.<int> = new Vector.<int>();
				var pathCoords:Vector.<Number> = new Vector.<Number>();
				
				while (glo)
				{
					var step:JourneyStep = new JourneyStep();
					step.index = glo.journeySettings.index;
					step.x = x;
					step.y = y[i % 2];
					step.width = STEP_SIZE;
					step.height = STEP_SIZE;
					step.visited = journey.isVisited(step.index);
					step.selected = (journey.currentIndex == step.index);
					
					containerWidth = step.x + step.width;
					container.add(step);
					steps.push(step);
					
					if (i == 0)
						pathCommands.push(GraphicsPathCommand.MOVE_TO);
					else
						pathCommands.push(GraphicsPathCommand.LINE_TO);
					
					pathCoords.push(step.x + size2);
					pathCoords.push(step.y + size2);
					
					glo = journey.next(glo.journeySettings.index);
					i++;
					x += STEP_STEP;
				}
				
				containerWidth += H_PADDING;
				
				container.graphics.clear();
				container.graphics.lineStyle(3, ColourPalette.JOURNEY_LIGHT_BLUE);
				container.graphics.drawPath(pathCommands, pathCoords);
				container.graphics.lineStyle();
			}
		}
		
		/**
		 * Updates the states of the steps (visited and selected states).
		 */
		protected function updateSteps():void
		{
			if (!journey)
				return;
			
			var glo:Glo = journey.first();
			var i:uint = 0;
			
			while (glo)
			{
				var step:JourneyStep = steps[i];
				step.visited = journey.isVisited(step.index);
				step.selected = (journey.currentIndex == step.index);
				
				glo = journey.next(glo.journeySettings.index);
				i++;
			}
		}
		
		//--------------------------------------------------
		// scrollerX
		//--------------------------------------------------
		
		/**
		 * @private
		 * The x position of the container scroll rect. Required only for
		 * TweenLite as setting the 'x' position of the scroll rect is not
		 * enough, we need to reassign the rectangle every time.
		 */
		public function get scrollerX():Number
		{
			return containerScrollRect.x;
		}
		
		/**
		 * @private
		 */
		public function set scrollerX(value:Number):void
		{
			containerScrollRect.x = value;
			container.scrollRect = containerScrollRect;
		}

		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.CLICK, mouseClickHandler, true);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (journeyChanged)
			{
				journeyChanged = false;
				createSteps();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(container);
			
			titleDisplay.defaultTextFormat = new TextFormat(FontUtil.FONT_REGULAR, 10, ColourPalette.JOURNEY_LIGHT_BLUE);
			titleDisplay.text = "ROUTE";
			titleDisplay.embedFonts = true;
			titleDisplay.multiline = false;
			titleDisplay.wordWrap = false;
			titleDisplay.selectable = false;
			titleDisplay.autoSize = TextFieldAutoSize.LEFT;
			addChild(titleDisplay);
			
			createSteps();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			containerScrollRect.width = width;
			containerScrollRect.height = height;
			container.scrollRect = containerScrollRect;
			
			titleDisplay.x = TITLE_PADDING;
			titleDisplay.y = TITLE_PADDING;
			
			graphics.clear();
			graphics.beginFill(ColourPalette.JOURNEY_DARK_BLUE);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handles Journey change events.
		 */
		protected function journey_eventHandler(event:JourneyEvent):void
		{
			switch (event.type)
			{
				case JourneyEvent.LIST_CHANGED:
					createSteps();
					break;
				
				case JourneyEvent.CURRENT_CHANGED:
				case JourneyEvent.VISITED_CHANGED:
					updateSteps();
					break;
			}
		}
		
		/**
		 * Handle mouse down. Initializes scroll processing if required.
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			// do not scroll if not required
			if (containerWidth <= containerScrollRect.width)
				return;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			
			TweenLite.killTweensOf(this);
			mouseDownX = event.stageX;
			lastMouseX = event.stageX;
			cancelClick = false;
		}
		
		/**
		 * Handle mouse click. Stop event propagation if user scrolled the view.
		 */
		protected function mouseClickHandler(event:MouseEvent):void
		{
			if (cancelClick)
			{
				cancelClick = false;
				event.stopImmediatePropagation();
			}
		}
		
		/**
		 * Handle stage mouse move. Scroll view and check if next mouse click should be canceled.
		 */
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var dx:Number = event.stageX - lastMouseX;
			lastMouseX = event.stageX;
			
			if (Math.abs(event.stageX - mouseDownX) > MOVE_THRESHOLD)
				cancelClick = true;
			
			if (containerScrollRect.x - dx >= 0 && containerScrollRect.right - dx <= containerWidth) 
				containerScrollRect.offset(-dx, 0);
			else
				containerScrollRect.offset(-dx / 2, 0);
			
			container.scrollRect = containerScrollRect;
		}
		
		/**
		 * Handle stage mouse up. Remove stage mouse listeners and animate view back
		 * if it has been scrolled over the limits.
		 */
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			
			var dx:Number = 0;
			if (containerScrollRect.x < 0)
				dx = -containerScrollRect.x;
			else if (containerScrollRect.right > containerWidth)
				dx = containerWidth - containerScrollRect.right;
			
			if (dx != 0)
			{
				TweenLite.to(this, 0.5, {"scrollerX": containerScrollRect.x + dx, "ease": Expo.easeOut});
			}
		}

		/**
		 * Handles 'removed from stage' event to monitor when the component is added back
		 * on stage to trigger validation which only works when the component is on stage.
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Handles 'added to stage' event to trigger validation of items invalidated while
		 * the component was not on stage.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			validateData();
			validateDisplay();
			validateState();
		}
	}
}