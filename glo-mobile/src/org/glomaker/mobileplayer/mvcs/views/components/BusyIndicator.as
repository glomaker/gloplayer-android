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
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	import mx.core.MovieClipLoaderAsset;
	
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
		
		[Embed(source="../assets/busy-indicator.swf")]
		protected static const AnimAsset:Class;
		
		//--------------------------------------------------
		// Protected properties
		//--------------------------------------------------
		
		protected const anim:MovieClipLoaderAsset = new AnimAsset();
		protected const blur:BlurFilter = new BlurFilter(3, 3);
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function BusyIndicator()
		{
			anim.addEventListener(Event.COMPLETE, anim_completeHandler);
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
		// Overridden functions
		//--------------------------------------------------
		
		/**
		 * Overridden to add/remove the animation to prevent it from using resources when
		 * the busy indicator is not visible.
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if (value == visible)
				return;
			
			super.visible = value;
			
			if (visible && !anim.parent)
				addChild(anim);
			else if (!visible && anim.parent)
				removeChild(anim);
			
			if (application)
			{
				width = application.width;
				height = application.height;
				application.filters = visible ? [ blur ] : null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (visible)
				addChild(anim);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			//center anim
			anim.x = (width - anim.measuredWidth) / 2;
			anim.y = (height - anim.measuredHeight) / 2;
			
			//background
			graphics.clear();
			graphics.beginFill(0, 0.5);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handle animation complete event to reposition it when it completes loading.
		 */
		protected function anim_completeHandler(event:Event):void
		{
			anim.removeEventListener(Event.COMPLETE, anim_completeHandler);
			invalidateDisplay();
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