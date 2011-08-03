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

package net.dndigital.components.mobile
{
	/**
	 * Interface for MobileList item renderers. 
	 * @author nilsmillahn
	 */	
	public interface IMobileListItemRenderer
	{
		function set data(value:Object):void;
		function get data():Object;
		function set index(value:Number):void;
		function get index():Number;
		function set itemWidth(value:Number):void;
		function get itemWidth():Number;
		function set itemHeight(value:Number):void;
		function get itemHeight():Number;
		function selectItem():void;
		function unselectItem():void;
		function destroy():void;
	}
}