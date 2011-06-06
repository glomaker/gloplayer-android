package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.net.dns.AAAARecord;
	
	import net.dndigital.core.Container;
	import net.dndigital.core.IUIComponent;
	import net.dndigital.core.UIComponent;
	import net.dndigital.glo.mvcs.models.vo.Component;
	import net.dndigital.glo.mvcs.models.vo.Page;
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.glo.mvcs.views.controls.Controls;
	import net.dndigital.glo.mvcs.views.controls.IGloComponent;
	import net.dndigital.glo.mvcs.views.controls.Image;
	import net.dndigital.glo.mvcs.views.controls.TextArea;
	import net.dndigital.glo.mvcs.views.controls.VideoPlayer;
	
	/**
	 * 
	 *
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
		 * Reference to Controls that manipulate next/previous slides and other aspects of player.
		 */
		protected const controls:Controls = new Controls;
		
		/**
		 * @private
		 * Reference to the project instance that was seccessfuly build.
		 */
		protected var builded:Project;
		
		/**
		 * @private
		 * Collection of Pages Components.
		 */
		protected const pages:Vector.<IUIComponent> = new Vector.<IUIComponent>;
		
		/**
		 * @private
		 * Reference to currently displayed page.
		 */
		protected var current:IUIComponent;
		
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
			invalidateData();
			log("project({0})", value);
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
			controls.height = 50;
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
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if(project != builded)
				build().invalidateDisplay();
			
			if(pages != null && pages.length > 0 && _index != -1 && pages[_index] != current)
				replace(index);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function replace(index:int):IUIComponent
		{
			if (current)
				remove(current);
			
			if (pages != null && pages.length > 0)
				current = add(pages[index]) as IUIComponent;
			else
				current = null;
			log("replace({0}) current={1}", index, current);
			return current;
		}
		
		/**
		 * @private
		 */
		protected function build():GloPlayer
		{
			clear(false);
			
			if(project == null)
				return this;
			
			for (var i:int = 0; i < project.pages.length; i ++)
				pages.push(create(project.pages[i]));
			
			index = 0;
			pages.fixed = true;
			invalidateDisplay();
			builded = project;
			return this;
		}
		
		/**
		 * @private
		 * Clears Player from pages.
		 */
		protected function clear(sealList:Boolean = true):GloPlayer
		{
			pages.fixed = false;
			while(pages.length) {
				var page:Sprite = pages.shift();
				if(page.stage)
					removeChild(pages.shift());
			}
			pages.fixed = sealList;
			return this;
		}
		
		/**
		 * @private
		 * Build single page.
		 */
		protected function create(page:Page):IUIComponent
		{
			const c:UIComponent = new UIComponent;
			
			for (var i:int = 0; i < page.components.length; i ++)
				switch(page.components[i].id)
				{
					case "textarea":
						c.addChild(component(new TextArea, page.components[i]) as DisplayObject);
						break;
					case "imageloader":
						c.addChild(component(new Image, page.components[i]) as DisplayObject);
						break;
					case "videoplayer":
						c.addChild(component(new VideoPlayer, page.components[i]) as DisplayObject);
						break;
					default:
						break;
				}
			
			return c;
		}
		
		/**
		 * @private
		 * Initializes a component.
		 */
		protected function component(target:IGloComponent, data:Component):IGloComponent
		{
			target.x 	  = data.x;
			target.y 	  = data.y;
			target.width  = data.width;
			target.height = data.height;
			return target.initialize() as IGloComponent;
		}
	}
}