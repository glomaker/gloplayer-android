package net.dndigital.utils
{
	/**
	 * Class used by <code>IComponent.delay</code> to store data about methods or function to be invoked on next display update.
	 * 
	 * @see		Function
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public final class Fun
	{
		public function Fun(fun:Function, args:Array = null)
		{
			super();
			
			this.fun = fun;
			this.args = args;
		}
		
		/**
		 * Function closure.
		 */
		public var fun:Function;
		
		/**
		 * Function closure's arguments.
		 */
		public var args:Array;
	}
}