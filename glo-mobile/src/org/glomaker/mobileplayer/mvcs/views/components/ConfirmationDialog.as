package org.glomaker.mobileplayer.mvcs.views.components
{
	import flash.events.MouseEvent;
	
	import net.dndigital.components.IGUIComponent;
	
	import org.glomaker.mobileplayer.mvcs.utils.ScreenMaths;

	/**
	 * A dialog that displays a message, a 'Yes' button and a 'No' button for asking the
	 * user to confirm an action.
	 * 
	 * @author haykel
	 * 
	 */
	public class ConfirmationDialog extends Notification
	{
		//--------------------------------------------------
		// Constatnts
		//--------------------------------------------------
		
		protected static const BUTTON_WIDTH:uint = ScreenMaths.mmToPixels(20);
		protected static const BUTTON_HEIGHT:uint = ScreenMaths.mmToPixels(8);
		
		//--------------------------------------------------
		// Instance variables
		//--------------------------------------------------
		
		protected const yesButton:LabelButton = new LabelButton();
		protected const noButton:LabelButton = new LabelButton();
		
		//--------------------------------------------------
		// response
		//--------------------------------------------------
		
		protected var _response:Boolean = false;
		
		/**
		 * Returns the user response. It is set to 'true' if he clicked
		 * on 'yes' and 'false' otherwise. This value is only valid
		 * after the 'close' event has been dispatched.
		 */
		public function get response():Boolean
		{
			return _response;
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():IGUIComponent
		{
			autoClose = false;
			
			return super.initialize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			textField.multiline = true;
			
			yesButton.label = "YES";
			yesButton.width = BUTTON_WIDTH;
			yesButton.height = BUTTON_HEIGHT;
			yesButton.addEventListener(MouseEvent.CLICK, button_clickHandler);
			addChild(yesButton);
			
			noButton.label = "NO";
			noButton.width = BUTTON_WIDTH;
			noButton.height = BUTTON_HEIGHT;
			noButton.addEventListener(MouseEvent.CLICK, button_clickHandler);
			addChild(noButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commited():void
		{
			super.commited();
			
			yesButton.validate();
			noButton.validate();
			
			width = Math.max(width, BUTTON_WIDTH*2 + 45);  // 45 is 2*15 pixels padding + 15 pixels gap
			height = textField.height + BUTTON_HEIGHT + 45; // 45 is 2*15 pixels padding + 15 pixels gap
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resized(width:Number, height:Number):void
		{
			super.resized(width, height);
			
			textField.x = (width - textField.width) / 2;
			textField.y = 15;
			
			var buttonsWidth:Number = BUTTON_WIDTH*2 + 15;
			yesButton.x = (width - buttonsWidth) / 2;
			yesButton.y = textField.y + textField.height + 15;
			noButton.x = yesButton.x + BUTTON_WIDTH + 15;
			noButton.y = yesButton.y;
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		protected function button_clickHandler(event:MouseEvent):void
		{
			_response = (event.currentTarget == yesButton);
			destroy();
		}
	}
}