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
package org.glomaker.mobileplayer.mvcs.services {
	
	import flash.filesystem.File;
	
	import org.glomaker.mobileplayer.mvcs.models.vo.Project;

	public function parse(xml:XML, directory:File):Project {
		return $project(xml, directory);
	}
}

import eu.kiichigo.utils.*;

import flash.filesystem.File;
import flash.utils.Dictionary;

import org.glomaker.mobileplayer.mvcs.models.vo.*;

/**
 * @private
 */
var log:Function = eu.kiichigo.utils.log("parse");



/**
 * Parses a <code>xmlList</code> with <code>parser</code> into <code>vector</code>.
 * 
 * @param xmlList 	<code>XMLList</code> to be parsed.
 * @param vector	<code>Vector</code> wich will hold results of parsing.
 * @param parser	<code>Function</code> that will be used to parse individual elements.
 * @return 			<code>Vector</code> filled with parsed objects.
 * 
 */
function $list(xmlList:XMLList, vector:*, parser:Function):* {
	for (var i:int = 0; i < xmlList.length(); i++)
		vector.push(parser(xmlList[i]));		
	vector.fixed = true;
	return vector;
}

/**
 * Parses <code>xml</code> into an instance of <code>Project</code>.
 * 
 * @param xml 		<code>XML</code> to be parsed.
 * @return 			<code>Project</code> instance parsed from <code>xml</code>.
 */
function $project(xml:XML, directory:File):Project {
	const project:Project 		= new Project;
		project.hasFullPaths 	= xml.@hasFullFilePaths;
		project.width 			= xml.props.w;
		project.height 			= xml.props.h;
		project.background 		= xml.props.rgb;
		project.pages 			= $list(xml.nodes.page, new Vector.<Page>, curry($page, true, directory));
		project.directory 		= directory;
	return project;
}

/**
 * Parses <code>xml</code> into an instance of <code>Page</code>.
 * 
 * @param xml 		<code>XML</code> to be parsed.
 * @return 			<code>Page</code> instance parsed from <code>xml</code>.
 */
function $page(xml:XML, directory:File):Page {
	const page:Page = new Page;
		page.components = $list(xml.component, new Vector.<Component>, curry($component, true, directory));
	return page;
}

/**
 * Parses <code>xml</code> into an instance of <code>Component</code>.
 * 
 * @param xml 		<code>XML</code> to be parsed.
 * @return 			<code>Component</code> instance parsed from <code>xml</code>.
 */
function $component(xml:XML, directory:File):Component {
	const component:Component = new Component;
		component.id = xml.@id;
		component.x = xml.@x;
		component.y = xml.@y;
		component.width = xml.@width;
		component.height = xml.@height;
		component.directory = directory;
		component.data = $data(xml.children());
		
		//for some reason, if we assign a reference of 'xml' to 'rawXML',
		//'rawXML' will have all its children removed when 'GloComponent::dataUpdated()'
		//is called, so we make a copy.
		component.rawXML = new XML(xml.toXMLString());
	return component;
}

/**
 * Parses additional data passed in component node.
 */
function $data(xmlList:XMLList):Object {
	var data:Object = new Object;
	for each (var node:XML in xmlList) {
		if(node.hasSimpleContent())
			data[node.name()] = node.toString();
		else
			data[node.name()] = $data(node.children());
	}
	return data;
}