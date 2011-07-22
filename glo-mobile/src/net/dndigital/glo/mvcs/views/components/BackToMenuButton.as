package net.dndigital.glo.mvcs.views.components
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import net.dndigital.components.Button;
	import net.dndigital.components.Label;
	import net.dndigital.glo.mvcs.models.enum.ColourPalette;
	import net.dndigital.glo.mvcs.utils.DrawingUtils;

	/**
	 * View component - button to go back to Menu from Player. 
	 * @author nilsmillahn
	 */	
	public class BackToMenuButton extends Button
	{
		
		protected var label:Label;
		
		public function BackToMenuButton()
		{
			super();
			mouseChildren = false;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			label = label || new Label();
			label.text = "MENU";
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