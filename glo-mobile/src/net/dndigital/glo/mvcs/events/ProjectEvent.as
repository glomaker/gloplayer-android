package net.dndigital.glo.mvcs.events
{
	import flash.events.Event;
	
	import net.dndigital.glo.mvcs.models.vo.Project;

	public final class ProjectEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Cached Events
		//
		//--------------------------------------------------------------------------
		
		public static const NEXT_PAGE_EVENT:ProjectEvent = new ProjectEvent(ProjectEvent.NEXT_PAGE);
		public static const PREV_PAGE_EVENT:ProjectEvent = new ProjectEvent(ProjectEvent.PREV_PAGE);
		public static const MENU_EVENT:ProjectEvent = new ProjectEvent(ProjectEvent.MENU);

		//--------------------------------------------------------------------------
		//
		//  Event Types Constants
		//
		//--------------------------------------------------------------------------
		
		public static const PROJECT:String = "project";
		public static const PAGE:String = "page";
		public static const NEXT_PAGE:String = "next";
		public static const PREV_PAGE:String = "prev";
		public static const MENU:String = "menu";
		public static const GLO_VALIDATE_ERROR:String = "glovalidateerror";
		

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProjectEvent(type:String, project:Project = null, index:int = -1)
		{
			super(type);

			_project = project;
			_index = index;
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
		
		/**
		 * @private
		 */
		protected var _index:int = -1;
		/**
		 * Index of a page to switch to.
		 */
		public function get index():int { return _index; }

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
			return new ProjectEvent(type, _project, _index);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return formatToString("ProjectEvent", "project", "index");
		}
	}
}