package net.dndigital.glo.mvcs.views.components
{
	import eu.kiichigo.utils.log;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.describeType;
	
	import net.dndigital.components.Button;
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
	import net.dndigital.glo.mvcs.utils.DrawingUtils;
	
	import org.bytearray.display.ScaleBitmap;
	
	public final class NavButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(NavButton);
		
		//--------------------------------------------------------------------------
		//
		//  State Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public static const UP:String = "up";
		
		/**
		 * @private
		 */
		public static const DOWN:String = "down";
		
		/**
		 * @private
		 */
		public static const DISABLED:String = "disabled";
		
		public static const LEFT:String = "pointLeft";
		public static const RIGHT:String = "pointRight";
		
		//--------------------------------------------------------------------------
		//
		//  Instance Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Arrow shape
		 */
		protected const arrow:Shape = new Shape;
		protected const hit:Sprite = new Sprite;
		
		protected var _direction:String = RIGHT;
		
		protected var _arrowUpColour:uint = 0xffffff;
		protected var _arrowDownColour:uint = ColourPalette.HIGHLIGHT_BLUE;
		protected var _arrowDisabledColour:uint = ColourPalette.DISABLED_BLUE;
		protected var _colourChanged:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function set direction( value:String ):void
		{
			if( value != _direction )
			{
				_direction = value;
				invalidateDisplay();
			}
		}
		
		public function set arrowUpColour( value:uint ):void
		{
			if( value != _arrowUpColour )
			{
				_arrowUpColour = value;
				_colourChanged = true;
				invalidateData();
			}
		}
		
		public function set arrowDownColour( value:uint ):void
		{
			if( value != _arrowDownColour )
			{
				_arrowDownColour = value;
				_colourChanged = true;
				invalidateData();
			}
		}
		
		public function set arrowDisabledColour( value:uint ):void
		{
			if( value != _arrowDisabledColour )
			{
				_arrowDisabledColour = value;
				_colourChanged = true;
				invalidateData();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// hit area
			addChild( hit );
			hitArea = hit;
			hit.visible = false;

			// arrow shape - always the same size, centred around origin
			arrow.graphics.clear();
			arrow.graphics.beginFill( 0xffffff, 1 );
			arrow.graphics.moveTo( -15, -10 );
			arrow.graphics.lineTo( 15, 0 );
			arrow.graphics.lineTo( -15, 10 );
			arrow.graphics.lineTo( -15, -10 );
			arrow.graphics.endFill();
			addChild(arrow);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stateChanged(newState:String):void
		{
			super.stateChanged(newState);
			setArrowColour();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function commited():void
		{
			super.commited();
			setArrowColour();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			// hit area
			hit.graphics.clear();
			hit.graphics.beginFill( 0xff0000, 1 );
			hit.graphics.drawRect( 0, 0, width, height );
			
			// gradient background
			DrawingUtils.drawStandardGradient( graphics, width, height );

			// rotate arrow
			_direction == LEFT ? arrow.scaleX = -1 : arrow.scaleX = 1;
			
			// centre arrow
			arrow.x = width / 2;
			arrow.y = height / 2;
		}
		
		
		/**
		 * Changes arrow colour. 
		 */		
		protected function setArrowColour():void
		{
			var t:ColorTransform = new ColorTransform();
			
			switch( state )
			{
				case DOWN:
					t.color = _arrowDownColour;
					break;
				
				case DISABLED:
					t.color = _arrowDisabledColour;
					break;
				
				default:
					t.color = _arrowUpColour;
					break;
			}

			// apply
			arrow.transform.colorTransform = t;
		}
	}
}