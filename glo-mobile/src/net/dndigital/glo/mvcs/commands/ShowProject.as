package net.dndigital.glo.mvcs.commands
{
	import eu.kiichigo.utils.log;
	
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	import net.dndigital.glo.mvcs.models.GloModel;
	
	import org.robotlegs.mvcs.Command;
	
	public final class ShowProject extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(ShowProject);
		
		
		[Inject]
		/**
		 * @private
		 * Project event, containing reference to received instance of <code>Project</code>.
		 */
		public var event:ProjectEvent;
		
		[Inject]
		/**
		 * @private
		 * Reference to the Model.
		 */
		public var model:GloModel;
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			dispatch(ApplicationEvent.SHOW_PLAYER_EVENT);
			
			model.length = event.project.length;
			model.index = 0;
			log("model={0}", model);
		}
	}
}