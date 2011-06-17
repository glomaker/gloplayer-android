package net.dndigital.utils {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	public function drawRectangle(target:Object, color:uint, width:int, height:int, alpha:Number = 1, corner:int = 0, clear:Boolean = true):void {
		if (target is Shape || target is Sprite)
			target = target.graphics;
		
		if (clear)
			target.clear();
		
		target.beginFill(color, alpha);
		target.drawRoundRect(0, 0, width, height, corner, corner);
		target.endFill();
	}
}