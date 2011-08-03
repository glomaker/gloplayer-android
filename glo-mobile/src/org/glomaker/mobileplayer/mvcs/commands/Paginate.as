package org.glomaker.mobileplayer.mvcs.commands
{	
	import eu.kiichigo.utils.log;
	
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.views.GloPlayer;
	
	import org.robotlegs.mvcs.Command;

	public class Paginate extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(Paginate);
		
		[Inject]
		/**
		 * @private
		 * Project event, containing reference to received instance of <code>Project</code>.
		 */
		public var event:ProjectEvent;
		
		[Inject]
		/**
		 * @private
		 * 
		 */
		public var model:GloModel;
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			if (event.type == ProjectEvent.NEXT_PAGE) {
				if (model.index < (model.length - 1))
					model.index ++;
			}
			
			if (event.type == ProjectEvent.PREV_PAGE) {
				if (model.index > 0)
					model.index --;
			}
		}
	}
}