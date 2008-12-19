package share
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;

	import core.Cloud;
	import core.CanvasCloud;
	import session.CloudSession;
	import controls.colorClasses.CloudGradient;
	import controls.fontClasses.CloudFont;
	import controls.brushClasses.CloudBrush;
	import controls.shapeClasses.CloudShape;


	public class SharedCloud
	{

		public var localID:uint = 0; // Local ID (Incremental Creation Index), dont clone as is

		public var remoteID:String = "0"; // remote ID (ID from the library)

		[Bindable]
		public var name:String = "cloud"; // Cloud Name

		[Bindable]
		public var iconBitmap:Bitmap = null; // Cloud Icon Bitmap


		
	}
}