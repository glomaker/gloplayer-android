package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.models.vo.Glo;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.GTouchList;
	import net.dndigital.glo.mvcs.views.components.MenuListItem;
	
	import thanksmister.touchlist.renderers.ITouchListItemRenderer;
	
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
		 * maps ITouchListItemRenderer instances ot their Glo value objects. 
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
			list.addEventListener( MouseEvent.CLICK, handleButton );
		}
		
		/**
		 * @iheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			var listPadding:uint = 15;
			var topPadding:uint = ScreenMaths.mmToPixels(20);
			
			list.x = listPadding;
			list.y = topPadding;
			list.width = width - 2*listPadding;
			list.height = height - topPadding - listPadding;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (filesChanged) {
				
				list.touchList.removeListItems();
				fileDict = new Dictionary();
				
				for (var i:int = 0; i < _files.length*20; i ++)
				{
					var ir:ITouchListItemRenderer = new MenuListItem();
					ir.data = _files[i % _files.length].displayName;
					ir.itemHeight = ScreenMaths.mmToPixels(10);
					list.touchList.addListItem( ir );
					
					fileDict[ ir ] = _files[ i % _files.length ];
				}

				invalidateDisplay();
				filesChanged = false;
			}
		}
		
		/**
		 * @private
		 * Handles menu buttons clicks.
		 */
		protected function handleButton(event:MouseEvent):void
		{
			var glo:Glo = fileDict[ event.target ];
			if( glo )
				dispatchEvent(new GloMenuEvent(GloMenuEvent.LOAD_FILE, glo.file));
		}
	}
}