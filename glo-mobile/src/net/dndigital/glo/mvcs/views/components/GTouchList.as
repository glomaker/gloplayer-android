package net.dndigital.glo.mvcs.views.components
{
	import net.dndigital.components.GUIComponent;
	
	import thanksmister.touchlist.controls.TouchList;
	
	/**
	 * Provides a GUIComponent wrapper for the TouchList class so that it can be added to containers. 
	 * @author nilsmillahn
	 * 
	 */	
	public class GTouchList extends GUIComponent
	{
	
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * TouchList component wrapped by this class 
		 */		
		protected const _list:TouchList = new TouchList(0, 0);
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */		
		public function GTouchList()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns the TouchList instance contained within the component. 
		 * @return 
		 */		
		public function get touchList():TouchList
		{
			return _list;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  GUIComponent implementation
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild( _list );
		}
		
		/**
		 * @inheritDoc 
		 * @param width
		 * @param height
		 */		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			_list.resize( width, height );
		}
		
	}
}