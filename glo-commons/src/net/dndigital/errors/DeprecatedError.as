/*
Copyright (c) 2011 DN Digital Ltd (http://dndigital.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

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
			super(message.split("{0}").join(deprecated).split("{1}").join(current));
		}
	}
}