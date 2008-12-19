package panels.center
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import mx.managers.CursorManager;
	import mx.controls.Alert;


	public class ShirtLoader
	{
		// Shirt image loader
		private var loader:Loader = new Loader(); // USE SWFLoader instead!!!

		private var cloudShirtPanel:CloudShirtPanel = null;



		// TODO : better abstracted loading class...

		public function ShirtLoader()
		{
			// shirt loader callbacks
        	loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadShirt);  // Bad to add multiple time?
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError); // Bad to add multiple time?
		}


        public function LoadShirt(_cloudShirtPanel:CloudShirtPanel):void
		{
			cloudShirtPanel = _cloudShirtPanel;
			var request:URLRequest = new URLRequest(Globals.GetShirtImage(cloudShirtPanel.shirtModel, cloudShirtPanel.shirtColor, cloudShirtPanel.shirtSide));
            loader.load(request);

            CursorManager.setBusyCursor(); // Display the busy cursor
		}


		// Shirt image loaded
        private function onCompleteLoadShirt(event:Event):void
        {
            //event.target.loader;
           	var image:Bitmap = Bitmap(loader.content);
            image.smoothing = true; // SLOWER!

            cloudShirtPanel.shirtImage.source = image; // Set the shirt image on the shirtPanel
            loader.unload();
            
            CursorManager.removeBusyCursor(); // Hide the busy cursor
        }

		private function onIOError(event:IOErrorEvent):void 
        {
            CloudAlert.show("Unable to load image: " + event.text);

            CursorManager.removeBusyCursor(); // Hide the busy cursor
        }



	}
}