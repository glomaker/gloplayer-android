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
	import eu.kiichigo.utils.log;
	
	import flash.display.AVM1Movie;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	import net.dndigital.components.IGUIComponent;

	public final class FlashAnimation extends GloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(FlashAnimation);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected const container:Sprite = new Sprite;
		
		/**
		 * @private
		 */
		protected const loader:Loader = new Loader;
		
		/**
		 * @private
		 * A Reference to loaded SWF file.
		 */
		protected var swf:DisplayObject;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _source:String = "";
		/**
		 * source.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get source():String { return _source; }
		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			if (_source == value)
				return;
			_source = value;
			load(value);
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _containerWidth:int;
		/**
		 * containerWidth.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get containerWidth():int { return _containerWidth; }
		/**
		 * @private
		 */
		public function set containerWidth(value:int):void
		{
			if (_containerWidth == value)
				return;
			_containerWidth = value;
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _containerHeight:int;
		/**
		 * containerHeight.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get containerHeight():int { return _containerHeight; }
		/**
		 * @private
		 */
		public function set containerHeight(value:int):void
		{
			if (_containerHeight == value)
				return;
			_containerHeight = value;
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _background:uint;
		/**
		 * background.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get background():uint { return _background; }
		/**
		 * @private
		 */
		public function set background(value:uint):void
		{
			if (_background == value)
				return;
			_background = value;
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected var _playControl:Boolean;
		/**
		 * playControl.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get playControl():Boolean { return _playControl; }
		/**
		 * @private
		 */
		public function set playControl(value:Boolean):void
		{
			if (_playControl == value)
				return;
			_playControl = value;
			invalidateData();
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
			mapProperty("filePath", "source");
			mapProperty("bgcolour", "background");
			mapProperty("containerWidth");
			mapProperty("containerHeight");
			mapProperty("playControlValue", "playControl");
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
				
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(container);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			const cooficient:Number = Math.min(width / containerWidth, height / containerHeight);
			
			container.width = containerWidth * cooficient;
			container.height = containerHeight * cooficient;
			
			graphics.clear();
			graphics.beginFill(_background);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			
			loader.unload();
			
			if (swf && swf.parent) {
				container.removeChild(swf);
				swf = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Loads a SWF file and adds it to display list.
		 */
		protected function load(source:String):void
		{
			loader.unload();
			if (source != null)
				loader.load(new URLRequest(component.directory.resolvePath(source).url));
		}
		
		/**
		 * @private
		 */
		protected function handleLoadComplete(event:Event):void
		{
			//log("handleLoadComplete() content={0}", loader.content);
			if (loader.content is AVM1Movie)
				swf = container.addChild(loader);
			else
				swf = container.addChild(loader.content);
			Mouse.show();	// TODO Some movies hide cursor, this fixes this behavior, see if that's needed.
			invalidateDisplay();
		}
		
		/**
		 * @private
		 */
		protected function handleLoadError(event:IOErrorEvent):void
		{
			log("handleLoadError({0})", event);
		}
	}
}