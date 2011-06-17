package net.dndigital.utils {
	import flash.display.Shape;
	import flash.display.Sprite;

	public function drawRectangle(target:Object, color:uint, width:int, height:int, clear:Boolean = true):void {
		if (target is Shape || target is Sprite)
			target = target.graphics;
		
		if (clear)
			target.clear();
		
		target.beginFill(color);
		target.drawRect(0, 0, width, height);
		target.endFill();
	}
}