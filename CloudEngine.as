package
{
	import core.CloudController;
	import core.CanvasController;
	import session.SessionController;
	import share.ShareController;


	// Cloud Engine singleton: Interface to the Cloud designer implementation
	public class CloudEngine
	{
		private static var cloudEngine:CloudEngine = null;


		private var sessionController:SessionController = null;

		private var canvasController:CanvasController = null;

		private var cloudCursor:CloudCursor = null;

		private var cloudDialogManager:CloudDialogManager = null;

		private var cloudHistory:CloudHistory = null;

		private var shareController:ShareController = null;


		public function CloudEngine()
		{
			// Singletons instanciations
			sessionController = new SessionController();
			canvasController = new CanvasController();
			cloudCursor = new CloudCursor();
			cloudDialogManager = new CloudDialogManager();
			cloudHistory = new CloudHistory();
			shareController = new ShareController();
		}

		public static function GetInstance():CloudEngine
		{
			if(!cloudEngine)
			{
				cloudEngine = new CloudEngine();
			}
			return cloudEngine;
		}


		public function GetSessionController():SessionController
		{
			return sessionController;
		}

		public function GetCanvasController():CanvasController
		{
			return canvasController;
		}

		public function GetCloudController():CloudController
		{
			if(canvasController.GetCanvas())
			{
				return canvasController.GetCanvas().cloudController;	
			}
			return null;
		}

		public function GetShareController():ShareController
		{
			return shareController;
		}
	}
}