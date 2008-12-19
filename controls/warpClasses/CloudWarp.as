package controls.warpClasses
{
	import flash.display.Bitmap;
	import flash.geom.Point;

	import share.SharedCloud;


	public class CloudWarp extends SharedCloud
	{
		private static var factoryIndex:uint = 0; // Creation Index


		// Warp dynamic Bitmap
		[Bindable]
		public var dispMap:Bitmap = null;



		public function CloudWarp()
		{
			this.localID = factoryIndex++;

			iconBitmap = new Globals.g_assets.Shape00;
		}


		public function clone():CloudWarp
		{
			var cloudWarp:CloudWarp = new CloudWarp();

			cloudWarp.name = this.name;

			if(this.iconBitmap)
				cloudWarp.iconBitmap = new Bitmap(this.iconBitmap.bitmapData, "auto", false);

			if(this.dispMap)
				cloudWarp.dispMap = new Bitmap(this.dispMap.bitmapData, "auto", false);

			return cloudWarp;
		}


		// SAVE Warp XML
		public function Save():XML
		{
			var warpXML:XML = new XML("<warp></warp>");

			return warpXML;
		}


		// LOAD Warp XML
		public function Load(warpXML:XML):void
		{
			
		}

	}
}