package net.dndigital.core
{
	/**
	 * Class used by <code>IComponent.delay</code> to store data about methods or function to be invoked on next display update.
	 * 
	 * @author David "nirth" Sergey
	 * 
	 */
	public final class Fun
	{
		public function Fun(fun:Function, args:Array)
		{
			super();
			
			this.fun = fun;
			this.args = args;
		}
		
		/**
		 * @private
		 * Function closure.
		 */
		public var fun:Function;
		
		/**
		 * @private
		 * Function closure's arguments.
		 */
		public var args:Array;
	}
}