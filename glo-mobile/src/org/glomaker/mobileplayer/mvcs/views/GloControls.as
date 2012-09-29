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
	
	import flash.events.MouseEvent;
	
	import net.dndigital.components.Button;
	import net.dndigital.components.Container;
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.events.GloMenuEvent;
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.utils.DrawingUtils;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.BackToMenuButton;
	import org.glomaker.mobileplayer.mvcs.views.components.JourneyManagerButton;
	import org.glomaker.mobileplayer.mvcs.views.components.NavButton;
	import org.glomaker.mobileplayer.mvcs.views.components.QRCodeButton;
	import org.glomaker.mobileplayer.mvcs.views.components.RefreshButton;
	
	/**
	 * View controls flow and playback of the <code>GloPlayer</code> view, and handles page swaping.
	 * 
	 * @see		net.dndigital.components.UIComponent
	 * @see		net.dndigital.components.Container
	 * @see		net.dndigital.glo.mvcs.views.GloPlayer
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloControls extends Container implements IGloView
	{		
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloControls);
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		// states
		public static const HOME:String = "home";
		public static const PLAYER:String = "player";
		public static const JOURNEY:String = "journey";
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Next navigation button.
		 */
		protected const next:NavButton = new NavButton;
		
		/**
		 * @private
		 * Previous navigation button.
		 */
		protected const prev:NavButton = new NavButton;
		
		/**
		 * @private
		 * Text field for menu link.  
		 */		
		protected const menuLink:BackToMenuButton = new BackToMenuButton;
		
		/**
		 * @private
		 * Refresh GLOs button.
		 */
		protected const refresh:RefreshButton = new RefreshButton;

		/**
		 * @private
		 * Button to open QR code reader.
		 */
		protected const qrCode:QRCodeButton = new QRCodeButton;
		
		/**
		 * @private
		 * Button to open journey manager.
		 */
		protected const journeyManager:JourneyManagerButton = new JourneyManagerButton;
		
		//--------------------------------------------------------------------------
		//
		//  qrCodeEnabled
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Set enabled state of the QR Code button.
		 */
		public function set qrCodeEnabled(value:Boolean):void
		{
			qrCode.enabled = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  journeyManagerEnabled
		//
		//--------------------------------------------------------------------------
		
		private var _journeyManagerEnabled:Boolean;
		
		/**
		 * Set enabled state of the journey button.
		 */
		public function set journeyManagerEnabled(value:Boolean):void
		{
			_journeyManagerEnabled = value;
			
			journeyManager.enabled = _journeyManagerEnabled && (state != JOURNEY);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Locks and unlocks navigation buttons.
		 * 
		 * @param	prev	Indicates whether previous navigation control should be disabled or not.
		 * @param	next	Indicates whether next navigation control should be disabled or not.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function lock(prev:Boolean = false, next:Boolean = false):void
		{
			this.prev.enabled = !prev;
			this.next.enabled = !next;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			addEventListener(MouseEvent.CLICK, handleClick);
			state = HOME;
			
			return super.initialize();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
	
			add( menuLink );
			add(refresh);
			add(qrCode);
			add(journeyManager);
			
			next.direction = NavButton.RIGHT;
			add(next);

			prev.direction = NavButton.LEFT;
			add(prev);

			// force redraw
			invalidateDisplay();
		}

		
		override protected function stateChanged(newState:String):void
		{
			super.stateChanged(newState);
			
			journeyManager.enabled = _journeyManagerEnabled && (newState != JOURNEY);
			
			invalidateDisplay();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);

			// sizes
			var gap:Number = ScreenMaths.mmToPixels(0.5);
			var minButtons:Number = 3 * height + 4 * gap;
			var navWidth:Number = Math.min(height, (width - minButtons) / 2);
			var buttonWidth:Number = (width - 2 * navWidth - 4 * gap) / 3;

			prev.height = height;
			next.height = height;
			menuLink.height = height;
			refresh.height = height;
			qrCode.height = height;
			journeyManager.height = height;
			
			prev.width = navWidth;
			next.width = navWidth;
			menuLink.width = buttonWidth;
			refresh.width = buttonWidth;
			qrCode.width = buttonWidth;
			journeyManager.width = buttonWidth;

			// positioning && visible buttons
			var firstButton:Button;
			var lastButton:Button;
			
			prev.x = 0;
			next.x = width - next.width;
			
			switch (state)
			{
				case PLAYER:
				case JOURNEY:
					prev.visible = true;
					next.visible = true;
					qrCode.visible = true;
					menuLink.visible = true;
					journeyManager.visible = true;
					refresh.visible = false;
					
					qrCode.x = navWidth + gap;
					menuLink.x = qrCode.x + buttonWidth + gap;
					journeyManager.x = menuLink.x + buttonWidth + gap;
					
					firstButton = qrCode;
					lastButton = journeyManager;
					break;
				
				default: //HOME
					prev.visible = false;
					next.visible = false;
					qrCode.visible = true;
					menuLink.visible = false;
					journeyManager.visible = false;
					refresh.visible = true;
					
					qrCode.x = (width - gap) / 2 - buttonWidth;
					refresh.x = qrCode.x + buttonWidth + gap;
					
					firstButton = qrCode;
					lastButton = refresh;
					break;
			}
			
			if (!isNaN(width+height))
			{
				graphics.clear();
				
				// background
				DrawingUtils.drawStandardGradient( graphics, width, height );
				
				// gaps
				graphics.beginFill(ColourPalette.DISABLED_BLUE);
				graphics.drawRect(firstButton.x - gap, 0, lastButton.x + lastButton.width + gap - (firstButton.x - gap), height);
				graphics.endFill();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			invalidateDisplay();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handles mouse events generated by <code>GloControl</code>
		 */
		protected function handleClick(event:MouseEvent):void
		{
			if (event.target == next)
				dispatchEvent(ProjectEvent.NEXT_PAGE_EVENT);
			else if(event.target == prev)
				dispatchEvent(ProjectEvent.PREV_PAGE_EVENT);
			else if(event.target == menuLink)
				dispatchEvent(ProjectEvent.MENU_EVENT);
			else if(event.target == refresh)
				dispatchEvent(GloMenuEvent.LIST_ITEMS_EVENT);
			else if(event.target == qrCode)
				dispatchEvent(ApplicationEvent.SHOW_QR_CODE_READER_EVENT);
			else if(event.target == journeyManager)
				dispatchEvent(ApplicationEvent.SHOW_JOURNEY_MANAGER_EVENT);
		}
	}
}