/*
Copyright (c) 2012 DN Digital Ltd (http://dndigital.net)

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

package org.glomaker.mobileplayer.mvcs.views.glocomponents.accessviews
{
	import flash.events.Event;
	
	/**
	 * Event dispatched when the script popup should be displayed.
	 * 
	 * @author haykel
	 * 
	 */
	public class ShowScriptEvent extends Event
	{
		public static const SHOW_SCRIPT:String = "showScript";
		
		/**
		 * Helper function to create an event with the specified file.
		 */
		public static function create(file:String):ShowScriptEvent
		{
			return new ShowScriptEvent(SHOW_SCRIPT, file);
		}
		
		/**
		 * Script file path.
		 */
		public var file:String;
		
		public function ShowScriptEvent(type:String, file:String)
		{
			super(type);
			
			this.file = file;
		}
		
		override public function clone():Event
		{
			return new ShowScriptEvent(type, file);
		}
	}
}