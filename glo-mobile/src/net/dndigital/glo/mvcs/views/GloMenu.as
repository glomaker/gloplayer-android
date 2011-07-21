package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
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
		 * @private
		 * Container for buttons.
		 */
		protected const buttons:Container = new Container;
		
		
		protected const list:GTouchList = new GTouchList; 
		
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
			// add(buttons);
			add(list);
			list.addEventListener( MouseEvent.CLICK, handleButton );
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
				buttons.removeAll(destroyButton);
				list.touchList.removeListItems();
				fileDict = new Dictionary();
				
				for (var i:int = 0; i < _files.length*20; i ++)
				{
					var ir:ITouchListItemRenderer = new MenuListItem();
					ir.data = getButtonName(_files[i % _files.length]);
					ir.itemHeight = ScreenMaths.mmToPixels(10);
					list.touchList.addListItem( ir );
					
					fileDict[ ir ] = _files[ i % _files.length ];
				}
				
				/*
					var button:MenuButton = new MenuButton;
						button.y = i * ScreenMaths.mmToPixels(8);
						button.file = _files[i];
						button.addEventListener(MouseEvent.CLICK, handleButton);
					buttons.add(button);
				*/

				invalidateDisplay();
				filesChanged = false;
			}
		}
		
		private function getButtonName( file:File ):String
		{
			// we use the name of the .glo file
			// unless it's the generic 'project.glo', in which case we use the parent folder instead
			var lowerName:String = file.name.toLowerCase();
			
			if( lowerName != "project.glo" )
			{
				// strip off the '.glo' extension
				return file.name.substr( 0, lowerName.lastIndexOf(".") );
			}
			
			// generic filename
			// use parent folder name instead
			return file.parent.name;
			
			/*
			var name:String = file.  .name.split(".glo").join("");
			
			
			
			if (name.toUpperCase() == "PROJECT") {
				if (file.url.indexOf("Glos") >= 0)
					name = file.url.split("Glos")[1];
				else
					name = file.url.split("app:/assets/")[1];
			}
			
			name = name.split("/").join("").
				split("\"").join("").
				split("project.glo").join("");
			
			return name;
			*/
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
			var f:File = fileDict[ event.target ];
			if( f )
				dispatchEvent(new GloMenuEvent(GloMenuEvent.LOAD_FILE, f));
		}
	}
}