package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.models.vo.Project;

	public class ProjectEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Event Types Constants
		//
		//--------------------------------------------------------------------------
		
		public static const PROJECT:String = "project";

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProjectEvent(type:String, project:Project)
		{
			super(type);

			_project = project;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _project:Project;
		/**
		 * Reference to an instance of <code>Project</code>.
		 * 
		 * @see		net.dndigital.glo.mvcs.models.vo.Project
		 */
		public function get project():Project { return _project }

		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new ProjectEvent(type, project);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("ProjectEvent", "project");
		}
	}
}