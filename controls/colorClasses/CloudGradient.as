package controls.colorClasses
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.geom.Matrix;

	import share.SharedCloud;


	public class CloudGradient extends SharedCloud
	{		
		private static var factoryIndex:uint = 0; // Creation Index

		
		[Bindable]
		public var gradientType:String = GradientType.LINEAR;

		[Bindable]
		public var colors:Array = new Array(); // 0x000000 - 0xFFFFFF

		[Bindable]
		public var alphas:Array = new Array(); // 0.0 - 1.0

		[Bindable]
		public var ratios:Array = new Array(); // 0 - 255


		[Bindable]
		public var rotation:Number = 0.0; // in radian -PI to PI
		//private var matrix:Matrix = new Matrix();


		[Bindable]
		public var spreadMethod:String = SpreadMethod.PAD;

		[Bindable]
		public var interpolationMethod:String = InterpolationMethod.RGB;

		[Bindable]
		public var focalPointRatio:Number = 0.0;



		// Constructor 
		public function CloudGradient()
		{
			this.localID = factoryIndex++;

			// Default values
			gradientType = GradientType.LINEAR;
			colors = [0x000000, 0xFFFFFF];
			alphas = [1.0 , 0.0];
			ratios = [0, 255];

  			//matrix.rotate(rotation);
 
  			spreadMethod = SpreadMethod.PAD;
			interpolationMethod = InterpolationMethod.RGB;
			focalPointRatio = 0.0;
		}


		public function clone():CloudGradient
		{
			var gradient:CloudGradient = new CloudGradient();

			gradient.remoteID = this.remoteID;
			gradient.name = this.name;

			gradient.gradientType = this.gradientType;

			for each(var color:uint in this.colors) // for each color
				gradient.colors.push(color);

			for each(var alpha:Number in this.alphas) // for each alpha
				gradient.alphas.push(alpha);	

			for each(var ratio:Number in this.ratios) // for each ratio
				gradient.ratios.push(ratio);

			gradient.rotation = this.rotation;

			gradient.spreadMethod = this.spreadMethod;
			gradient.interpolationMethod = this.interpolationMethod;

			gradient.focalPointRatio = this.focalPointRatio;

			return gradient;
		}


		// SAVE Gradient XML
		public function Save():XML
		{
			var gradientXML:XML = new XML("<gradient></gradient>");

			gradientXML.@remoteID = this.remoteID;
			gradientXML.@name = this.name;

			gradientXML.@gradientType = this.gradientType;

			var colorsXML:XML = new XML("<colors></colors>");
			for each(var color:uint in this.colors) // for each color
			{
				colorsXML.appendChild(color);
			}
			gradientXML.appendChild(colorsXML); // Add colors XML to gradient XML


			var alphasXML:XML = new XML("<alphas></alphas>");
			for each(var alpha:Number in this.alphas) // for each alpha
			{
				alphasXML.appendChild(alpha);
			}
			gradientXML.appendChild(alphasXML); // Add alphas XML to gradient XML


			var ratiosXML:XML = new XML("<ratios></ratios>");
			for each(var ratio:Number in this.ratios) // for each ratio
			{
				ratiosXML.appendChild(ratio);
			}
			gradientXML.appendChild(ratiosXML); // Add ratios XML to gradient XML


			gradientXML.@rotation = this.rotation;

			gradientXML.@spreadMethod = this.spreadMethod;
			gradientXML.@interpolationMethod = this.interpolationMethod;

			gradientXML.@focalPointRatio = this.focalPointRatio;

			return gradientXML;
		}


		// LOAD Gradient XML
		public function Load(gradientXML:XML):void
		{
			if(!gradientXML)
				return;

			this.remoteID = gradientXML.@remoteID;
			this.name = gradientXML.@name;

			this.gradientType = gradientXML.@gradientType;

			var colorsXML:XMLList = gradientXML.colors..color;
			if(colorsXML)
			{
				for each(var color:uint in colorsXML) // for each color
					this.colors.push( color );
			}

			var alphasXML:XMLList = gradientXML.alphas..alpha;
			if(alphasXML)
			{
				for each(var alpha:Number in alphasXML) // for each alpha
					this.alphas.push( alpha );
			}

			var ratiosXML:XMLList = gradientXML.ratios..ratio;
			if(ratiosXML)
			{
				for each(var ratio:Number in ratiosXML) // for each ratio
					this.ratios.push( ratio );
			}

			this.rotation = gradientXML.@rotation;

			this.spreadMethod = gradientXML.@spreadMethod;
			this.interpolationMethod = gradientXML.@interpolationMethod;

			this.focalPointRatio = gradientXML.@focalPointRatio;
		}


	}
}