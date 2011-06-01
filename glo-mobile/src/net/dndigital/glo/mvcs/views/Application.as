package net.dndigital.glo.mvcs.views
{
	import flash.display.Sprite;
	
	public class Application extends Sprite
	{
		/**
		 * @private
		 * Indicates an instance of GloPlayer. This is constant since we need to initialize it only once.
		 */
		protected const player:GloPlayer = new GloPlayer;
		
		public function showPlayer():GloPlayer
		{
			if(player.stage == null )
				addChild(player);
			
			return player;
		}
		
		public function hidePlayer():GloPlayer
		{
			if(player.stage != null)
				removeChild(player);
			
			return player;
		}
	}
}