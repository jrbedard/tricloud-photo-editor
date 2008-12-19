package library
{
	import flash.events.Event;
	import flash.display.Bitmap;

	public class MetaCloudEvent extends Event
	{
		public var metaCloud:XML = null;
		public var iconBitmap:Bitmap = null;

		public function MetaCloudEvent(type:String, metaCloud:XML, iconBitmap:Bitmap = null)
		{
			super(type, true);
			this.metaCloud = metaCloud;
			this.iconBitmap = iconBitmap;
		}
	}
}