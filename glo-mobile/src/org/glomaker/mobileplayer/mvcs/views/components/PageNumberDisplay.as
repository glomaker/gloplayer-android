/* 
* GLO Mobile Player: Copyright (c) 2011 LTRI, University of West London. An
* Open Source Release under the GPL v3 licence (see http://www.gnu.org/licenses/).
* Authors: DN Digital Ltd, Tom Boyle, Lyn Greaves, Carl Smith.

* This program is free software: you can redistribute it and/or modify it under the terms 
* of the GNU General Public License as published by the Free Software Foundation, 
* either version 3 of the License, or (at your option) any later version. This program
* is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* 
* For GNU Public licence see http://www.gnu.org/licenses/ or http://www.opensource.org/licenses/.
*
* External libraries used:
*
* Greensock Tweening Library (TweenLite), copyright Greensock Inc
* "NO CHARGE" NON-EXCLUSIVE SOFTWARE LICENSE AGREEMENT
* http://www.greensock.com/terms_of_use.html
*	
* A number of utility classes Copyright (c) 2008 David Sergey, published under the MIT license
*
* A number of utility classes Copyright (c) DN Digital Ltd, published under the MIT license
*
* The ScaleBitmap class, released open-source under the RPL license (http://www.opensource.org/licenses/rpl.php)
*/
package org.glomaker.mobileplayer.mvcs.views.components
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	
	import flash.display.BlendMode;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.Label;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;

	/**
	 * Displays the page number of the current slide.
	 * @author nilsmillahn
	 */	
	public class PageNumberDisplay extends GUIComponent
	{
		
		/**
		 * Delay before view component autohides, in milliseconds. 
		 */		
		protected static const AUTOHIDE_DELAY:uint = 1000;
		
		/**
		 * Duration for the 'show()' animation, in seconds. 
		 */		
		protected static const SHOW_DURATION:Number = 0.5;
		
		/**
		 * Duration for the 'hide()' animation, in seconds. 
		 */		
		protected static const HIDE_DURATION:Number = 1;
		
		/**
		 * Label child component 
		 */		
		protected var label:Label;
		
		/**
		 * Text to display within the label 
		 */		
		protected var _labelText:String = "";
		
		/**
		 * Base y position of component.
		 * Stored so we can animate around it.
		 */		
		protected var _baseY:Number;
		
		/**
		 * Currently hidden? 
		 */		
		protected var _isHidden:Boolean = false;
		
		/**
		 * Timer for automatic hiding of the display. 
		 */		
		protected var _hideTimer:Timer;

		//--------------------------------------------------------------------------
		//
		//  Public methods, Getter / Setters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Set text to display in the label. 
		 * @param value
		 */		
		public function set labelText( value:String ):void
		{
			_labelText = value;
			if( label )
			{
				label.text = _labelText;
				positionLabel();
			}
		}
		
		
		/**
		 * baseY is the anchor position for the view component. It will animate around it.
		 * If baseY is updated during animation, the component will reposition immediately.
		 * @param value
		 */		
		public function set baseY( value:Number ):void
		{
			_baseY = value;
			
			// update position accordingly
			// and interrupt any ongoing animations
			if( _isHidden )
			{
				alpha = 0;
				y = _baseY + height;
			}else{
				alpha = 1;
				y = _baseY;
			}
			TweenNano.killTweensOf( this );
		}

		/**
		 * Show the view component. 
		 * @param animate true to use animation, false for immediate 'show'
		 */		
		public function show( animate:Boolean = true ):void
		{
			// state
			_isHidden = false;
			
			// move into place immediately, then fade in
			TweenNano.killTweensOf( this );
			y = _baseY;
			
			if( animate )
			{
				TweenNano.to( this, SHOW_DURATION, { alpha: 1, ease: Sine.easeOut } );
			}else{
				alpha = 1;
			}
			
			// start auto-hide timer
			_hideTimer.reset();
			_hideTimer.start();
		}

		/**
		 * Hide the view component.
		 * The first time you call 'hide', the view component records its y-position and will animate back there on the next show()
		 * @param animate true to use animation, false for immediate results
		 */		
		public function hide( animate:Boolean = true ):void
		{
			_hideTimer.reset();
			_hideTimer.stop();
			
			// state
			_isHidden = true;

			// store base position so we can animate back
			if( isNaN(_baseY) )
			{
				_baseY = y;
			}

			// fade out + move away
			TweenNano.killTweensOf( this );
			
			if( animate )
			{
				TweenNano.to( this, HIDE_DURATION, { y: _baseY + height, alpha: 0, ease: Sine.easeOut } );
			}else{
				alpha = 0;
				y = _baseY + height;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @constructor 
		 */		
		public function PageNumberDisplay()
		{
			blendMode = BlendMode.LAYER; // better animations when a textfield is included
			mouseChildren = false;
			
			_hideTimer = new Timer( AUTOHIDE_DELAY );
			_hideTimer.addEventListener( TimerEvent.TIMER, handleHideTimer );
		}

		//--------------------------------------------------------------------------
		//
		//  GUIComponent Overrides
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			label = label || new Label();
			label.textFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
			label.text = _labelText;
			addChild( label );
		}

		/**
		 * @inheritDoc 
		 * @param width
		 * @param height
		 */		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// reposition label accordingly
			positionLabel();
			
			// draw background
			graphics.clear();
			graphics.beginFill( ColourPalette.SLATE_BLUE, 0.5 );
			graphics.drawRect( 0, 0, width, height );
		}

		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Positions the label within the view component. 
		 */		
		protected function positionLabel():void
		{
			label.x = ( width - label.width ) / 2;
			label.y = ( height - label.height ) / 2;
		}
		
		/**
		 * Event handler - the Hide Timer has completed. 
		 * @param e
		 */		
		protected function handleHideTimer( e:TimerEvent = null ):void
		{
			hide();
		}
		
	}
}