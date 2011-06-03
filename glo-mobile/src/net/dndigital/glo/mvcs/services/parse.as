package net.dndigital.glo.mvcs.services {
	import eu.kiichigo.utils.log;
	
	import net.dndigital.glo.mvcs.models.vo.Page;
	import net.dndigital.glo.mvcs.models.vo.Project;
	import net.dndigital.utils.Fun;

	public function parse(xml:XML):Project {
		return $project(xml);
	}
}

import eu.kiichigo.utils.*;

import net.dndigital.glo.mvcs.models.vo.*;

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
function $project(xml:XML):Project {
	var project:Project = new Project;
		project.hasFullPaths = xml.@hasFullFilePaths;
		project.width = xml.props.w;
		project.height = xml.props.h;
		project.background = xml.props.rgb;
		project.pages = $list(xml.nodes.page, new Vector.<Page>, $page);
	return project;
}

/**
 * Parses <code>xml</code> into an instance of <code>Page</code>.
 * 
 * @param xml 		<code>XML</code> to be parsed.
 * @return 			<code>Page</code> instance parsed from <code>xml</code>.
 */
function $page(xml:XML):Page {
	var page:Page = new Page;
		page.components = $list(xml.component, new Vector.<Component>, $component);
	return page;
}

/**
 * Parses <code>xml</code> into an instance of <code>Component</code>.
 * 
 * @param xml 		<code>XML</code> to be parsed.
 * @return 			<code>Component</code> instance parsed from <code>xml</code>.
 */
function $component(xml:XML):Component {
	var component:Component = new Component;
		component.id = xml.@id;
		component.x = xml.@x;
		component.y = xml.@y;
		component.width = xml.@width;
		component.height = xml.@height;
	return component;
}