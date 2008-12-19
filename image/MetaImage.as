package image
{
	import flash.display.Bitmap;

	public class MetaImage
	{
		[Bindable]
		public var imageName:String = '';

		[Bindable]
		public var imageWidth:uint = 0;

		[Bindable]
		public var imageHeight:uint = 0;

		[Bindable]
		public var imageSize:String = '';


		[Bindable]
		public var bitmap:Bitmap = null;

	}
}