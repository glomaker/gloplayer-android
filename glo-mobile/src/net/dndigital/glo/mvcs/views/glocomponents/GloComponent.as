package net.dndigital.glo.mvcs.views.glocomponents
{
	import eu.kiichigo.utils.log;
	import eu.kiichigo.utils.path;
	
	import flash.events.Event;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.glo.mvcs.events.PlayerEvent;
	import net.dndigital.glo.mvcs.models.vo.Component;
	import net.dndigital.glo.mvcs.views.GloPlayer;
	
	/**
	 * Base class for GloComponents such as <code>TextArea</code> and <code>Image</code>. Class <code>GloComponent</code> defines basic structure for the component to be rendered in player.
	 *  
	 * @see		net.dndigital.components.IGUIComponent
	 * @see		net.dndigital.components.GUIComponent
	 * @see		net.dndigital.glo.mvcs.models.vo.Component
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class GloComponent extends GUIComponent implements IGloComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloComponent);
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Holds instances of <code>Mapper</code> class that contain information for property assignation from data an instance of <code>IGloComponent</code>.
		 */
		protected const mappers:Vector.<Mapper> = new Vector.<Mapper>;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Flag, indicates whether Data was changed.
		 */
		protected var componentVOChanged:Boolean = false;
		/**
		 * @private
		 */
		protected var _component:Component;
		/**
		 * @copy	net.dndigital.glo.mvcs.views.controls.IGloComponent#component
		 *
		 * @see		net.dndigital.glo.mvcs.models.vo.Component
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get component():Component { return _component; }
		/**
		 * @private
		 */
		public function set component(value:Component):void
		{
			if (_component == value)
				return;
			_component = value;
			componentVOChanged = true;
			invalidateData();
		}
		
		/**
		 * @private
		 */
		protected var _player:GloPlayer;
		/**
		 * @copy	net.dndigital.glo.mvcs.views.controls.IGloComponent#player
		 * 
		 * @see		net.dndigital.glo.mvcs.views.GloPlayer
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get player():GloPlayer { return _player; }
		/**
		 * @private
		 */
		public function set player(value:GloPlayer):void
		{
			if (_player == value)
				return;
			if (_player)
				_player.removeEventListener(PlayerEvent.DESTROY, handleDestroy);
			_player = value;
			if (_player)
				_player.addEventListener(PlayerEvent.DESTROY, handleDestroy);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function destroy():void
		{
			if (_player)
				_player.removeEventListener(PlayerEvent.DESTROY, handleDestroy);
		}
		//--------------------------------------------------------------------------
		//
		//  Overrien API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (componentVOChanged) {
				dataUpdated(_component);
				componentVOChanged = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Method invoked when <code>IGloComponent.data</code> receives new set of properties.
		 * Override this method for each component to process additional component's properties.
		 * 
		 * @private	data	<code>Dictionary</code> containing new properties.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function dataUpdated(data:Object):void
		{
			if(mappers.length > 0)
				for (var i:int = 0; i < mappers.length; i ++)
					mappers[i].apply(this);
		}
		
		/**
		 * Maps property from <code>IGloComponent.data</code> to instance of <code>IGloComponent</code>.
		 * 
		 * @param	from		<code>String</code> indicates path to property on <code>IGloComponent.data</code>.
		 * @param	to			<code>String</code> indicates path to property on <code>IGloComponent</code>.
		 * @param	initializer	<code>Function</code> indicates initializer function that will performe any parsing or changing on item before it's applied to an instance <code>IGloComponent</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		protected function mapProperty(from:String, to:String = null):void
		{ 
			if (to === null)
				to = from;
			mappers.push(new Mapper(from, to));
			delay(lockMappers);
		}
		
		/**
		 * @private
		 * Locks (Vector.fixed=true) collection of mappers.
		 */
		protected function lockMappers():void
		{
			mappers.fixed = true;
		}
		
		
		/**
		 * Handles component destruction.
		 */
		protected function handleDestroy(event:Event):void
		{
			destroy();
		}
	}
}
import com.adobe.serialization.json.JSON;

import eu.kiichigo.utils.path;

import net.dndigital.glo.mvcs.views.glocomponents.IGloComponent;

class Mapper {
	/**
	 * Constructor. Creates new instance of <code>Mapper</code>.
	 */
	public function Mapper(from:String, to:String)
	{
		super();
		
		this.from = from;
		this.to = to;
	}
	
	/**
	 * @private
	 */
	protected var from:String;
	/**
	 * @private
	 */
	protected var to:String;
	
	/**
	 * Applies property located with <code>to</code> and <code>data</code> to <code>component</code>.
	 * 	  
	 * @param component Reference to <code>IGloComponent</code> which property should be mapped.
	 */
	public function apply(gloComponent:IGloComponent):void
	{
		var value:* = path(gloComponent.component.data, from);
		if (value === null)
			return;
		
		value = JSON.decode(value);
		gloComponent[to] = value;
	}
}

/**
 * Identity initializer, works as basic lambda identity function and returns itself. This method is used as default initializer for mappers.
 * Define own initializer methods if data should be parsed or changed before applied to <code>IGloComponent</code> from <code>IGloComponent.data</code>.
 * 
 * @param	item	Any object.
 * 
 * @return	Returns instance or value provided in <code>item</code>.
 * 
 * @langversion 3.0
 * @playerversion Flash 10
 * @playerversion AIR 2.5
 * @productversion Flex 4.5
 */
function identity(item:*):* { return item; }