package type.image
{
	public class ImageStyle
	{

		[Bindable]
		public var brightness:Number = 0.0;

		[Bindable]
		public var contrast:Number = 0.0;


		[Bindable]
		public var resizeCanvas:Boolean = true;



		public function ImageStyle()
		{
		
		}

		// Clone imageStyle
		public function clone():ImageStyle
		{
			var imageStyle:ImageStyle = new ImageStyle();

			imageStyle.brightness = this.brightness;
			imageStyle.contrast = this.contrast;

			imageStyle.resizeCanvas = this.resizeCanvas;

			return imageStyle;
		}


		// Save imageStyle XML
		public function Save():XML
		{
			var imageStyleXML:XML = new XML("<imageStyle></imageStyle>"); // Create imageStyle XML

			imageStyleXML.@brightness = this.brightness.toFixed(2);
			imageStyleXML.@contrast = this.contrast.toFixed(2);

			imageStyleXML.@resizeCanvas = this.resizeCanvas;

			return imageStyleXML;
		}

		// Load imageStyle XML
		public function Load(imageStyleXML:XML):void
		{
			if(!imageStyleXML)
				return;

			this.brightness = imageStyleXML.@brightness;
			this.contrast = imageStyleXML.@contrast;

			this.resizeCanvas = (imageStyleXML.@resizeCanvas == 'true');
		}


	}
}