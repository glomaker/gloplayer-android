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

package net.dndigital.components.mobile
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * Dispatched when a list item has been selected (ie. tapped) by the user.
	 * @eventType net.dndigital.components.mobile.MobileListEvent.ITEM_SELECTED
	 */
	[Event(name="itemSelected", type="net.dndigital.components.mobile.MobileListEvent")]
	
	/**
	 * List with touch interaction.
	 * Not optimised for long lists.
	 * @author nilsmillahn
	 */	
	public class MobileList extends Sprite
	{
		/**
		 * Maximum number of pixels of mouse movement before a tap becomes a drag. 
		 */		
		protected static const MOVE_THRESHOLD:Number = 3;
		
		/**
		 * Absolute value (in pixels) of distance to frameTargetY within which the eased animation is seen to have finished. 
		 */		
		protected static const ABS_TARGET_ANIM_MARGIN:Number = 2;
		
		/**
		 * Factor by which to multiply speed at each frame of inertia scrolling.
		 * Should be < 1, otherwise speed won't decrease!
		 */		
		protected static const SPEED_MULTIPLIER:Number = 0.95;
		
		/**
		 * Absolute movement amount in pixels at which the inertia movement is deemed to have stopped. 
		 */		
		protected static const ABS_INERTIA_MARGIN:Number = 0.5;
		
		/**
		 * Amount (in positive pixels) by which the inertia animation will overshoot the list min/max position.
		 * Once it's done so, the inertia animation will revert to the eased animation back to min/max. 
		 */		
		protected static const INERTIA_OVERSHOOT:Number = 125;
		
		/**
		 * Amount (in percent) to change alpha of scrollbar during fade animation. 
		 */		
		protected static const SCROLL_FADE_STEP:Number = 0.1;
		
		//------- List --------
		
		private var listHitArea:Shape;
		private const list:Sprite = new Sprite();
		private var listHeight:Number = 100;
		private var listWidth:Number = 100;
		private var scrollListHeight:Number;
		private var scrollAreaHeight:Number;
		
		//------ Scrolling ---------------
		
		private var scrollBar:Sprite;
		private var firstY:Number = 0; // first touch position
		private var minY:Number = 0;
		private var maxY:Number = 0;
		private var listScrollRect:Rectangle = new Rectangle(); // scrollrect instance
		
		//------- Touch Events --------
		
		private var selectDelayCount:int = -1; // set to -1 once item.selectItem() has been called
		private var maxSelectDelayCount:int = 3; // change this to make 'tap press' item selection slower or faster
		private var selectedItem:IMobileListItemRenderer;
		private var isAnimating:Boolean = false;
		
		// ------ Constructor --------
		
		public function MobileList(w:Number, h:Number)
		{
			init( w, h );
		}
		
		protected function init( w:Number, h:Number ):void
		{
			listWidth = w; 
			listHeight = h;
			scrollAreaHeight = listHeight;
			
			scrollListHeight = 0;
			
			createList();
			createScrollBar();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected var frameTime:Number = 30;
		
		/**
		 * Event handler - added to stage. 
		 * @param e
		 */		
		protected function onAdded( e:Event ):void
		{
			frameTime = 1000 / stage.frameRate;
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		/**
		 * Event handler - removed from stage. 
		 * @param e
		 */		
		protected function onRemoved( e:Event ):void
		{
			removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			stopAnimation( true );
		}
		
		/**
		 * Sets list y position.
		 * @param value
		 */		
		protected function set listY( value:Number ):void
		{
			// scrollRect works in reverse
			listScrollRect.y = -value;
			listScrollRect.width = listWidth;
			listScrollRect.height = scrollAreaHeight;
			list.scrollRect = listScrollRect;

			// scrollbar
			updateScrollbarPosition();
		}
		
		protected function get listY():Number
		{
			// scrollRect works in reverse
			return -listScrollRect.y;
		}
		
		/**
		 * Stop any ongoing animation. 
		 * @param complete true - complete existing animation, false - don't complete existing animation
		 */		
		protected function stopAnimation( complete:Boolean = false ):void
		{
			isAnimating = false;
			
			removeEventListener( Event.ENTER_FRAME, toTarget );
			removeEventListener( Event.ENTER_FRAME, toInertia );
			
			if( complete )
			{
				if( !isNaN( frameTargetY ) )
				{
					listY = frameTargetY;
				}
			}
			
			frameTargetY = NaN;
			animSpeed = NaN;
		}
		
		/**
		 * Creates / recreates the list container, it's hit area and mask
		 **/
		private function createList():void
		{
			if(!listHitArea){
				listHitArea = new Shape();
				addChild(listHitArea);
			}
			
			listHitArea.graphics.clear();
			listHitArea.graphics.beginFill(0x000000, 1);
			listHitArea.graphics.drawRect(0, 0, listWidth, listHeight)
			listHitArea.graphics.endFill();

			addChild(list);
			
			list.graphics.clear();
			list.graphics.beginFill(0x000000, 1);
			list.graphics.drawRect(0, 0, listWidth, listHeight)
			list.graphics.endFill();
			list.mask = listHitArea;
			
			// scrollbar must be on top
			if( scrollBar )
			{
				addChild( scrollBar );
			}
		}
		
		/**
		 * Creates / recreates the scrollbar.
		 **/
		protected function createScrollBar():void
		{
			if(!scrollBar) {
				scrollBar = new Sprite();
				addChild(scrollBar);
			}
			
			scrollBar.x = listWidth - 5;
			scrollBar.y = 0;
			scrollBar.graphics.clear();
			
			if(scrollAreaHeight < scrollListHeight) {
				scrollBar.graphics.beginFill(0xffffff, .5);
				scrollBar.graphics.lineStyle(1, 0x5C5C5C, .5);
				scrollBar.graphics.drawRoundRect(0, 0, 4, (scrollAreaHeight/scrollListHeight*scrollAreaHeight), 6, 6);
				scrollBar.graphics.endFill();
				scrollBar.alpha = 0;
			}
		}
		
		/**
		 * Starts animation to fade in the scrollbar. 
		 */		
		protected function showScrollbar():void
		{
			removeEventListener( Event.ENTER_FRAME, scrollFadeOut );
			addEventListener( Event.ENTER_FRAME, scrollFadeIn );
		}
		
		/**
		 * Starts animation to fade out the scrollbar. 
		 */		
		protected function hideScrollbar():void
		{
			removeEventListener( Event.ENTER_FRAME, scrollFadeIn );
			addEventListener( Event.ENTER_FRAME, scrollFadeOut );
		}
		
		/**
		 * Start an easing animation to a particular target value. 
		 * @param targetValue
		 */		
		protected function easeToTarget( targetValue:Number ):void
		{
			frameTargetY = targetValue;
			isAnimating = true;
			
			removeEventListener( Event.ENTER_FRAME, toInertia );
			addEventListener( Event.ENTER_FRAME, toTarget );
		}
		
		/**
		 * Start an easing animation to a particular target value. 
		 * @param targetValue
		 */		
		protected function startInertiaAnim():void
		{
			isAnimating = true;
			tt = getTimer();
			
			removeEventListener( Event.ENTER_FRAME, toTarget );
			addEventListener( Event.ENTER_FRAME, toInertia );
		}
		
		/**
		 * Calculate current scroll percentage. 
		 */		
		protected function calcScrollPercent():Number
		{
			// need to bound to 0 <= p <= 1 because of overshoot animation
			return Math.min( 1, Math.max( 0, ( maxY - listY )/(maxY - minY) ) ); 
		}
		
		/**
		 * Recalculate minY, maxY list position values based on list height and scroll area. 
		 */		
		protected function recalcScrollBounds():void
		{
			minY = Math.min( -scrollListHeight + scrollAreaHeight, 0 );
			maxY = 0;
		}
		
		/**
		 * Updates scrollbar position based on current list position. 
		 */		
		protected function updateScrollbarPosition():void
		{
			scrollBar.y = calcScrollPercent() * ( scrollAreaHeight - scrollBar.height );
		}
		
		// ------ public methods --------
		
		/**
		 * Redraw component usually as a result of orientation change.
		 * */
		public function resize(w:Number, h:Number):void
		{
			// no animation
			stopAnimation( true );
			
			listWidth = w; 
			listHeight = h;
			
			scrollAreaHeight = h;
			
			createList(); // redraw list
			createScrollBar(); // redraw scrollbar
			
			// reset list to top
			// TODO: maintain scroll percentage
			recalcScrollBounds();
			listY = maxY;
			
			// resize each list item
			var children:Number = list.numChildren;
			for (var i:int = 0; i < children; i++) {
				var item:DisplayObject = list.getChildAt(i);
				IMobileListItemRenderer(item).itemWidth = listWidth;
			}
		}
		
		/**
		 * Add item to the end of the list. 
		 * @param item
		 */		
		public function addListItem(item:IMobileListItemRenderer):void
		{
			stopAnimation( true );
			
			var listItem:DisplayObject = item as DisplayObject;
			listItem.y = scrollListHeight;
			item.itemWidth = listWidth;
			item.index = list.numChildren; // needs to be done before addChild()
			
			// add to display list
			list.addChild(listItem);
			
			// height has changed
			scrollListHeight = scrollListHeight + listItem.height;
			recalcScrollBounds();
			createScrollBar();
		}
		
		/**
		 * Optimised version that adds lots of list items in one go. 
		 * @param list
		 */		
		public function addListItems(items:Vector.<IMobileListItemRenderer>):void
		{
			stopAnimation(true);
			
			var d:DisplayObject;
			for each( var item:IMobileListItemRenderer in items )
			{
				d = item as DisplayObject;
				d.y = scrollListHeight;
				item.itemWidth = listWidth;
				item.index = list.numChildren; // needs to be done before addChild()
				
				// add to display list
				list.addChild( d );
				
				// height has changed
				scrollListHeight += item.itemHeight;
			}
			
			// scrollbars
			recalcScrollBounds();
			createScrollBar();
			
		}
		
		/**
		 * Remove all items from the list.
		 **/
		public function removeListItems():void
		{
			stopAnimation( true );
			
			selectDelayCount = -1;
			scrollListHeight = 0;
			
			recalcScrollBounds();
			listY = maxY;
			
			while(list.numChildren > 0) {
				var item:DisplayObject = list.removeChildAt(0);
				IMobileListItemRenderer( item ).destroy();
			}
		}
		
		// ------ private methods -------
		
		protected var ty:Number;
		protected var tt:Number;
		protected var touchPoint:Point = new Point(0,0);
		
		protected var lastMoveDY:Number;
		
		/**
		 * Detects first mouse or touch down position.
		 * */
		protected function onMouseDown( e:MouseEvent ):void 
		{
			var wasAnimating:Boolean = isAnimating;
			
			// stop any kind of animation
			stopAnimation( false );
			
			//
			firstY = ty = e.stageY;
			lastMoveDY = 0;
			
			// handle further mouse events on stage for better response
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			// scrollbar should now be visible
			showScrollbar();
			
			// tap delay to stop item highlighting when being dragged
			selectDelayCount = maxSelectDelayCount;
			
			// if the list was currently animating, we don't select an item on tap
			if( wasAnimating )
			{
				selectedItem = null;
				removeEventListener( Event.ENTER_FRAME, delayedItemSelect );
			}else{
				// check which item was under the finger when tapped
				// TODO: can this be optimised?
				touchPoint.y = e.stageY;
				const touchY:Number = list.globalToLocal( touchPoint ).y;
				
				// loop
				var i:uint = 0;
				var child:DisplayObject;
				
				while(i < list.numChildren)
				{
					child = list.getChildAt(i);
					if( touchY > child.y && touchY < child.y + child.height )
					{
						break;
					}
					
					// next (important to do this after the if-statement)
					i++;
				}
				
				// check results
				if( i == list.numChildren )
				{
					// went through whole list without finding anything
					selectedItem = null;
				}else{
					// found an item in the middle
					selectedItem = IMobileListItemRenderer( child );
					
					// start item highlight loop
					addEventListener( Event.ENTER_FRAME, delayedItemSelect );
				}
			}
		}
		
		/**
		 * List moves with mouse or finger when mouse down or touch activated. 
		 * If we move the list moves more than the scroll ratio then we 
		 * clear the selected list item. 
		 * */
		protected function onMouseMove( e:MouseEvent ):void 
		{
			if( selectedItem )
			{
				// if the user moves even a little bit, this won't be treated as a tap anymore
				if( Math.abs( e.stageY - firstY ) > MOVE_THRESHOLD )
				{
					selectedItem.unselectItem();
					selectedItem = null;
					removeEventListener( Event.ENTER_FRAME, delayedItemSelect );
				}
			}
			
			// record move since last mouse-move
			lastMoveDY = e.stageY - ty;

			// record positions for next loop
			ty = e.stageY;
			
			// should get harder if we're dragging past the boundaries
			if( listY < minY || listY > maxY )
			{
				listY += Math.round(lastMoveDY/2);
			}else{
				listY += Math.round(lastMoveDY);
			}
		}
		
		protected var frameTargetY:Number;
		protected var animSpeed:Number;
		
		/**
		 * Handles mouse up and begins animation. This also deslects
		 * any currently selected list items. 
		 * */
		protected function onMouseUp( e:MouseEvent ):void
		{
			// no need to handle mouse events anymore
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseUp );
			
			// other event cleanup
			removeEventListener( Event.ENTER_FRAME, delayedItemSelect );

			// if something was tapped, we are finished
			if( selectedItem )
			{
				// if item hasn't been visually selected yet, we do that now
				// and let 1 frame elapse so it can render the selected state
				if( selectDelayCount >= 0 )
				{
					selectDelayCount = -1;
					selectedItem.selectItem();
					addEventListener( Event.ENTER_FRAME, continueItemTap );
					return;
				}
				
				continueItemTap();
				return;
			}
			
			// nothing was tapped
			// that means we are dragging the list and need to switch to animation now that the user has let go
			if( listY < minY )
			{
				// list was dragged down past the minimum point
				easeToTarget( minY );
				
			}else if( listY > maxY ){
				// list was dragged up past the maximum point
				easeToTarget( maxY );
			}else{
				// still within normal bounds - should carry on scrolling and slow down gradually
				// we calculate the speed based on the expected Enter_frame loop duration
				// so that the animation will be similar to the finger movement
				animSpeed = ( lastMoveDY / frameTime );
				
				if( animSpeed != 0 )
				{
					startInertiaAnim();
				}else{
					hideScrollbar();
				}
			}
		}

		/**
		 * Continue processing the item-tap event. 
		 * Wrapped as function to allow delayed call from mouse_up event handler.
		 * @param e Optional - may or may not be called from an event handler.
		 */		
		protected function continueItemTap( e:Event = null ):void
		{
			hideScrollbar();
			removeEventListener( Event.ENTER_FRAME, continueItemTap );
			selectedItem.unselectItem();
			dispatchEvent( new MobileListEvent( MobileListEvent.ITEM_SELECTED, selectedItem, true ) );
		}
		
		/**
		 * Event handler - enter-frame loop to select tapped item after a certain duration. 
		 * @param e
		 */		
		protected function delayedItemSelect( e:Event ):void
		{
			if( !selectedItem )
			{
				removeEventListener( Event.ENTER_FRAME, delayedItemSelect );
				return;
			}

			// once the tap delay has expired, we highlight the item
			// this prevents items initially flashing as selected when dragging the list
			if( selectDelayCount == 0 )
			{
				selectDelayCount = -1;
				selectedItem.selectItem();
				removeEventListener( Event.ENTER_FRAME, delayedItemSelect );
			}else{
				selectDelayCount--;
			}
		}
		
		
		/**
		 * Event handler - enter frame loop for eased animation to a specific target Y.
		 * Uses the 'frameTargetY' property. 
		 * @param e
		 */		
		protected function toTarget( e:Event ):void
		{
			listY += ( frameTargetY - listY ) / 4;
			
			if( Math.abs( listY - frameTargetY ) < ABS_TARGET_ANIM_MARGIN )
			{
				listY = frameTargetY;
				hideScrollbar();
				stopAnimation();
			}
		}
		
		/**
		 * Event handler - enter frame loop for inertia animation.
		 * Uses the 'animSpeed' property. 
		 * @param e
		 */		
		protected function toInertia( e:Event ):void
		{
			// time since last event
			var dt:Number = getTimer() - tt;
			tt = getTimer();
			
			// update position ( distance = time * speed )
			listY += dt*animSpeed;
			
			// slow down
			animSpeed *= SPEED_MULTIPLIER;
			
			// if movement has become very small, then we need to stop the animation
			if( Math.abs( dt*animSpeed ) < ABS_INERTIA_MARGIN )
			{
				stopAnimation(false);
				
				// if the list has overshot, go into easing animation back to list boundaries
				if( listY > maxY )
				{
					easeToTarget( maxY );
				}else if( listY < minY ){
					easeToTarget( minY );
				}else{
					hideScrollbar();
				}
				return;
			}
			
			// animation is still ongoing
			// if we've overshot by more than the allowed overshoot, we switch into easing animation back to list boundaries
			if( listY > maxY + INERTIA_OVERSHOOT )
			{
				listY = maxY + INERTIA_OVERSHOOT;
				stopAnimation(false);
				easeToTarget( maxY );
			}else if( listY < minY - INERTIA_OVERSHOOT ){
				listY = minY - INERTIA_OVERSHOOT;
				stopAnimation(false);
				easeToTarget( minY );
			}
		}
		
		
		/**
		 * Event handler - enter frame loop to fade the scrollbar in. 
		 * @param e
		 */		
		protected function scrollFadeIn( e:Event ):void
		{
			scrollBar.alpha += SCROLL_FADE_STEP;
			if( scrollBar.alpha >= 1 )
			{
				scrollBar.alpha = 1;
				removeEventListener( Event.ENTER_FRAME, scrollFadeIn );
			}
		}
		
		/**
		 * Event handler - enter frame loop to fade the scrollbar outs. 
		 * @param e
		 */		
		protected function scrollFadeOut( e:Event ):void
		{
			scrollBar.alpha -= SCROLL_FADE_STEP;
			if( scrollBar.alpha <= 0 )
			{
				scrollBar.alpha = 0;
				removeEventListener( Event.ENTER_FRAME, scrollFadeOut );
			}
		}
		
		
		
		/**
		 * Destroy, destroy, must destroy.
		 * */
		protected function destroy(e:Event = null):void
		{
			stopAnimation(false);
			removeEventListener(Event.REMOVED, destroy);
			removeEventListener( Event.ENTER_FRAME, scrollFadeIn );
			removeEventListener( Event.ENTER_FRAME, scrollFadeOut );
			removeEventListener( Event.ENTER_FRAME, delayedItemSelect );
			removeListItems();
			selectDelayCount = 0;
			removeChild(scrollBar);
			removeChild(list);
			removeChild(listHitArea);
		}
	}
}