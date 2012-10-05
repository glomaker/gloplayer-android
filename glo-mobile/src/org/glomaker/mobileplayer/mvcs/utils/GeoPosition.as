package org.glomaker.mobileplayer.mvcs.utils
{
	/**
	 * Represents a geographical position.
	 * 
	 * @see http://www.movable-type.co.uk/scripts/latlong.html
	 * 
	 * @author haykel
	 * 
	 */
	public class GeoPosition
	{
		public var latitude:Number;
		public var longitude:Number;
		
		/**
		 * Constructor.
		 */
		public function GeoPosition(latitude:Number=NaN, longitude:Number=NaN)
		{
			this.latitude = latitude;
			this.longitude = longitude;
		}
		
		/**
		 * Is the point valid (currently only checks whether latitude and longitude are not NaN).
		 */
		public function get valid():Boolean
		{
			return (!isNaN(latitude) && !isNaN(longitude));
		}
		
		/**
		 * Returns the distance in meters from this point to the specified target point.
		 * 
		 * If any of the points is invalid, NaN is returned.
		 */
		public function distance(target:GeoPosition):Number
		{
			if (!valid || !target || !target.valid)
				return NaN;
			
			var pi80:Number = Math.PI/180;
			var lat1:Number = latitude * pi80;
			var lng1:Number = longitude * pi80;
			var lat2:Number = target.latitude * pi80;
			var lng2:Number = target.longitude * pi80;
			
			var earthRadius:Number = 6372797; // mean radius of Earth in m
			var dlat:Number = lat2-lat1;
			var dlng:Number = lng2-lng1;
			var a:Number = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlng / 2) * Math.sin(dlng / 2);
			var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
			var m:Number = earthRadius*c;
			
			return Math.round(m);
		}
		
		/**
		 * Angle in degrees of the line between this point and the target point relatively to the north.
		 */
		public function azimuth(target:GeoPosition):Number
		{
			if (!valid || !target || !target.valid)
				return NaN;
			
			var pi80:Number = Math.PI/180;
			var lat1:Number = latitude * pi80;
			var lng1:Number = longitude * pi80;
			var lat2:Number = target.latitude * pi80;
			var lng2:Number = target.longitude * pi80;
			
			var dlng:Number = lng2-lng1;
			
			var y:Number = Math.sin(dlng) * Math.cos(lat2);
			var x:Number = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dlng);
			var brng:Number = Math.atan2(y, x);
			
			return (Math.round(brng / pi80) + 360) % 360;
		}
		
		public function toString():String
		{
			return "GeoPosition (" + latitude.toString() + " , " + longitude.toString() + ")";
		}
	}
}