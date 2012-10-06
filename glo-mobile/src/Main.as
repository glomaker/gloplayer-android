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
 *
 * The LocalNotificationLib native extension, by Juan Carlos Pazmino (https://bitbucket.org/juankpro/jklocalnotifications-ane)
*/
package
{
	import com.greensock.TweenLite;
	
	import eu.kiichigo.utils.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.GloContext;
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.utils.FontUtil;
	import org.glomaker.mobileplayer.mvcs.views.components.MenuButton;
	import org.robotlegs.mvcs.Context;
	
	[SWF(backgroundColor='#000000')]
	public class Main extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(Main);
		
		
		/**
		 * @private
		 */
		protected var gloContext:GloContext;
		
		public function Main()
		{
			super();
			
			stage.frameRate = 24;
			
			// fonts
			FontUtil.init();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// RobotLegs bootstrap
			gloContext = new GloContext(this);

			// mobile lifecycle events
			addEventListener( Event.ACTIVATE, handleActivate );
			addEventListener( Event.DEACTIVATE, handleDeactivate );
			
			// Multitouch Gestures
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
		}

		/**
		 * Event handler - mobile app activated. 
		 * @param e
		 */		
		protected function handleActivate( e:Event ):void
		{
			stage.frameRate = 24;
			gloContext.dispatchEvent( ApplicationEvent.ACTIVATE_EVENT );
		}
		
		/**
		 * Event handler - mobile app deactivated. 
		 * @param e
		 */		
		protected function handleDeactivate( e:Event ):void
		{
			stage.frameRate = 0.1;
			gloContext.dispatchEvent( ApplicationEvent.DEACTIVATE_EVENT );
		}
	}
}