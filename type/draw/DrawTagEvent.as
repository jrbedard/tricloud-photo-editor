package type.draw
{
	import flash.events.Event;
	import type.draw.DrawTag


	public class DrawTagEvent extends Event
	{
		public var drawTag:DrawTag = null;

		public function DrawTagEvent(type:String, drawTag:DrawTag)
		{
			super(type, true);
			this.drawTag = drawTag;
		}

		// clone?
	}
}