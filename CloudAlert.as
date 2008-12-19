package
{
	import mx.controls.Alert;

	public class CloudAlert
	{

		public static function show(text:String, title:String, titleIconClass:Class = null, iconClass:Class = null):void
		{
			var alert:Alert = Alert.show(text, title, 4.0, null, null, iconClass, 4.0);
			alert.titleIcon = titleIconClass;
		}
		
	}
}