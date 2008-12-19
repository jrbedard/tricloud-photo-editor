package events
{
	import flash.events.Event;

	public class CloudFlagEvent extends Event
	{
		public var metaCloud:XML = null;
		public var reasonID:uint = 0;
		public var reasonText:String = '';

		public function CloudFlagEvent(type:String, metaCloud:XML, reasonID:uint, reasonText:String)
		{
			super(type, true);
			this.metaCloud = metaCloud;
			this.reasonID = reasonID;
			this.reasonText = reasonText;
		}

		// clone?
	}
}