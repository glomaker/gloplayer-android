/*
The MIT License

Copyright (c) 2009-2011 
David "Nirth" Sergey ( nirth@kiichigo.eu, nirth.furzahad@gmail.com )

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
	 * Accepts item and path, and returns value of a property.
	 * 
	 * <code>
	 * var a:Number = path({a: {b: {c: 1}}}, "a.b.c");
	 *		var b:Number = path(<xmlroot>
	 *								<node b="2"/>
	 *							</xmlroot>, "node.@b");
	 *		var c:Number = path(<xmlroot>
	 *								<node>
	 *									<c>3</c>
	 *								</node>
	 *							</xmlroot>, "node.c");
	 *		log("a={0} b={1} c={2}", a, b, c); // a=1 b=2 c=0
	 * </code>
	 * 
	 * @param	item		Item which contains desired value.
	 * @param	path		Path withing <code>item</code> to be navigated to.
	 * 
	 * @returns		Property value indicated by <code>path</code> within <code>item</code>.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function path(item:Object, path:String):* {
		// If there is no path, or path is invalid we simpy return original <code>item</code>.
		if (path == null || path.length == 0 || path.indexOf(".") == -1)
			return item;
		// Break path to array.
		var elements:Array = path.split(".");
		while (elements.length)
			item = item[elements.shift()];	// Reassign item with new values.
		return item;
	}
}