// ActionScript file
package cloud.events
{
	import flash.events.Event;
	import cloud.core.Cloud;


	public class CloudTreeEvent extends Event
	{
		public var m_cloudName:String = "";
		public var m_cloudType:String = "";


		public function CloudEvent(type:String, cloudName:String, cloudType:String)
		{
			super(type, true);
			m_cloudName = cloudName;
			m_cloudType = cloudType;
		}

		// clone?
	}
}