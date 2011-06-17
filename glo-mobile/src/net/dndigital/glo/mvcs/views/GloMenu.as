package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.filter;
	import eu.kiichigo.utils.log;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.system.System;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.MenuButton;
	
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
		 * @private
		 * Container for buttons.
		 */
		protected const buttons:Container = new Container;
		
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
		protected var _files:Vector.<File>;
		/**
		 * files.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get files():Vector.<File> { return _files; }
		/**
		 * @private
		 */
		public function set files(value:Vector.<File>):void
		{
			if (_files == value)
				return;
			_files = value;
			filesChanged = true;
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
		override protected function createChildren():void
		{
			buttons.fitToContent = true;
			add(buttons);
			super.createChildren();
		}
		
		/**
		 * @iheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			buttons.invalidateDisplay();
			//buttons.validate();
			buttons.x = (width - buttons.width) / 2;
			buttons.y = (height - buttons.height) / 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (filesChanged) {
				buttons.removeAll(destroyButton);
				for (var i:int = 0; i < _files.length; i ++) {
					var button:MenuButton = new MenuButton;
						button.y = i * ScreenMaths.mmToPixels(8);
						button.file = _files[i];
						button.addEventListener(MouseEvent.CLICK, handleButton);
					buttons.add(button);
					invalidateDisplay();
				}
				filesChanged = false;
			}
		}
		
		/**
		 * @private
		 * Finilizes existance of a <code>MenuButton</code>.
		 */
		protected final function destroyButton(component:IGUIComponent):void
		{
			//if (component is MenuButton)
				component.removeEventListener(MouseEvent.CLICK, handleButton);
		}
		
		/**
		 * @private
		 * Handles menu buttons clicks.
		 */
		protected function handleButton(event:MouseEvent):void
		{
			dispatchEvent(new GloMenuEvent(GloMenuEvent.LOAD_FILE, event.target.file));
		}
	}
}