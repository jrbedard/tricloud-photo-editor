package controls.fontClasses
{
	import flash.events.Event;

	public class FontEvent extends Event
	{
		public var font:CloudFont = null;

		public function FontEvent(type:String, font:CloudFont)
		{
			super(type, true);
			this.font = font;
		}
	}
}