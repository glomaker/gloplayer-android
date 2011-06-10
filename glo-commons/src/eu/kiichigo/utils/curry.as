/*
The MIT License

Copyright (c) 2008 David Sergey, nirth@fouramgames.com, nirth.furzahad@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
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
package eu.kiichigo.utils {
	/**
	 * Curries function provided in <code>fun</code> argument, with parameters provided in <code>rest</code. And returns reference to curried function.
	 * 
	 * @param	fun		<code>Function</code> to be carried.
	 * @param	after	<code>Boolean</code> indicates whether parameters should go before or after.
	 * @param	rest	List of parameters to be carried with <code>fun</code>.
	 * 
	 * @return	A reference to the curried <code>Function</code>.
	 * 
	 * @see		Function
	 */
	public function curry(fun:Function, after:Boolean = true, ...rest:*):Function {
		if (after)
			return function(...args:*):* {
				return fun.apply(null, args.concat(rest));
			};
		else
			return function(...args:*):* {
				return fun.apply(null, rest.concat(args));
			};
	}
}