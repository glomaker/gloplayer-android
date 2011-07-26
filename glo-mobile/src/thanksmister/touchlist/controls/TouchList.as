package thanksmister.touchlist.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.IListMarkerFormat;
	
	import thanksmister.touchlist.events.ListItemEvent;
	import thanksmister.touchlist.renderers.ITouchListItemRenderer;
	

	/**
	 * List with touch interaction.
	 * Not optimised for long lists.
	 * @author nilsmillahn
	 */	
	public class TouchList extends Sprite
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
		private var lastY:Number = 0; // last touch position
		private var firstY:Number = 0; // first touch position
		private var listY:Number = 0; // initial list position on touch 
		private var diffY:Number = 0;
		private var inertiaY:Number = 0;
		private var minY:Number = 0;
		private var maxY:Number = 0;
		private var totalY:Number;
		private var scrollRatio:Number = 40; // how many pixels constitutes a touch
		
		//------- Touch Events --------
		
		private var selectDelayCount:Number = 0;
		private var maxSelectDelayCount:Number = 3; // change this to increase or descrease tap sensitivity
		private var selectedItem:ITouchListItemRenderer;
		private var isAnimating:Boolean = false;

		// ------ Constructor --------
		
		public function TouchList(w:Number, h:Number)
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
					list.y = frameTargetY;
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
			return Math.min( 1, Math.max( 0, ( maxY - list.y )/(maxY - minY) ) ); 
		}
			
		/**
		 * Recalculate minY, maxY list position values based on list height and scroll area. 
		 */		
		protected function recalcScrollBounds():void
		{
			minY = -scrollListHeight + scrollAreaHeight;
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
			list.y = maxY;
			
			updateScrollbarPosition();
			
			// resize each list item
			var children:Number = list.numChildren;
			for (var i:int = 0; i < children; i++) {
				var item:DisplayObject = list.getChildAt(i);
				ITouchListItemRenderer(item).itemWidth = listWidth;
			}
		}
		
		/**
		 * Add item to the end of the list. 
		 * @param item
		 */		
		public function addListItem(item:ITouchListItemRenderer):void
		{
			stopAnimation( true );
			
			var listItem:DisplayObject = item as DisplayObject;
				listItem.y = scrollListHeight;
				
			ITouchListItemRenderer(listItem).itemWidth = listWidth;
			
			// add to display list
			list.addChild(listItem);
			
			// height has changed
			scrollListHeight = scrollListHeight + listItem.height;
			recalcScrollBounds();
			createScrollBar();
		}
		
		/**
		 * Remove all items from the list.
		 **/
		public function removeListItems():void
		{
			stopAnimation( true );

			selectDelayCount = 0;

			scrollAreaHeight = 0;
			scrollListHeight = 0;
			
			recalcScrollBounds();
			list.y = maxY;
			
			while(list.numChildren > 0) {
				var item:DisplayObject = list.removeChildAt(0);
				ITouchListItemRenderer( item ).destroy();
			}
		}
		
		// ------ private methods -------
		
		protected var firstT:Number;
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
			firstT = tt = getTimer();
			
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
			}else{
				// check which item was under the finger when tapped
				// TODO: can this be optimised?
				touchPoint.y = e.stageY;
				touchPoint = list.globalToLocal( touchPoint );
				
				// loop
				var i:uint = 0;
				var child:DisplayObject = list.getChildAt( i );
				var last:uint = list.numChildren - 1;
	
				while( i < last && child.y < touchPoint.y )
				{
					child = list.getChildAt( ++i );
				}
				
				// finished the loop
				if( i == 0 )
				{
					// not clicked on anything
					selectedItem = null;
				}else{
					// i is the index of the first child further down than the tap coordinate
					// so i-1 is the index of the element under the finger
					selectedItem = ITouchListItemRenderer( list.getChildAt( i - 1 ) );
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
				// once the tap delay has expired, we highlight the item
				// this prevents items initially flashing as selected when dragging the list
				if( selectDelayCount == 0 )
				{
					selectedItem.selectItem();
				}else{
					selectDelayCount--;
				}
				
				// if the user moves even a little bit, this won't be treated as a tap anymore
				if( Math.abs( e.stageY - firstY ) > MOVE_THRESHOLD )
				{
					selectedItem.unselectItem();
					selectedItem = null;
				}
			}
			
			lastMoveDY = e.stageY - ty;
			
			ty = e.stageY;
			tt = getTimer();
			
			// should get harder if we're dragging past the boundaries
			if( list.y < minY || list.y > maxY )
			{
				list.y += lastMoveDY/2;
			}else{
				list.y += lastMoveDY;
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

			// if something was tapped, we are finished
			if( selectedItem )
			{
				hideScrollbar();
				selectedItem.unselectItem();
				dispatchEvent( new ListItemEvent( ListItemEvent.ITEM_SELECTED, selectedItem, true ) );
				return;
			}
			
			// nothing was tapped
			// that means we are dragging the list and need to switch to animation now that the user has let go
			if( list.y < minY )
			{
				// list was dragged down past the minimum point
				easeToTarget( minY );

			}else if( list.y > maxY ){
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
		 * Event handler - enter frame loop for eased animation to a specific target Y.
		 * Uses the 'frameTargetY' property. 
		 * @param e
		 */		
		protected function toTarget( e:Event ):void
		{
			list.y += ( frameTargetY - list.y ) / 4;
			updateScrollbarPosition();
			
			if( Math.abs( list.y - frameTargetY ) < ABS_TARGET_ANIM_MARGIN )
			{
				list.y = frameTargetY;
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
			list.y += dt*animSpeed;
			
			// slow down
			animSpeed *= SPEED_MULTIPLIER;
			
			// list has moved - update scrollbar
			updateScrollbarPosition();
			
			// if movement has become very small, then we need to stop the animation
			if( Math.abs( dt*animSpeed ) < ABS_INERTIA_MARGIN )
			{
				stopAnimation(false);
				
				// if the list has overshot, go into easing animation back to list boundaries
				if( list.y > maxY )
				{
					easeToTarget( maxY );
				}else if( list.y < minY ){
					easeToTarget( minY );
				}else{
					hideScrollbar();
				}
				return;
			}

			// animation is still ongoing
			// if we've overshot by more than the allowed overshoot, we switch into easing animation back to list boundaries
			if( list.y > maxY + INERTIA_OVERSHOOT )
			{
				list.y = maxY + INERTIA_OVERSHOOT;
				stopAnimation(false);
				easeToTarget( maxY );
			}else if( list.y < minY - INERTIA_OVERSHOOT ){
				list.y = minY - INERTIA_OVERSHOOT;
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
			removeListItems();
			selectDelayCount = 0;
			removeChild(scrollBar);
			removeChild(list);
			removeChild(listHitArea);
		}
	}
}