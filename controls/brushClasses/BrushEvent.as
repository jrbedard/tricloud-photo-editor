package controls.brushClasses
{
	import flash.events.Event;

	public class BrushEvent extends Event
	{
		public var brush:CloudBrush = null;

		public function BrushEvent(type:String, brush:CloudBrush)
		{
			super(type, true);
			this.brush = brush;
		}
	}
}