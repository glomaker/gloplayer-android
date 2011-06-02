package net.dndigital.glo.mvcs.services
{
	import net.dndigital.glo.mvcs.models.vo.Project;
	
	/**
	 * <code>IProjectService</code> can be used to load and parse *.glo project files.
	 * 
	 * @author		David "nirth" Sergey
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public interface IProjectService
	{
		/**
		 * <code>String</code>, <code>File</code> or <code>XML</code>.
		 * Source of the service, if <code>String</code> or <code>File</code> is passed file will be loaded, and parsed, if <code>XML</code> is passed data will be parsed.
		 * 
		 * @see		XML
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get source():Object;
		/**
		 * @private
		 */
		function set source( value:Object ):void;
		
		
		/**
		 * Parsed instance of <code>Project</code> can be accessed through this property.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Project
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get project():Project;
		
		
		/**
		 * Initiates File Selection.
		 * 
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function select():IProjectService;
		
	}
}