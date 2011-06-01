package eu.kiichigo.utils {
	public function nextFrame(fun:Function, args:Array = null):void {
		var closure:Closure = new Closure;
			closure.fun = fun;
			closure.args = args;
		for(var i:uint = 0; i < closures.length; i ++)
			if(closures[i].eq(closure))
				return;
		closures.push(closure);
	}
}


import flash.display.Sprite;
import flash.events.Event;

/**
 * @private
 * Holds queued for next frame invocation instances of closures.
 */
const closures:Vector.<Closure> = new Vector.<Closure>;

/**
 * @private
 * Used as "beacon" to dispatch enterFrame.
 */
const sprite:Sprite = new Sprite;


function enterFrame(event:Event):void
{
	while(closures.length) {
		var closure:Closure = closures.pop();
			closure.fun.apply(null, closure.args);
	}
}

class Closure
{
	public var fun:Function;
	public var args:Array = null;
	
	public function eq(closure:Closure):Boolean
	{
		return ( args == closure.args && fun == closure.fun );
	}
}