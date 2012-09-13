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
	
	import flash.utils.Dictionary;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.mobile.IMobileListItemRenderer;
	import net.dndigital.components.mobile.MobileListEvent;
	
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.GTouchList;
	import org.glomaker.mobileplayer.mvcs.views.components.MenuListItem;

	/**
	 * View component used to display the menu. 
	 * @author nilsmillahn
	 * 
	 */	
	public class GloMenu extends Container implements IGloView
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(GloMenu);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * menu list 
		 */		
		protected const list:GTouchList = new GTouchList; 
		
		/**
		 * maps IMobileListItemRenderer instances ot their Glo value objects. 
		 */		
		protected var fileDict:Dictionary = new Dictionary();
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var filesChanged:Boolean = false;

		/**
		 * @private
		 */
		protected var _files:Vector.<Glo>;
		
		/**
		 * files.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get files():Vector.<Glo> { return _files; }
		
		/**
		 * @private
		 */
		public function set files(value:Vector.<Glo>):void
		{
			if (_files == value)
				return;
			
			_files = value;
			filesChanged = true;
			invalidateData();
		}
		
		/**
		 * Padding to use around the menu list.
		 * The space will be left blank. 
		 */		
		protected var _padding:Number = 10;
		
		public function get padding():Number
		{
			return _padding;
		}
		
		public function set padding(value:Number):void
		{
			if( value != _padding )
			{
				_padding = value;
				invalidateDisplay();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			add(list);
			list.addEventListener( MobileListEvent.ITEM_SELECTED, handleButton );
		}
		
		/**
		 * @iheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			list.x = padding;
			list.y = padding;
			list.width = width - 2*padding;
			list.height = height - 2*padding;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (filesChanged)
			{
				list.touchList.removeListItems();
				fileDict = new Dictionary();
				var buffer:Vector.<IMobileListItemRenderer> = new Vector.<IMobileListItemRenderer>();
				
				for (var i:int = 0; i < _files.length; i ++)
				{
					var ir:IMobileListItemRenderer = new MenuListItem();
					ir.data = _files[i % _files.length].displayName;
					ir.itemHeight = Math.round( ScreenMaths.mmToPixels(15) );
					buffer.push( ir );
					
					fileDict[ ir ] = _files[ i % _files.length ];
				}
				
				list.touchList.addListItems( buffer );
				filesChanged = false;
				invalidateDisplay();
			}
		}
		
		/**
		 * @private
		 * Handles menu buttons clicks.
		 */
		protected function handleButton(event:MobileListEvent):void
		{
			var glo:Glo = fileDict[ event.item ];
			if( glo )
				dispatchEvent(new LoadProjectEvent(LoadProjectEvent.SHOW, glo));
		}
	}
}