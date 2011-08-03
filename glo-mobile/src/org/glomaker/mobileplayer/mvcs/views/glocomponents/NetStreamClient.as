package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.glomaker.mobileplayer.mvcs.events.NetStreamEvent;

	[Exclude(kind="event", name="activate")]
	[Exclude(kind="event", name="deactivate")]
	
	[Event(name="metaData", type="org.glomaker.mobileplayer.mvcs.events.NetStreamEvent")]
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
			dispatchEvent(new NetStreamEvent(NetStreamEvent.META_DATA, infoObject.width, infoObject.height, infoObject.duration));
		}
		public function onXMPData(infoObject:Object):void
		{
			// ignored
		}
		public function onCuePoint(info:Object):void
		{
			// ignored
		}
		public function onSeekPoint(info:Object):void
		{
			// ignored
		}
		public function onImageData(infoObject:Object):void
		{
			// ignored
		}
		public function onPlayStatus(infoObject:Object):void
		{
			// ignored
		}
		public function onTextData(infoObject:Object):void
		{
			// ignored
		}

	}
}