package controls.brushClasses
{
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import mx.collections.ArrayCollection;

	import controls.colorClasses.CloudGradient;


	public class BrushFactory
	{

		public function BrushFactory()
		{
			
		}

		public function Populate(brushList:ArrayCollection):void
		{

			// Brush00: Circle
			var brush:CloudBrush = new CloudBrush();
			brush.name = "Circle";
			brushList.addItem(brush); // Default Circle Brush (Brush00)

			// Brush01: Square
			brush = new CloudBrush();
			brush.name = "Square";
			brush.iconBitmap = new Globals.g_assets.Brush01 as Bitmap;
			brush.lineCaps = CapsStyle.SQUARE;
			brush.lineJoints = JointStyle.BEVEL; // square joints
			brushList.addItem(brush);

			// brush02: Gradient Circle
			brush = new CloudBrush();
			brush.name = "Smooth Circle";
			brush.iconBitmap = new Globals.g_assets.Brush02 as Bitmap;
			brush.isGradient = true;
			brush.gradient = new CloudGradient;
			brush.gradient.gradientType = GradientType.LINEAR;
			brushList.addItem(brush);

			// brush03 'Star'
			brush = new CloudBrush();
			brush.name = "Star";
			brush.iconBitmap = new Globals.g_assets.Brush03 as Bitmap;
			brush.isBitmap = true;
			brush.defaultSize = 20;
			brush.size = 20;
			brushList.addItem(brush);

			// brush04 'paw'
			brush = new CloudBrush();
			brush.name = "Paw";
			brush.iconBitmap = new Globals.g_assets.Brush04 as Bitmap;
			brush.isBitmap = true;
			brushList.addItem(brush);
		}
			
	}
}