package library
{
	import flash.events.Event;

	public class CloudLibraryBrowseEvent extends Event
	{
		public var query:String = ""; // for search
		public var sortBy:String = ""; // for search and browse
		public var itemType:String = "";
		//public var metaCloudFilter:MetaCloudFilter = null; // Cloud Type for now


		public function CloudLibraryBrowseEvent(type:String, query:String, sortBy:String, itemType:String)
	    {
	        super(type, true);
	        this.query = query;
	        this.sortBy = sortBy;
	        this.itemType = itemType;
	    }

	    override public function clone():Event
	    {
	        return new CloudLibraryBrowseEvent(type, query, sortBy, itemType);
	    }
	}
}