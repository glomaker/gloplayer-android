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
package org.glomaker.mobileplayer.mvcs
{
	import flash.display.DisplayObjectContainer;
	
	import org.glomaker.mobileplayer.mvcs.commands.*;
	import org.glomaker.mobileplayer.mvcs.events.*;
	import org.glomaker.mobileplayer.mvcs.models.GloModel;
	import org.glomaker.mobileplayer.mvcs.services.*;
	import org.glomaker.mobileplayer.mvcs.views.*;
	import org.glomaker.mobileplayer.mvcs.views.components.PageNumberDisplay;
	import org.glomaker.mobileplayer.mvcs.views.components.ProgressBar;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class GloContext extends Context
	{
		//--------------------------------------------------------------------------
		//
		//  Log
		//
		//--------------------------------------------------------------------------
		import eu.kiichigo.utils.log;
		/**
		 * @private
		 */
		protected static var log:Function = eu.kiichigo.utils.log(GloContext);
		
		public function GloContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function startup():void
		{
			// Singletons
			injector.mapSingletonOf(IProjectService, ProjectService);
			injector.mapSingletonOf(IFileService, AppDirFileService, "appFileService");
			injector.mapSingletonOf(IFileService, ZippedFileService, "docFileService");
			injector.mapSingletonOf(GloModel, GloModel);
			
			// Controllers and Commands
			// startup sequence:
			// 1) scan application directory for GLOs
			// 2) create main application view
			// 3) mediators will trigger the next events to fetch other data
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, ScanAppDirectory, ContextEvent, true);
			commandMap.mapEvent(FileServiceEvent.APPDIR_SCAN_COMPLETED, CreateApplicationView, FileServiceEvent, true);
			
			commandMap.mapEvent(GloMenuEvent.LIST_FILES, ScanDocumentDirectory, GloMenuEvent);
			commandMap.mapEvent(FileServiceEvent.DOCUMENTS_SCAN_COMPLETED, DocumentDirScanCompleted, FileServiceEvent);
			
			commandMap.mapEvent(GloMenuEvent.LOAD_FILE, LoadProject, GloMenuEvent);
			commandMap.mapEvent(ProjectEvent.PROJECT, ShowProject, ProjectEvent);
			commandMap.mapEvent(ProjectEvent.NEXT_PAGE, Paginate, ProjectEvent);
			commandMap.mapEvent(ProjectEvent.PREV_PAGE, Paginate, ProjectEvent);
			
			// Views and Mediators
			mediatorMap.mapView(GloApplication, GloApplicationMediator);
			mediatorMap.mapView(GloPlayer, GloPlayerMediator);
			mediatorMap.mapView(GloMenu, GloMenuMediator);
			mediatorMap.mapView(GloControls, GloControlsMediator);
			mediatorMap.mapView(PageNumberDisplay, PageNumberDisplayMediator);
			mediatorMap.mapView(ProgressBar, ProgressBarMediator);
			
			super.startup();
		}
	}
}