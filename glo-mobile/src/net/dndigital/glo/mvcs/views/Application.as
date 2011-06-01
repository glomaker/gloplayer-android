package net.dndigital.glo.mvcs.views
{
	import flash.display.Sprite;
	
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
	public class Application extends Sprite
	{
		/**
		 * @private
		 * Indicates an instance of GloPlayer. This is constant since we need to initialize it only once.
		 */
		protected const player:GloPlayer = new GloPlayer;
		
		/**
		 * Activates <code>GloPlayer</code> as it's current view.
		 *  
		 * @return 	Active instance of <code>GloPlayer</code>
		 */
		public function showPlayer():GloPlayer
		{
			if(player.stage == null )
				addChild(player);
			
			return player;
		}
	}
}