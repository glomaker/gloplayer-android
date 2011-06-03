package net.dndigital.glo.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.views.GloApplication;
	
	import org.robotlegs.mvcs.Command;
	
	public final class ShowPlayer extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(ShowPlayer);
		
		
		[Inject]
		/**
		 * @private
		 * Project event, containing reference to received instance of <code>Project</code>.
		 */
		public var event:ProjectEvent;
		
		[Inject]
		/**
		 * @private
		 * Project event, containing reference to received instance of <code>Project</code>.
		 */
		public var application:GloApplication;
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			log("execute() event={0} application={1}", event, application);
		}
	}
}