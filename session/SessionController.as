package session
{
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.HTTPService;	
	import mx.events.CloseEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.PopUpManager;

	import core.CanvasCloud;
	import dialogs.LeaveDialog;



	public class SessionController
	{

		[Bindable]
		private var canvas:CanvasCloud = null;

		[Bindable]
		private var cloudSession:CloudSession = null; // active session



		// Modal Session Load/Save
		private const sessionDialog:SessionDialog = SessionDialog.sessionDialog;

		// Session History Dialog
		private const historyDialog:HistoryDialog = HistoryDialog.historyDialog;

		// Leave TriCloud
		private const leaveDialog:LeaveDialog = LeaveDialog.leaveDialog;


		private var httpService:HTTPService = null;

		private var isLeaving:Boolean = false;





		public function SessionController()
		{
			this.cloudSession = new CloudSession(); // Default Session

			sessionDialog.addEventListener("close", onCloseSessionDialog); // detect closing
			historyDialog.addEventListener("close", onCloseHistoryDialog);

			// Load default session XML
			LoadDefaultSession();
		}

		public function SetCanvas(canvas:CanvasCloud):void
		{
			this.canvas = canvas;

			cloudSession.canvas = canvas;

			CloudHistory.action("New Canvas", cloudSession, false);
		}


		// Session Factory
		private function SessionFactory():CloudSession
		{
			var newSession:CloudSession = new CloudSession(); // Default Session

			// Factory

			return newSession;
		}



		// Session Accessors
		private function SetSession(session:CloudSession):void
		{
			this.cloudSession = cloudSession;
		}
		public function GetSession():CloudSession
		{
			if(!cloudSession)
			{
				trace("Warning, no session is loaded");
			}
			return cloudSession;
		}


		// User Accessors
		public function GetUser():XML
		{
			if(!cloudSession || !cloudSession.userXML)
			{
				trace("Warning, no session or user is loaded");
			}
			return cloudSession.userXML;
		}


		// Session
		public function IsUserLogged():Boolean
		{
			if(cloudSession && cloudSession.userXML)
			{
				return true; // logged
			}
			else
			{
				return false; // not logged
			}
		}

		// User Accessors
		public function SetUser(user:XML):void
		{
			if(!cloudSession)
			{
				trace("Warning, no session is loaded");
			}
			else
			{
				if(user) // Login
				{
					cloudSession.userXML = user.copy();
				}
				else // Logout
				{
					cloudSession.userXML = null;
				}
			}
		}



		// Load defaultSession.XML file from URL
		public function LoadDefaultSession():void
		{
			httpService = new HTTPService();

			httpService.url = "/flash/TriCloud/defaultSession.xml";
			httpService.addEventListener("result", onResultLoadDefaultSession);
			httpService.addEventListener("fault", onFault);
			httpService.resultFormat = "e4x";
			httpService.send();
		}

		private function onResultLoadDefaultSession(event:ResultEvent):void
		{
			var defaultSessionXML:XML = event.result as XML;

			this.cloudSession.Load(defaultSessionXML); // Load sesssion XML
		}

		private function onFault(event:FaultEvent):void
		{
			CloudAlert.show("Error: Unable to load defaultSession.xml", 'Session Error');
		}


		public function LoadSavedSession(sessionXML:XML, bytes:ByteArray):void
		{
			CloudHistory.clear(); // Clear History

			// TODO: reset other stuff here...

			bytes.uncompress();
			//var bmpData:BitmapData = new BitmapData();
			

			this.cloudSession.Load(sessionXML); // Load session XML

			// TODO: Tell the browser via FABridge to display the session name in the browser's title.
		}
		



		public function LoginSession():void
		{
			
		}


		// New Session
		public function NewSession():void
		{
			// Do you want to save 
        	var alert:Alert = Alert.show("Do you want to save your Session?", "Save Session", 3, canvas, alertClickHandlerNew);
			alert.titleIcon = Globals.g_assets.TriCloudIcon16;
			alert.graphics.lineStyle(2, 0xFF0000, 1.0);
			alert.graphics.moveTo(0,0);
			alert.graphics.lineTo(300,300);
			// bouyah!
		}


		// Load Session
		public function LoadSession():void
		{
        	PopUpManager.addPopUp(sessionDialog, canvas.parentApplication as DisplayObject, true);
			sessionDialog.init("load");
			PopUpManager.centerPopUp(sessionDialog); // Center Image dialog
		}

		// Save Session
		public function SaveSession():void
		{
        	PopUpManager.addPopUp(sessionDialog, canvas.parentApplication as DisplayObject, true);
			sessionDialog.init("save");
			PopUpManager.centerPopUp(sessionDialog); // Center Image dialog
		}


		private function onCloseSessionDialog(event:Event):void
        {
        	PopUpManager.removePopUp(sessionDialog);

        	if(isLeaving)
        	{
        		LeaveTriCloud();
        		isLeaving = false;
        	}
        }





		// Asked to save canvas before new
        private function alertClickHandlerNew(event:CloseEvent):void 
        {
			if(event.detail==Alert.YES)
            {
            	SaveSession();
            }
            else
            {
            	CloudEngine.GetInstance().GetCanvasController().ClearAll();

            	LoadDefaultSession();
            	return;
            }
        }




		// HISTORY MANAGER
		// -------------------------
		public function onClickHistoryManager(posX:uint, posY:uint):void
		{
			PopUpManager.addPopUp(historyDialog, canvas.parentApplication as DisplayObject, false);

			// Position the dialog just below the undo/redo buttons
			historyDialog.x = posX;
			historyDialog.y = posY;
		}

		private function onCloseHistoryDialog(event:Event):void
		{
            PopUpManager.removePopUp(historyDialog);
		}


		public function onItemClickHistoryBtn(event:ItemClickEvent):void
		{
			if(event.item.name == "undo") // undo
			{
			  	CloudHistory.undo();
			}
			else // redo
			{
				CloudHistory.redo();
			}
		}


		public function onClickSettings():void
		{
			
			
		}


		// Exit
		public function onClickExit():void
        {
			// Do you want to save 
        	var alert:Alert = Alert.show("Do you want to save your Session before leaving?", "Save Session", 3, canvas, alertClickHandlerFinish);
        }

		// Asked to save canvas before finishing
        private function alertClickHandlerFinish(event:CloseEvent):void 
        {
			if(event.detail==Alert.YES)
            {
            	isLeaving = true;
            	SaveSession();
            }
            else
            {
            	LeaveTriCloud();
            }
        }


		public function LeaveTriCloud():void
		{
			// Leave Dialog to submit Clouds
            PopUpManager.addPopUp(leaveDialog, canvas.parentApplication as DisplayObject, true);
			leaveDialog.init(canvas);
			PopUpManager.centerPopUp(leaveDialog); // Center Leave dialog
		}


	}
}