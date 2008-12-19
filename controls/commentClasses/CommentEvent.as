package controls.commentClasses
{
	import flash.events.Event;

	public class CommentEvent extends Event
	{
		public var comment:XML = null;

		public function CommentEvent(type:String, comment:XML)
		{
			super(type, true);
			this.comment = comment;
		}
	}
}