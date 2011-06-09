package net.dndigital.components
{
	import flash.display.DisplayObject;
	
	import net.dndigital.errors.DeprecatedError;

	/**
	 * Represents instances of Containers. Containers used to hold multiple instances of <code>IComponents</code> and <code>IContainers</code> and align them properly.
	 *  
	 * @see		net.dndigital.glo.components.IComponent
	 * @see		net.dndigital.glo.components.Component
	 * @see		net.dndigital.glo.components.ILayout
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Container extends GUIComponent implements IContainer
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
		protected static var log:Function = eu.kiichigo.utils.log(Container);
		
		
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Flag, indicates whether children are being invalidated and component re-measured.
		 */
		protected var measuring:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  IContainer Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _layout:ILayout;
		
		/**
		 * @copy 	net.dndigital.core.IContainer#layout
		 * 
		 * @see		net.dndigital.core.ILayout
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get layout():ILayout { return _layout; }
		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			if ( _layout == value )
				return;
			_layout = value;
			invalidateChildren();
		}
		
		/**
		 * @private
		 */
		protected const _children:Vector.<IGUIComponent> = new Vector.<IGUIComponent>;
		/**
		 * @copy 	net.dndigital.core.IContainer#children
		 * 
		 * @see		net.dndigital.core.IComponent
		 * @see		net.dndigital.core.Component
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get children():Vector.<IGUIComponent> 
		{
			return _children;
		}
		
		//--------------------------------------------------------------------------
		//
		//  IContainer Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy 	net.dndigital.core.IContainer#invalidateChildren
		 * 
		 * @see		net.dndigital.core.IComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function invalidateChildren():void
		{
			if(measuring)
				return;
			
			delay(validateChildren);
			measuring = true;
		}
		
		/**
		 * @copy 	net.dndigital.core.IContainer#add
		 * 
		 * @see		net.dndigital.core.IComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function add(component:IGUIComponent, properties:Object = null, index:int = -1):IGUIComponent
		{
			// Quit if component already added.
			if(_children.indexOf(component) != -1)
				return null;

			if(index == -1)
				var result:IGUIComponent = $addChild(component as DisplayObject) as IGUIComponent;
			else
				result = $addChildAt(component as DisplayObject, index) as IGUIComponent;

			// Update vector
			if(_children.fixed)
				_children.fixed = false;
			_children.push(component);
			_children.fixed = true;
			
			// Initialize component.
			component.initialize();
			
			// Invalidate children
			invalidateChildren();

			return component;
		}
		
		/**
		 * @copy 	net.dndigital.core.IContainer#remove
		 * 
		 * @see		net.dndigital.core.IComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function remove(component:Object):IGUIComponent
		{
			// Quit if component is not present.
			if(_children.indexOf(component) < 0)
				return null;
			
			var result:IGUIComponent;
			
			if(component is IGUIComponent)		// if IComponent is provided use removeChild
				result = $removeChild(component as DisplayObject) as IGUIComponent;
			else							// otherwise use removeChildAt and assume it's a number.
				result = $removeChildAt(Number(component)) as IGUIComponent;
			
			// Update children vector.
			var childIndex:int = _children.indexOf(result);

			if(childIndex >= 0) {
				if(_children.fixed)
					_children.fixed = false;
				_children.splice(childIndex, 1);
				_children.fixed = true;
			}
			
			// Invalidate children
			invalidateChildren();
			
			return result;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateDisplay():void
		{
			if (_children && _children.length)
				for (var i:int = 0; i < _children.length; i ++)
					_children[i].invalidateDisplay();
			
			super.invalidateDisplay();
		}
		/**
		 * @inheritDoc
		 */
		override public function validate():void
		{
			super.validate();
			validateChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidate():void
		{
			super.invalidate();
			invalidateChildren();
		}
		
		/**
		 * @private
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw new DeprecatedError("addChild", "add");
			return null;
		}
		
		/**
		 * @private
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new DeprecatedError("addChildAt", "add");
			return null;
		}
		
		/**
		 * @private
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw new DeprecatedError("removeChild", "remove");
			return null;
		}
		
		/**
		 * @private
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			throw new DeprecatedError("removeChildAt", "remove");
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Delegating addChild
		 */
		protected function $addChild(child:DisplayObject):DisplayObject { return super.addChild(child) };
		
		/**
		 * @private
		 * Delegating addChildAt
		 */
		protected function $addChildAt(child:DisplayObject, index:int):DisplayObject { return super.addChildAt(child, index) };
		
		/**
		 * @private
		 * Delegating removeChild
		 */
		protected function $removeChild(child:DisplayObject):DisplayObject { return super.removeChild(child) };
		
		/**
		 * @private
		 * Delegating removeChildAt
		 */
		protected function $removeChildAt(index:int):DisplayObject { return super.removeChildAt(index) };
		
		/**
		 * @private
		 * Validates children and their properties, and invokes dataUpdated method. This method should not be called manually.
		 */
		protected function validateChildren():void
		{
			measure();
			measuring = false;
			
			// After component are measured invalidate a display immediately.
			invalidateDisplay();
		}
		
		/**
		 * Method called when children added to component and it's resizing. Override this method to extend or change functionality. This method shouldn't be called manually, use invalidateDisplay to schedule instead.
		 */
		protected function measure():void {}
	}
}