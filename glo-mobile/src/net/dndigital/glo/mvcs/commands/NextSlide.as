package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.SlideEvent;
	
	import org.robotlegs.mvcs.Command;

	public class NextSlide extends Command
	{
		protected var event:SlideEvent;
		
		public function NextSlide()
		{
			super();
		}
	}
}