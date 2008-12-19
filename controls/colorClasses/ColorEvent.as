package controls.colorClasses
{
	import flash.events.Event;

	public class ColorEvent extends Event
	{
		public var color:uint = 0x000000;
		public var alpha:Number = 1.0;

		public function ColorEvent(type:String, color:uint, alpha:Number)
		{
			super(type, true);
			this.color = color;
			this.alpha = alpha;
		}

		// clone?
	}
}