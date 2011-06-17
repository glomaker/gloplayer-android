package net.dndigital.glo.mvcs.views
{
	import eu.kiichigo.utils.log;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	
	import net.dndigital.components.*;
	import net.dndigital.glo.mvcs.events.PlayerEvent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.vo.*;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.glocomponents.*;

	/**
	 * Dispatched when an instance of <code>GloPlayer</code> changed page.
	 *
	 * @eventType net.dndigital.glo.mvcs.events.ProjectEvent.PAGE_CHANGED
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4.5
	 */
	[Event(name="pageChanged", type="net.dndigital.glo.mvcs.events.ProjectEvent")]
	/**
	 * Dispatched when instance of <code>GloPlayer</code> is about to switch to next page.
	 *
	 * @eventType net.dndigital.glo.mvcs.events.ProjectEvent.NEXT_PAGE
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4.5
	 */
	[Event(name="nextPage", type="net.dndigital.glo.mvcs.events.ProjectEvent")]
	/**
	 * Dispatched when instance of <code>GloPlayer</code> is about to switch to previous page.
	 *
	 * @eventType net.dndigital.glo.mvcs.events.ProjectEvent.PREV_PAGE
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4.5
	 */
	[Event(name="prevPage", type="net.dndigital.glo.mvcs.events.ProjectEvent")]
	/**
	 * Dispatched when instance of <code>GloPlayer</code> is about to be destroyed.
	 *
	 * @eventType net.dndigital.glo.events.PlayerEvent.DESTROY
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4.5
	 */
	[Event(name="destroy", type="net.dndigital.glo.mvcs.events.PlayerEvent")]
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
		
		/**
		 * @private
		 * Flag, indicates whether background should be redrawn.
		 */
		protected var redrawBackground:Boolean = false;
		
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
			redrawBackground = true;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _fullscreened:IFullscreenable;
		/**
		 * fullscreened.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get fullscreened():IFullscreenable { return _fullscreened; }
		/**
		 * @private
		 */
		public function set fullscreened(value:IFullscreenable):void
		{
			if (_fullscreened == value)
				return;
			_fullscreened = value;
			invalidateDisplay();
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
			addEventListener(TransformGestureEvent.GESTURE_SWIPE, handleSwipe);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
			return super.initialize();
		}
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
			
			if (current) {
				// FIXME 41 is a height of control bar in GloMaker v2. It seems that there is no data about this height in project file, so I had to hardcode it. It would be recommended to move this parameter to project.glo or xml config in future versions.
				const h:int = height - controls.height + 41; // We need to calculate new height.
				const cooficient:Number = Math.min(width / project.width, h / project.height);
				const offset:Point = new Point((width - project.width * cooficient) / 2, (h - project.height * cooficient) / 2);
				const container:Sprite = current as Sprite;
				
				for (var i:int = 0; i < container.numChildren; i ++)
					if (container.getChildAt(0) is IGloComponent)
						resize(container.getChildAt(i) as IGloComponent, cooficient, offset);
			}

			graphics.clear();
			if (project) {
				graphics.beginFill(project.background);
				graphics.drawRect(0, 0, width, height - controls.height);
				graphics.endFill();
			}
			
			//log("resized");
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (project != built)
				build().invalidateDisplay();
			
			if (pages != null && pages.length > 0 && _index != -1 && pages[_index] != current) {
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
			
			dispatchEvent(new ProjectEvent(ProjectEvent.PAGE_CHANGED, _project, _index));
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
					case "rectangle":
						container.addChild(component(new Rectangle, page.components[i]));
						break;
					case "videoplayer":
						container.addChild(component(new VideoPlayer, page.components[i]));
						break;
					case "swfloader":
						container.addChild(component(new FlashAnimation, page.components[i]));
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
			target.component   	= vo;
			target.player		= this;
			return target as DisplayObject;
		}
		
		/**
		 * Function handles resizing of instances of <code>IGloComponent</code>.
		 * 
		 * @param component		<code>IGloComponent</code> instance to be resized.
		 * @param cooficient	<code>Number</code>. Cooficient that's used for resizing. It should be calculated prior to resing.
		 * @return 				<code>IGloCompomnent</code> that was just resized.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function resize(component:IGloComponent, cooficient:Number, offset:Point):IGloComponent
		{
			if (fullscreened == null) {
				const vo:Component = component.component;
				component.x = vo.x * cooficient + offset.x;
				component.y = vo.y * cooficient + offset.y;
				component.width = vo.width * cooficient;
				component.height = vo.height * cooficient;
				component.visible = true;
			} else {
				if (component is IFullscreenable && component == _fullscreened) {
					component.x = component.y = 0;
					component.width = stage.fullScreenWidth;
					component.height = stage.fullScreenHeight;
					component.visible = true;
				} else {
					component.visible = false;
				}
			}
			return component;
		}
		
		/**
		 * @private
		 * Handles swipe events.
		 */
		protected final function handleSwipe(event:TransformGestureEvent):void
		{
			if(event.offsetX == -1)
				dispatchEvent(ProjectEvent.NEXT_PAGE_EVENT);
			else
				dispatchEvent(ProjectEvent.PREV_PAGE_EVENT);
		}
		
		/**
		 * Handles REMOVED_FROM_STAGE event, and notifies sub children of it's impending destruction.
		 */
		protected function removedFromStage(event:Event):void
		{
			log("removedFromStage()");
			dispatchEvent(PlayerEvent.DESTROY_EVENT);
		}
	}
}