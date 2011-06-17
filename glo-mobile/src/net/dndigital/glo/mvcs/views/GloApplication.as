package net.dndigital.glo.mvcs.views
{
	import flash.display.Sprite;
	
	import net.dndigital.components.Application;
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.components.Label;
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	
	/**
	 * Main and First view of GloMaker Player Application. All views and popups are hosted in <code>Application</code>.
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloApplication extends Application implements IGloView
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloApplication);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Background Asset
		 */
		protected const gloMakerLogo:GloMakerLogo = new GloMakerLogo;

		/**
		 * @private
		 * Reference to an instance of GloPlayer. This is constant since we need to initialize it only once.
		 */
		protected const player:GloPlayer = new GloPlayer;
		
		/**
		 * @private
		 * Reference to an instance of GloMenu. This is constant since we need to initialize it only once.
		 */
		protected const menu:GloMenu = new GloMenu;
		
		/**
		 * @private
		 * Indicates current view.
		 */
		protected var current:IGloView = null;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Activates <code>GloPlayer</code> as it's current view.
		 */
		public function showPlayer():void
		{
			replace(player);
		}
		
		/**
		 * Activates <code>GloMenu</code> as it's current view.
		 */
		public function showMenu():void
		{
			replace(menu);
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
			super.initialize();
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITIALIZED));
			
			return this;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			const gui:GUIComponent = new GUIComponent;
				  gui.addChild(gloMakerLogo);
			add(gui);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			if (current) {
				current.width = width;
				current.height = height;
			}
			
			const padding:uint = 25;
			gloMakerLogo.width = width - padding * 2;
			gloMakerLogo.height = height - padding * 2;
			gloMakerLogo.x = (width - gloMakerLogo.width) / 2;
			gloMakerLogo.y = (height - gloMakerLogo.height) / 2;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Replaces current view and updates current.
		 */
		protected function replace(view:IGloView):IGloView
		{
			if(current == view)
				return null;
			//log("replace({0}) curret={1} children={2}", view, current, children);
			
			// remove current view if any.
			if(current != null)
				remove(current);
			// add new view, and update current reference.
			current = add(view as IGUIComponent) as IGloView;
			
			return current;
		}
	}
}