package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.NodeEvent;
	
	import org.robotlegs.mvcs.Command;

	public class NextSlide extends Command
	{
		protected var event:NodeEvent;
		
		public function NextSlide()
		{
			super();
		}
	}
}