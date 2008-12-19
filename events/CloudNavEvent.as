package events
{
	import flash.events.MouseEvent;

	public class CloudNavEvent extends MouseEvent
	{
		public function CloudNavEvent(type:String)
		{
			super(type, true);
			//m_cloud = cloud;
		}

		// clone?
	}
}