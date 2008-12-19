package library
{	
	import flash.events.Event;
	import mx.events.ItemClickEvent;
	import mx.collections.ArrayCollection;


	public class LibraryHistory
	{
		public static var historyList:ArrayCollection = new ArrayCollection(); // Array of Actions
		public static var historyIndex:uint = 0;

		
		// Constructor
		public function LibraryHistory()
		{
			
		}

		// Save before Action
		public static function action(actionName:String, historyClient:ICloudHistoryClient):void
		{
			var stateXML:XML = historyClient.Save(); // save state XML

			var actionEntry:Object = {name:actionName, icon:Globals.g_assets.AddTagIcon, 
									  client:historyClient, state:stateXML};

			historyIndex = historyList.length+1; // position index to action
			historyList.addItem(actionEntry); // add action in list
		}


		// Go Back
		public static function back():void
		{
			var actionEntry:Object = historyList.getItemAt(historyList.length-1); // retreive last entry
			if(actionEntry && actionEntry.client && actionEntry.state)
			{
				actionEntry.client.Load( actionEntry.state ); // Load XML state

				if(historyIndex > 0)
					historyIndex--;
			}
		}

		// Go Forward
		public static function forward():void
		{
			if(historyIndex < historyList.length-1)
				historyIndex++;
		}

		// Refresh
		public static function refresh():void
		{
			
		}

		// Stop
		public static function stop():void
		{
			
		}

	}
}