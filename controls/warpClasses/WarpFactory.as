package controls.warpClasses
{	
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import mx.collections.ArrayCollection;


	public class WarpFactory
	{
		public function WarpFactory()
		{
			
		}

		public function Populate(warpList:ArrayCollection):void
		{
			var warp:CloudWarp = new CloudWarp(); // Default Bend Warp
			warp.name = "Warp00";
			warpList.addItem(warp);

			warp = new CloudWarp(); // Default Bend Warp
			warp.name = "Warp01";
			warpList.addItem(warp);

			warp = new CloudWarp(); // Default Bend Warp
			warp.name = "Warp02";
			warpList.addItem(warp);
		}

	}
}