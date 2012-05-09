/**
 * Copyright DN Digital Ltd 2012.
**/
package org.glomaker.mobileplayer.mvcs.views.glocomponents
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.dndigital.components.IGUIComponent;
	
	/**
	 * Displays a GPS-enabled compoennt. 
	 * @author Nils
	 * 
	 */	
	public class GPSComponent extends GloComponent
	{

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var titleField:TextField;
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy	net.dndigital.glo.mvcs.views.controls.IGloComponent#activate 
		 */		
		override public function activate():void
		{
			// override in component implementation
			super.activate();
		}
		
		/**
		 * @copy	net.dndigital.glo.mvcs.views.controls.IGloComponent#deactivate 
		 */		
		override public function deactivate():void
		{
			// override in component implementation
			super.deactivate();
		}
		
		/**
		 * @copy	net.dndigital.glo.mvcs.views.controls.IGloComponent#destroy
		 */ 
		override public function destroy():void
		{
			super.destroy();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overriden API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			mapProperty("cornerRadius");
			mapProperty("bgcolour", "color");
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if( !titleField )
			{
				titleField = new TextField();
				titleField.selectable = false;
				addChild( titleField );
				
				var tf:TextFormat = new TextFormat();
				tf.font = "_sans";
				tf.size = 13;
				
				titleField.setTextFormat( tf );
				titleField.defaultTextFormat = tf;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			graphics.clear();
			graphics.beginFill(0xcecece);
			graphics.drawRect( 0, 0, width, height);
			graphics.endFill();
			
			titleField.text = "Non-release component: GPS Integration";
			titleField.x = 10;
			titleField.y = 10;
			titleField.width = width - 20;
			titleField.autoSize = TextFieldAutoSize.LEFT;
		}
		
	}
	
}