package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.events.EventDispatcher;

	public final class NetStreamClient extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(NetStreamClient);
		
		//--------------------------------------------------------------------------
		//
		//  NetStream Handlers
		//
		//--------------------------------------------------------------------------
		
		public function onMetaData(infoObject:Object):void
		{
			log("onMetaData({0*})", infoObject);
		}
	}
}