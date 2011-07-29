package net.dndigital.glo.mvcs.views
{
	import flash.system.Capabilities;
	
	import net.dndigital.components.Application;
	import net.dndigital.components.IGUIComponent;
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.utils.ScreenMaths;
	import net.dndigital.glo.mvcs.views.components.LogoHeader;
	
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
		 * Reference to logo header. 
		 */		
		protected const logo:LogoHeader = new LogoHeader;
		
		
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
			logo.visible = false;
		}
		
		/**
		 * Activates <code>GloMenu</code> as it's current view.
		 */
		public function showMenu():void
		{
			replace(menu);
			logo.visible = true;
		}
		
		/**
		 * Removes current view. 
		 */		
		public function clear():void
		{
			logo.visible = false;
			
			if( current )
			{
				remove( current );
				current = null;
			}
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
			
			// the logo is the only item always on screen
			// the other elements will be swapped out via the 'replace' function
			add( logo );
			
			// initialise menu subview
			menu.padding = 0; // ScreenMaths.mmToPixels( 3 );
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
			
			logo.width = width;
			logo.height = Math.max( 95, ScreenMaths.mmToPixels( 15 ) ); // max because we need a bit of space for the logo which is about 60px high

			menu.y = logo.height + 1;
			menu.width = width;
			menu.height = height - menu.y;
			
			// black background
			graphics.clear();
			graphics.beginFill( 0x000000, 1 );
			graphics.drawRect( 0, 0, width, height );
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
			
			// remove current view if any.
			if(current != null)
				remove(current);
			// add new view, and update current reference.
			current = add(view as IGUIComponent) as IGloView;
			
			return current;
		}
		

	}
}