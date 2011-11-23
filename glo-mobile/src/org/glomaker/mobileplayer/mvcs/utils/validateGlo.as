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
package org.glomaker.mobileplayer.mvcs.utils {
	import com.adobe.crypto.MD5;
	
	import eu.kiichigo.utils.log;

	public function validateGlo(xml:XML):Boolean {
		var nodeName:String = "filehash";
		
		// if no validation tag was found, then we can't validate, so assume invalid
		if(!xml.hasOwnProperty(nodeName))
			return false;
		
		// (Back door) ... exception, ignore the process of validation if the key word ignore is found! (Musbah: 09July09) .. to allow people to edit the XML file manually
		if(xml.child(nodeName) == "ignore")
			return true;
		
		var validationNode:String = xml.child(nodeName);
		delete xml.child(nodeName)[0];
		
		var hash:String = MD5.hash(xml.toXMLString());
		
		return hash == validationNode;
	}
}