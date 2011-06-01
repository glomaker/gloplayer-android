package net.dndigital.glo.mvcs.commands
{
	import net.dndigital.glo.mvcs.events.ApplicationEvent;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Starts a Player on <code>Application</code>.
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */	public class StartPlayer extends Command
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
		protected static var log:Function = eu.kiichigo.utils.log(StartPlayer);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		/**
		 * @private
		 * An instance of <code>ApplicationEvent</code>
		 */
		public var event:ApplicationEvent;
		
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
			event.application.showPlayer();
		}
	}
}