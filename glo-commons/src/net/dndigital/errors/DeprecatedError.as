package net.dndigital.errors
{
	/**
	 * Instances of this error are thrown by methods that considered to be deprecated and shouldn't be used.
	 * 
	 * @see		Error
	 * 
	 * @author David "nirth" Sergey.
	 * @author DN Digital Ltd.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public final class DeprecatedError extends Error
	{
		/**
		 * Creates new instance of <code>DeprecatedError</code>. With custom message.
		 * 
		 * @param deprecated		Old method name, that is called, and should not be used.
		 * @param current			Method that programmer should use instead.
		 * @param message			Message pattern, with {0} and {1} to denote <code>deprecated</code> and <code>current</code>.
		 */
		public function DeprecatedError(deprecated:String, current:String,
										message:String = "Method {0} is deprecated, please use {1} instead.")
		{
			message.split("{0}").join(deprecated).split("{1}").join(current);
			
			super(message);
		}
	}
}