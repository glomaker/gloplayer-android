package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	import net.dndigital.glo.mvcs.events.ProjectEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public final class ShowProject extends Command
	{
		[Inject]
		/**
		 * @private
		 * Project event, containing reference to received instance of <code>Project</code>.
		 */
		public var event:ProjectEvent;
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			dispatch(ApplicationEvent.SHOW_PLAYER_EVENT);
		}
	}
}