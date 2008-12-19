package library
{
	import flash.events.Event;
	import flash.geom.Point;


	public class CloudLibraryListItemEvent extends Event
	{
		public var metaCloud:XML = null;
		public var mousePos:Point = null;	

		public function CloudLibraryListItemEvent(type:String, metaCloud:XML, mousePos:Point)
		{
			super(type, true);
			this.metaCloud = metaCloud;
			this.mousePos = mousePos;
		}
	}
}