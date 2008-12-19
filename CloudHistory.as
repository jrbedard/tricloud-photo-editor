package
{
	import flash.events.Event;
	import flash.display.BitmapData;
	import mx.events.ItemClickEvent;
	import mx.collections.ArrayCollection;

	


	// Cloud Engine's History Manager
	public class CloudHistory
	{

		// TODO: 1 history stack per Cloud

		public static var historyList:ArrayCollection = new ArrayCollection(); // Array of Actions

		public static var historyIndex:uint = 0;


		// binary data (bitmapData)
		public static var historyDataList:Array = new Array(); // Array of Data

		// save binary for this action?
		public static var historySaveBinary:Boolean = false;



		// Constructor
		public function CloudHistory()
		{
			
		}

		// Save before Action
		public static function action(actionName:String, historyClient:ICloudHistoryClient, saveBmpData:Boolean):void
		{
			// DO CLEAN: If actions exist after the last added, delete them
			var cleanIndex:uint = historyIndex+1;
			while(cleanIndex < historyList.length)
			{
				historyList.removeItemAt(cleanIndex);
				// todo: remove binary?
			}

			// DO ACTION
			historySaveBinary = saveBmpData; // save binary as well?

			var stateXML:XML = historyClient.Save(); // save state XML

			var actionEntry:Object = {name: historyIndex + ") " + actionName + (saveBmpData?' (B)':''), 
									  icon: Globals.g_assets.AddTagIcon, 
									  client: historyClient, 
									  state: stateXML,
									  saveBitmapData: saveBmpData};

			historyList.addItem(actionEntry); // add action in list
			historyIndex = historyList.length-1;  // position index to action at the end of the list
		}


		// Undo Last Action
		public static function undo():void
		{
			if(historyIndex < 1) // Dont Undo the Canvas creation
				return;

			historyIndex--;

			var actionEntry:Object = historyList.getItemAt(historyIndex); // retreive last entry
			if(actionEntry && actionEntry.client && actionEntry.state)
			{
				actionEntry.client.Load( actionEntry.state ); // Load XML state

				if(actionEntry.saveBitmapData)
				{
					// Load Previous bitmapData entry
				}
			}

			// TODO: If index is historyList.length-1, Save state here, to redo exactly to our current state
		}


		// Redo Next Action
		public static function redo():void
		{
			if(historyIndex >= historyList.length-1) // Cannot Redo what hasnt happened yet
				return;

			historyIndex++;

			var actionEntry:Object = historyList.getItemAt(historyIndex); // retreive entry
			if(actionEntry && actionEntry.client && actionEntry.state)
			{
				actionEntry.client.Load( actionEntry.state ); // Load XML state

				if(actionEntry.saveBitmapData)
				{
					// Load Current bitmapData entry
				}
			}
		}



		// Save binary data (ie: bitmapData), return path
		public static function saveBitmapData(bmpData:BitmapData):int
		{
			if(!historySaveBinary) // Dont save binary for this action
				return -1;

			// Copy BmpData
			var newBmpData:BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0);
			newBmpData.draw(bmpData);

			var index:int = historyDataList.push(newBmpData); // push data in array, returns next slot index
			return index-1; // return index
		}


		// Load binary data (ie: bitmapData), returns Data
		public static function loadBitmapData(index:int):BitmapData
		{
			if(index < 0)
				return null;

			if(index < historyDataList.length)
			{
				return historyDataList[index]; // return binary data at specified index

				// TODO: delete?
			}
			return null;
		}





		// Clear History
		public static function clear():void
		{
			historyList.removeAll();
			historyIndex = 0;

			while(historyDataList.length)
			{
				historyDataList.pop(); // remove data
			}
		}




	}
}