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
package org.glomaker.mobileplayer.mvcs.commands
{
	import org.glomaker.mobileplayer.mvcs.services.IFileService;
	import org.glomaker.mobileplayer.mvcs.services.PrepareGLOsService;
	import org.robotlegs.mvcs.Command;

	/**
	 * Document directory scanning has completed. 
	 * @author nilsmillahn
	 */	
	public class DocumentDirScanCompleted extends Command
	{
		
		[Inject(name="appFileService")]
		public var appDirService:IFileService;
		
		[Inject(name="docFileService")]
		public var docsDirService:IFileService;
		
		[Inject]
		public var prepareGLOsService:PrepareGLOsService;
		
		/**
		 * @inheritDoc 
		 */		
		override public function execute():void
		{
			super.execute();
			
			// prepare glos
			prepareGLOsService.glos = appDirService.glos.concat( docsDirService.glos );
		}
	}
}