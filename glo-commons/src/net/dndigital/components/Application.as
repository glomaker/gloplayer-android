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
	import flash.events.Event;
	import flash.text.TextFormat;

	/**
	 * Represents top level container used as main Application component.
	 * 
	 * @see		net.dndigital.components.IComponent
	 * @see		net.dndigital.components.Component
	 * @see		net.dndigital.components.ILayout
	 * @see		net.dndigital.components.IContainer
	 * @see		net.dndigital.components.Container
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public class Application extends Container
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
		protected static var log:Function = eu.kiichigo.utils.log(Application);
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function Application()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handling
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function added(event:Event):void
		{	
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			initialize();
		}

		/**
		 * @private
		 */
		protected function removed(event:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
	}
}