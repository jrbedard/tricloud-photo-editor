package
{
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import mx.collections.ArrayCollection
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.effects.Resize;
	import mx.effects.Parallel;
	import mx.events.EffectEvent 
	import mx.managers.PopUpManager;


	public class CloudDialogManager
	{

		private static var dialogs:ArrayCollection = new ArrayCollection();

		private static var fadeIn:Fade = null;
		private static var resize:Resize = null;


		public function CloudDialogManager()
		{
			fadeIn = new Fade();
			fadeIn.alphaFrom = 0.0;
			fadeIn.alphaTo = 1.0;
			fadeIn.duration = 250;

			resize = new Resize();
			resize.heightFrom = 0;
			resize.duration = 250;
		}


		// Show Dialog
		public static function OpenDialog(dialog:UIComponent, parentControl:UIComponent):void
		{
			var globalPos:Point = parentControl.parent.localToGlobal(new Point(parentControl.x, parentControl.y));

			if(globalPos.x < parentControl.parentApplication.width/2) // left of application
			{
				dialog.x = Math.max(0, globalPos.x + parentControl.width - dialog.width);
				dialog.x = Math.min(dialog.x, parentControl.parentApplication.width - dialog.width); // dont overflow to the right
			}
			else
			{
				dialog.x = Math.max(0, globalPos.x);
				dialog.x = Math.min(dialog.x, parentControl.parentApplication.width - dialog.width); // dont overflow to the right
			}

			dialog.y = Math.max(0, globalPos.y - dialog.height - 10);

			PopUpManager.addPopUp(dialog, parentControl, false); // more optimal?

			dialog.visible = true;
			fadeIn.target = dialog;
			fadeIn.play();

			//resize.heightTo = dialog.height;
			//resize.target = dialog;
			//resize.play();

			dialogs.addItem(dialog);
		}


		// Close Dialog
		public static function CloseDialog(dialog:UIComponent):void
		{
			PopUpManager.removePopUp(dialog);
			dialogs.removeItemAt( dialogs.getItemIndex(dialog) );
		}


		// Hide Dialogs (ex: design -> Cloud Library)
		public static function HideAllDialog():void
		{
			for each(var dialog:UIComponent in dialogs)
			{
				dialog.visible = false;
			}
		}

		// Restore Dialogs (ex: Cloud Library -> design)
		public static function ShowAllDialog():void
		{
			for each(var dialog:UIComponent in dialogs)
			{
				dialog.visible = true;
			}
		}
	
	}
}