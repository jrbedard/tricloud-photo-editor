package image
{
	import flash.events.Event;

	// new uploaded Image
	public class ImageEvent extends Event
	{
		public var m_bmp:Bitmap = null;


		public function ImageEvent(type:String, bmp:Bitmap)
		{
			super(type, true);
			if(bmp)
			{
				m_bmp = new Bitmap(bmp.bitmapData); // Copy so we can export out of this dialog
			}
			else
			{
				trace('Image ERROR!, null bitmap!')
			}
		}

		// clone?
	}
}