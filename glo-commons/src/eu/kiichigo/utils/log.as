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
package eu.kiichigo.utils
{	
	import flash.external.ExternalInterface;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * Higher order function. Logging/tracing helper.
	 * <code>
	 * 
	 * @param	filter		Class or String that will be used to prefix log messages.
	 * @param	logger		Function reference. Reference to the fuction that's used to output messages.
	 * 
	 * @return				Function, thats ready to log.
	 */
	public function log( filter:Object = "", ...rest ):Function
	{
		if( !loggable )
			return function( ...rest ):void {};
		
		if( filter is Class )
			filter = getQualifiedClassName( filter ).split( "::" )[1];
		
		if( rest == null || rest.length == 0 )
			rest = [trace];
		
		var loggers:Vector.<Function> = new Vector.<Function>;
		for( var i:uint = 0; i < rest.length; i ++ )
			loggers.push( rest[i] );
		loggers.fixed = true;
		
		
		return function( ...messages:* ):void {
			if( !loggable )
				return;
			
			var time:String = ( Math.round( getTimer() / 10 ) / 100 ).toString();
			var parts:Array = time.split( "." );
			var s:String = parts[0];
			var ms:String = parts.length == 1 ? "0" : parts[1];
			
			while( s.length < 3 )
				s = "0" + s;
			while( ms.length < 3 )
				ms = "0" + ms;
				
			time = s + "." + ms;
			
			var string:String = "[" + time + "]" + ( ( filter &&  filter.length ) ? "[" + filter + "] " : "" );
			
			if( messages.length == 2 &&
				messages[0].toString().indexOf( "$" ) != -1 ) {
				string += messages[0];
				var max:uint = 55;
				while( string.indexOf( "$" ) != -1 && max > 0 ) {
					var from:int = string.indexOf( "$" );
					var to:int = string.indexOf( " ", from );
					var name:String = string.substring( from, to == -1 ? string.length : to );
					string = string.split( name ).join( messages[1][name.split( "$" ).join( "" )] );
					max --
				}
			}
			else if( messages &&
				     messages[0] &&
					 messages[0].toString().indexOf( "{" ) != -1 && 
					 messages[0].toString().indexOf( "}" ) != -1 ) {
				string += messages.shift();
				for( var i:int = 0; i < messages.length; i ++ )
					if( string.indexOf( "{" + i + "}" ) >= 0 )
						string = string.split( "{" + i + "}" ).join( messages[i] );
					else if( string.indexOf( "{" + i + "*}" ) >= 0 )
						string = string.split( "{" + i + "*}" ).join( $logObject( messages[i] ));
			} else {
				for( var j:uint = 0; j < messages.length; j ++ )
					if( messages[j] is String )
						string += messages[j] + " ";
					else if( messages[j] == null )
						string += 'null ';
					else if( messages[j] is Number || messages[j] is Boolean )
						string += messages[j].toString() + " ";
					else if( messages[j] is XML || messages[j] is XMLList )
						string += messages[j].toXMLString() + " ";
					else
						string += messages[j].toString() + " ";
			}	
			
			for( var l:uint = 0; l < loggers.length; l ++ )
				loggers[l].apply( null, [string] );
		}
	}
}

import flash.external.ExternalInterface;

function $console( string:String ):void
{
	if( ExternalInterface.available ) {
		ExternalInterface.call( "console.log", string );
	}
}

function $logObject( object:Object ):String
{
	var result:String = "";
	for( var property:String in object ) {
		var p:Object = object[property];
		result += property + "=";
		if( p == null ||
			p is Boolean ||
			p is Number || p is uint  || p is int ||
			p is String ||
			p is Array )
			result += p;
		else if( $dynamic( p ) )
			result += $logObject( p );
		else
			result += p.toString();
		
		result += "    \n";
	}
	return "{\n"+ result + "}";
}

function $dynamic( object:Object ):Boolean
{
	for( var property:String in object )
		return true;
	return false;
}