package net.dndigital.glo.mvcs.services
{
	import flash.filesystem.File;
	
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
		 * Indicates file that should be loaded and parsed by service.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Project
		 * @see		flash.filesystem.File
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.5
		 * @productversion Flex 4.5
		 */
		function get file():File;
		/**
		 * @private
		 */
		function set file(value:File):void;
	}
}