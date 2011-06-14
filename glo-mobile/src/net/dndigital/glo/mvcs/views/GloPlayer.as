package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.filter;
	import eu.kiichigo.utils.log;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import net.dndigital.components.Container;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.models.vo.Component;
	import net.dndigital.glo.mvcs.models.vo.Page;
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.glocomponents.IGloComponent;
	import net.dndigital.glo.mvcs.views.glocomponents.Image;
	import net.dndigital.glo.mvcs.views.glocomponents.Placeholder;
	import net.dndigital.glo.mvcs.views.glocomponents.Rectangle;
	import net.dndigital.glo.mvcs.views.glocomponents.TextArea;
	import net.dndigital.glo.mvcs.views.glocomponents.VideoPlayer;
	
	/**
	 * 
	 * @see		net.dndigital.glo.mvcs.views.GloPlayerMediator
	 * @see		net.dndigital.glo.mvcs.models.vo.Project
	 * @see 	net.dndigital.core.Component
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloPlayer extends Container implements IGloView
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloPlayer);
		
		//--------------------------------------------------------------------------
		//
		//  Private Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Collection of component that displayed in a GloPlayer.
		 */
		protected const components:Vector.<IGloComponent> = new Vector.<IGloComponent>;
		
		/**
		 * @private
		 * Reference to Controls that manipulate next/previous slides and other aspects of player.
		 */
		protected const controls:GloControls = new GloControls;
		
		/**
		 * @private
		 * Reference to the project instance that was seccessfuly build.
		 */
		protected var built:Project;
		
		/**
		 * @private
		 * Collection of Pages Components.
		 */
		protected const pages:Vector.<IGUIComponent> = new Vector.<IGUIComponent>;
		
		/**
		 * @private
		 * Reference to currently displayed page.
		 */
		protected var current:IGUIComponent;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _index:int = -1;
		/**
		 * index.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get index():int { return _index; }
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			if (_index == value)
				return;
			_index = value;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _project:Project;
		/**
		 * Reference to Pro
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get project():Project { return _project; }
		/**
		 * @private
		 */
		public function set project(value:Project):void
		{
			if (_project == value)
				return;
			_project = value;
			log("project({0})", value);
			invalidateData();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			controls.width = _width;
			controls.height = ScreenMaths.mmToPixels(10);
			add(controls);
		}
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			controls.width = width;
			controls.y = height - controls.height;
			
			if(project) {
				graphics.clear();
				graphics.beginFill(project.background);
				graphics.drawRect(0, 0, width, height - controls.height);
				graphics.endFill();
			}
			
			log("resized");
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if(project != built)
				build().invalidateDisplay();
			
			if(pages != null && pages.length > 0 && _index != -1 && pages[_index] != current) {
				replace(index);
				invalidateDisplay();
			}
			
			// Decide whether Navigation Buttons needs to be locked or not.			
			controls.lock(_index == 0,
						  _index == _project.length - 1);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Replaces a page which displayed now with provided in index.
		 */
		protected function replace(index:int):IGUIComponent
		{
			if (current)
				remove(current);
			
			if (pages != null && pages.length > 0)
				current = add(pages[index]) as IGUIComponent;
			else
				current = null;
			
			bringToFront(controls);
			
			if (_index != index)
				_index = index;
			return current;
		}
		
		/**
		 * @private
		 * Builds Pages and inner Components in a player.
		 */
		protected function build():GloPlayer
		{
			clear(false);
			
			if(project == null)
				return this;
			
			for (var i:int = 0; i < project.pages.length; i ++)
				pages.push(page(project.pages[i]));
			
			pages.fixed = true;
			built = project;
			
			
			return this;
		}
		
		/**
		 * @private
		 * Removes pages from Player.
		 */
		protected function clear(sealList:Boolean = true):GloPlayer
		{
			pages.fixed = false;
			while (pages.length) {
				var page:Sprite = pages.shift();
				if (page.stage)
					remove(pages.shift());
			}
			pages.fixed = sealList;
			built = null;
			
			while (components.length)
				components.pop();

			return this;
		}
		
		/**
		 * @private
		 * Handles rearranging and resizing components on pages.
		 */
		protected function rearrange(width:int, height:int):void
		{
			var w:int = _project.width;
			var h:int = _project.height;
		
			for (var i:uint = 0; i < components.length; i ++) {
				var c:IGloComponent = components[i];
				var vo:Component	= c.component;
			}
		}
		
		/**
		 * @private
		 * Creates single page.
		 */
		protected function page(page:Page):IGUIComponent
		{
			const container:GUIComponent = new GUIComponent;
			
			for (var i:int = 0; i < page.components.length; i ++)
				switch(page.components[i].id)
				{
					case "textarea":
						container.addChild(component(new TextArea, page.components[i]));
						break;
					case "imageloader":
						container.addChild(component(new Image, page.components[i]));
						break;
					case "videoplayer":
						container.addChild(component(new VideoPlayer, page.components[i]));
						break;
					case "rectangle":
						container.addChild(component(new Rectangle, page.components[i]));
						break;
					case "videoplayer":
						container.addChild(component(new VideoPlayer, page.components[i]));
						break;
					default:
						container.addChild(component(new Placeholder, page.components[i]));
						break;
				}
		
			return container;
		}
		
		/**
		 * @private
		 * Initializes a component.
		 */
		protected function component(target:IGloComponent, vo:Component):DisplayObject
		{
			if (components.indexOf(target) == -1)
				components.push(target);
			target.x 	 		= vo.x;
			target.y 	  		= vo.y;
			target.width  		= vo.width;
			target.height 		= vo.height;
			target.component   	= vo;
			return target as DisplayObject;
		}
	}
}