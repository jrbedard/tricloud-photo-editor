package controls.shapeClasses
{
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import mx.collections.ArrayCollection;


	public class ShapeFactory
	{

		public function ShapeFactory()
		{
			
		}

		public function Populate(shapeList:ArrayCollection):void
		{
			var shape:CloudShape = new CloudShape();
			shape.name = "shape00";
			shape.iconBitmap = new Globals.g_assets.Shape00 as Bitmap;
			shapeList.addItem(shape); // Default Shape?

			shape = new CloudShape();
			shape.name = "shape01";
			shape.iconBitmap = new Globals.g_assets.Shape01 as Bitmap;
			shapeList.addItem(shape); // Default Shape?

			shape = new CloudShape();
			shape.name = "shape02";
			shapeList.addItem(shape); // Default Shape?

			shape = new CloudShape();
			shape.name = "shape03";
			shapeList.addItem(shape); // Default Shape?
		}
	}
}