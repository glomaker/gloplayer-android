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
package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import flash.utils.Dictionary;
	
	import net.dndigital.components.IGUIComponent;
	import org.glomaker.mobileplayer.mvcs.models.vo.Component;
	import org.glomaker.mobileplayer.mvcs.views.GloPlayer;

	/**
	 * The IGloComponent interface defines api that programmer must implement to create child components for <code>IGloPlayer</code>.
	 *  
	 * @see		net.dndigital.components.IUIComponent
	 * @see		net.dndigital.components.UIComponent
	 * @see		net.dndigital.glo.mvcs.models.vo.Component
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IGloComponent extends IGUIComponent
	{
		/**
		 * Data VO received from file. Containing component's data.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Component
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get component():Component;
		/**
		 * @private
		 */
		function set component(value:Component):void;
		
		/**
		 * Reference to an instance of <code>GloPlayer</code> that's owns current instance of <code>IGloComponent</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.views.GloPlayer
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get player():GloPlayer;
		
		/**
		 * @private
		 */
		function set player(value:GloPlayer):void;
		

		/**
		 * Notifies the component that the application has been activated again.
		 * Components should continue playing animations / video / sound that was paused when 'deactivate()' occurred.
		 * 
		 * @see deactivate()
		 *   
		 */		
		function activate():void;
		
		
		/**
		 * Notifies the component that the application has been de-activated.
		 * That usually means the user has pressed a mobile hotkey to navigate away from the app.
		 * Components should stop animations / video / sound from playing.
		 * 
		 * @see activate() 
		 * 
		 */		
		function deactivate():void;
		
		
		/**
		 * Method begins destruction of an instance of <code>IGloComponent</code> and assets created by it.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function destroy():void;
	}
}