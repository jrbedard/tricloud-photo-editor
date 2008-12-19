package controls.colorClasses
{
	import flash.events.Event;

	public class GradientEvent extends Event
	{
		public var gradient:CloudGradient = null;

		public function GradientEvent(type:String, gradient:CloudGradient)
		{
			super(type, true);
			this.gradient = gradient;
		}
	}
}