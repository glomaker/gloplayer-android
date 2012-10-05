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
package org.glomaker.mobileplayer.mvcs.views
{
	import com.christiancantrell.extensions.Compass;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.sensors.Geolocation;
	
	import net.dndigital.components.GUIComponent;
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.assets.JourneyDetails;
	import org.glomaker.mobileplayer.assets.LaunchButton;
	import org.glomaker.mobileplayer.mvcs.events.JourneyEvent;
	import org.glomaker.mobileplayer.mvcs.events.JourneyManagerEvent;
	import org.glomaker.mobileplayer.mvcs.events.LoadProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.enum.ColourPalette;
	import org.glomaker.mobileplayer.mvcs.models.vo.Glo;
	import org.glomaker.mobileplayer.mvcs.models.vo.Journey;
	import org.glomaker.mobileplayer.mvcs.models.vo.JourneySettings;
	import org.glomaker.mobileplayer.mvcs.utils.GeoPosition;
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;
	import org.glomaker.mobileplayer.mvcs.views.components.JourneyInfoPanel;
	import org.glomaker.mobileplayer.mvcs.views.components.JourneyRoute;
	import org.glomaker.mobileplayer.mvcs.views.components.JourneyStep;
	
	/**
	 * View component to display the journey manager.
	 * 
	 * @author haykel
	 * 
	 */
	public class JourneyManager extends GUIComponent implements IGloView
	{
		//--------------------------------------------------
		// Constants
		//--------------------------------------------------
		
		protected static const HPADDING:uint = ScreenMaths.mmToPixels(5);
		protected static const VPADDING:uint = ScreenMaths.mmToPixels(2);
		protected static const INFO_HEIGHT:uint = ScreenMaths.mmToPixels(7);
		protected static const LAUNCH_HEIGHT:uint = ScreenMaths.mmToPixels(8);
		protected static const STRIPE_HEIGHT:uint = ScreenMaths.mmToPixels(3);
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected var journey:Journey;
		protected var journeyChanged:Boolean;
		
		protected var geo:Geolocation;
		protected var targetPosition:GeoPosition;

		protected var compass:Compass;
		protected var azimuth:Number = 0;
		protected var targetAzimuth:Number = 0;

		protected var systemIdleMode:String;
		
		protected var journeyInfo:JourneyInfoPanel = new JourneyInfoPanel();
		protected var route:JourneyRoute = new JourneyRoute();
		protected var locationInfo:JourneyInfoPanel = new JourneyInfoPanel();
		protected var journeyDetails:JourneyDetails = new JourneyDetails();
		protected var launchButton:LaunchButton = new LaunchButton();
		
		//--------------------------------------------------
		// glo
		//--------------------------------------------------
		
		private var _glo:Glo;
		private var gloChanged:Boolean;

		/**
		 * Current GLO.
		 */
		public function get glo():Glo
		{
			return _glo;
		}

		/**
		 * @private
		 */
		public function set glo(value:Glo):void
		{
			if (value == _glo)
				return;
			
			_glo = value;
			
			var oldJourney:Journey = journey;
			journey = glo ? glo.journey : null;
			
			if (journey != oldJourney)
			{
				if (oldJourney)
					oldJourney.removeEventListener(JourneyEvent.VISITED_CHANGED, journey_eventHandler);
				
				if (journey)
					journey.addEventListener(JourneyEvent.VISITED_CHANGED, journey_eventHandler);
				
				journeyChanged = true;
			}
			
			gloChanged = true;
			invalidateData();
		}
		
		//--------------------------------------------------
		// trackGPS
		//--------------------------------------------------
		
		private var _trackGPS:Boolean;

		/**
		 * Whether to enable tracking for GPS position or not.
		 */
		public function get trackGPS():Boolean
		{
			return _trackGPS;
		}

		/**
		 * @private
		 */
		public function set trackGPS(value:Boolean):void
		{
			if (value == _trackGPS)
				return;
			
			_trackGPS = value;
			
			updateGPS();
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		/**
		 * Updates display based on visited state of current GLO.
		 */
		protected function updateVisited():void
		{
			var visited:Boolean = false;
			var launchVisible:Boolean = false;
			if (journey && glo && glo.journeySettings)
			{
				visited = journey.isVisited(glo.journeySettings.index);
				launchVisible = visited || (!glo.journeySettings.hasGPS && !glo.journeySettings.hasQRCode);
			}
			
			journeyDetails.visited = visited;
			launchButton.visible = launchVisible;
		}
		
		/**
		 * Updates gps and compass tracking based on current config and Glo.
		 */
		protected function updateGPS():void
		{
			var doTrack:Boolean = trackGPS && targetPosition;
			if (doTrack && !geo)
			{
				geo = new Geolocation();
				compass = new Compass();
				
				geo.setRequestedUpdateInterval(1000);
				geo.addEventListener(StatusEvent.STATUS, geo_statusHandler);
				if (!geo.muted)
					addUpdateListeners();
			}
			else if (!doTrack && geo)
			{
				geo.removeEventListener(StatusEvent.STATUS, geo_statusHandler);
				if (!geo.muted)
					removeUpdateListeners();
				
				geo = null;
				compass = null;
			}
		}
		
		/**
		 * Adds listeners for gps and compass update events.
		 */
		protected function addUpdateListeners():void
		{
			compass.register();
			compass.addEventListener(StatusEvent.STATUS, compass_statusHandler);
			geo.addEventListener(GeolocationEvent.UPDATE, geo_updateHandler);
			
			// keep awake while tracking
			systemIdleMode = NativeApplication.nativeApplication.systemIdleMode;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		/**
		 * Removes listeners for gps and compass update events.
		 */
		protected function removeUpdateListeners():void
		{
			compass.deregister();
			compass.removeEventListener(StatusEvent.STATUS, compass_statusHandler);
			geo.removeEventListener(GeolocationEvent.UPDATE, geo_updateHandler);
			
			azimuth = 0;
			targetAzimuth = 0;
			journeyDetails.distance = null;
			journeyDetails.direction = 0;
			
			// reset idle mode
			NativeApplication.nativeApplication.systemIdleMode = systemIdleMode;
		}
		
		/**
		 * Updates the compass direction based on current device and target azimuth values.
		 * 
		 */
		protected function updateDirection():void
		{
			journeyDetails.direction = Math.round(targetAzimuth - azimuth);
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
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			if (journeyChanged || gloChanged)
			{
				if (journeyChanged)
				{
					journeyChanged = false;
					route.journey = journey;
					journeyInfo.text = journey ? journey.displayName : "";
				}
				
				if (gloChanged)
				{
					gloChanged = false;
					var settings:JourneySettings = glo ? glo.journeySettings : null;
					targetPosition = settings && settings.hasGPS ? settings.gpsPosition : null;
					locationInfo.text = settings ? settings.location : "";
					journeyDetails.index = settings ? settings.index : 0;
					journeyDetails.compassVisible = targetPosition != null;
					journeyDetails.direction = 0;
					journeyDetails.distance = null;
					
					updateGPS();
				}
				
				updateVisited();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			journeyInfo.title = "JOURNEY";
			addChild(journeyInfo);
			
			route.addEventListener(MouseEvent.CLICK, route_clickHandler);
			addChild(route);
			
			locationInfo.title = "LOCATION";
			addChild(locationInfo);
			
			addChild(journeyDetails);
			
			launchButton.addEventListener(MouseEvent.CLICK, launchButton_clickHandler);
			addChild(launchButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			journeyInfo.width = width;
			journeyInfo.height = JourneyInfoPanel.HEIGHT;
			
			route.y = journeyInfo.height;
			route.width = width;
			route.height = JourneyRoute.HEIGHT;
			
			locationInfo.y = route.y + route.height;
			locationInfo.width = width;
			locationInfo.height = JourneyInfoPanel.HEIGHT;
			
			// main area
			
			// backgound
			var mainRect:Rectangle = new Rectangle(0, locationInfo.y + locationInfo.height, width, height - locationInfo.y - locationInfo.height);
			
			graphics.clear();
			
			var m:Matrix = new Matrix();
			m.createGradientBox(mainRect.width, mainRect.height, Math.PI / 2);
			
			graphics.beginGradientFill(GradientType.LINEAR, [0x9ca4b0, 0xffffff], [1, 1], [0, 255], m);
			graphics.drawRect(mainRect.x, mainRect.y, mainRect.width, mainRect.height);
			graphics.endFill();
			
			// details
			var detailsSize:Number = Math.min(mainRect.width - (2 * HPADDING), mainRect.height - (3 * VPADDING) - LAUNCH_HEIGHT);
			var hPadding:Number = (mainRect.width - detailsSize) / 2;
			var vPadding:Number = (mainRect.height - detailsSize - LAUNCH_HEIGHT) / 3;
			
			journeyDetails.x = hPadding;
			journeyDetails.y = mainRect.y + vPadding;
			journeyDetails.width = detailsSize;
			journeyDetails.height = detailsSize;
			
			graphics.beginFill(ColourPalette.JOURNEY_DARK_BLUE);
			graphics.drawRect(mainRect.x, journeyDetails.y + ((journeyDetails.height - STRIPE_HEIGHT) / 2), mainRect.width, STRIPE_HEIGHT);
			graphics.endFill();
			
			// launch button
			launchButton.scaleY = LAUNCH_HEIGHT / (launchButton.height / launchButton.scaleY);
			launchButton.scaleX = launchButton.scaleY;
			launchButton.x = (mainRect.width - launchButton.width) / 2;
			launchButton.y = journeyDetails.y + journeyDetails.height + vPadding;
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		/**
		 * Handles 'launch button' clicks to open current GLO in player.
		 */
		protected function launchButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new LoadProjectEvent(LoadProjectEvent.SHOW, glo));
		}
		
		/**
		 * Handles 'route' clicks to detect step selection.
		 */
		protected function route_clickHandler(event:MouseEvent):void
		{
			var step:JourneyStep = event.target as JourneyStep;
			if (step)
				dispatchEvent(new JourneyManagerEvent(JourneyManagerEvent.STEP_CLICKED, step.index));
		}
		
		/**
		 * Handles Journey change events.
		 */
		protected function journey_eventHandler(event:JourneyEvent):void
		{
			updateVisited();
		}
		
		/**
		 * Handles GeoLocation update events. Updates distance and direction of compass.
		 */
		protected function geo_updateHandler(event:GeolocationEvent):void
		{
			var currentPosition:GeoPosition = new GeoPosition(event.latitude, event.longitude);
			if (targetPosition && currentPosition.valid)
			{
				var distance:Number = currentPosition.distance(targetPosition);
				var formatted:String;
				if (distance >= 100)
				{
					distance = Math.ceil(distance);
					formatted = distance.toString() + "km";
				}
				else if (distance >= 1)
				{
					distance = Math.ceil(distance * 10) / 10;
					formatted = distance.toString() + "km";
				}
				else
				{
					distance = Math.ceil(distance * 1000);
					formatted = distance.toString() + "m";
				}
				
				journeyDetails.distance = formatted;
				
				targetAzimuth = currentPosition.azimuth(targetPosition);
				updateDirection();
				
				if (distance <= event.horizontalAccuracy && !launchButton.visible)
				{
					launchButton.visible = true;
				}
			}
		}
		
		/**
		 * Handles GeoLocation status events.
		 */
		protected function geo_statusHandler(event:StatusEvent):void
		{
			if (geo.muted)
				removeUpdateListeners();
			else
				addUpdateListeners();
		}
		
		/**
		 * Handles Compass update events. Updates direction of compass.
		 */
		protected function compass_statusHandler(event:StatusEvent):void
		{
			var values:Array = event.level.split("&");
			azimuth = Number(values[0]);
			updateDirection();
		}
		
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