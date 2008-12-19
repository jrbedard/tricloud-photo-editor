package controls.warpClasses
{
	import flash.events.Event;

	public class WarpEvent extends Event
	{
		public var warp:CloudWarp = null;

		public function WarpEvent(type:String, shape:CloudWarp)
		{
			super(type, true);
			this.warp = warp;
		}
	}
}