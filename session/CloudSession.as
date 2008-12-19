package session
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import mx.managers.PopUpManager;

	import core.CanvasCloud;
	import dialogs.JoinDialog;


	// A Session is 1 user and his/her canvas

	public class CloudSession implements ICloudHistoryClient
	{

		private static var factoryIndex:uint = 0; // Creation Index


		public var localID:uint = 0; // Local session ID (Incremental Creation Index), dont clone as is

		public var remoteID:String = "0"; // Remote session ID (ID from the library)


		[Bindable]
		public var name:String = "default"; // Saved name

		[Bindable]
		public var type:String = "Private"; // type of session: Private or Public

		[Bindable]
		public var description:String = "default session";



		[Bindable]
		public var created:Date = new Date(); // now

		[Bindable]
		public var modified:Date = new Date();



		// user
		[Bindable]
		public var userXML:XML = null;


		// canvas (1 canvas per session for now)
		[Bindable]
		public var canvas:CanvasCloud = null;


		// Not Logged Dialog
		private var joinDialog:JoinDialog = JoinDialog.joinDialog;





		public function CloudSession()
		{
			this.localID = factoryIndex++;
		}


		// clone Session, evil?
		public virtual function clone():CloudSession
		{
			var cloudSession:CloudSession = new CloudSession();

			cloudSession.remoteID = this.remoteID;
			cloudSession.name = this.name;
			cloudSession.type = this.type;
			cloudSession.description = this.description;

			cloudSession.created = this.created;
			cloudSession.modified = this.modified;

			cloudSession.userXML = this.userXML.copy();
			cloudSession.canvas = this.canvas.clone();

			return cloudSession;
		}


		// Save session XML
		public virtual function Save():XML
		{
			var sessionXML:XML = new XML("<session></session>");

			sessionXML.@localID = this.localID;
			sessionXML.@remoteID = this.remoteID;
			sessionXML.@name = this.name;
			sessionXML.@type = this.type;
			sessionXML.@description = this.description;

			sessionXML.@created = Globals.FlexDateToDataBase( this.created );
			sessionXML.@modified = Globals.FlexDateToDataBase( this.modified );

			if(this.userXML)
			{
				//var userXML:XML = this.user.Save(); // Save user XML
				sessionXML.appendChild(userXML);
			}
			else
			{
				trace('Save Session XML: no User')
			}

			if(this.canvas)
			{
				var canvasXML:XML = this.canvas.Save(); // Save canvas XML
				sessionXML.appendChild(canvasXML);
			}
			else
			{
				trace('Save Session XML: no canvas')
			}

			return sessionXML;
		}


		// Load session XML
		public virtual function Load(sessionXML:XML):void
		{
			if(!sessionXML)
				return;

			//this.localID = sessionXML.@localID;
			this.remoteID = sessionXML.@remoteID;
			this.name = sessionXML.@name;
			this.type = sessionXML.@type;
			this.description = sessionXML.@description;

			this.created = Globals.DataBaseDateToFlex( sessionXML.@created );
			this.modified = Globals.DataBaseDateToFlex( sessionXML.@modified );

			var userXML:XML = (sessionXML..user)[0] as XML; // Find the user
			if(userXML) // only 1 for now
			{
				// TODO: Security, Compare remote user with current user 
				this.userXML = userXML; // Load user XML
			}

			var canvasXML:XMLList = sessionXML..canvas as XMLList; // Find all the canvas in session
			if(canvasXML[0]) // only 1 for now
			{
				this.canvas.Load(canvasXML[0]); // Load first canvasXML
			}
		}



		// VALIDATE Registered USER
		public function ValidateUser():Boolean
		{
			if(!userXML)
			{
				PopUpManager.addPopUp(joinDialog, canvas.parentApplication as DisplayObject, true);
				PopUpManager.centerPopUp(joinDialog); // Center Join dialog
				joinDialog.addEventListener("close", onCloseJoinDialog)
				return false;
			}
			return true;
		}

		// Close Join Dialog
		private function onCloseJoinDialog(event:Event):void
		{
			PopUpManager.removePopUp(joinDialog);
		}





	}
}