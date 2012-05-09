package org.glomaker.mobileplayer.mvcs.views.components
{
	import flash.text.TextFormat;
	
	import net.dndigital.components.Button;
	import net.dndigital.components.Label;
	
	import org.glomaker.mobileplayer.mvcs.utils.DrawingUtils;
	
	public class LabelButton extends Button
	{
		
		protected var label:Label;
		protected var labelText:String = "";

		public function LabelButton( text:String )
		{
			super();
			mouseChildren = false;
			labelText = text;
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			label = label || new Label();
			label.text = labelText;
			label.textFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
			
			addChild( label );
		}
		
		override protected function resized(width:Number, height:Number):void
		{
			super.resized( width, height );
			
			// position label
			label.x = ( width - label.width ) / 2;
			label.y = ( height - label.height ) / 2;
			
			// gradient background
			DrawingUtils.drawStandardGradient( graphics, width, height );
		}
	}
}