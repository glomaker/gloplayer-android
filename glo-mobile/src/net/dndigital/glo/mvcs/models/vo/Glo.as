package net.dndigital.glo.mvcs.models.vo
{
	import flash.filesystem.File;

	/**
	 * Value object
	 * Represents data about a GLO available in the file system.
	 * Not to be confused with Project which represent an actual loaded GLO.
	 * @author nilsmillahn
	 */	
	public class Glo
	{
		
		public var file:File;
		public var displayName:String;

		/**
		 * @constructor 
		 * @param file
		 * @param displayName
		 */		
		public function Glo( file:File, displayName:String )
		{
			this.file = file;
			this.displayName = displayName;
		}

		
		/**
		 * Returns a string containing some of instance's properties.
		 * @return	Class name and some of instance properties and values.
		 */
		public function toString():String
		{
			return "Glo Value Object - " + displayName;
		}
		
	}
}