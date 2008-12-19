package tree
{
	import flash.events.Event;
	import flash.geom.Point;

	import core.Cloud;
	

	public class CloudTreeItemEvent extends Event
	{
		public var m_cloud:Cloud = null;
		public var m_mousePos:Point = null;

		public function CloudTreeItemEvent(type:String, sCloud:Cloud, mousePos:Point)
		{
			super(type, true);
			this.m_cloud = sCloud;
			this.m_mousePos = mousePos;
		}
	}
}