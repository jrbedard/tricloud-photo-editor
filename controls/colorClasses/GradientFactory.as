package controls.colorClasses
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.geom.Matrix;
	import mx.collections.ArrayCollection;


	public class GradientFactory
	{

		private var gradientList:ArrayCollection = null; // Array of Gradients

		
		public function GradientFactory()
		{
			
		}

		public function Populate(gradientList:ArrayCollection):void
		{
			this.gradientList = gradientList;

			// Gradient00: default linear
			var gradient:CloudGradient = new CloudGradient();
			gradientList.addItem(gradient); // default Gradient

			// Gradient01: default radial
			gradient = new CloudGradient();
			gradient.gradientType = GradientType.RADIAL; // Radial gradient
			gradientList.addItem(gradient); // add

			// Gradient02: red linear 
			gradient = new CloudGradient();
			gradient.gradientType = GradientType.LINEAR;
			gradient.colors[1] = 0xFF0000;
			gradient.alphas[1] = 1.0; 
			gradientList.addItem(gradient); // add

			// Gradient03: green radial
			gradient = new CloudGradient();
			gradient.gradientType = GradientType.RADIAL;
			gradient.colors[0] = 0x00FF00;
			gradient.colors[1] = 0x000000;
			gradient.alphas[0] = 1.0;
			gradient.alphas[1] = 1.0; 
			gradientList.addItem(gradient); // add

			// Gradient04: blue linear
			gradient = new CloudGradient();
			gradient.gradientType = GradientType.LINEAR;
			gradient.colors[0] = 0x0000FF;
			gradient.alphas[1] = 1.0; 
			gradientList.addItem(gradient); // add
		}


	}
}