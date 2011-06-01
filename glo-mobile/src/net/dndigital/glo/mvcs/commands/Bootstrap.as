package net.dndigital.glo.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.glo.mvcs.events.PlayerEvent;
	import net.dndigital.glo.mvcs.views.Application;
	import net.dndigital.glo.mvcs.views.GloPlayer;
	
	import org.robotlegs.mvcs.Command;
	
	public class Bootstrap extends Command
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
		protected static var log:Function = eu.kiichigo.utils.log(Bootstrap);
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			log("execute()");
			
			contextView.addChild( new Application );
			
			dispatch( PlayerEvent.START_PLAYER_EVENT );
		}
	}
}