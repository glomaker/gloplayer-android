package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.components.Application;
	import net.dndigital.glo.mvcs.views.GloApplication;
	
	import org.robotlegs.mvcs.Command;

	/**
	 * Creates the main application view.
	 * Call once when application is ready to run. 
	 * @author nilsmillahn
	 */	
	public class CreateApplicationView extends Command
	{

		/**
		 * @inheritDoc 
		 */		
		override public function execute():void
		{
			// main app view
			var application:Application = new GloApplication;
			application.width = contextView.stage.fullScreenWidth;
			application.height = contextView.stage.fullScreenHeight;
			
			contextView.addChild(application);
		}
	
	}
}