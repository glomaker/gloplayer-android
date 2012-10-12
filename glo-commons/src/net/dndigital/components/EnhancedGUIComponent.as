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

package net.dndigital.components
{
	import flash.events.Event;

	/**
	 * The <code>GUIComponent</code> has the drawback that its validation system only
	 * works if it is on the display list. If a component is removed from the display
	 * list, then invalidated, then added back to the display list, validation is not
	 * executed. This has the limitation that we must make sure that a component is
	 * always on the display list before making any changes (assignments).
	 * 
	 * This class enhances <code>GUIComponent</code> by adding handlers that run the
	 * validation process every time the component is added to the display list so
	 * that it can be invalidated even if it is not yet in the display list.
	 * 
	 * We did not add this functionality to the <code>GUIComponent</code> directly
	 * because at the time this class was impemented there were too many components
	 * that use it and should be reviewed first to make sure they don't break.
	 * 
	 * @author haykel
	 * 
	 */
	public class EnhancedGUIComponent extends GUIComponent
	{
		public function EnhancedGUIComponent()
		{
			super();
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			return super.initialize();
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handles 'removed from stage' event to monitor when the component is added back
		 * on stage to trigger validation which only works when the component is on stage.
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Handles 'added to stage' event to trigger validation of items invalidated while
		 * the component was not on stage.
		 * 
		 * We do not reuse 'addedToStage' because it should only be run the first time
		 * the component is added to the display list.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			validateData();
			validateDisplay();
			validateState();
		}
	}
}