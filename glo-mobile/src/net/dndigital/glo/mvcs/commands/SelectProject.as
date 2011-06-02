package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.services.IProjectService;
	
	import org.robotlegs.mvcs.Command;
	
	public class SelectProject extends Command
	{
		[Inject]
		/**
		 * @private
		 * ProjectService
		 */
		public var projectService:IProjectService;
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			projectService.select();
		}
	}
}