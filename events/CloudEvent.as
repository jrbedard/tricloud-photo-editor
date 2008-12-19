package events
{
	import flash.events.Event;
	import core.Cloud;


	public class CloudEvent extends Event
	{
		public var m_cloud:Cloud = null;

		public function CloudEvent(type:String, cloud:Cloud)
		{
			super(type, true);
			m_cloud = cloud;
		}

		// clone?
	}
}