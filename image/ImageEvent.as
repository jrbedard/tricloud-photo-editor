package image
{
	import flash.display.Bitmap;
	import flash.events.Event;

	// new imported Image
	public class ImageEvent extends Event
	{

		public var m_bmp:Bitmap = null;
		public var m_cloudName:String = '';
		public var m_resizeCanvas:Boolean = false;


		public function ImageEvent(type:String, bitmap:Bitmap, cloudName:String, resizeCanvas:Boolean)
		{
			super(type, true);
			if(bitmap)
			{
				m_bmp = new Bitmap(bitmap.bitmapData); // Copy so we can export out of this dialog
			}
			else
			{
				CloudAlert.show('Invalid Bitmap', 'Image Event')
			}

			m_cloudName = cloudName;
			m_resizeCanvas = resizeCanvas;
		}

		// clone?
	}
}