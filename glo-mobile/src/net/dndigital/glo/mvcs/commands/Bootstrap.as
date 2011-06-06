package net.dndigital.glo.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.components.Application;
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.views.GloApplication;
	import net.dndigital.glo.mvcs.views.GloPlayer;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Bootstraps and initializes an application.
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
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
			var application:Application = new GloApplication;
				application.width = contextView.stage.fullScreenWidth;
				application.height = contextView.stage.fullScreenHeight;
				
			log("height={0},{1},{2}", contextView.stage);
			contextView.addChild(application);
		}
	}
}