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
	import org.glomaker.mobileplayer.mvcs.events.ProjectEvent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Page;
	import org.glomaker.mobileplayer.mvcs.views.components.PageNumberDisplay;
	import org.glomaker.mobileplayer.mvcs.views.components.ProgressBar;
	
	import org.robotlegs.mvcs.Mediator;

	/**
	 * Integrates a ProgressBar component into the application. 
	 * @author nilsmillahn
	 */	
	public class ProgressBarMediator extends Mediator
	{
		
		[Inject]
		public var view:ProgressBar;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(eventDispatcher, ProjectEvent.PAGE_CHANGED, handlePageChanged, ProjectEvent );
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			eventMap.unmapListener( eventDispatcher, ProjectEvent.PAGE_CHANGED, handlePageChanged );
		}
		
		protected function handlePageChanged( e:ProjectEvent ):void
		{
			if( e.project && e.project.length > 0 )
			{
				if( e.project.length == 1)
				{
					// single page only - always viewing at 100%
					view.percent = 1;	
				}else{
					// more than one page, calculate percentage
					view.percent = e.index / (e.project.length - 1);
				}
			}else{
				view.percent = 0;
			}
			
		}
		
		
	}
}