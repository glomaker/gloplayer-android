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
package eu.kiichigo.utils
{
	/**
	 * Formats instance to string.
	 */
	public function formatToString(instance:Object, ...properties:*):String
	{
		var props:*;
		if( properties.length == 1 && !(properties[0] is String))
			props = properties[0];
		else
			props = properties;
		
		var string:String = '[' + getClassName(instance) + ' ';
		for each (var property:String in props )
		if(instance.hasOwnProperty( property))
			string += property + '=' + instance[property] + ' ';
		string = string.substring(0, string.length - 1);
		string += ']';
		return string;
	}
}