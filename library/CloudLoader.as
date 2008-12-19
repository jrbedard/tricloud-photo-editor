package library
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import mx.rpc.events.*;
	import mx.controls.ProgressBar;
	import mx.controls.Alert;
	import mx.managers.CursorManager;

	import core.CanvasCloud;
	import controls.brushClasses.BrushDialog;
	import controls.fontClasses.FontDialog;
	import controls.shapeClasses.ShapeDialog;
	import type.*;




	public class CloudLoader
	{

		[Bindable]
		public var cloudLibrary:CloudLibrary = null;

		[Bindable]
		private var cloudLoader:URLLoader = new URLLoader(); // Cloud Downloader

		[Bindable]
		public var progressBar:ProgressBar = null;

		[Bindable]
		private var metaCloud:XML = null; // Downloaded meta Cloud

		[Bindable]
		private var cloudXML:XML = null; // Downloaded Cloud




		public function CloudLoader()
		{
			// Cloud Download progress
			cloudLoader.addEventListener(Event.OPEN, onCloudDownloadStarted);
			cloudLoader.addEventListener(ProgressEvent.PROGRESS, onCloudDownloadProgress);
			cloudLoader.addEventListener(Event.COMPLETE, onCloudDownloadCompleted);

			// download errors
			cloudLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			cloudLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpError);
			cloudLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}



		public function DownloadCloud(selMetaCloud:XML, cloudXML:XML):void
		{
			this.metaCloud = selMetaCloud;
			this.cloudXML = cloudXML;

			// Really download Cloud
			var request:URLRequest = new URLRequest(selMetaCloud.@dataPath);
			request.method = "GET"; // !! this is the default 
			//request.data =  variable;

			// Load Cloud
			cloudLoader.load(request);
		}


		// Cloud Download started
		private function onCloudDownloadStarted(event:Event):void
		{
			CursorManager.setBusyCursor();

			progressBar.visible = true;
			progressBar.setProgress(0, 0);
		}

		// Download progress
		private function onCloudDownloadProgress(event:ProgressEvent):void
		{
			progressBar.setProgress(event.bytesLoaded, event.bytesTotal);
			progressBar.label = "Downloading '" + metaCloud.@name + "' " + 
				Globals.GetFileSize(event.bytesLoaded) + "/" + Globals.GetFileSize(event.bytesTotal) + " bytes...";
		}

		// Cloud Download Completed
		private function onCloudDownloadCompleted(event:Event):void
		{
			CursorManager.removeBusyCursor();
			progressBar.visible = false;

			CloudAlert.show("Cloud ''" + metaCloud.@name + "'' Downloaded!", 'Cloud Library');


			if(!cloudLoader.data)
			{
				CloudAlert.show("Error Downloading Cloud", "Cloud Loader");
				return;
			}

 			var data:Object = cloudLoader.data;

			if(metaCloud.@type == CloudType.ST_IMAGE)
			{
				LoadImageCloud();
			}
			else if(metaCloud.@type == CloudType.ST_FONT)
			{
				LoadFontCloud();
			}
			else if(metaCloud.@type == CloudType.ST_BRUSH)
			{
				LoadBrushCloud();
			}
			else if(metaCloud.@type == CloudType.ST_SHAPE)
			{
				LoadShapeCloud();
			}
			else if(metaCloud.@type == CloudType.ST_EFFECT)
			{
				LoadEffectCloud();
			}
			else if(metaCloud.@type == CloudType.ST_GRADIENT)
			{
				LoadGradientCloud();
			}

			// Return to CloudDesign View
			//TriCloud(cloudLibrary.parentApplication).setCurrentState('cloudDesign');
		}


		// LOAD IMAGE
		private function LoadImageCloud():void
		{
			// Image Cloud
		    var bytes:ByteArray = new ByteArray();
		    bytes.writeObject(cloudLoader.data);

			var rec:Rectangle =  new Rectangle(0,0, 400, 400);

		   	var bmpData:BitmapData = new BitmapData(rec.width , rec.height);
		  	bmpData.setPixels(rec, bytes);

			var canvas:CanvasCloud = CloudEngine.GetInstance().GetCanvasController().GetCanvas();
			if(!canvas)
				return;

			canvas.AddNewCloud(metaCloud.@name, CloudType.IMAGE);
		}


		// LOAD FONT
		private function LoadFontCloud():void
		{
			cloudLoader.data;

			var canvas:CanvasCloud = CloudEngine.GetInstance().GetCanvasController().GetCanvas();
			if(!canvas)
				return;

			//var textCloud:TextCloud = canvas.AddNewCloud(metaCloud.@name, CloudType.TEXT) as TextCloud;

			var fontDialog:FontDialog = FontDialog.fontDialog;

			var cloudFontXML:XML = (cloudXML..font)[0];
			if(cloudFontXML)
			{
				fontDialog.AddCloudFont(cloudFontXML);
			}
			else
			{
				CloudAlert.show("Invalid Cloud Font", "Cloud Font Loading")
			}
		}


		// LOAD BRUSH
		private function LoadBrushCloud():void
		{
			var brushDialog:BrushDialog = BrushDialog.brushDialog;
		}

		// LOAD SHAPE
		private function LoadShapeCloud():void
		{
			var shapeDialog:ShapeDialog = ShapeDialog.shapeDialog;
		}

		// LOAD EFFECT
		private function LoadEffectCloud():void
		{
			
		}

		// LOAD GRADIENT
		private function LoadGradientCloud():void
		{
		
		}



		// Cloud Download ERRORS
		private function onSecurityError(securityErrorEvent:SecurityErrorEvent):void
		{
			progressBar.visible = false;
			CursorManager.removeBusyCursor();
			CloudAlert.show(securityErrorEvent.text, "Load Cloud Security Error");
		}
		private function onHttpError(httpStatusEvent:HTTPStatusEvent):void
		{
			progressBar.visible = false;
			CursorManager.removeBusyCursor();
			//CloudAlert.show(httpStatusEvent.type, "Load Cloud Http Error");
		}
		private function onIOError(ioErrorEvent:IOErrorEvent):void
		{
			progressBar.visible = false;
			CursorManager.removeBusyCursor();
			CloudAlert.show(ioErrorEvent.text, "Load Cloud IO Error");			
		}


		
	}
}