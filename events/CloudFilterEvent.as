package cloud.events
{
	import flash.events.Event;

	// Event between CloudStyleDialog and CloudStylePanel, Cloud
	public class CloudFilterEvent extends Event
	{
		public var m_active:Boolean;
		public var m_filterParams:Array; // Filter override

		public function CloudFilterEvent(type:String, active:Boolean, filterParams:Array)
		{
			super(type, true);
			m_active = active;
			m_filterParams = filterParams;
		}

		// clone?
	}
}