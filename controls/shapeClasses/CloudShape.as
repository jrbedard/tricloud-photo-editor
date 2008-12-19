package controls.shapeClasses
{
	import flash.display.Bitmap;
	import flash.geom.Point;

	import share.SharedCloud;


	// Shape
	public class CloudShape extends SharedCloud
	{
		private static var factoryIndex:uint = 0; // Creation Index


// vars
		// List of points : polyLine
		public var points:Array = new Array();

		// List of control points for curves
		public var curveCPoints:Array = new Array();

		// List of color fills
		public var fills:Array = new Array();




		public function CloudShape()
		{
			this.localID = factoryIndex++;

			iconBitmap = new Globals.g_assets.Shape00;

			points.push(new Point(0,0));
			points.push(new Point(1,0));
			points.push(new Point(0.5,1));
		}


		public function clone():CloudShape
		{
			var cloudShape:CloudShape = new CloudShape();

			cloudShape.remoteID = this.remoteID;
			cloudShape.name = this.name;

			// ...

			return cloudShape;
		}


		// SAVE Shape XML
		public function Save():XML
		{
			var shapeXML:XML = new XML("<shape></shape>");

			shapeXML.@remoteID = this.remoteID;
			shapeXML.@name = this.name;

			// ...

			return shapeXML;
		}

		// LOAD Shape XML
		public function Load(shapeXML:XML):void
		{
			if(!shapeXML)
				return;

			shapeXML.@remoteID = this.remoteID;
			shapeXML.@name = this.name;

			// ...
		}

	
	}
}