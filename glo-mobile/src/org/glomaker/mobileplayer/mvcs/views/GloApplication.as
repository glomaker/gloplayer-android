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
	import flash.system.Capabilities;
	
	import net.dndigital.components.Application;
	import net.dndigital.components.IGUIComponent;
	import org.glomaker.mobileplayer.mvcs.events.ApplicationEvent;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.LogoHeader;
	
	/**
	 * Main and First view of GloMaker Player Application. All views and popups are hosted in <code>Application</code>.
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloApplication extends Application implements IGloView
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
		protected static var log:Function = eu.kiichigo.utils.log(GloApplication);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Reference to an instance of GloPlayer. This is constant since we need to initialize it only once.
		 */
		protected const player:GloPlayer = new GloPlayer;
		
		/**
		 * @private
		 * Reference to an instance of GloMenu. This is constant since we need to initialize it only once.
		 */
		protected const menu:GloMenu = new GloMenu;
		
		
		/**
		 * @private
		 * Reference to logo header. 
		 */		
		protected const logo:LogoHeader = new LogoHeader;
		
		
		/**
		 * @private
		 * Indicates current view.
		 */
		protected var current:IGloView = null;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Activates <code>GloPlayer</code> as it's current view.
		 */
		public function showPlayer():void
		{
			replace(player);
			logo.visible = false;
		}
		
		/**
		 * Activates <code>GloMenu</code> as it's current view.
		 */
		public function showMenu():void
		{
			replace(menu);
			logo.visible = true;
		}
		
		/**
		 * Removes current view. 
		 */		
		public function clear():void
		{
			logo.visible = false;
			
			if( current )
			{
				remove( current );
				current = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			super.initialize();
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITIALIZED));
			
			return this;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			// the logo is the only item always on screen
			// the other elements will be swapped out via the 'replace' function
			add( logo );
			
			// initialise menu subview
			menu.padding = 0; // ScreenMaths.mmToPixels( 3 );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			if (current) {
				current.width = width;
				current.height = height;
			}
			
			logo.width = width;
			logo.height = Math.max( 95, ScreenMaths.mmToPixels( 15 ) ); // max because we need a bit of space for the logo which is about 60px high

			menu.y = logo.height + 1;
			menu.width = width;
			menu.height = height - menu.y;
			
			// black background
			graphics.clear();
			graphics.beginFill( 0x000000, 1 );
			graphics.drawRect( 0, 0, width, height );
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Replaces current view and updates current.
		 */
		protected function replace(view:IGloView):IGloView
		{
			if(current == view)
				return null;
			
			// remove current view if any.
			if(current != null)
				remove(current);
			// add new view, and update current reference.
			current = add(view as IGUIComponent) as IGloView;
			
			return current;
		}
		

	}
}