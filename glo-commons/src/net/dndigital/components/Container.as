/*
Copyright (c) 2011 DN Digital Ltd (http://dndigital.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package net.dndigital.components
{
	import eu.kiichigo.utils.apply;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import net.dndigital.errors.DeprecatedError;
	import net.dndigital.utils.Fun;

	/**
	 * Represents instances of Containers. Containers used to hold multiple instances of <code>IComponents</code> and <code>IContainers</code> and align them properly.
	 *  
	 * @see		net.dndigital.glo.components.IGUIComponent
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
		 * @copy 	net.dndigital.components.IContainer#layout
		 * 
		 * @see		net.dndigital.components.ILayout
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
		protected var _fitToContent:Boolean = false;
		/**
		 * fitToContent.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function get fitToContent():Boolean { return _fitToContent; }
		/**
		 * @private
		 */
		public function set fitToContent(value:Boolean):void
		{
			if (_fitToContent == value)
				return;
			_fitToContent = value;
			invalidateChildren();
		}
		
		
		/**
		 * @private
		 */
		protected const _children:Vector.<IGUIComponent> = new Vector.<IGUIComponent>;
		/**
		 * @copy 	net.dndigital.components.IContainer#children
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * @see		net.dndigital.components..GUIComponent
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
		 * @copy 	net.dndigital.components.IContainer#invalidateChildren
		 * 
		 * @see		net.dndigital.components.IGUIComponent
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
		 * @copy 	net.dndigital.components.IContainer#add
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function add(component:IGUIComponent, properties:Object = null, index:int = -1):IGUIComponent
		{
			// Quit if component already added.
			if(_children.indexOf(component) != -1) {
				bringToFront(component);
				return null;
			}
			
			if (properties != null)
				apply(component, properties);
			
			if(index == -1)
				$addChild(component as DisplayObject) as IGUIComponent;
			else
				$addChildAt(component as DisplayObject, index) as IGUIComponent;
			
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
		 * @copy 	net.dndigital.components.IContainer#remove
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function remove(component:Object):IGUIComponent
		{
			//log("{0}.remove({1})", this, component);
			// Quit if component is not present.
			if ((component is IGUIComponent && _children.indexOf(component) < 0) ||
				(component is Number && component >= _children.length))
				return null;
			//log("removed");
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
		
		
		/**
		 * @copy 	net.dndigital.components.IContainer#removeAll
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function removeAll(destructor:Function = null):IContainer
		{
			while (numChildren)
				if (destructor as Function)
					destructor(remove(numChildren - 1));
				else
					remove(numChildren - 1);

			//log("{0}.removeAll() numChildren={1}", this, numChildren);
			return this;
		}
		
		/**
		 * @copy	net.dndigital.components.IContainer#bringToFront
		 * 
		 * @see		net.dndigital.components.IGUIComponent
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		public function bringToFront(component:IGUIComponent):IGUIComponent
		{
			swapChildren(component as DisplayObject, getChildAt(numChildren - 1));
			return component;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
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
		protected function measure():void
		{
			if (!fitToContent)
				return;
			
			var w:int = 0;
			var h:int = 0;
			for (var i:int = 0; i < _children.length; i ++)
				w = Math.max(w, _children[i].x + _children[i].width),
				h = Math.max(h, _children[i].y + _children[i].height);
			width = w;
			height = h;
		}
	}
}