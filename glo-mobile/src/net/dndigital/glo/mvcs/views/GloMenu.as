package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.utils.Dictionary;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.mobile.IMobileListItemRenderer;
	import net.dndigital.components.mobile.MobileListEvent;
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.models.vo.Glo;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.GTouchList;
	import net.dndigital.glo.mvcs.views.components.MenuListItem;

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
				
				for (var i:int = 0; i < _files.length*10; i ++)
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
				dispatchEvent(new GloMenuEvent(GloMenuEvent.LOAD_FILE, glo.file));
		}
	}
}