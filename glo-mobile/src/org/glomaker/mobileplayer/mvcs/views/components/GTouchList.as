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
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.mobile.MobileList;
	
	/**
	 * Provides a GUIComponent wrapper for the TouchList class so that it can be added to containers. 
	 * @author nilsmillahn
	 * 
	 */	
	public class GTouchList extends GUIComponent
	{
	
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * TouchList component wrapped by this class 
		 */		
		protected const _list:MobileList = new MobileList(0, 0);
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */		
		public function GTouchList()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns the TouchList instance contained within the component. 
		 * @return 
		 */		
		public function get touchList():MobileList
		{
			return _list;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  GUIComponent implementation
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild( _list );
		}
		
		/**
		 * @inheritDoc 
		 * @param width
		 * @param height
		 */		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			_list.resize( width, height );
		}
		
	}
}