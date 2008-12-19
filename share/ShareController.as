package share
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import mx.managers.PopUpManager;

	import core.Cloud;
	import core.CanvasCloud;
	import session.CloudSession;
	import controls.colorClasses.CloudGradient;
	import controls.fontClasses.CloudFont;
	import controls.brushClasses.CloudBrush;
	import controls.shapeClasses.CloudShape;


	public class ShareController
	{

		// Cloud Share
		private const shareCloudDialog:ShareCloudDialog = ShareCloudDialog.shareCloudDialog;

		[Bindable]
		private var canvas:CanvasCloud = null;



    	public function ShareController()
		{
			
		}


		// Validate Selected Cloud
		private function ValidateCloud(sCloud:Cloud):Cloud
		{
			var selCloud:Cloud = CloudEngine.GetInstance().GetCloudController().GetCloud();
			if(!selCloud)
			{
				CloudAlert.show('No Cloud Selected', 'Share Image Cloud');
				return null;
			}

			// Cloud not the same as selected
			if(sCloud && sCloud != selCloud)
			{
			  	CloudAlert.show('Error, cloud mismatch', 'Share Image Cloud');
			  	return null;
			}

			return selCloud;
		}


		// Share IMAGE Cloud
		public function ShareImageCloud(sCloud:Cloud = null):void
		{
			var selCloud:Cloud = ValidateCloud(sCloud);
			if(!selCloud)
				return;

			// horible
			canvas = CloudEngine.GetInstance().GetCanvasController().GetCanvas();

			shareCloudDialog.cloudType = CloudType.ST_IMAGE;

        	PopUpManager.addPopUp(shareCloudDialog, canvas.parentApplication as DisplayObject, true);
			shareCloudDialog.initCloud(selCloud);
			PopUpManager.centerPopUp(shareCloudDialog); // Center Share dialog	

        	shareCloudDialog.addEventListener("close", onCloseShareCloudDialog); // detect dialog closing
		}


		// Share FONT Cloud
		public function ShareCloud(sharedCloud:SharedCloud, cloudType:String):void
		{
			if(!sharedCloud)
			{
				if(1)
				{
					CloudAlert.show('Too Share a ' + cloudType + '....', 'Share ' + cloudType);
				}
				return;
			}

			if(sharedCloud.remoteID != "0") // Font already in the Library
			{
				CloudAlert.show('This ' + cloudType + ' already exists in the Cloud Library' , 'Share ' + cloudType);
				return;
			}

			// horible
			canvas = CloudEngine.GetInstance().GetCanvasController().GetCanvas();

			shareCloudDialog.cloudType = cloudType;

			PopUpManager.addPopUp(shareCloudDialog, canvas.parentApplication as DisplayObject, true);
			shareCloudDialog.initSharedCloud(sharedCloud);
			PopUpManager.centerPopUp(shareCloudDialog); // Center Share dialog	

        	shareCloudDialog.addEventListener("close", onCloseShareCloudDialog); // detect dialog closing
		}


		// Close share Cloud Dialog
		private function onCloseShareCloudDialog(event:Event):void
        {
        	shareCloudDialog.removeEventListener("close", onCloseShareCloudDialog); // remove event listener
            PopUpManager.removePopUp(shareCloudDialog); // Close CloudSubmit dialog
        }



	}
}