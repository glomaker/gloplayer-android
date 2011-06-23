package net.dndigital.glo.mvcs.views.components
{
	import com.greensock.TweenLite;
	
	import eu.kiichigo.utils.log;

	public class AnimatedButton extends IconButton
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static const log:Function = eu.kiichigo.utils.log(AnimatedButton);
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var visibilityChanged:Boolean = false;
		/**
		 * @private
		 */
		protected var _visible:Boolean;
		/**
		 * @copy	flash.display.DisplayObject#visible
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		override public function get visible():Boolean { return _visible; }
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if (_visible == value)
				return;
			_visible = value;
			visibilityChanged = true;
			invalidateData();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (visibilityChanged) {
				const alpha:Number = _visible ? 1 : 0;
				TweenLite.to(this, .5, {alpha: alpha, onStart: animationStart, onComplete: animationComplete});
				visibilityChanged = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Handles Start of Visibility animation.
		 */
		protected function animationStart():void
		{
			super.visible = true;
		}
		
		/**
		 * @private
		 * Handles End of Visibility animation.
		 */
		protected function animationComplete():void
		{
			super.visible = _visible;
		}
	}
}