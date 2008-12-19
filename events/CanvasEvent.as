package events
{
	import flash.events.Event;
	import core.CanvasCloud;

	public class CanvasEvent extends Event
	{
		public var m_canvas:CanvasCloud = null;

		public function CanvasEvent(type:String, canvas:CanvasCloud)
		{
			super(type, true);
			m_canvas = canvas;
		}

		// clone?
	}
}