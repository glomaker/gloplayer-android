package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.dndigital.glo.events.NetStreamEvent;

	[Exclude(kind="event", name="activate")]
	[Exclude(kind="event", name="deactivate")]
	
	[Event(name="metaData", type="net.dndigital.glo.events.NetStreamEvent")]
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
			log("onMetaData()");
			dispatchEvent(new NetStreamEvent(NetStreamEvent.META_DATA, infoObject.width, infoObject.height, infoObject.duration));
		}
	}
}