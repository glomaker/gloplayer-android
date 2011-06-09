package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.GloMenuEvent;
	import net.dndigital.glo.mvcs.services.IProjectService;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoadProject extends Command
	{
		[Inject]
		/**
		 * @private
		 * ProjectService
		 */
		public var projectService:IProjectService;
		
		[Inject]
		/**
		 * @private
		 * Event
		 */
		public var event:GloMenuEvent;
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			projectService.file = event.file;
		}
	}
}