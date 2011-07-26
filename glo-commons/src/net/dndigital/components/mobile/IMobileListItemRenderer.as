package net.dndigital.components.mobile
{
	/**
	 * Interface for MobileList item renderers. 
	 * @author nilsmillahn
	 */	
	public interface IMobileListItemRenderer
	{
		function set data(value:Object):void;
		function get data():Object;
		function set index(value:Number):void;
		function get index():Number;
		function set itemWidth(value:Number):void;
		function get itemWidth():Number;
		function set itemHeight(value:Number):void;
		function get itemHeight():Number;
		function selectItem():void;
		function unselectItem():void;
		function destroy():void;
	}
}