package type.draw
{
	import flash.display.JointStyle;
	import flash.display.CapsStyle;

	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import controls.colorClasses.CloudGradient;
	import controls.brushClasses.CloudBrush;
	import controls.shapeClasses.CloudShape;


	public class DrawStyle
	{
		[Bindable]
		public var selectedTool:String = DrawTag.BRUSH;

		// Line color & alpha
		[Bindable]
		public var lineColor:uint = 0x000000; // main drawing color
		[Bindable]
		public var lineAlpha:Number = 1.0;

		// Line Properties
		[Bindable]
		public var lineThickness:Number = 5;
		[Bindable]
		public var lineCaps:String = CapsStyle.NONE;
		[Bindable]
		public var lineJoints:String = JointStyle.MITER;
		[Bindable]
		public var lineJointMiterLimit:Number = 3.0;

		// Line Gradient
		[Bindable]
		public var isLineGradient:Boolean = false;
		[Bindable]
		public var lineGradient:CloudGradient = new CloudGradient();
		[Bindable]
		public var lineGradientMatrix:Matrix = new Matrix();


		// Fill
		[Bindable]
		public var fillColor:uint = 0xF50426;
		[Bindable]
		public var fillAlpha:Number = 1.0;

		// Fill gradient
		[Bindable]
		public var isFillGradient:Boolean = false;
		[Bindable]
		public var fillGradient:CloudGradient = new CloudGradient();
		[Bindable]
		public var fillGradientMatrix:Matrix = new Matrix();



		// BRUSH
		[Bindable]
		public var selectedBrush:CloudBrush = new CloudBrush();
		[Bindable]
		public var lineHardness:Number = 50;
		[Bindable]
		public var drawBrushCP:Boolean = false;


		// LINE
		[Bindable]
		public var curvedLine:Boolean = false;
		[Bindable]
		public var roundEndedLine:Boolean = false;


		// RECTANGLE
		[Bindable]
		public var filledRect:Boolean = false;
		[Bindable]
		public var roundedRectX:int = 0;
		[Bindable]
		public var roundedRectY:int = 0;


		// ELLIPSE
		[Bindable]
		public var filledEllipse:Boolean = false;


		// SHAPE
		[Bindable]
		public var polylineDrawing:Boolean = false; // Drawing a polyline
		[Bindable]
		public var curvedPolyline:Boolean = false;
		[Bindable]
		public var filledPolyline:Boolean = false;
		

		// CUSTOM SHAPE
		[Bindable]
		public var selectedShape:CloudShape = new CloudShape();
		[Bindable]
		public var filledShape:Boolean = false;


		// dragging Tag
		[Bindable]
		public var draggingTag:Boolean = false; // Dragging a Tag whitin drawCloud



		public function DrawStyle()
		{
		
		}

		// Clone drawStyle
		public function clone():DrawStyle
		{
			var drawStyle:DrawStyle = new DrawStyle();

			drawStyle.selectedTool = this.selectedTool;

			// common line color
			drawStyle.lineColor = this.lineColor;
			drawStyle.lineAlpha = this.lineAlpha;

			// common line attributes
			drawStyle.lineThickness = this.lineThickness;
			drawStyle.lineCaps = this.lineCaps;
			drawStyle.lineJoints = this.lineJoints;
			drawStyle.lineJointMiterLimit = this.lineJointMiterLimit;

			// common line gradient
			drawStyle.isLineGradient = this.isLineGradient;
			drawStyle.lineGradient = this.lineGradient.clone();
			drawStyle.lineGradientMatrix = this.lineGradientMatrix.clone();

			// common fill color
			drawStyle.fillColor = this.fillColor;
			drawStyle.fillAlpha = this.fillAlpha;
	
			// common fill gradient
			drawStyle.isFillGradient = this.isLineGradient;
			drawStyle.fillGradient = this.fillGradient.clone();
			drawStyle.fillGradientMatrix = this.fillGradientMatrix.clone();


			// BRUSH
			drawStyle.selectedBrush = this.selectedBrush.clone();
			drawStyle.lineHardness = this.lineHardness;
			drawStyle.drawBrushCP = this.drawBrushCP;

			// LINE
			drawStyle.curvedLine = this.curvedLine;
			drawStyle.roundEndedLine = this.roundEndedLine;

			// RECTANGLE
			drawStyle.filledRect = this.filledRect;
			drawStyle.roundedRectX = this.roundedRectX;
			drawStyle.roundedRectY = this.roundedRectY;

			// ELLIPSE
			drawStyle.filledEllipse = this.filledEllipse;

			// POLYLINE
			drawStyle.polylineDrawing = this.polylineDrawing;
			drawStyle.curvedPolyline = this.curvedPolyline;
			drawStyle.filledPolyline = this.filledPolyline;


			// CUSTOM SHAPE
			drawStyle.selectedShape = this.selectedShape.clone();
			drawStyle.filledShape = this.filledShape;

			// DRAGGING TAG
			drawStyle.draggingTag = this.draggingTag; // Dragging a Tag whitin drawCloud

			return drawStyle;
		}


		// Save drawStyle XML
		public function Save():XML
		{
			var drawStyleXML:XML = new XML("<drawStyle></drawStyle>"); // Create drawStyle XML

			drawStyleXML.@selectedTool = this.selectedTool;

			// common line color
			drawStyleXML.@lineColor = this.lineColor;
			drawStyleXML.@lineAlpha = this.lineAlpha;

			// common line attributes
			drawStyleXML.@lineThickness = this.lineThickness;
			drawStyleXML.@lineCaps = this.lineCaps;
			drawStyleXML.@lineJoints = this.lineJoints;
			drawStyleXML.@lineJointMiterLimit = this.lineJointMiterLimit;

			// common line gradient
			drawStyleXML.@isLineGradient = this.isLineGradient;

			var lineGradientXML:XML = new XML("<lineGradient></lineGradient>");
			lineGradientXML.appendChild( this.lineGradient.Save() );
			drawStyleXML.appendChild( lineGradientXML );

			//drawStyleXML.@lineGradientMatrix = this.lineGradientMatrix; // TODO

			// common fill color
			drawStyleXML.@fillColor = this.fillColor;
			drawStyleXML.@fillAlpha = this.fillAlpha;

			// common fill gradient
			drawStyleXML.@isFillGradient = this.isLineGradient;

			var fillGradientXML:XML = new XML("<fillGradient></fillGradient>");
			fillGradientXML.appendChild( this.fillGradient.Save() );
			drawStyleXML.appendChild( fillGradientXML );

			//drawStyleXML.@fillGradientMatrix = this.fillGradientMatrix; // TODO


			// BRUSH
			var brushXML:XML = this.selectedBrush.Save();
			drawStyleXML.appendChild( brushXML );
			drawStyleXML.@lineHardness = this.lineHardness;
			drawStyleXML.@drawBrushCP = this.drawBrushCP;

			// LINE
			drawStyleXML.@curvedLine = this.curvedLine;
			drawStyleXML.@roundEndedLine = this.roundEndedLine;

			// RECTANGLE
			drawStyleXML.@filledRect = this.filledRect;
			drawStyleXML.@roundedRectX = this.roundedRectX;
			drawStyleXML.@roundedRectY = this.roundedRectY;

			// ELLIPSE
			drawStyleXML.@filledEllipse = this.filledEllipse;

			// SHAPE
			drawStyleXML.@polylineDrawing = this.polylineDrawing;
			drawStyleXML.@curvedPolyline = this.curvedPolyline;
			drawStyleXML.@filledPolyline = this.filledPolyline;

			// CUSTOM SHAPE
			var shapeXML:XML = this.selectedShape.Save();
			drawStyleXML.appendChild( shapeXML );
			drawStyleXML.@filledShape = this.filledShape;

			// DRAGGING TAG
			drawStyleXML.@draggingTag = this.draggingTag; // Dragging a Tag whitin drawCloud

			return drawStyleXML;
		}


		// Load drawStyle XML
		public function Load(drawStyleXML:XML):void
		{
			this.selectedTool = drawStyleXML.@selectedTool;

			// common line color
			this.lineColor = drawStyleXML.@lineColor;
			this.lineAlpha = drawStyleXML.@lineAlpha;

			// common line attributes
			this.lineThickness = drawStyleXML.@lineThickness;
			this.lineCaps = drawStyleXML.@lineCaps;
			this.lineJoints = drawStyleXML.@lineJoints;
			this.lineJointMiterLimit = drawStyleXML.@lineJointMiterLimit;

			// common line gradient
			this.isLineGradient = (drawStyleXML.@isLineGradient == 'true');

			var lineGradientXML:XML = (drawStyleXML..lineGradient)[0];
			if(lineGradientXML)
			{
				 this.lineGradient.Load(lineGradientXML.gradient);
			}
			//this.lineGradientMatrix = drawStyleXML.@lineGradientMatrix; // TODO


			// common fill color
			this.fillColor = drawStyleXML.@fillColor;
			this.fillAlpha = drawStyleXML.@fillAlpha;

			// common fill gradient
			this.isLineGradient = (drawStyleXML.@isFillGradient == 'true');

			var fillGradientXML:XML = (drawStyleXML..fillGradient)[0];
			if(fillGradientXML)
			{
				this.fillGradient.Load(fillGradientXML.gradient);
			}
			//this.fillGradientMatrix = drawStyleXML.@fillGradientMatrix; // TODO


			// BRUSH
			var brushXML:XML = (drawStyleXML..brush);
			if(brushXML)
			{
				this.selectedBrush.Load(brushXML);
			}
			this.lineHardness = drawStyleXML.@lineHardness;
			this.drawBrushCP = (drawStyleXML.@drawBrushCP == 'true');

			// LINE
			this.curvedLine = (drawStyleXML.@curvedLine == 'true');
			this.roundEndedLine = (drawStyleXML.@roundEndedLine == 'true');

			// RECTANGLE
			this.filledRect = (drawStyleXML.@filledRect == 'true');
			this.roundedRectX = drawStyleXML.@roundedRectX;
			this.roundedRectY = drawStyleXML.@roundedRectY;

			// ELLIPSE
			this.filledEllipse = (drawStyleXML.@filledEllipse == 'true');

			// SHAPE
			this.polylineDrawing = (drawStyleXML.@polylineDrawing == 'true');
			this.curvedPolyline = (drawStyleXML.@curvedPolyline == 'true');
			this.filledPolyline = (drawStyleXML.@filledPolyline == 'true');

			// CUSTOM SHAPE
			var shapeXML:XML = (shapeXML..shape);
			if(shapeXML)
			{
				this.selectedShape.Load(shapeXML);
			}
			this.filledShape = (drawStyleXML.@filledShape == 'true');

			// DRAGGING TAG
			this.draggingTag = (drawStyleXML.@draggingTag == 'true'); // Dragging a Tag whitin drawCloud
		}

	}
}