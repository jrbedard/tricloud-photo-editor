package controls.shapeClasses
{
	import flash.events.Event;

	public class ShapeEvent extends Event
	{
		public var shape:CloudShape = null;

		public function ShapeEvent(type:String, shape:CloudShape)
		{
			super(type, true);
			this.shape = shape;
		}
	}
}